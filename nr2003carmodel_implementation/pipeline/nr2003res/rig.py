"""Reference rig evaluation (Python twin of roblox/CarModel/NR2003CarModelRig.lua).

Evaluates the exported descriptor exactly as the original draw path does (NR2003.exe 005662d0 + rendserv.dll
compiled-node traversal), in NR2003 model axes (metres, +X fwd, +Y left, +Z up):
  frames            T(t) R(h, p, r), R = Rz(h) Ry(p) Rx(r)                       (005f6f20)
  AnimatedTransform keys bracketed by t < key.time, translation lerp, quaternion nlerp with sign flip when
                    |q2 - q1|^2 >= 1, normalised, (x, y, z, w)                      (rendserv 10012810 / 10012970)
  StateSwitch       values[i] <= v < values[i+1], nothing outside [values[0], values[n]]   (rendserv 10011ec0)
  LodSwitch         first threshold >= distance (scaled), detail floor if < level count (rendserv 100118e0)
Draw-time node overrides (005662d0), given a draw state `ds`:
  lf/rf wheel  translate (rest x, rest y, ds.wheelZ[i]); rotate (ds.steer + 1.570795, rest r, ds.spin[i])
  lr/rr wheel  translate (rest x, rest y, ds.wheelZ[i]); rotate (rest h + 1.570795, rest r, ds.spin[i])
  steer        rotate (rest h, rest p, ds.steeringWheelAngle)            (cockpit camera only: drawobj+0x30 bit 0x01)
  shifter      rotate (rest h, ds.shifter[0], ds.shifter[1])             (cockpit camera only)
  needles      rotate (0, rest p, gauge angle)                           (0056edd0 / 0056f040; focus car, every view)
  head         translate ds.head (car+0x153c.. = head node rest + head-state displacement), rotate
               (0, headPitch - body pitch, headRoll - body roll)         (00566538..0056658a)
"""
import math

HALF_PI_F32 = 1.5707950592041016          # 006f5e74 (f32 1.570795)
WHEELS = {"lfwheel": 0, "rfwheel": 1, "lrwheel": 2, "rrwheel": 3}
NEEDLES = ("ptach", "poilp", "poilt", "pfuel", "pwater", "pvoltage")


def euler(h, p, r):
    ch, sh, cp, sp, cr, sr = math.cos(h), math.sin(h), math.cos(p), math.sin(p), math.cos(r), math.sin(r)
    return [cp * ch, ch * sr * sp - cr * sh, sr * sh + ch * cr * sp,
            cp * sh, cr * ch + sr * sp * sh, cr * sp * sh - sr * ch,
            -sp, sr * cp, cr * cp]


def mat_from_quat(q):
    x, y, z, w = q
    return [2 * x * x + 2 * w * w - 1, 2 * x * y - 2 * w * z, 2 * x * z + 2 * w * y,
            2 * x * y + 2 * w * z, 2 * y * y + 2 * w * w - 1, 2 * y * z - 2 * w * x,
            2 * x * z - 2 * w * y, 2 * y * z + 2 * w * x, 2 * z * z + 2 * w * w - 1]


def mul(A, B):
    return [sum(A[3 * i + k] * B[3 * k + j] for k in range(3)) for i in range(3) for j in range(3)]


def apply(A, v):
    return (A[0] * v[0] + A[1] * v[1] + A[2] * v[2], A[3] * v[0] + A[4] * v[1] + A[5] * v[2],
            A[6] * v[0] + A[7] * v[1] + A[8] * v[2])


def compose(parent, t, R):
    pt, pR = parent
    tt = apply(pR, t)
    return ((pt[0] + tt[0], pt[1] + tt[1], pt[2] + tt[2]), mul(pR, R))


def animated(keys, t):
    n = len(keys)
    k, f = 1, 0.0
    if keys[0][0] < t:
        found = False
        for i in range(1, n):
            if t < keys[i][0]:
                f = (t - keys[i - 1][0]) / (keys[i][0] - keys[i - 1][0])
                k = i
                found = True
                break
        if not found:
            f, k = 1.0, n - 1
    k = min(k, n - 1)
    a, b = keys[k - 1], keys[k]
    tr = tuple((b[2][j] - a[2][j]) * f + a[2][j] for j in range(3))
    if f == 0:
        q = a[1]
    elif f >= 1:
        q = b[1]
    else:
        q1, q2 = a[1], b[1]
        g = 1 - f
        if sum((q2[j] - q1[j]) ** 2 for j in range(4)) >= 1:
            q = [g * q1[j] - f * q2[j] for j in range(4)]
        else:
            q = [f * q2[j] + g * q1[j] for j in range(4)]
        s = 1 / math.sqrt(sum(x * x for x in q))
        q = [x * s for x in q]
    return tr, mat_from_quat(q)


