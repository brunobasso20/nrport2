"""Original automatic-shift unit fixtures, from real x86 execution in Unicorn.

NR2003_MEM=... UNICORN_PY=... PYTHONPATH=... python recovery/assist_implementation/automatic_reference.py
"""
from fractions import Fraction
import base64
import json
import math
from pathlib import Path
import random
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path[:0] = [str(ROOT / "recovery/stage10"), str(ROOT / "recovery/stage6_7")]
import orig_setup as O


def bits(x): return struct.unpack("<I", struct.pack("<f", x))[0]
def f32(u): return struct.unpack("<f", struct.pack("<I", u))[0]
def near(x): return f32(bits(x))


def rd32(value):
    if isinstance(value, float) and value == 0:
        return bits(value)
    number = float(value)
    result = bits(number)
    if Fraction(f32(result)) > value:
        result += -1 if number > 0 else 1
    return result


def x80(m):
    mantissa, exponent = struct.unpack("<QH", bytes(m.uc.mem_read(0xF7E100, 10)))
    sign = -1 if exponent & 0x8000 else 1
    exponent &= 0x7FFF
    assert exponent != 0x7FFF, "nonfinite x87 reference"
    if mantissa == 0: return -0.0 if sign < 0 else 0.0
    return sign * Fraction(mantissa) * Fraction(2) ** ((exponent or 1) - 16383 - 63)


def returned(m, target, *args):
    m.call(target, *args)
    m.call(0xF7E080)  # FSTP tbyte [f7e100]; RET: preserves the actual 64-bit x87 significand
    return x80(m)


def lua(value):
    if isinstance(value, dict):
        return "{" + ",".join("[" + json.dumps(str(k)) + "]=" + lua(v) for k, v in value.items()) + "}"
    if isinstance(value, (list, tuple)):
        return "{" + ",".join(map(lua, value)) + "}"
    if isinstance(value, str): return json.dumps(value)
    return repr(value)


