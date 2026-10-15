"""Compare extracted Studio surface data with actual NR2003 1.2.0.1 x86.

Input is the numeric script directory from read_studio_model.py. This runs only
the original grip-loader multiplication loop (00510011..0051002d) in Unicorn,
with the recovered Watkins Glen INI inputs; no installer or game is launched.
"""
import argparse
import base64
import hashlib
import json
from pathlib import Path
import re
import struct
from unicorn import Uc, UC_ARCH_X86, UC_MODE_32
from unicorn.x86_const import UC_X86_REG_FPCW
from identify_reference import identify

ROOT = Path(__file__).resolve().parents[2]
BASE = 0x6e9000


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("studio", type=Path)
    parser.add_argument("reference", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    identity = identify(args.reference.read_bytes())
    if identity["sha256"] != "27e76919be6722bee0dcaddc92454fea338e99a97404df6220448314feb4500a":
        raise ValueError("Wrong reference executable")
    if not all(c["exact_match"] for c in identity["committed_chunks"]):
        raise ValueError("Reference code mismatch")
    inventory = json.loads((args.studio / "scripts.json").read_text())
    tables = json.loads((ROOT / "watkinsglen_implementation/recovery/evidence/surface_tables.json").read_text())
    wanted = [(0x74fb30, 80), (0x6f6570, 80), (0x6f6148, 80), (0x6f6198, 80),
              (0x6f63c8, 80), (0x6f6418, 80), (0x6f65c0, 80), (0x74b9d8, 16)]
    memory, present = {}, set()
    scripts = inventory["scripts"]
    selected = [s for s in scripts if "/Core/NR2003Cup/NR2003CupImage" in s["path"]]
    selected += [s for s in scripts if "/Core/NR2003Cup/NR2003CupFrameData" in s["path"]]
    selected += [s for s in scripts if "/Core/NR2003Cup/NR2003CupTrackData" in s["path"]]
    for script in selected:
        text = (args.studio / script["file"]).read_text()
        zero = re.search(r"zero=\{(.*?)\n\},", text, re.S)
        if zero:
            for offset, size in re.findall(r"\{(\d+),(\d+)\}", zero[1]):
                start, end = BASE + int(offset), BASE + int(offset) + int(size)
                for address, length in wanted:
                    for a in range(max(start, address), min(end, address + length)):
                        memory[a] = 0
        for offset, encoded in re.findall(r'\{(\d+),"([A-Za-z0-9+/=]*)"\}', text):
            start = BASE + int(offset)
            end = start + len(encoded) * 3 // 4
            overlaps = [(max(start, a), min(end, a + n)) for a, n in wanted if start < a + n and a < end]
            if not overlaps:
                continue
            data = base64.b64decode(encoded)
            for lo, hi in overlaps:
                for address in range(lo, min(hi, start + len(data))):
                    memory[address] = data[address - start]
                    present.add(address)
    def studio_bytes(address, size):
        return bytes(memory[a] for a in range(address, address + size))
    machine = Uc(UC_ARCH_X86, UC_MODE_32)
    machine.mem_map(0x400000, 0x400000)
    for name in ("00400000.bin", "006e9000.bin", "0071b000.bin"):
        machine.mem_write(int(name[:8], 16), (ROOT / "recovery/vehicle_core" / name).read_bytes())
    constant_results = []
    for address, size in wanted[1:-1]:
        original = bytes(machine.mem_read(address, size))
        actual = studio_bytes(address, size)
        constant_results.append(dict(address=f"{address:08x}", bytes=size,
            original_sha256=hashlib.sha256(original).hexdigest(), exact_match=original == actual))
    # The loader receives parsed float32 INI values and stores with simulation RC=down.
    for material in tables["materials"]:
        machine.mem_write(0x74fb30 + 4 * material["index"], struct.pack("<f", material["track_ini_multiplier"]))
    machine.reg_write(UC_X86_REG_FPCW, 0x077f)
    machine.emu_start(0x510011, 0x51002d, count=1000)
    rows = []
    for material in tables["materials"]:
        address = 0x74fb30 + 4 * material["index"]
        original = bytes(machine.mem_read(address, 4))
        actual = studio_bytes(address, 4)
        rows.append(dict(index=material["index"], name=material["name"],
                         multiplier=material["track_ini_multiplier"],
                         original=struct.unpack("<f", original)[0], studio=struct.unpack("<f", actual)[0],
                         original_bits=f"{int.from_bytes(original, 'little'):08x}",
                         studio_bits=f"{int.from_bytes(actual, 'little'):08x}", exact_match=original == actual))
    thermal = []
    for index, key in enumerate(("track_tire_wear", "track_tire_heat", "track_tire_wear_loss", "track_tire_wear_exp")):
        actual = studio_bytes(0x74b9d8 + 4 * index, 4)
        expected = struct.pack("<f", tables["track_ini"][key])
        thermal.append(dict(key=key, expected=struct.unpack("<f", expected)[0],
                            studio=struct.unpack("<f", actual)[0], exact_match=actual == expected))
    report = dict(studio_sha256=inventory["sha256"], reference_sha256=identity["sha256"],
        reference_version=identity["versions"][0]["file"],
        executed_range=["00510011", "0051002d"], fpcw="0x077f",
        input_provenance="Recovered Watkins Glen INI values in surface_tables.json; original INI file is not embedded in this snapshot",
        material_results=rows, constant_tables=constant_results, thermal_inputs=thermal,
        all_exact=all(x["exact_match"] for x in rows + constant_results + thermal))
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(f"{sum(r['exact_match'] for r in rows)}/20 surface scalars equal original x86; "
          f"{sum(r['exact_match'] for r in constant_results)}/6 constant tables; "
          f"{sum(r['exact_match'] for r in thermal)}/4 thermal/wear inputs")
    if not report["all_exact"]:
        raise SystemExit("Studio surface data mismatch")


if __name__ == "__main__":
    main()
