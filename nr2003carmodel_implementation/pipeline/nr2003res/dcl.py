"""PKWARE Data Compression Library 'implode' stream decoder (the DAT entry compression).

Canonical Huffman tables and the bit conventions of the public DCL format, as implemented by
OpenNR-Tools src/fs/dcl_blast.cpp (MIT). Output: the decoded bytes.
"""
_LEN_RLE = (0x02, 0x23, 0x24, 0x35, 0x26, 0x17)
_DIST_RLE = (0x02, 0x14, 0x35, 0xE6, 0xF7, 0x97, 0xF8)
_LIT_RLE = (11, 124, 8, 7, 28, 7, 188, 13, 76, 4, 10, 8, 12, 10, 12, 10, 8, 23, 8,
            9, 7, 6, 7, 8, 7, 6, 55, 8, 23, 24, 12, 11, 7, 9, 11, 12, 6, 7, 22, 5,
            7, 24, 6, 11, 9, 6, 7, 22, 7, 11, 38, 7, 9, 8, 25, 11, 8, 11, 9, 12, 8,
            12, 5, 38, 5, 38, 5, 11, 7, 5, 6, 21, 6, 10, 53, 8, 7, 24, 10, 27,
            44, 253, 253, 253, 252, 252, 252, 13, 12, 45, 12, 45, 12, 61, 12, 45,
            44, 173)
_LEN_BASE = (3, 2, 4, 5, 6, 7, 8, 9, 10, 12, 16, 24, 40, 72, 136, 264)
_LEN_EXTRA = (0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8)
_MAXBITS = 13


class DclError(ValueError):
    pass


def _table(rle, total):
    lengths = []
    for b in rle:
        lengths += [b & 0x0F] * ((b >> 4) + 1)
    if len(lengths) != total:
        raise DclError("RLE length mismatch")
    count = [0] * (_MAXBITS + 1)
    for n in lengths:
        if n:
            count[n] += 1
    symbols = [s for k in range(1, _MAXBITS + 1) for s, n in enumerate(lengths) if n == k]
    return count, symbols


_LEN = _table(_LEN_RLE, 16)
_DIST = _table(_DIST_RLE, 64)
_LIT = None


def decompress(data, expected=None):
    global _LIT
    if len(data) < 2:
        raise DclError("stream shorter than its header")
    lit_type, dict_log2 = data[0], data[1]
    if lit_type not in (0, 1) or dict_log2 not in (4, 5, 6):
        raise DclError("bad DCL header %d/%d" % (lit_type, dict_log2))
    if lit_type == 1 and _LIT is None:
        _LIT = _table(_LIT_RLE, 256)
    pos, buf, nbits = 2, 0, 0
    out = bytearray()
    n = len(data)

    def bits(k):
        nonlocal pos, buf, nbits
        while nbits < k:
            if pos >= n:
                raise DclError("stream truncated")
            buf |= data[pos] << nbits
            pos += 1
            nbits += 8
        v = buf & ((1 << k) - 1)
        buf >>= k
        nbits -= k
        return v

    def huff(t):
        count, symbols = t
        code = first = index = 0
        for ln in range(1, _MAXBITS + 1):
            code = (code << 1) | (bits(1) ^ 1)
            c = count[ln]
            if code < first + c:
                return symbols[index + code - first]
            index += c
            first = (first + c) << 1
        raise DclError("bad Huffman code")

    while True:
        if bits(1):
            sym = huff(_LEN)
            length = _LEN_BASE[sym] + (bits(_LEN_EXTRA[sym]) if _LEN_EXTRA[sym] else 0)
            if length == 519:
                break
            eb = 2 if length == 2 else dict_log2
            dist = ((huff(_DIST) << eb) | bits(eb)) + 1
            if dist > len(out):
                raise DclError("distance beyond output")
            src = len(out) - dist
            for i in range(length):
                out.append(out[src + i])
        else:
            out.append(bits(8) if lit_type == 0 else huff(_LIT))
    if expected is not None and len(out) != expected:
        raise DclError("size %d != %d" % (len(out), expected))
    return bytes(out)
