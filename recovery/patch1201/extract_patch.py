"""Offline, CRC-checked extraction of the supplied English 1000->1201 Wise patch.

Only this identified archive/installer is supported. Never executes the installer,
applies deltas, or uses embedded filenames as filesystem paths. Extracted game
payloads belong in local scratch, not in git. Python standard library only.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import zipfile
import zlib

ARCHIVE_SHA256 = "f69747db9865ec560d93b09201ff6c0f687987110aac1eb16947be5b019ca6f5"
INSTALLER_SHA256 = "20a0e4c6febe68ac7fb008f7af90a9d83b5efee32509bf4ff2fb0ed5254f6134"
FIRST_STREAM = 0x3AB5
MAX_OUTPUT = 128 * 1024 * 1024


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def read_installer(path):
    data = path.read_bytes()
    digest = sha256(data)
    if digest == ARCHIVE_SHA256:
        with zipfile.ZipFile(path) as archive:
            entries = archive.infolist()
            if len(entries) != 1 or entries[0].file_size != 16854326:
                raise ValueError("Unexpected archive members")
            data = archive.read(entries[0])
    if sha256(data) != INSTALLER_SHA256:
        raise ValueError("Not the verified English 1000->1201 patch; refusing guessed offsets")
    return data


def decode_streams(data):
    """Walk contiguous raw-DEFLATE streams, each followed by its CRC32.

    Two streams have one zero alignment byte before the CRC. Accept at most
    four zero bytes, and require the CRC to match before advancing.
    """
    start, records, payloads = FIRST_STREAM, [], []
    while start < len(data):
        decoder = zlib.decompressobj(-15)
        payload = decoder.decompress(data[start:], MAX_OUTPUT)
        if not decoder.eof:
            raise ValueError(f"Truncated or oversized stream at {start:#x}")
        end = len(data) - len(decoder.unused_data)
        crc = zlib.crc32(payload)
        padding = next((n for n in range(5)
                        if data[end:end+n] == bytes(n)
                        and data[end+n:end+n+4] == struct.pack("<I", crc)), None)
        if padding is None:
            raise ValueError(f"CRC mismatch at {start:#x}")
        records.append(dict(index=len(records), file=f"{len(records):04d}.bin",
                            start=start, end=end, crc_padding=padding,
                            size=len(payload), sha256=sha256(payload), crc32=f"{crc:08x}"))
        payloads.append(payload)
        start = end + padding + 4
    if start != len(data) or len(records) != 123:
        raise ValueError("Unexpected stream count or unconsumed installer tail")
    return records, payloads


def inventory(records, payloads):
    script, base = payloads[1], records[6]["start"]
    for row, payload in zip(records, payloads):
        # The Wise script stores compressed start/end offsets relative to stream 6.
        start = row["start"] - base
        end = row["end"] + row["crc_padding"] + 4 - base
        row["kind"] = ("binary_delta" if payload.startswith(b"\x03$/")
                       else "complete_payload")
        if start < 0:
            continue
        offset = script.find(struct.pack("<II", start, end))
        if offset < 0:
            continue
        name_at = offset + 40
        name_end = script.find(b"\0", name_at)
        if name_end < 0:
            continue
        name = script[name_at:name_end].decode("cp1252")
        if not name.startswith(("%MAINDIR%\\", "%TEMP%\\")):
            continue
        row.update(path=name, script_offset=offset)
    # These are labels recovered from installer records, not reconstructed files.
    game = next(row for row in records if row.get("path") == "%MAINDIR%\\NR2003.exe")
    if game["index"] != 15 or game["kind"] != "binary_delta":
        raise ValueError("Unexpected executable payload mapping")
    track, assignments = None, []
    pattern = (rb"%MAINDIR%\\tracks\\([a-z_]+)\\track\.ini|"
               rb"((?:ai_[a-z_]+|pace_speed_limit_mph|checkpoint_[0-9]+) *= *[\x20-\x7e]+)")
    for match in re.finditer(pattern, script):
        if match[1]:
            track = match[1].decode("ascii")
        else:
            assignments.append(dict(script_offset=match.start(), track=track,
                                    literal=match[2].decode("cp1252")))
    return dict(installer_sha256=INSTALLER_SHA256, stream_count=len(records),
                consumed_to_eof=True, records=records, track_ini_assignment_literals=assignments)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("patch", type=Path, help="supplied ZIP or its installer EXE")
    parser.add_argument("output", type=Path, help="new local scratch directory")
    args = parser.parse_args()
    data = read_installer(args.patch)
    records, payloads = decode_streams(data)
    manifest = inventory(records, payloads)
    args.output.mkdir(parents=True, exist_ok=False)
    for row, payload in zip(records, payloads):
        (args.output / row["file"]).write_bytes(payload)
    (args.output / "inventory.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"Verified {len(records)} streams, consumed installer to EOF; "
          "NR2003.exe is delta payload 0015.bin, not a runnable executable.")


if __name__ == "__main__":
    main()
