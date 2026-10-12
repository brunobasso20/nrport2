"""Papyrus MIP texture reader (OpenNR-Tools docs/formats/car.md 'Embedded MIP', src/fs/mip_texture.cpp).

Layout: 32-byte header (signature 04 00, base format, address flags, log2 width/height, colour key AARRGGBB,
mipmap count, option, factor, reserved) followed by BMAP chunks (smallest level first), each with a 14-byte BMHD
(format, width, height, decoded pitch, DCL flag) and a DATA chunk. Chunk tags are byte-reversed on disk.
Pixel rows are stored top row first (Direct3D convention: v = 0 is the first row).
"""
import struct
import zlib
from . import dcl

RGB565, RGB555KEY, ARGB4444, RGB888, BGRA8888, DXT1, DXT3 = 0x03, 0x04, 0x05, 0x06, 0x07, 0x0A, 0x0B
FORMAT_NAMES = {RGB565: "RGB565", RGB555KEY: "RGB555+colorkey", ARGB4444: "ARGB4444", RGB888: "RGB888",
                BGRA8888: "BGRA8888", DXT1: "DXT1", DXT3: "DXT3"}


class MipError(ValueError):
    pass


def _tag(b, p, logical):
    return b[p:p + 4] == logical[::-1].encode("ascii")


class Level:
    __slots__ = ("format", "width", "height", "pitch", "pixels")


class Mip:
    def __init__(self, data):
        if len(data) < 32:
            raise MipError("shorter than the MIP header")
        (self.sig0, self.sig1, self.format, self.address, self.log2w, self.log2h, self.color_key, self.count,
         self.option, self.factor, self.reserved) = struct.unpack_from("<BBBBIIIIIfI", data, 0)
        self.levels = []
        p = 32
        while len(data) - p >= 12 and _tag(data, p, "BMAP"):
            size = struct.unpack_from("<I", data, p + 8)[0]
            end = p + 12 + size
            q = p + 12
            if not _tag(data, q, "BMHD"):
                raise MipError("BMAP without BMHD")
            hs = struct.unpack_from("<I", data, q + 8)[0]
            fmt, w, h, pitch, comp = struct.unpack_from("<BIIIB", data, q + 12)
            q += 12 + hs
            while q < end and not _tag(data, q, "DATA"):
                q += 1
            if not _tag(data, q, "DATA"):
                raise MipError("BMAP without DATA")
            ds = struct.unpack_from("<I", data, q + 8)[0]
            payload = data[q + 12:q + 12 + ds]
            if comp:
                payload = dcl.decompress(payload)
            lv = Level()
            lv.format, lv.width, lv.height, lv.pitch, lv.pixels = fmt, w, h, pitch, payload
            if fmt not in (DXT1, DXT3) and len(payload) != pitch * h:
                raise MipError("level %dx%d payload %d != pitch*height %d" % (w, h, len(payload), pitch * h))
            self.levels.append(lv)
            p = end
            while p < len(data) and data[p] == 0x20:   # inter-chunk padding
                p += 1
        if not self.levels:
            raise MipError("no BMAP levels")

    @property
    def clamp_u(self):
        return bool(self.address & 1)

    @property
    def clamp_v(self):
        return bool(self.address & 2)

    def largest(self):
        return max(self.levels, key=lambda lv: lv.width * lv.height)

    def rgba(self, level=None):
        """Decode one level (default: the largest) to (width, height, bytes RGBA, top row first)."""
        lv = level or self.largest()
        return lv.width, lv.height, decode(lv, self.color_key)


def _e5(v):
    return (v << 3) | (v >> 2)


def _e6(v):
    return (v << 2) | (v >> 4)


def _e4(v):
    return (v << 4) | v