def main():
    result = {"source": "NR2003.exe 1.2.0.1 ORIGINAL 00562f90/00553920/005536b0 in Unicorn, FPCW 0x077f",
              "executableSHA256": "27e76919be6722bee0dcaddc92454fea338e99a97404df6220448314feb4500a", "contexts": []}
    for name, chassis in (("cup_default", 2), ("road_fast", 4)):
        m = O.boot()
        spec = O.prepare(m, chassis_type=chassis)
        items = None
        if chassis == 4:
            source = json.loads((ROOT / "tests/patch1201/setup_reference.json").read_text())["profiles"]["fast"]
            chunk = base64.b64decode(source["chunkBase64"])
            packed = m.alloc(len(chunk), chunk)
            m.fpcw = 0x027F
            assert m.call(0x558830, 0, source["setupVersion"], packed, len(chunk), ecx=O.GARAGE) == len(chunk)
            assert m.call(0x558DA0, ecx=O.GARAGE)
            items = {i: m.u32(O.GARAGE + i * 4) for i in range(184)}
            m.fpcw = 0x077F
        O.apply(m, items)
        m.w32(0xBDBD00, chassis)
        m.w32(0xBDDDE0, 1 if chassis == 4 else 0)
        m.uc.mem_write(0xF7E080, b"\xdb\x3d" + struct.pack("<I", 0xF7E100) + b"\xc3")
        context = set([0xBDBD00, 0xBDDDE0, O.SLOT + 0x58A, O.SLOT + 12 + 0x56A])
        engine_set = m.u32(O.SLOT + 12 + 0x56A)
        context.add(engine_set + 0x2C)
        for base in (O.GARAGE, O.ACTIVE):
            context.update(base + 4 * i for i in range(0x66, 0x6F))
        context.update(0xC086E0 + 4 * i for i in range(8))
        context.update(spec + i for i in (0x4C, 0x50, 0x54, 0x58))
        profiles = m.u32(0x734368)
        context.add(0x734368)
        for wheel in (2, 3):
            profile = m.call(0x56ED60, wheel, ecx=spec)
            context.add(profiles + 4 * profile)
            entry = m.u32(profiles + 4 * profile)
            context.add(entry)
            binding = 0xBF3A20 + wheel * 0xA39 + 0x70
            assert m.u32(binding) == entry, "original tyre binding differs from original spec/profile lookup"
            context.add(binding)
        ctx = {"name": name, "inputs": [[a, m.u32(a)] for a in sorted(context)], "rpm": [], "selector": []}
        m.call(0x562F90)
        addresses = [0xC08728] + [0xC533F8 + 4 * i for i in range(8)]
        addresses += [0xC53418 + 4 * i for i in range(8)] + [0xC53438 + 4 * i for i in range(8)]
        ctx["initialized"] = [[a, m.u32(a)] for a in addresses]
        flags = [m.u32(0xC086E0 + 4 * i) for i in range(8)]
        speeds = {gear: [0.0, 1.0, 20.0, 50.0, 100.0] for gear in range(6)}
        for gear in range(2, 6):
            per_speed = float(returned(m, 0x553920, bits(1.0), spec, gear))
            for threshold in (m.f32(0xC08728) * m.f32(0x6F599C + gear * 4), m.f32(0xC533F8 + gear * 4)):
                value = near(threshold / per_speed)
                if value > 0:
                    speeds[gear].extend(f32(bits(value) + delta) for delta in (-1, 0, 1))
        for gear, samples in speeds.items():
            for speed in samples:
                original = returned(m, 0x553920, bits(speed), spec, gear)
                ctx["rpm"].append([bits(speed), gear, float(original), rd32(original)])
        rng = random.Random(1201 + chassis)
        vectors = []
        for gear in range(6):
            for gearbox in (0, 1, 2):
                for phase in (0, 1, 3, 4):
                    vectors.append((gear, gearbox, phase, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0))
        for gear, samples in speeds.items():
            for speed in samples:
                vectors.append((gear, 0, 0, speed, 5000.0, 1.0, 0, 0, 0, 0, 0))
                vectors.append((gear, 1, 0, speed, 5000.0, 0.3, 0, 0, 0, 0, 0))
        for _ in range(120):
            vectors.append((rng.randrange(6), rng.randrange(3), rng.choice([0, 1, 2, 3, 4]),
                rng.choice([0.0, 5.0, 25.0, 60.0, 100.0]), rng.choice([0.0, 499.0, 500.0, 501.0, 9000.0]),
                rng.choice([0.0, near(0.2), near(0.4), 1.0]), rng.randrange(2), rng.randrange(2), rng.randrange(2),
                rng.randrange(2), rng.choice([0, 0, 2, 3])))
        for gear, gearbox, phase, speed, rpm, throttle, up, down, selected, held, disabled in vectors:
            writes = [[0x74C97C, gear], [0xBF6F0C, gearbox], [0xBF6EA0, phase], [0xBF63CC, 0],
                      [0xBF6E98, 9], [0xBF6E20, up | (down << 8) | (selected << 16)], [0xBF6E23, 3],
                      [0xBF6EA4, bits(throttle)], [0xBF6EBA, held], [0xBF6DC8, bits(rpm / m.f32(0x6F5A54))],
                      [0x74C9AC, 11], [0x7559C4, 11], [0xBF6F44, bits(speed)]]
            writes += [[0xC086E0 + 4 * i, 1 if i == disabled and disabled else flags[i]] for i in range(8)]
            for address, value in writes: m.w32(address, value)
            m.call(0x5536B0)
            expected = [[a, m.u32(a)] for a in (0xBF63CC, 0xBF6E98, 0xBF6E23, 0xBF6F44, 0x74C9AC)]
            ctx["selector"].append({"inputs": writes, "expected": expected})
        result["contexts"].append(ctx)
        print(name, "init", len(ctx["initialized"]), "RPM", len(ctx["rpm"]), "selectors", len(ctx["selector"]), flush=True)
    out = ROOT / "tests/assists"
    out.mkdir(parents=True, exist_ok=True)
    (out / "automatic_reference.json").write_text(json.dumps(result, separators=(',', ':')) + "\n")
    (out / "automatic_reference.luau").write_text("-- GENERATED by recovery/assist_implementation/automatic_reference.py from original x86.\nreturn " + lua(result) + "\n")


if __name__ == "__main__": main()
