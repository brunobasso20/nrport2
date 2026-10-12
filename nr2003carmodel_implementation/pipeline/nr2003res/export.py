"""Exporters: OBJ/MTL geometry library (Roblox axes, studs), textures (PNG), rig descriptor (JSON + Luau module).

Geometry library: one OBJ object per unique 3do Shape ("G%03d_<name>"), vertices in the local frame of the node the
shape hangs under, converted to Roblox axes/studs (scale.point). Four calibration markers (tetrahedra) at the file
origin and +4 studs on X/Y/Z let the Roblox installer recover any rigid transform or uniform scale the Studio 3D
Importer applies. UV: v is written as 1 - v (OBJ convention; the 3do/MIP data are Direct3D, v = 0 = first row).
"""
import json
import math
import os
from . import scale

MARKERS = {"NR2003_MARKER_O": (0.0, 0.0, 0.0), "NR2003_MARKER_X": (4.0, 0.0, 0.0),
           "NR2003_MARKER_Y": (0.0, 4.0, 0.0), "NR2003_MARKER_Z": (0.0, 0.0, 4.0)}
MARKER_SIZE = 0.25


def base_texture(material):
    tex = [t for t in material["textures"] if t]
    return tex[0] if tex else None


def tex_stem(name):
    return os.path.splitext(name)[0] if name else "untextured"


def geometry_name(g):
    nm = "".join(ch if ch.isalnum() or ch == "_" else "_" for ch in (g["name"] or ""))[:24]
    return "G%03d_%s" % (g["id"], nm) if nm else "G%03d" % g["id"]


def geometry_bounds(g, mps):
    pts = [scale.point(*p, mps=mps) for p in g["positions"]]
    lo = [min(p[i] for p in pts) for i in range(3)]
    hi = [max(p[i] for p in pts) for i in range(3)]
    return lo, hi


def write_obj(scene, path, mtl_name, mps=scale.METRES_PER_STUD, header=""):
    lines = ["# " + l for l in header.splitlines()]
    lines.append("mtllib %s" % mtl_name)
    vbase = tbase = nbase = 1
    for g in scene.geometries:
        lines.append("o %s" % geometry_name(g))
        mat = "T_" + tex_stem(base_texture(g["material"]))
        if g["material"]["opacity"] < 1:
            mat += "_op%03d" % int(round(g["material"]["opacity"] * 100))
        lines.append("usemtl %s" % mat)
        for p in g["positions"]:
            lines.append("v %.6f %.6f %.6f" % scale.point(*p, mps=mps))
        for u, v in g["uvs"]:
            lines.append("vt %.6f %.6f" % (u, 1.0 - v))
        for n in g["normals"]:
            x, y, z = scale.vector(*n)
            ln = math.sqrt(x * x + y * y + z * z) or 1.0
            lines.append("vn %.6f %.6f %.6f" % (x / ln, y / ln, z / ln))
        for a, b, c in g["tris"]:
            lines.append("f %d/%d/%d %d/%d/%d %d/%d/%d" % (vbase + a, tbase + a, nbase + a, vbase + b, tbase + b,
                                                        nbase + b, vbase + c, tbase + c, nbase + c))
        k = len(g["positions"])
        vbase += k
        tbase += k
        nbase += k
    for name, (x, y, z) in MARKERS.items():
        s = MARKER_SIZE
        lines.append("o %s" % name)
        lines.append("usemtl T_marker")
        for dx, dy, dz in ((s, 0, 0), (0, s, 0), (0, 0, s), (-s * 0.5, -s * 0.5, -s * 0.5)):
            lines.append("v %.6f %.6f %.6f" % (x + dx, y + dy, z + dz))
        for a, b, c in ((1, 2, 3), (1, 4, 2), (2, 4, 3), (3, 4, 1)):
            lines.append("f %d %d %d" % (vbase + a - 1, vbase + b - 1, vbase + c - 1))
        vbase += 4
    open(path, "w").write("\n".join(lines) + "\n")


