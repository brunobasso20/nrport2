#!/usr/bin/env python3
"""Convert the ORIGINAL NR2003 car resources to a Roblox import package.

usage: python3 -I convert_car.py --series <NR2003>/series/cup --out <dir> [--model make_a] [--make 0..3]
                                 [--livery <file.car>] [--metres-per-stud 0.28]

Reads loose files in --series first, then the series DAT archive(s) (cup.dat), exactly the resource names the game
builds in 004287a0 / 004296b0 / 0042a5a0 / 0042a660 / 00429800 ("<model>.3do", "<model>_shadow.3do",
"<model>_light_cockpit.3do", "<model>_pieces.3do", "<model>_lights.3do") and 00568610 ("<model>.cam").
Damage branches are resolved to the undamaged car (out of scope); carMakeIdx = --make
(0 Chevrolet, 1 Dodge, 2 Ford, 3 Pontiac: the order of the .car 'car_make' key and card_<make>.mip).
Output (nothing is uploaded anywhere):
  <out>/obj/<package>.glb         geometry library per package, textures embedded (RECOMMENDED for the Studio 3D Importer)
  <out>/obj/<package>.obj + .mtl  the same as OBJ / MTL (map_d for transparent textures)
  <out>/textures/*.png            decoded textures (largest MIP level, RGBA; also copied next to the .obj for the importer)
  <out>/luau/NR2003CarModelData_<package>.lua   rig descriptor for the Roblox runtime
  <out>/json/<package>.json       the same descriptor as JSON
  <out>/studio/INSTALL_CARMODEL_ASSETS.lua  Studio installer of the descriptor + imported model (after INSTALL_CARMODEL)
  <out>/studio/NR2003CarModelData_<model>.rbxmx  the descriptor as a ModuleScript (Insert from File alternative)
  <out>/manifest.json             provenance: source files, SHA-256, DAT entry names, sizes, options
With --livery the .car CTEX is decoded to textures/livery_<name>.png and, as the game does for that car (CTEX replaces
card.mip), also written as textures/card.png (the generic card.mip is kept as textures/card_default.png); --keep-card
leaves card.png generic.
"""
import argparse
import hashlib
import json
import os
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nr2003res import car as carfile, dat, export, mip, obj3do, scale, scene, studio  # noqa: E402

CAMERA_MODES = ["Nose", "Gearbox", "On Car", "Roll Bar", "F Susp", "R Susp"]   # modes 10..15 (0056b960)


class Resources:
    def __init__(self, series_dir):
        self.dir = series_dir
        self.archives = []
        for f in sorted(os.listdir(series_dir)):
            if f.lower().endswith(".dat"):
                p = os.path.join(series_dir, f)
                self.archives.append((p, dat.DatArchive(p)))
        self.used = {}

    def get(self, name, required=True):
        loose = os.path.join(self.dir, name)
        if os.path.isfile(loose):
            data = open(loose, "rb").read()
            self.used[name] = {"source": os.path.basename(loose), "kind": "loose", "size": len(data),
                               "sha256": hashlib.sha256(data).hexdigest()}
            return data
        for p, a in self.archives:
            if name in a:
                e = a.by_name[name.lower()]
                data = a.read(e)
                self.used[name] = {"source": os.path.basename(p), "kind": "dat", "entry": e.name,
                                   "compressed": e.compressed, "size": len(data),
                                   "sha256": hashlib.sha256(data).hexdigest()}
                return data
        if required:
            raise SystemExit("missing original resource: %s (looked in %s and its .dat archives)" % (name, self.dir))
        return None


def read_cam(data):
    tag, _, size = struct.unpack_from("<4sII", data, 0)
    if tag != b"MACC" or size != 0xd8:
        raise ValueError("unexpected .cam chunk %r size %d" % (tag, size))
    cams = {}
    for i, name in enumerate(CAMERA_MODES):
        v = struct.unpack_from("<9f", data, 12 + 36 * i)
        cams[name] = {"mode": 10 + i, "pos": list(v[0:3]), "hpr": list(v[3:6]), "fov": list(v[6:9])}
    return cams