def select_state(values, v):
    n = len(values) - 1
    if n < 1 or v < values[0] or v > values[n]:
        return None
    i = 0
    for k in range(1, n):
        if v < values[k]:
            break
        i += 1
    return i


def select_lod(distances, d, floor=0):
    n = len(distances)
    i = 0
    for k in range(1, n):
        if d <= distances[k]:
            break
        i += 1
    if floor < n and i < floor:      # renderer detail floor (vf +0x154) only when below the level count
        i = floor
    return i


def default_draw_state():
    return {"steer": 0.0, "spin": [0, 0, 0, 0], "wheelZ": None, "steeringWheelAngle": 0.0,
            "gauges": {}, "head": None, "cockpit": False}


def evaluate(desc, variables, ds, camera_pos=None, lod_scale=1.0, lod_floor=0):
    """Returns (frames {node id: (t, R)}, active instance list [(instance, (t, R))]) in model space."""
    nodes = desc["nodes"]
    kids = {}
    for n in nodes:
        if n.get("parent") is not None:
            kids.setdefault(n["parent"], []).append(n)
    world = {}
    active = set()
    cockpit = variables.get("cockpitView") == 1
    ident = ((0.0, 0.0, 0.0), [1, 0, 0, 0, 1, 0, 0, 0, 1])

    def frame_local(n):
        name = n.get("name", "")
        t = list(n["t"])
        h, p, r = n["hpr"]
        if "keys" in n:
            tr, R = animated(n["keys"], variables.get(n.get("channel"), 0.0))
            return tr, R
        if name in WHEELS:
            i = WHEELS[name]
            if ds.get("wheelZ") is not None:
                t[2] = ds["wheelZ"][i]
            head = ds["steer"] if i < 2 else h
            return tuple(t), euler(head + HALF_PI_F32, r, ds["spin"][i])
        if name in NEEDLES and name in ds.get("gauges", {}):          # focus car: every view
            return tuple(t), euler(0.0, p, ds["gauges"][name])
        if cockpit and name == "steer":                                # cockpit camera only (drawobj+0x30 bit 0x01)
            return tuple(t), euler(h, p, ds.get("steeringWheelAngle", 0.0))
        if cockpit and name == "shifter" and ds.get("shifter") is not None:
            return tuple(t), euler(h, ds["shifter"][0], ds["shifter"][1])
        if name == "head" and ds.get("head") is not None:
            bp, br = ds.get("bodyPitchRoll", (0.0, 0.0))
            return tuple(ds["head"]), euler(0.0, ds.get("headPitch", 0.0) - bp, ds.get("headRoll", 0.0) - br)
        return tuple(t), euler(h, p, r)

    def walk(n, xf):
        k = n["kind"]
        if k in ("frame",):
            xf = compose(xf, *frame_local(n))
        elif k == "billboard":
            xf = compose(xf, tuple(n["pivot"]), [1, 0, 0, 0, 1, 0, 0, 0, 1])
        world[n["id"]] = xf
        active.add(n["id"])
        ch = kids.get(n["id"], [])
        if k == "switch":
            i = select_state(n["values"], variables.get(n["variable"], n.get("default", 0.0)))
            for c in ch:
                if i is not None and c["index"] == i:
                    walk(c, xf)
            return
        if k == "lod":
            if camera_pos is None:
                i = lod_floor if lod_floor < len(n["distances"]) else 0
            else:
                cx, cy, cz = compose(xf, tuple(n["center"]), [1, 0, 0, 0, 1, 0, 0, 0, 1])[0]
                d = math.dist((cx, cy, cz), camera_pos) * lod_scale
                i = select_lod(n["distances"], d, lod_floor)
            levels = [c for c in ch]
            idx = min(i, max(c["index"] for c in levels)) if levels else None
            for c in levels:
                if c["index"] == idx:
                    walk(c, xf)
            return
        for c in ch:
            walk(c, xf)

    walk(nodes[0], ident)
    out = [(inst, world[inst["frame"]]) for inst in desc["instances"] if inst["node"] in active]
    return world, out
