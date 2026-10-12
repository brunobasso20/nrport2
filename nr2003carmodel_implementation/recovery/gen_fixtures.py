#!/usr/bin/env python3
"""Golden vectors for tests/run.luau: ORIGINAL NR2003.exe / rendserv.dll code executed in Unicorn (orig_carmodel.py).

usage: NR2003_MEM=<NR2003.exe memory> RENDSERV_MEM=<rendserv.dll memory> python3 gen_fixtures.py <package dir> <out.lua>
<package dir> = convert_car.py output (json/make_a.json: on-car camera table + model switches / LODs / keys).
Writes plain numbers only (the fixture holds no geometry or texture)."""
import json
import math
import random
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "pipeline"))
import orig_carmodel as O  # noqa: E402
from nr2003res import rig as R  # noqa: E402


def f32(x):
    return struct.unpack("<f", struct.pack("<f", x))[0]


def lua(v):
    if isinstance(v, bool):
        return "true" if v else "false"
    if v is None:
        return "nil"
    if isinstance(v, int):
        return str(v)
    if isinstance(v, float):
        if v != v:
            return "0/0"
        if v in (float("inf"), float("-inf")):
            return "math.huge" if v > 0 else "-math.huge"
        return repr(v)
    if isinstance(v, str):
        return json.dumps(v)
    if isinstance(v, (list, tuple)):
        return "{" + ",".join(lua(x) for x in v) + "}"
    if isinstance(v, dict):
        return "{" + ",".join("%s=%s" % (k if k.isidentifier() else "[%s]" % json.dumps(k), lua(x)) for k, x in v.items()) + "}"
    raise TypeError(type(v))


