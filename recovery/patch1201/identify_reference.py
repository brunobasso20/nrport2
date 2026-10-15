"""Identify the imported reference PE and compare committed physics memory exports.

Uses PE headers and RT_VERSION bytes, not filenames or a PE timestamp to infer
version. No game execution and no third-party Python dependencies.
"""
import argparse
import json
from pathlib import Path
import struct
import zlib
from extract_patch import read_installer, decode_streams, sha256

ROOT = Path(__file__).resolve().parents[2]
EXPECTED_SHA256 = "27e76919be6722bee0dcaddc92454fea338e99a97404df6220448314feb4500a"
CHUNKS = ("00400000.bin", "006e9000.bin", "0071b000.bin")


def identify(data):
    u16 = lambda off: struct.unpack_from("<H", data, off)[0]
    u32 = lambda off: struct.unpack_from("<I", data, off)[0]
    pe = u32(0x3c)
    if data[:2] != b"MZ" or data[pe:pe+4] != b"PE\0\0":
        raise ValueError("Not a PE")
    opt = pe + 24
    if u16(opt) != 0x10b:
        raise ValueError("Expected PE32")
    base = u32(opt + 28)
    sections = []
    for index in range(u16(pe + 6)):
        off = opt + u16(pe + 20) + 40 * index
        virtual_size, rva, size, raw = struct.unpack_from("<IIII", data, off + 8)
        sections.append((rva, size, raw, virtual_size))

    def file_offset(rva, length=1):
        if rva < u32(opt + 60) and rva + length <= u32(opt + 60):
            return rva
        for start, size, raw, _ in sections:
            if start <= rva and rva + length <= start + size:
                if raw + rva - start + length > len(data):
                    break
                return raw + rva - start
        raise ValueError(f"RVA {rva:#x} is not backed by file bytes")

    resource = file_offset(u32(opt + 96 + 2 * 8))

    def children(relative):
        directory = resource + relative
        count = u16(directory + 12) + u16(directory + 14)
        if count > 4096:
            raise ValueError("Oversized resource directory")
        return [struct.unpack_from("<II", data, directory + 16 + index * 8)
                for index in range(count)]

    versions = []
    for type_id, names in children(0):
        if type_id != 16 or not names & 0x80000000:
            continue
        for _, languages in children(names & 0x7fffffff):
            if not languages & 0x80000000:
                raise ValueError("Malformed version resource")
            for language, entry in children(languages & 0x7fffffff):
                if entry & 0x80000000:
                    raise ValueError("Malformed language resource")
                rva, length = struct.unpack_from("<II", data, resource + entry)
                off = file_offset(rva, length)
                key = "VS_VERSION_INFO\0".encode("utf-16-le")
                if data[off + 6:off + 6 + len(key)] != key:
                    raise ValueError("Unexpected version root key")
                fixed = (off + 6 + len(key) + 3) & ~3
                if u16(off + 2) != 52 or u32(fixed) != 0xfeef04bd:
                    raise ValueError("Missing VS_FIXEDFILEINFO")
                def version(ms, ls):
                    return ".".join(str(v) for v in (ms >> 16, ms & 65535, ls >> 16, ls & 65535))
                versions.append(dict(language=language, offset=off, size=length,
                                     file=version(u32(fixed + 8), u32(fixed + 12)),
                                     product=version(u32(fixed + 16), u32(fixed + 20))))
    if not versions:
        raise ValueError("No RT_VERSION resource")
    image_size = u32(opt + 56)
    if image_size > 64 * 1024 * 1024:
        raise ValueError("Oversized image")
    image = bytearray(image_size)
    header_size = u32(opt + 60)
    image[:header_size] = data[:header_size]
    for rva, size, raw, _ in sections:
        if raw + size > len(data) or rva + size > image_size:
            raise ValueError("Section outside file or mapped image")
        image[rva:rva+size] = data[raw:raw+size]
    chunks = []
    for name in CHUNKS:
        committed = (ROOT / "recovery/vehicle_core" / name).read_bytes()
        rva = int(name[:8], 16) - base
        off = file_offset(rva)
        original = image[rva:rva + len(committed)]
        chunks.append(dict(file=name, bytes=len(committed), file_offset=off,
                           sha256=sha256(committed), exact_match=committed == original))
    return dict(sha256=sha256(data), size=len(data), crc32=f"{zlib.crc32(data):08x}",
                pe_timestamp=u32(pe + 8), versions=versions, committed_chunks=chunks)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("reference", type=Path, help="original imported FileBytes exported from Ghidra")
    parser.add_argument("--patch", type=Path, help="supplied patch ZIP or EXE; also check target metadata")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    report = identify(args.reference.read_bytes())
    if args.patch:
        rows, payloads = decode_streams(read_installer(args.patch))
        delta = payloads[15]
        # Observed fixed header fields for this pinned Wise delta, not a general delta decoder.
        target_crc, target_size = struct.unpack_from("<II", delta, 5)
        report["patch_target"] = dict(stream=15, kind="binary_delta",
            sha256=rows[15]["sha256"], crc32_offset=5, size_offset=9,
            crc32=f"{target_crc:08x}", size=target_size,
            crc32_matches=f"{target_crc:08x}" == report["crc32"],
            size_matches=target_size == report["size"])
    report["verified_1201_reference"] = (
        report["sha256"] == EXPECTED_SHA256
        and all(v["file"] == v["product"] == "1.2.0.1" for v in report["versions"])
        and all(c["exact_match"] for c in report["committed_chunks"])
        and ("patch_target" not in report or
             report["patch_target"]["crc32_matches"] and report["patch_target"]["size_matches"]))
    text = json.dumps(report, indent=2) + "\n"
    if args.output:
        args.output.write_text(text)
    else:
        print(text, end="")
    if not report["verified_1201_reference"]:
        raise SystemExit("Reference does not match the verified 1.2.0.1 baseline")


if __name__ == "__main__":
    main()
