"""Capture controlled camber inputs from the verified NR2003 1.2.0.1 x86 image.

Run from the repository with NR2003_MEM pointing at ExportMemoryPy.py output.
Requires the same Unicorn/Capstone Python setup as recovery/stage6_7.
This executes the original emitter and generated callbacks, never the Luau port.
"""
from __future__ import annotations

import hashlib
import json
import math
import os
from pathlib import Path
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path[:0] = [str(ROOT / "recovery/stage10"), str(ROOT / "recovery/stage6_7")]
import orig_setup as OS
from orig_runtime import Original, STATE, INPUT, flat

TRAVEL = [-0.02, 0.0, 0.05, 0.10, 0.13]
STEER = [-0.2, 0.0, 0.2]
ROLL = [-0.05, 0.0, 0.05]
HEIGHTS = [5.0, 5.5]  # actual LF garage ride-height settings, inches
LO, HI = 0x6E9000, 0xF80000
SHA256 = "27e76919be6722bee0dcaddc92454fea338e99a97404df6220448314feb4500a"
MEMORY_HASHES = {
    "00400000.bin": "050bfced894537e3bacbf09f62eb0e2b3e9d62b2e7f427bb15ea22b1911d945f",
    "006e9000.bin": "16dc95d49d96e687ce09e8a293e47403d59258b68d6e5df07b9df38ca3fe82e5",
    "0071b000.bin": "e2ecdc6f471dfe964caec08fc67ebb146a67b69b2f3e6209e51631cbd6248e8c",
}


def lua(value):
    if isinstance(value, dict):
        return "{" + ",".join("[" + json.dumps(k) + "]=" + lua(v) for k, v in value.items()) + "}"
    if isinstance(value, (list, tuple)):
        return "{" + ",".join(map(lua, value)) + "}"
    if isinstance(value, str):
        return json.dumps(value)
    return repr(value)


def exported_range(image, start, size):
    """Ghidra may split the committed header/text range into separate blocks."""
    out, covered = bytearray(size), bytearray(size)
    for line in (image / "blocks.tsv").read_text().splitlines()[1:]:
        _, address, length, initialized = line.split("\t")
        address, length = int(address, 16), int(length)
        lo, hi = max(start, address), min(start + size, address + length)
        if lo < hi and initialized == "true":
            block = (image / f"{address:08x}.bin").read_bytes()
            out[lo - start:hi - start] = block[lo - address:hi - address]
            covered[lo - start:hi - start] = bytes([1]) * (hi - lo)
    assert all(covered), f"missing original bytes at {start:08x}"
    return bytes(out)


def main():
    image = Path(os.environ["NR2003_MEM"])
    assert (image / "blocks.tsv").exists(), "ExportMemoryPy.py output is required"
    for name, expected in MEMORY_HASHES.items():
        committed = ROOT / "recovery/vehicle_core" / name
        assert hashlib.sha256(committed.read_bytes()).hexdigest() == expected, name
        data = exported_range(image, int(name[:8], 16), committed.stat().st_size)
        assert hashlib.sha256(data).hexdigest() == expected, name
    fixtures = ROOT / "tests/patch1201"
    fixtures.mkdir(parents=True, exist_ok=True)
    result = {
        "metadata": {
            "version": "1.2.0.1",
            "originalFileSHA256": SHA256,
            "source": "original x86 emitter/build/predictor/tire path in Unicorn",
            "memorySHA256": MEMORY_HASHES,
            "garageFPCW": "0x037f",
            "simulationFPCW": "0x077f",
            "columns": ["rideHeightLF_in", "travel_m", "steer_rad", "chassisRoll_rad",
                        "LF_tireCamberArgument", "RF_tireCamberArgument", "LF_renderAxisZ", "RF_renderAxisZ"],
        },
        "setups": [],
        "rows": [],
    }
    for height in HEIGHTS:
        m = OS.boot()
        OS.prepare(m)
        # Original garage setter: receives the display-unit float bits, then snaps/converts.
        raw = struct.unpack("<I", struct.pack("<f", height))[0]
        m.fpcw = 0x037F  # front-end garage conversion: nearest, extended precision
        m.call(0x5581D0, 36, raw, ecx=OS.GARAGE)
        m.fpcw = 0x077F  # simulation/build: round toward minus infinity
        height_raw = m.u32(OS.GARAGE + 4 * 36)
        OS.apply(m, {36: height_raw})
        m.uc.mem_write(OS.OV.BG_FLAG, b"\x01")
        result["setups"].append([height, height_raw])
        original = Original.__new__(Original)
        original.m, original.root = m, 0x727290
        original.blocks = [m.alloc(20) for _ in range(4)]
        original.outF = [m.alloc(12) for _ in range(4)]
        original.outP = [m.alloc(12) for _ in range(4)]
        original.gv = [m.alloc(12) for _ in range(4)]
        original.ret = [0.0] * 4
        snapshot = bytes(m.uc.mem_read(LO, HI - LO))
        scratch = m.alloc(45 * 4)
        for travel in TRAVEL:
            for steer in STEER:
                for roll in ROLL:
                    m.uc.mem_write(LO, snapshot)
                    for block in original.blocks:
                        m.uc.mem_write(block, bytes(20))
                    state = [0.0] * 45
                    state[4] = 0.42
                    state[6], state[9] = math.sin(roll / 2), math.cos(roll / 2)
                    state[13] = state[19] = travel
                    for i, value in enumerate(state):
                        m.wf(scratch + 4 * i, value)
                    m.w32(0xE847C8, scratch)
                    m.w32(0xE84664, 0xE84474)
                    m.call(0x5B4560, original.root)
                    for i in range(9):
                        m.wf(INPUT + 4 * i, steer if i < 2 else 0.0)
                    m.uc.mem_write(0xE843FC, b"\x01")
                    m.call(0x5B2B90, original.root, INPUT)
                    original.tires(flat())
                    tire = [m.f32(0xBF3A20 + w * 0xA39 + 0x2BC) for w in range(2)]
                    render = []
                    for record in (5, 8):
                        pointer = m.u32(original.root + record * 0x505 + 0x339 + 7 * 4)
                        render.append(m.f32(pointer))
                    values = [height, travel, steer, roll, *tire, *render]
                    assert all(math.isfinite(x) for x in values), values
                    result["rows"].append(values)
        print(f"Captured original x86: rideHeightLF={height:g} in, 45 controlled poses", flush=True)
    (fixtures / "camber_reference.json").write_text(json.dumps(result, indent=2) + "\n")
    (fixtures / "camber_reference.luau").write_text(
        "-- GENERATED by recovery/patch1201/gen_camber_reference.py; original NR2003 1.2.0.1.\nreturn " + lua(result) + "\n")
    print(f"Wrote {len(result['rows'])} original x86 reference rows")


if __name__ == "__main__":
    main()
