"""Scene builder: Papyrus .3do object graph -> rig description (frames, switches, LODs, merged mesh buckets).

Semantics recovered from NR2003.exe / rendserv.dll (see ../../recovery/CARMODEL_RECOVERY.md):
  * Transform / AnimatedTransform: child coordinates are local to t + R, R = Rz(h) Ry(p) Rx(r) (005f6f20).
  * StateSwitch (rendserv CompiledStateSwitch 10011ec0): variable v selects child i with values[i] <= v and
    v < values[i+1] (last child up to values[n] inclusive); v outside [values[0], values[n]] draws nothing.
  * LodSwitch (rendserv CompiledLODSwitch 100118e0): level i = number of thresholds distances[1..] below the
    distance to the switch centre.
Shared objects (back references) become ONE geometry with several instances (e.g. the four gauge needles, the
wheel LODs repeated in every body LOD). Geometry stays in its frame's local coordinates (metres, NR2003 axes).
Variables with a fixed value for this milestone (damage, out of scope) are resolved here and their other branches
are dropped; every other switch is kept for the runtime. carMakeIdx is fixed to the exported make.
"""
from . import obj3do

# damage / debris variables: the undamaged car (00429a80 binds them; 0042b6c0 writes damaged = 0 with no damage)
FIXED_DAMAGE = {
    "damaged": 0.0, "chassis_damage": 0.0, "corners_damage": 0.0, "grill_damage": 0.0, "hood_damage": 0.0,
    "rend_damage": 0.0, "rf_removed": 0.0, "lf_removed": 0.0, "rr_removed": 0.0, "lr_removed": 0.0,
    "grill_removed": 0.0, "hood_removed": 0.0, "rend_removed": 0.0, "frontend_broken": 0.0, "rearend_broken": 0.0,
    "panels_or_fragments": 0.0, "panel_selector": 0.0, "fragment_selector": 0.0,
}


def select_state(values, v):
    """Child index chosen by the original CompiledStateSwitch for value v (None = nothing drawn)."""
    n = len(values) - 1
    if n < 1 or v < values[0] or v > values[n]:
        return None
    i = 0
    for k in range(1, n):
        if v < values[k]:
            break
        i += 1
    return i


def select_lod(distances, d):
    """Level chosen by the original CompiledLODSwitch for (scaled) distance d."""
    i = 0
    for k in range(1, len(distances)):
        if d <= distances[k]:
            break
        i += 1
    return i


class Scene:
    def __init__(self):
        self.nodes = []      # dicts: id, parent, kind, name, ...
        self.geometries = []  # unique shapes: id, handle, name, material, positions, normals, uvs, tris (frame-local)
        self.geometry_of = {}  # 3do object handle -> geometry id (shared objects = one geometry)
        self.instances = []   # id, node (tree parent), frame (nearest frame/billboard/root), geometry, selflit

    def add(self, parent, kind, **kw):
        n = dict(id=len(self.nodes), parent=parent, kind=kind, **kw)
        self.nodes.append(n)
        return n["id"]


def _material(app, selflit):
    tex = []
    if app is not None:
        tex = [t.texture.lower() if t is not None else None for t in app.textures]
    m = {"textures": tex,
         "ambient": list(app.ambient) if app else [1, 1, 1], "diffuse": list(app.diffuse) if app else [1, 1, 1],
         "specular": list(app.specular) if app else [0, 0, 0], "shininess": app.shininess if app else 0,
         "reflectivity": app.reflectivity if app else 0, "opacity": app.opacity if app else 1,
         "envmap": app.envmap_index if app else 0, "selflit": selflit}
    return m


def triangles(prim):
    """Triangles of one primitive chain (TriList / TriStrip / TriFan), degenerate ones removed."""
    out = []
    while prim is not None:
        ix = prim.indices
        if prim.cls == "TriList":
            for k in range(0, len(ix) - 2, 3):
                out.append((ix[k], ix[k + 1], ix[k + 2]))
        elif prim.cls == "TriStrip":
            for k in range(len(ix) - 2):
                a, b, c = ix[k], ix[k + 1], ix[k + 2]
                out.append((a, b, c) if k % 2 == 0 else (b, a, c))
        elif prim.cls == "TriFan":
            for k in range(1, len(ix) - 1):
                out.append((ix[0], ix[k], ix[k + 1]))
        prim = prim.next
    return [t for t in out if t[0] != t[1] and t[1] != t[2] and t[0] != t[2]]