def main():
    pkg, out = Path(sys.argv[1]), Path(sys.argv[2])
    desc = json.load(open(pkg / "json" / "make_a.json"))
    rnd = random.Random(2003)
    E = O.Exe()
    E.set_onboard(desc["cameras"])
    fx = {}
    # 0056f040 gauges -----------------------------------------------------------------------------------------
    cals = {"ptach": [0, 10000, -116, 141], "pfuel": [0, f32(1.08), -40, 220], "pwater": [60, 127, -40, 220],
            "poilt": [60, 127, -40, 220], "poilp": [0.5, 6.5, -40, 220], "pvoltage": [0, 27, -40, 220]}
    g = []
    for name, cal in cals.items():
        lo, hi = cal[0], cal[1]
        vals = [lo, hi, lo - 1, hi + 1, (lo + hi) / 2, float("nan")] + [rnd.uniform(lo - (hi - lo) * 0.2, hi + (hi - lo) * 0.2) for _ in range(40)]
        for v in vals:
            v = f32(v)
            g.append([name, v, E.gauge(cal, v)])
    fx["gauges"] = g
    # 005f6f20 / 005f74c0 ---------------------------------------------------------------------------------------
    eul = []
    for _ in range(150):
        h, p, r = f32(rnd.uniform(-7, 7)), f32(rnd.uniform(-1.6, 1.6)), f32(rnd.uniform(-7, 7))
        eul.append([[h, p, r], E.euler(h, p, r)])
    fx["euler"] = eul
    dec = []
    for _ in range(150):
        h, p, r = f32(rnd.uniform(-3.1, 3.1)), f32(rnd.uniform(-1.5, 1.5)), f32(rnd.uniform(-3.1, 3.1))
        M = E.euler(h, p, r)
        dec.append([M, list(E.decompose(M))])
    fx["decompose"] = dec
    # 00565b10 ----------------------------------------------------------------------------------------------
    fx["wheelSpeed"] = [[f32(x), E.wheel_speed(f32(x))] for x in
                        [0, 19.999, 20, 20.001, 59.999, 60, 60.001, -20, -60, -150, 200] + [rnd.uniform(-120, 120) for _ in range(30)]]
    # 00569210 / 00569230 / 00569250 / 00569260: look easing and the 00568e20 mode-change conversions --------------
    def fbits(x):
        return struct.unpack("<I", struct.pack("<f", x))[0]
    ease = []
    for x in [0.0, 1.0, 0.5, 0.25, 0.75, 1e-6] + [rnd.uniform(0, 1) for _ in range(40)]:
        x = f32(x)
        ease.append([x] + [E.call_st0(fn, fbits(x), 0) for fn in (0x569210, 0x569230, 0x569250, 0x569260)])
    fx["ease"] = ease
    # 0056a9a0 render camera ----------------------------------------------------------------------------------
    cams = []
    for mode in (1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15):
        for k in range(12):
            h, p, r = f32(rnd.uniform(-3.1, 3.1)), f32(rnd.uniform(-0.25, 0.25)), f32(rnd.uniform(-0.25, 0.25))
            Rb = E.euler(h, p, r)
            pos = [f32(rnd.uniform(-500, 500)), f32(rnd.uniform(-500, 500)), f32(rnd.uniform(0.2, 30))]
            head = [f32(-0.75 + rnd.uniform(-0.02, 0.02)), f32(0.4 + rnd.uniform(-0.02, 0.02)), f32(0.467 + rnd.uniform(-0.02, 0.02))]
            hp, hr = f32(p + rnd.uniform(-0.05, 0.05)), f32(r + rnd.uniform(-0.05, 0.05))
            look, analog = 0.0, 0.0
            if mode in (1, 2, 3):
                sign = {1: 0.0, 2: 1.0, 3: -1.0}[mode]
                if mode == 1 and k % 3 == 1:
                    sign = 1.0
                eased = f32(rnd.uniform(0, 0.7853982))
                look = f32(sign * eased)
                if k % 4 == 3:
                    analog = f32(rnd.uniform(-1, 1))
            res = O.camera_render(E, mode, pos, Rb, head, hp, hr, look=look, analog=analog)
            cams.append({"mode": mode, "pos": pos, "R": Rb, "head": head, "headPitch": hp, "headRoll": hr, "look": look,
                         "analog": analog, "eye": res["eye"], "M": O.quat_matrix(res["quat"]), "fov": res["fov"],
                         "near": res["near"]})
    fx["cameras"] = cams
    fx["onCar"] = desc["cameras"]
    # camera order tables (00411530 / 00411550) and camera constants, read from the image
    mem = E.m.uc.mem_read
    fx["camTables"] = {"next": list(struct.unpack("<22i", bytes(mem(0x6ec798, 88)))),
                       "prev": list(struct.unpack("<22i", bytes(mem(0x6ec7f0, 88))))}

    def rf(a, k="f"):
        return struct.unpack("<" + k, bytes(mem(a, struct.calcsize(k))))[0]
    fx["constants"] = {"fovMin": rf(0xc5c27c), "fovMax": rf(0xc5736c), "fovStep": rf(0x6e97f0),
                       "fovDefaultDeg": rf(0x6ef48c), "optionDegToRad": rf(0x6ec778), "optionRadToDeg": rf(0x6ec77c),
                       "lookTime": rf(0x6ea4cc), "wideFov": rf(0x6f69a0, "d"), "quarterPi": rf(0x6f5f30),
                       "fourOverPi": rf(0x6f5f48), "lookSmoothing": rf(0x74eb94), "lookDeadZone": rf(0x74eb98),
                       "eye": [rf(0x74ebbc), rf(0x74ebc0), rf(0x74ebc4)],
                       "defaultFov": [rf(0x6f5f18), rf(0x6f5f1c), rf(0x6f5f20)]}
    # rendserv.dll compiled nodes ---------------------------------------------------------------------------------
    RS = O.Rendserv()
    sw = []
    value_sets = sorted({tuple(n["values"]) for n in desc["nodes"] if n["kind"] == "switch"})
    for vals in value_sets:
        tests = sorted(set([vals[0] - 1, vals[-1] + 1, 0.0, 0.5, 0.9, 1.0, 1.5, 1.9, 2.0, 2.5, 3.0, 9.9, 10.0] + list(vals)))
        for v in tests:
            v = f32(v)
            sw.append([list(vals), v, RS.state_switch(list(vals), v)])
    fx["stateSwitch"] = sw
    lods = []
    dist_sets = sorted({tuple(n["distances"]) for n in desc["nodes"] if n["kind"] == "lod"})
    for dists in dist_sets:
        for d in list(dists) + [rnd.uniform(0, dists[-1] * 1.3) for _ in range(25)] + [-1.0, 1e6]:
            d = f32(d)
            for floor in (0, 2):
                lods.append([list(dists), d, floor, RS.lod(list(dists), d, floor=floor)])
    fx["lod"] = lods
    anim = []
    for n in desc["nodes"]:
        if n.get("keys") and not any(a["name"] == n["name"] for a in anim):
            keys = n["keys"]
            times = [k[0] for k in keys]
            samples = sorted(set([-10.0, 0.0, 1.0, times[-1], times[-1] + 50.0] + [float(t) for t in times] +
                                 [f32(rnd.uniform(0, times[-1])) for _ in range(20)]))
            vals = []
            for t in samples:
                tr, M = RS.animated(keys, t)
                vals.append([t, tr, M])
            anim.append({"name": n["name"], "keys": keys, "samples": vals})
    fx["animated"] = anim
    # reference rig (pipeline/nr2003res/rig.py, validated by the preview renders) -----------------------------------
    rigs = []
    scen = [
        ({"cockpitView": 1.0, "steeringWheelEnable": 0.0, "windshieldEnable": 0.0, "day_night": 0.0},
         {"steer": 0.05, "spin": [0.3, 0.4, 1.0, 1.1], "wheelZ": [-0.05, -0.051, -0.08, -0.079], "steeringWheelAngle": -0.6,
          "gauges": {"ptach": -0.4, "poilp": 0.3, "poilt": 0.2, "pfuel": 0.1, "pwater": -0.6, "pvoltage": 0.9},
          "shifter": [0.12, -0.05], "head": [-0.74, 0.41, 0.47], "headPitch": 0.025, "headRoll": -0.02,
          "body": [0.3, 0.02, -0.03]}, (0.0, 0.0, 0.5)),
        ({"cockpitView": 0.0, "timeValue": 1170.0, "wheel_speed_0": 1.0, "wheel_speed_1": 2.0}, {"steer": -0.1, "spin": [1, 2, 3, 4],
          "wheelZ": [-0.06, -0.06, -0.07, -0.07], "steeringWheelAngle": 0.0, "gauges": {}}, (-6.0, 0.0, 2.25)),
        ({"cockpitView": 0.0, "timeValue": 2400.0}, {"steer": 0.0, "spin": [0, 0, 0, 0], "wheelZ": None,
          "steeringWheelAngle": 0.0, "gauges": {}}, (-30.0, 5.0, 3.0)),
    ]
    for vars_, ds, campos in scen:
        if "body" in ds:   # body pitch / roll as 005f74c0 returns them for the body matrix
            _, bp, br = E.decompose(E.euler(*ds["body"]))
            ds["bodyPitchRoll"] = [bp, br]
        _, active = R.evaluate(desc, vars_, ds, camera_pos=campos)
        rigs.append({"vars": vars_, "ds": {k: v for k, v in ds.items() if v is not None}, "camera": list(campos),
                     "active": [[inst["id"], list(t), list(M)] for inst, (t, M) in active]})
    fx["rig"] = rigs
    out.write_text("-- GENERATED by nr2003carmodel_implementation/recovery/gen_fixtures.py from the ORIGINAL NR2003.exe /\n"
                   "-- rendserv.dll code executed in Unicorn (orig_carmodel.py) and the reference rig; do not edit.\n"
                   "return " + lua(fx) + "\n")
    print("fixtures:", {k: len(v) for k, v in fx.items()})
    # Studio self-test subset (roblox/CarModel/NR2003CarModelGolden.lua): original-code vectors only, no model data
    golden = {"gauges": fx["gauges"], "euler": fx["euler"][:40], "decompose": fx["decompose"][:40], "ease": fx["ease"],
              "wheelSpeed": fx["wheelSpeed"], "cameras": fx["cameras"][::2], "onCar": fx["onCar"], "camTables": fx["camTables"],
              "constants": fx["constants"], "stateSwitch": fx["stateSwitch"], "lod": fx["lod"]}
    gpath = HERE.parent / "roblox" / "CarModel" / "NR2003CarModelGolden.lua"
    text = ("-- NR2003CarModelGolden: golden vectors of the ORIGINAL NR2003.exe / rendserv.dll code (Unicorn, recovery/\n"
            "-- orig_carmodel.py) for NR2003CarModelSelfTest. GENERATED by recovery/gen_fixtures.py; do not edit.\n"
            "return " + lua(golden) + "\n")
    gpath.write_text(text)
    print("golden:", gpath, len(text), "chars")


if __name__ == "__main__":
    main()
