#!/usr/bin/env python3
"""Validation renderer: rebuilds the car from the EXPORTED package (OBJ geometry library + descriptor JSON) with the
reference rig (nr2003res/rig.py) and renders it from the ORIGINAL camera definitions with the original projection
(4:3 horizontal FOV converted Hor+ to the output aspect, frustum shifted by the camera's (0, -0.125) centre offset,
rendserv 100043a0 / NR2003.exe 00587e70). Software z-buffer, perspective-correct texturing, alpha test.

usage: python3 -I preview.py --pkg <convert_car --out dir> --png out.png [--width 640 --height 360]
"""
import argparse
import json
import math
import os
import sys

import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nr2003res import rig  # noqa: E402

BODY_Z = 0.42   # chassis reference height of the bench car at rest (the core starts at z = 0.42 m)


def load_obj(path):
    objs, cur = {}, None
    V, T, N = [], [], []
    for line in open(path):
        if line.startswith("o "):
            cur = line[2:].strip()
            objs[cur] = {"f": [], "mtl": None}
        elif line.startswith("v "):
            V.append([float(x) for x in line.split()[1:4]])
        elif line.startswith("vt "):
            T.append([float(x) for x in line.split()[1:3]])
        elif line.startswith("vn "):
            N.append([float(x) for x in line.split()[1:4]])
        elif line.startswith("usemtl "):
            objs[cur]["mtl"] = line.split()[1]
        elif line.startswith("f "):
            idx = []
            for tok in line.split()[1:]:
                parts = tok.split("/")
                vi = int(parts[0]) - 1
                ti = int(parts[1]) - 1 if len(parts) > 1 and parts[1] else -1
                idx.append((vi, ti))
            objs[cur]["f"].append(idx)
    return objs, np.array(V), np.array(T) if T else np.zeros((0, 2))


def load_mtl(path, texdir):
    mats, cur = {}, None
    for line in open(path):
        if line.startswith("newmtl "):
            cur = line.split()[1]
            mats[cur] = {"tex": None, "d": 1.0, "kd": (1, 1, 1)}
        elif line.startswith("map_Kd "):
            p = os.path.join(texdir, line.split()[1])
            if os.path.exists(p):
                mats[cur]["tex"] = np.asarray(Image.open(p).convert("RGBA"), dtype=np.float32) / 255.0
        elif line.startswith("d "):
            mats[cur]["d"] = float(line.split()[1])
        elif line.startswith("Kd "):
            mats[cur]["kd"] = tuple(float(x) for x in line.split()[1:4])
    return mats


def to_nr(p, mps):
    """Roblox studs (x=-y, y=z, z=-x) -> NR2003 metres."""
    return np.stack([-p[:, 2] * mps, -p[:, 0] * mps, p[:, 1] * mps], axis=1)


class Camera:
    def __init__(self, eye, R, fov43, shift=(0.0, -0.125), aspect=16 / 9):
        self.eye = np.array(eye, dtype=np.float64)
        self.R = np.array(R, dtype=np.float64).reshape(3, 3)      # columns: fwd, left, up (world)
        vfov = 2 * math.atan(math.tan(fov43 / 2) * 0.75)          # 00587e70: 4:3 horizontal -> vertical
        self.th = math.tan(vfov / 2)
        self.tw = self.th * aspect                                  # Hor+ for the output aspect
        self.cx, self.cy = shift