def write_mtl(scene, path):
    seen = {}
    for g in scene.geometries:
        m = g["material"]
        stem = tex_stem(base_texture(m))
        name = "T_" + stem + ("_op%03d" % int(round(m["opacity"] * 100)) if m["opacity"] < 1 else "")
        seen[name] = (stem, m)
    out = []
    for name, (stem, m) in sorted(seen.items()):
        out.append("newmtl %s" % name)
        out.append("Ka %.4f %.4f %.4f" % tuple(m["ambient"]))
        out.append("Kd %.4f %.4f %.4f" % tuple(m["diffuse"]))
        out.append("Ks %.4f %.4f %.4f" % tuple(m["specular"]))
        out.append("d %.4f" % m["opacity"])
        if stem != "untextured":
            out.append("map_Kd %s.png" % stem)
        out.append("")
    out += ["newmtl T_marker", "Kd 1 0 1", "d 1", ""]
    open(path, "w").write("\n".join(out))
    return sorted({s for s, _ in seen.values() if s != "untextured"})


def descriptor(scene, meta, mps=scale.METRES_PER_STUD):
    geoms = []
    for g in scene.geometries:
        lo, hi = geometry_bounds(g, mps)
        m = g["material"]
        geoms.append({"id": g["id"], "name": geometry_name(g), "shape": g["name"], "handle": g["handle"],
                      "texture": tex_stem(base_texture(m)), "textures": m["textures"], "opacity": m["opacity"],
                      "ambient": m["ambient"], "diffuse": m["diffuse"], "specular": m["specular"],
                      "shininess": m["shininess"], "reflectivity": m["reflectivity"], "envmap": m["envmap"],
                      "tris": len(g["tris"]), "verts": len(g["positions"]),
                      "min": [round(v, 6) for v in lo], "max": [round(v, 6) for v in hi],
                      "center": [round((a + b) * 0.5, 6) for a, b in zip(lo, hi)]})
    nodes = []
    for n in scene.nodes:
        d = {k: v for k, v in n.items() if v is not None and v != ""}
        nodes.append(d)
    inst = [{"id": i["id"], "node": i["node"], "frame": i["frame"], "geometry": i["geometry"],
             **({"selflit": i["selflit"]} if i["selflit"] else {})} for i in scene.instances]
    return {"format": "nr2003carmodel/1", "metresPerStud": mps, "axes": "roblox(x=-y_nr,y=z_nr,z=-x_nr)",
            "meta": meta, "nodes": nodes, "geometries": geoms, "instances": inst,
            "markers": {k: list(v) for k, v in MARKERS.items()}, "markerSize": MARKER_SIZE}


def _lua(v, ind=""):
    if v is None:
        return "nil"
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int,)):
        return str(v)
    if isinstance(v, float):
        if v != v or v in (float("inf"), float("-inf")):
            return "0/0" if v != v else ("math.huge" if v > 0 else "-math.huge")
        r = repr(v)
        return r
    if isinstance(v, str):
        return '"' + v.replace("\\", "\\\\").replace('"', '\\"') + '"'
    if isinstance(v, (list, tuple)):
        return "{" + ",".join(_lua(x) for x in v) + "}"
    if isinstance(v, dict):
        parts = []
        for k, x in v.items():
            key = k if (isinstance(k, str) and k.isidentifier()) else "[" + _lua(k) + "]"
            parts.append("%s=%s" % (key, _lua(x)))
        return "{" + ",".join(parts) + "}"
    raise TypeError(type(v))


def write_luau(desc, path, header):
    body = ["-- " + l for l in header.splitlines()]
    body.append("-- GENERATED by nr2003carmodel_implementation/pipeline/convert_car.py; do not edit by hand.")
    body.append("local D = {}")
    for key in ("format", "metresPerStud", "axes", "meta", "markers", "markerSize"):
        body.append("D.%s = %s" % (key, _lua(desc[key])))
    for key in ("nodes", "geometries", "instances"):
        body.append("D.%s = {" % key)
        for item in desc[key]:
            body.append("\t" + _lua(item) + ",")
        body.append("}")
    for key in [k for k in desc if k not in ("format", "metresPerStud", "axes", "meta", "markers", "markerSize",
                                             "nodes", "geometries", "instances")]:
        body.append("D.%s = %s" % (key, _lua(desc[key])))
    body.append("return D")
    open(path, "w").write("\n".join(body) + "\n")


def write_json(desc, path):
    with open(path, "w") as fh:
        json.dump(desc, fh, separators=(",", ":"))