def roles(sc):
    out = {}
    for n in sc.nodes:
        if n["kind"] in ("frame", "billboard") and n.get("name"):
            out.setdefault(n["name"], []).append(n["id"])
        if n["kind"] == "portal":
            out.setdefault("portal:" + n["name"], []).append(n["id"])
    return out


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--series", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--model", default="make_a")
    ap.add_argument("--make", type=int, default=0, choices=range(4))
    ap.add_argument("--livery", default=None, help=".car file whose CTEX replaces card.mip (optional)")
    ap.add_argument("--keep-card", action="store_true", help="with --livery: keep the generic card.png")
    ap.add_argument("--metres-per-stud", type=float, default=scale.METRES_PER_STUD)
    a = ap.parse_args(argv)
    mps = a.metres_per_stud
    res = Resources(a.series)
    for sub in ("obj", "textures", "luau", "json", "studio"):
        os.makedirs(os.path.join(a.out, sub), exist_ok=True)

    packages = [(a.model, True), (a.model + "_light_cockpit", False), (a.model + "_shadow", False)]
    textures = set()
    summary = {}
    built = []
    cams = read_cam(res.get(a.model + ".cam"))
    for pkg, required in packages:
        data = res.get(pkg + ".3do", required)
        if data is None:
            summary[pkg] = "absent"
            continue
        root, stream = obj3do.parse(data)
        sc = scene.build(root, {}, a.make)
        hdr = ("NR2003 %s.3do (%s), carMakeIdx %d, undamaged; %d geometries, %d instances, %d nodes"
               % (pkg, res.used[pkg + ".3do"]["source"], a.make, len(sc.geometries), len(sc.instances), len(sc.nodes)))
        textures |= {export.tex_stem(export.base_texture(g["material"])) for g in sc.geometries} - {"untextured"}
        meta = {"package": pkg, "model": a.model, "make": a.make, "source": res.used[pkg + ".3do"],
                "objects": len(stream.objects), "windingAgree": sc.stats["agree"],
                "windingDisagree": sc.stats["disagree"]}
        desc = export.descriptor(sc, meta, mps)
        desc["roles"] = roles(sc)
        if pkg == a.model:
            desc["cameras"] = cams
        built.append((pkg, sc, desc, hdr))
        summary[pkg] = {"geometries": len(sc.geometries), "instances": len(sc.instances), "nodes": len(sc.nodes),
                        "uniqueTriangles": sum(len(g["tris"]) for g in sc.geometries)}

    tex_out = {}
    for stem in sorted(textures):
        data = res.get(stem + ".mip", False)
        if data is None:
            tex_out[stem] = "MISSING"
            continue
        m = mip.Mip(data)
        w, h, px = m.rgba()
        open(os.path.join(a.out, "textures", stem + ".png"), "wb").write(mip.png(w, h, px))
        tex_out[stem] = {"format": mip.FORMAT_NAMES.get(m.format, hex(m.format)), "width": w, "height": h,
                         "clampU": m.clamp_u, "clampV": m.clamp_v, "factor": m.factor,
                         "alphaTransparent": any(px[i] < 255 for i in range(3, len(px), 4))}
    livery = None
    if a.livery:
        raw = open(a.livery, "rb").read()
        cf = carfile.CarFile(raw)
        t = cf.texture("CTEX")
        w, h, px = t.rgba()
        stem = "livery_" + os.path.basename(a.livery).split(".")[0]
        png = mip.png(w, h, px)
        open(os.path.join(a.out, "textures", stem + ".png"), "wb").write(png)
        card = os.path.join(a.out, "textures", "card.png")
        as_card = not a.keep_card and os.path.exists(card)
        if as_card:
            os.replace(card, os.path.join(a.out, "textures", "card_default.png"))
            open(card, "wb").write(png)
            tex_out["card"]["alphaTransparent"] = any(px[i] < 255 for i in range(3, len(px), 4))
        livery = {"file": os.path.basename(a.livery), "sha256": hashlib.sha256(raw).hexdigest(), "texture": stem,
                  "replaces": "card", "writtenAsCard": as_card, "driver": cf.driver()}
    # NR2003 draws the base texture's alpha as transparency (windows of card / bottom at alpha 136, the windshield
    # buildup glass, nets, lights); environment reflection masks are separate textures (shiny*.mip)
    blend = {k for k, v in tex_out.items() if isinstance(v, dict) and v["alphaTransparent"]}
    clamp = {k: (v["clampU"], v["clampV"]) for k, v in tex_out.items() if isinstance(v, dict)}
    for pkg, sc, desc, hdr in built:
        export.write_obj(sc, os.path.join(a.out, "obj", pkg + ".obj"), pkg + ".mtl", mps, header=hdr)
        export.write_mtl(sc, os.path.join(a.out, "obj", pkg + ".mtl"), blend)
        export.write_glb(sc, os.path.join(a.out, "obj", pkg + ".glb"), os.path.join(a.out, "textures"), mps, blend, clamp)
        for g in desc["geometries"]:
            g["alpha"] = "blend" if (g["texture"] in blend or g["opacity"] < 1) else "opaque"
        export.write_json(desc, os.path.join(a.out, "json", pkg + ".json"))
        luau_name = "NR2003CarModelData_" + pkg
        export.write_luau(desc, os.path.join(a.out, "luau", luau_name + ".lua"), hdr)
        if pkg == a.model:
            src = open(os.path.join(a.out, "luau", luau_name + ".lua")).read()
            with open(os.path.join(a.out, "studio", "INSTALL_CARMODEL_ASSETS.lua"), "w", newline="\n") as fh:
                fh.write(studio.assets_installer(desc, luau_name, src))
            with open(os.path.join(a.out, "studio", luau_name + ".rbxmx"), "w", newline="\n") as fh:
                fh.write(studio.rbxmx_module(luau_name, src))
    # the .mtl names its maps by file name: the Studio 3D Importer looks for them next to the .obj
    import shutil
    for f in sorted(os.listdir(os.path.join(a.out, "textures"))):
        if f.endswith(".png"):
            shutil.copyfile(os.path.join(a.out, "textures", f), os.path.join(a.out, "obj", f))
    manifest = {"tool": "nr2003carmodel_implementation/pipeline/convert_car.py", "metresPerStud": mps,
                "model": a.model, "make": a.make, "packages": summary, "textures": tex_out, "livery": livery,
                "alphaTransparent": sorted(blend),
                "cameras": cams, "resources": res.used,
                "archives": [{"file": os.path.basename(p), "hash": "%08x" % ar.hash,
                              "sha256": hashlib.sha256(ar.data).hexdigest(), "entries": len(ar.entries)}
                             for p, ar in res.archives],
                "licence": "Original NR2003 content (c) Papyrus / Sierra. Converted for the owner's private use; "
                           "do not redistribute."}
    with open(os.path.join(a.out, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=1)
    print(json.dumps({"packages": summary, "textures": len(tex_out)}, indent=1))


if __name__ == "__main__":
    main()