def render(cam, tris_world, W, H, sky=(0.62, 0.72, 0.85)):
    img = np.zeros((H, W, 3), dtype=np.float32)
    img[:] = sky
    zb = np.full((H, W), np.inf, dtype=np.float32)
    L = np.array([0.4, 0.3, 0.86])
    L /= np.linalg.norm(L)
    for P, UV, mat in tris_world:
        rel = P - cam.eye
        c = rel @ cam.R            # (fwd, left, up)
        if np.any(c[:, 0] < 0.05):
            continue
        sx = (-c[:, 1] / c[:, 0]) / cam.tw          # [-1, 1] before shift
        sy = (c[:, 2] / c[:, 0]) / cam.th
        sx = sx - cam.cx
        sy = sy - cam.cy                             # frustum shift: the view axis lands at ndc (-cx, -cy)
        px = (sx + 1) * 0.5 * W
        py = (1 - (sy + 1) * 0.5) * H
        x0, x1 = int(max(0, math.floor(px.min()))), int(min(W - 1, math.ceil(px.max())))
        y0, y1 = int(max(0, math.floor(py.min()))), int(min(H - 1, math.ceil(py.max())))
        if x0 > x1 or y0 > y1:
            continue
        area = (px[1] - px[0]) * (py[2] - py[0]) - (px[2] - px[0]) * (py[1] - py[0])
        if area >= 0:                   # counter-clockwise in a right-handed world = clockwise on screen (y down)
            continue
        n = np.cross(P[1] - P[0], P[2] - P[0])
        n = n / (np.linalg.norm(n) or 1)
        shade = 0.55 + 0.45 * max(0.0, float(n @ L))
        xs, ys = np.meshgrid(np.arange(x0, x1 + 1) + 0.5, np.arange(y0, y1 + 1) + 0.5)
        w0 = ((px[1] - xs) * (py[2] - ys) - (px[2] - xs) * (py[1] - ys)) / area
        w1 = ((px[2] - xs) * (py[0] - ys) - (px[0] - xs) * (py[2] - ys)) / area
        w2 = 1 - w0 - w1
        inside = (w0 >= 0) & (w1 >= 0) & (w2 >= 0)
        if not inside.any():
            continue
        iz = w0 / c[0, 0] + w1 / c[1, 0] + w2 / c[2, 0]
        z = 1 / iz
        sub = zb[y0:y1 + 1, x0:x1 + 1]
        m = inside & (z < sub)
        if not m.any():
            continue
        col = np.ones(xs.shape + (4,), dtype=np.float32)
        col[..., :3] = mat["kd"]
        tex = mat["tex"]
        if tex is not None and UV is not None:
            u = (w0 * UV[0, 0] / c[0, 0] + w1 * UV[1, 0] / c[1, 0] + w2 * UV[2, 0] / c[2, 0]) * z
            v = (w0 * UV[0, 1] / c[0, 0] + w1 * UV[1, 1] / c[1, 0] + w2 * UV[2, 1] / c[2, 0]) * z
            th, tw = tex.shape[:2]
            ti = np.clip(((1 - v) % 1.0 * th).astype(int), 0, th - 1)   # OBJ v back to the image row
            tj = np.clip((u % 1.0 * tw).astype(int), 0, tw - 1)
            col = tex[ti, tj]
        a = col[..., 3] * mat["d"]
        m &= a > 0.35
        if not m.any():
            continue
        rgb = col[..., :3] * shade
        sub[m] = z[m]
        dst = img[y0:y1 + 1, x0:x1 + 1]
        blend = np.clip(a, 0, 1)[..., None]
        dst[m] = (rgb * blend + dst * (1 - blend))[m]
    return img


def build_triangles(desc, objs, V, T, mats, variables, ds, cam_pos, mps):
    _, active = rig.evaluate(desc, variables, ds, camera_pos=cam_pos)
    geo_name = {g["id"]: g["name"] for g in desc["geometries"]}
    out = []
    for inst, (t, R) in active:
        o = objs.get(geo_name[inst["geometry"]])
        if o is None:
            continue
        Rm = np.array(R).reshape(3, 3)
        tv = np.array(t)
        mat = mats.get(o["mtl"], {"tex": None, "d": 1, "kd": (1, 1, 1)})
        for f in o["f"]:
            vi = [x[0] for x in f]
            ti = [x[1] for x in f]
            Pn = to_nr(V[vi], mps) @ Rm.T + tv
            Pn[:, 2] += BODY_Z
            UV = T[ti] if min(ti) >= 0 else None
            out.append((Pn, UV, mat))
    return out


def ground(size=60.0, step=1.0):
    """Checker ground (1 m cells) so horizon, pitch and scale are readable; small cells avoid near-plane culling."""
    out = []
    mats = [{"tex": None, "d": 1.0, "kd": (0.36, 0.38, 0.36)}, {"tex": None, "d": 1.0, "kd": (0.30, 0.32, 0.30)}]
    n = int(size / step)
    for i in range(-n, n):
        for j in range(-n, n):
            x0, y0 = i * step, j * step
            x1, y1 = x0 + step, y0 + step
            g = mats[(i + j) & 1]
            out.append((np.array([(x0, y0, 0), (x1, y0, 0), (x1, y1, 0)], float), None, g))
            out.append((np.array([(x0, y0, 0), (x1, y1, 0), (x0, y1, 0)], float), None, g))
    return out