def _orient(P, N, tris):
    """Winding agreeing with the authored vertex normals (right-handed, counter-clockwise front)."""
    agree = disagree = 0
    for a, b, c in tris:
        ux, uy, uz = P[b][0] - P[a][0], P[b][1] - P[a][1], P[b][2] - P[a][2]
        vx, vy, vz = P[c][0] - P[a][0], P[c][1] - P[a][1], P[c][2] - P[a][2]
        gx, gy, gz = uy * vz - uz * vy, uz * vx - ux * vz, ux * vy - uy * vx
        nx = N[a][0] + N[b][0] + N[c][0]
        ny = N[a][1] + N[b][1] + N[c][1]
        nz = N[a][2] + N[b][2] + N[c][2]
        d = gx * nx + gy * ny + gz * nz
        if d > 0:
            agree += 1
        elif d < 0:
            disagree += 1
    return agree, disagree


def build(root, variables, make, keep_lods=None):
    """Walk the graph. variables: fixed values (damage + make + caller extras); make: carMakeIdx exported."""
    fixed = dict(FIXED_DAMAGE)
    fixed.update(variables or {})
    fixed["carMakeIdx"] = float(make)
    sc = Scene()
    rid = sc.add(None, "root", name="")
    stats = {"agree": 0, "disagree": 0, "shapes": 0}

    def walk(n, parent, frame, selflit):
        if n is None:
            return
        c = n.cls
        if c in ("Transform", "AnimatedTransform"):
            kw = dict(name=n.name, t=list(n.translation), hpr=list(n.rotation))
            if c == "AnimatedTransform":
                kw.update(channel=n.channel, keys=[[k[0], list(k[1]), list(k[2])] for k in n.keys])
            fid = sc.add(parent, "frame", **kw)
            walk(n.child, fid, fid, selflit)
        elif c == "Billboard":
            fid = sc.add(parent, "billboard", name=n.name, pivot=list(n.pivot), axis=list(n.axis))
            walk(n.child, fid, fid, selflit)
        elif c == "Group":
            gid = parent
            if n.name:
                gid = sc.add(parent, "group", name=n.name)
            for ch in n.children:
                walk(ch, gid, frame, selflit)
        elif c == "StateSwitch":
            var = n.state_name
            if var in fixed:
                i = select_state(n.values, fixed[var])
                if i is not None and i < len(n.children):
                    walk(n.children[i], parent, frame, selflit)
                return
            sid = sc.add(parent, "switch", name=n.name, variable=var, values=list(n.values), default=n.default,
                         enabled=n.enabled)
            for i, ch in enumerate(n.children):
                cid = sc.add(sid, "case", name="", index=i)
                walk(ch, cid, frame, selflit)
        elif c == "LodSwitch":
            lid = sc.add(parent, "lod", name=n.name, center=list(n.center), distances=list(n.distances),
                         enabled=n.enabled)
            for i, ch in enumerate(n.children):
                if keep_lods is not None and i not in keep_lods:
                    continue
                cid = sc.add(lid, "level", name="", index=i)
                walk(ch, cid, frame, selflit)
        elif c == "SelfLighting":
            sl = {"diffuse": list(n.diffuse) if n.diffuse_set else None,
                  "specular": list(n.specular) if n.specular_set else None,
                  "ambient": list(n.ambient) if n.ambient_set else None}
            walk(n.child, parent, frame, sl)
        elif c == "Portal":
            vl = n.target
            pts = [[vl.position[0][i], vl.position[1][i], vl.position[2][i]] for i in n.indices] if vl else []
            sc.add(parent, "portal", name=n.name, polygon=pts)
        elif c == "Shape":
            g = n.geometry
            if g is None or g.vertex_list is None:
                return
            gid = sc.geometry_of.get(n.handle)
            if gid is None:
                vl = g.vertex_list
                tris = triangles(g.primitive)
                if not tris:
                    sc.geometry_of[n.handle] = -1
                    return
                nv = vl.count
                P = list(zip(*vl.position))
                N = list(zip(*vl.normal)) if vl.normal[0] is not None else [(0.0, 0.0, 0.0)] * nv
                U = vl.attributes[0] if vl.attributes and vl.attributes[0] is not None else [0.0] * nv
                V = vl.attributes[1] if vl.attributes and vl.attributes[1] is not None else [0.0] * nv
                ag, dg = _orient(P, N, tris)
                stats["agree"] += ag
                stats["disagree"] += dg
                gid = len(sc.geometries)
                sc.geometries.append(dict(id=gid, handle=n.handle, name=n.name, vertexList=vl.cls,
                                          material=_material(n.appearance, None), positions=P, normals=N,
                                          uvs=list(zip(U, V)), tris=tris))
                sc.geometry_of[n.handle] = gid
            if gid < 0:
                return
            stats["shapes"] += 1
            sc.instances.append(dict(id=len(sc.instances), node=parent, frame=frame, geometry=gid,
                                     selflit=selflit))
        elif c == "Empty":
            pass
        else:
            raise obj3do.FormatError("scene: unexpected %s" % c)

    walk(root, rid, rid, None)
    sc.stats = stats
    return sc