def _dxt_block(src, o, dxt1_alpha):
    c0, c1, idx = struct.unpack_from("<HHI", src, o)
    r0, g0, b0 = _e5((c0 >> 11) & 31), _e6((c0 >> 5) & 63), _e5(c0 & 31)
    r1, g1, b1 = _e5((c1 >> 11) & 31), _e6((c1 >> 5) & 63), _e5(c1 & 31)
    pal = [(r0, g0, b0, 255), (r1, g1, b1, 255)]
    if c0 > c1 or not dxt1_alpha:
        pal.append(((2 * r0 + r1 + 1) // 3, (2 * g0 + g1 + 1) // 3, (2 * b0 + b1 + 1) // 3, 255))
        pal.append(((r0 + 2 * r1 + 1) // 3, (g0 + 2 * g1 + 1) // 3, (b0 + 2 * b1 + 1) // 3, 255))
    else:
        pal.append(((r0 + r1) // 2, (g0 + g1) // 2, (b0 + b1) // 2, 255))
        pal.append((0, 0, 0, 0))
    return [pal[(idx >> (2 * i)) & 3] for i in range(16)]


def decode(lv, color_key=0):
    W, H, P, px, fmt = lv.width, lv.height, lv.pitch, lv.pixels, lv.format
    out = bytearray(W * H * 4)
    if fmt in (RGB565, RGB555KEY, ARGB4444):
        key16 = color_key & 0xFFFF
        for y in range(H):
            row = struct.unpack_from("<%dH" % W, px, y * P)
            o = y * W * 4
            for v in row:
                if fmt == RGB565:
                    out[o:o + 4] = bytes((_e5((v >> 11) & 31), _e6((v >> 5) & 63), _e5(v & 31), 255))
                elif fmt == RGB555KEY:
                    out[o:o + 4] = bytes((_e5((v >> 10) & 31), _e5((v >> 5) & 31), _e5(v & 31), 0 if v == key16 else 255))
                else:
                    out[o:o + 4] = bytes((_e4((v >> 8) & 15), _e4((v >> 4) & 15), _e4(v & 15), _e4((v >> 12) & 15)))
                o += 4
    elif fmt == RGB888:
        for y in range(H):
            row = px[y * P:y * P + 3 * W]
            o = y * W * 4
            out[o:o + 4 * W:4] = row[0::3]
            out[o + 1:o + 4 * W:4] = row[1::3]
            out[o + 2:o + 4 * W:4] = row[2::3]
            out[o + 3:o + 4 * W:4] = b"\xff" * W
    elif fmt == BGRA8888:
        for y in range(H):
            row = px[y * P:y * P + 4 * W]
            o = y * W * 4
            out[o:o + 4 * W:4] = row[2::4]
            out[o + 1:o + 4 * W:4] = row[1::4]
            out[o + 2:o + 4 * W:4] = row[0::4]
            out[o + 3:o + 4 * W:4] = row[3::4]
    elif fmt in (DXT1, DXT3):
        bw, bh = (W + 3) // 4, (H + 3) // 4
        o = 0
        for by in range(bh):
            for bx in range(bw):
                if fmt == DXT1:
                    blk = _dxt_block(px, o, True)
                    o += 8
                else:
                    alpha = []
                    for i in range(8):
                        alpha += [_e4(px[o + i] & 15), _e4(px[o + i] >> 4)]
                    blk = [c[:3] + (alpha[i],) for i, c in enumerate(_dxt_block(px, o + 8, False))]
                    o += 16
                for py in range(4):
                    y = by * 4 + py
                    if y >= H:
                        break
                    for pxl in range(4):
                        x = bx * 4 + pxl
                        if x >= W:
                            break
                        q = (y * W + x) * 4
                        out[q:q + 4] = bytes(blk[py * 4 + pxl])
    else:
        raise MipError("unknown pixel format 0x%02x" % fmt)
    return bytes(out)


def png(width, height, rgba):
    """Minimal RGBA8 PNG encoder (stdlib zlib)."""
    raw = bytearray()
    stride = width * 4
    for y in range(height):
        raw.append(0)
        raw += rgba[y * stride:(y + 1) * stride]

    def chunk(t, d):
        c = struct.pack(">I", len(d)) + t + d
        return c + struct.pack(">I", zlib.crc32(t + d) & 0xFFFFFFFF)
    return (b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0))
            + chunk(b"IDAT", zlib.compress(bytes(raw), 9)) + chunk(b"IEND", b""))