def cameras(desc, ds_head):
    """Original camera definitions at rest (body frame = identity at height BODY_Z)."""
    I = rig.euler(0, 0, 0)
    out = {}
    head = ds_head
    eye = (head[0] + 0.1, head[1] + 0.0, head[2] + 0.1 + BODY_Z)        # 0074ebbc (0.1, 0, 0.1)
    out["cockpit"] = (eye, I, math.radians(65.0))                        # cockpit FOV option default 65 deg
    out["external"] = ((3.2, -4.6, 1.5 + BODY_Z), rig.euler(math.atan2(4.6, -3.2), 0.12, 0), math.radians(60))
    out["F10Near"] = ((-6.0, 0.0, 2.25 + BODY_Z), rig.euler(0, 0.18, 0), 1.3612565994262695)
    out["F10Far"] = ((-9.0, 0.0, 4.0 + BODY_Z), rig.euler(0, 0.1995, 0), 1.3612565994262695)
    for name in ("Roll Bar", "Nose"):
        c = desc["cameras"][name]
        p = c["pos"]
        out[name] = ((p[0], p[1], p[2] + BODY_Z), rig.euler(*c["hpr"]), c["fov"][0])
    return out


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--pkg", required=True)
    ap.add_argument("--png", required=True)
    ap.add_argument("--width", type=int, default=640)
    ap.add_argument("--height", type=int, default=360)
    ap.add_argument("--views", default="cockpit,Roll Bar,F10Near,F10Far,Nose,external")
    ap.add_argument("--livery", default=None, help="PNG that replaces the card texture (the .car CTEX)")
    ap.add_argument("--steer", type=float, default=0.0, help="mean front hub steer car[0x1554] (rad, + = left)")
    ap.add_argument("--ratio", type=float, default=12.0)
    a = ap.parse_args(argv)
    desc = json.load(open(os.path.join(a.pkg, "json", "make_a.json")))
    mps = desc["metresPerStud"]
    objs, V, T = load_obj(os.path.join(a.pkg, "obj", "make_a.obj"))
    mats = load_mtl(os.path.join(a.pkg, "obj", "make_a.mtl"), os.path.join(a.pkg, "textures"))
    if a.livery:
        lv = np.asarray(Image.open(a.livery).convert("RGBA"), dtype=np.float32) / 255.0
        for k, m in mats.items():
            if k == "T_card" or k.startswith("T_card_op"):
                m["tex"] = lv
    head_rest = [n for n in desc["nodes"] if n.get("name") == "head"][0]["t"]
    wheelZ = [-0.0527, -0.0528, -0.0783, -0.0783]          # car+0x1558.. of the settled bench car (probe)
    gauge = {"ptach": math.radians(-116 + 257 * 0.3), "poilp": math.radians(-40 + 260 * (2.95 - 0.5) / 6.0),
             "poilt": math.radians(-40 + 260 * (93 - 60) / 67.0), "pfuel": math.radians(-40 + 260 * 0.612 / 1.08),
             "pwater": math.radians(-40), "pvoltage": math.radians(-40 + 260 * 13.8 / 27.0)}
    views = a.views.split(",")
    cams = cameras(desc, head_rest)
    tiles = []
    for v in views:
        eye, R, fov = cams[v]
        cockpit = v == "cockpit"
        hidden = v in ("Nose", "Gearbox", "F Susp", "R Susp")      # 0056bb30: car hidden -> cockpitView 10
        variables = {"cockpitView": 1.0 if cockpit else (10.0 if hidden else 0.0), "windshieldEnable": 0.0, "steeringWheelEnable": 0.0,
                     "mirrorFrameEnable": 0.0, "day_night": 0.0, "wheel_speed_0": 0.0, "wheel_speed_1": 0.0,
                     "wheel_speed_2": 0.0, "wheel_speed_3": 0.0, "tachLightEnable": 0.0, "roofFlapsEnable": 0.0,
                     "animate_driver": 0.0, "animate_wheel": 0.0, "timeValue": 1600.0, "backfireFrame": 0.0}
        swa = max(-2.79, min(2.79, -(a.ratio * a.steer)))
        ds = {"steer": a.steer, "spin": [0, 0, 0, 0], "wheelZ": wheelZ, "steeringWheelAngle": swa,
              "gauges": gauge if cockpit else {}, "head": None}
        cam = Camera(eye, R, fov, aspect=a.width / a.height)
        tris = ground() + build_triangles(desc, objs, V, T, mats, variables, ds, eye, mps)
        img = render(cam, tris, a.width, a.height)
        tiles.append((v, Image.fromarray((np.clip(img, 0, 1) * 255).astype(np.uint8))))
    cols = 2
    rows = (len(tiles) + 1) // 2
    sheet = Image.new("RGB", (cols * a.width, rows * a.height), (20, 20, 20))
    from PIL import ImageDraw
    for i, (v, im) in enumerate(tiles):
        d = ImageDraw.Draw(im)
        d.text((8, 6), v, fill=(255, 255, 0))
        sheet.paste(im, ((i % cols) * a.width, (i // cols) * a.height))
    sheet.save(a.png)


if __name__ == "__main__":
    main()
