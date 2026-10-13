#!/usr/bin/env python3
"""Convert supplied Papyrus Watkins Glen resources to calibrated Roblox visual assets.

Loose track files override track DAT entries; shared resources fill missing names. All
3DO channels, winding, MIP texels, source hashes and scene graphs are retained. Baked
visuals use highest-detail LOD and an explicit daytime/race/full-population state.
The visual meshes must have CanCollide=false: the lifted NR2003 world owns contacts.
"""
from __future__ import annotations

import argparse
import base64
import collections
import hashlib
import json
import math
import re
from pathlib import Path
import struct
import sys
from xml.sax.saxutils import escape

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
sys.path.insert(0, str(REPO / "nr2003carmodel_implementation" / "pipeline"))
from nr2003res import dat, export, mip, obj3do, rig, scale, scene  # noqa: E402
import ptf  # noqa: E402
from studio_track import write_installers  # noqa: E402

RACE_DAY = {"Population": 2.0, "Weekend": 2.0, "Day_Night": 0.0, "Weather": 0.0,
            "AnimObjs": 0.0, "caution_light": 0.0, "show_nonanimated_flagger_sf": 1.0,
            "show_nonanimated_flagger_pit": 1.0}
IDENTITY = ((0.0, 0.0, 0.0), [1, 0, 0, 0, 1, 0, 0, 0, 1])


def safe_resource_name(name):
    # Keep Papyrus virtual namespaces distinct: trackmat\\grass.mip and
    # grass.mip are different authored textures in this track archive.
    return name.replace("\\", "/").replace("/", "__").lower()


def original_track_dimensions(repo, mps):
    """Read the engine's loaded length, rather than a rounded advertised mileage."""
    image = (repo / "core/NR2003Cup/NR2003CupImage1.lua").read_text()
    base = int(re.search(r"return\s*\{base=(\d+)", image).group(1))
    records = {}
    for path in sorted((repo / "watkinsglen_implementation/core/NR2003Cup").glob("NR2003CupTrackData*.lua")):
        for offset, encoded in re.findall(r'\{(\d+),"([A-Za-z0-9+/=]+)"\}', path.read_text()):
            address = base + int(offset)
            payload = base64.b64decode(encoded, validate=True)
            for target in (0xBAD918, 0xBAD920):
                if address <= target and target + 4 <= address + len(payload):
                    records[target] = payload[target-address:target-address+4]
    if len(records) != 2:
        raise ValueError("Original track length/count records are missing")
    length = struct.unpack("<f", records[0xBAD918])[0]
    count = struct.unpack("<I", records[0xBAD920])[0]
    return {"metresPerStud": mps, "originalLapLengthMetres": length,
            "originalLapLengthStuds": length / mps, "originalSections": count,
            "lengthSource": "Original NR2003 loaded track memory 0xBAD918 (float32)",
            "scaleSource": "Existing NR2003Lab TestTune.metresPerStud = 0.28; car and track share one conversion"}


class Resources:
    def __init__(self, track: Path, shared: Path):
        self.files = {}
        self.provenance = {}
        self.archives = []
        self.used = {}
        for directory, role in ((track, "track"), (shared, "shared")):
            for path in sorted(directory.iterdir()):
                if path.is_file() and path.suffix.lower() != ".dat":
                    key = path.name.lower()
                    if key not in self.files:
                        raw = path.read_bytes()
                        self.files[key] = raw
                        self.provenance[key] = {"role": role, "kind": "loose", "file": path.name}
            for path in sorted(directory.glob("*.dat")):
                archive = dat.DatArchive(str(path))
                self.archives.append({"role": role, "file": path.name, "entries": len(archive.entries),
                                      "sha256": hashlib.sha256(archive.data).hexdigest()})
                for entry in archive.entries:
                    key = entry.name.lower()
                    if key not in self.files:
                        self.files[key] = archive.read(entry)
                        self.provenance[key] = {"role": role, "kind": "dat", "file": path.name,
                                                "entry": entry.name, "compressed": entry.compressed}
        self.aliases = {}
        for key in self.files:
            alias = safe_resource_name(key)
            if alias in self.aliases and self.aliases[alias] != key:
                raise ValueError("Resource export filename collision: " + alias)
            self.aliases[alias] = key

    def get(self, name, required=True):
        key = self.aliases.get(safe_resource_name(name), name.lower())
        raw = self.files.get(key)
        if raw is None:
            if required:
                raise ValueError("Missing original resource: " + name)
            return None
        self.used[key] = dict(self.provenance[key], size=len(raw), sha256=hashlib.sha256(raw).hexdigest())
        return raw


def transform_geometry(g, xf, name=None):
    t, rotation = xf
    out = dict(g)
    out["positions"] = [tuple(a + b for a, b in zip(rig.apply(rotation, p), t)) for p in g["positions"]]
    out["normals"] = [rig.apply(rotation, n) for n in g["normals"]]
    out["name"] = name or g["name"]
    return out


def normalized_geometry(g):
    out = dict(g)
    original = g["material"]["textures"]
    out["material"] = dict(g["material"], textures=[safe_resource_name(n)
                                                   if n else None for n in original])
    out["source"] = dict(g.get("source", {}), originalTexturePaths=original)
    return out


def flat_model(sc, variables):
    """Bake authored frame transforms and select one branch of every switch/LOD."""
    desc = export.descriptor(sc, {})
    _, active = rig.evaluate(desc, variables, rig.default_draw_state())
    return [transform_geometry(sc.geometries[inst["geometry"]], xf) for inst, xf in active]


def preserve_sky(res, variables, out):
    """Retain the original renderer settings and selected authored sky shape.

    NR2003 AppNodes configure the renderer, rather than ordinary world geometry.
    They are recorded separately; installing a finite sky mesh at the track origin
    would not reproduce the game's camera-centred sky renderer.
    """
    raw = res.get("sky.3do", False)
    if raw is None:
        return {}, set()
    stream = ptf.Stream(raw)
    root = stream.obj()
    if stream.p != len(raw):
        raise ValueError("sky.3do contains trailing bytes")
    applications = []
    path_states = []

    def select(node):
        if node is None:
            return None
        if node.cls == "StateSwitch":
            value = variables.get(node.state_name, node.default)
            index = scene.select_state(node.values, value)
            path_states.append({"variable": node.state_name, "value": value, "child": index})
            return select(node.children[index]) if index is not None else None
        if node.cls == "AppNode":
            applications.append({"id": node.app_id, "data": node.data.rstrip(b"\0").decode("latin-1")})
            return select(node.child)
        return node

    selected = select(root)
    sc = scene.build(selected, {}, 0) if selected is not None else scene.Scene()
    geometries = flat_model(sc, variables) if sc.nodes else []
    textures = {export.base_texture(g["material"]) for g in geometries} - {None}
    for app in applications:
        textures |= set(re.findall(r"[A-Za-z0-9_]+\.mip", app["data"]))
    result = {"source": res.used["sky.3do"], "objects": len(stream.objects), "selectedPath": path_states,
              "selectedApplications": applications,
              "allApplications": [{"handle": n.handle, "id": n.app_id,
                                   "data": n.data.rstrip(b"\0").decode("latin-1")}
                                  for n in stream.objects.values() if n.cls == "AppNode"],
              "selectedGeometry": geometries, "installed": False,
              "reason": "Original camera-centred sky and fog rendering has no exact Roblox renderer equivalent."}
    (out / "json" / "sky.json").write_text(json.dumps(result, separators=(",", ":")))
    return result, textures


def validate_geometry(g):
    nv = len(g["positions"])
    if not nv or len(g["normals"]) != nv or len(g["uvs"]) != nv:
        raise ValueError("Incomplete vertex channels: " + g["name"])
    if any(not math.isfinite(x) for channel in ("positions", "normals", "uvs") for p in g[channel] for x in p):
        raise ValueError("Non-finite geometry: " + g["name"])
    if any(i < 0 or i >= nv for tri in g["tris"] for i in tri):
        raise ValueError("Triangle index outside vertex buffer: " + g["name"])


def spatial_geometry(g, mps, max_studs=1800):
    """Clip unusually large authored meshes into Roblox-sized cells.

    Infield.3do contains one shape over 5,000 studs wide. Roblox BasePart.Size
    cannot represent that shape as one calibrated part. Triangle-plane clipping
    retains the original planar surface and linearly interpolates its channels.
    """
    dimensions = [max(p[i] for p in g["positions"]) - min(p[i] for p in g["positions"]) for i in range(3)]
    if max(dimensions) <= mps * max_studs:
        yield g
        return
    cell_size = mps * max_studs
    cells = {}

    def clip(vertices, axis, value, upper):
        if not vertices:
            return []
        result = []
        previous = vertices[-1]
        previous_inside = previous[0][axis] <= value if upper else previous[0][axis] >= value
        for current in vertices:
            current_inside = current[0][axis] <= value if upper else current[0][axis] >= value
            if current_inside != previous_inside:
                fraction = (value - previous[0][axis]) / (current[0][axis] - previous[0][axis])
                result.append(tuple(tuple(a + (b-a) * fraction for a, b in zip(pa, pb))
                                    for pa, pb in zip(previous, current)))
            if current_inside:
                result.append(current)
            previous, previous_inside = current, current_inside
        return result

    for triangle in g["tris"]:
        original = [(g["positions"][i], g["normals"][i], g["uvs"][i]) for i in triangle]
        lo = [math.floor(min(v[0][i] for v in original) / cell_size) for i in range(3)]
        hi = [math.floor(max(v[0][i] for v in original) / cell_size) for i in range(3)]
        for x in range(lo[0], hi[0] + 1):
            for y in range(lo[1], hi[1] + 1):
                for z in range(lo[2], hi[2] + 1):
                    cell = (x, y, z)
                    polygon = original
                    for axis, index in enumerate(cell):
                        polygon = clip(polygon, axis, index * cell_size, False)
                        polygon = clip(polygon, axis, (index + 1) * cell_size, True)
                    if len(polygon) < 3:
                        continue
                    dst = cells.setdefault(cell, dict(g, positions=[], normals=[], uvs=[], tris=[],
                        name=g["name"] + "_cell_%d_%d_%d" % cell,
                        source=dict(g.get("source", {}), spatialCell=list(cell), maxDimensionStuds=max_studs)))
                    for i in range(1, len(polygon) - 1):
                        tri = [polygon[0], polygon[i], polygon[i+1]]
                        a, b, c = [v[0] for v in tri]
                        normal = [(b[1]-a[1])*(c[2]-a[2])-(b[2]-a[2])*(c[1]-a[1]),
                                  (b[2]-a[2])*(c[0]-a[0])-(b[0]-a[0])*(c[2]-a[2]),
                                  (b[0]-a[0])*(c[1]-a[1])-(b[1]-a[1])*(c[0]-a[0])]
                        if sum(n*n for n in normal) <= 1e-16:
                            continue
                        base = len(dst["positions"])
                        for channel, key in enumerate(("positions", "normals", "uvs")):
                            dst[key].extend(v[channel] for v in tri)
                        dst["tris"].append((base, base+1, base+2))
    for _, item in sorted(cells.items()):
        if item["tris"]:
            yield item


def split_geometry(g, limit):
    """Split oversize shapes without changing triangles, UV seams or authored normals."""
    for start in range(0, len(g["tris"]), limit):
        tris = g["tris"][start:start + limit]
        ids = list(dict.fromkeys(i for tri in tris for i in tri))
        index = {old: new for new, old in enumerate(ids)}
        d = dict(g)
        for key in ("positions", "normals", "uvs"):
            d[key] = [g[key][i] for i in ids]
        d["tris"] = [tuple(index[i] for i in tri) for tri in tris]
        if len(g["tris"]) > limit:
            d["name"] += "_part%d" % (start // limit)
        yield d


def scene_from_geometry(geometries):
    sc = scene.Scene()
    sc.add(None, "root", name="")
    for gid, geom in enumerate(geometries):
        g = dict(geom, id=gid, handle=gid, vertexList=geom.get("vertexList", "TrackVisual"))
        sc.geometries.append(g)
        sc.instances.append({"id": gid, "node": 0, "frame": 0, "geometry": gid, "selflit": None})
    return sc


def decode_textures(res, names, out):
    decoded = {}
    cache_path = out.parent / "texture_cache.json"
    cache = json.loads(cache_path.read_text()) if cache_path.exists() else {}
    for name in sorted(names):
        stem = export.tex_stem(safe_resource_name(name))
        if stem == "untextured" or stem in decoded:
            continue
        raw = res.get(stem + ".mip")
        source_hash = hashlib.sha256(raw).hexdigest()
        cached = cache.get(stem)
        png_path = out / (stem + ".png")
        if (cached and cached.get("sourceSHA256") == source_hash and png_path.exists()
                and hashlib.sha256(png_path.read_bytes()).hexdigest() == cached.get("pngSHA256")):
            decoded[stem] = cached
            continue
        source = mip.Mip(raw)
        width, height, pixels = source.rgba()
        png_bytes = mip.png(width, height, pixels)
        (out / (stem + ".png")).write_bytes(png_bytes)
        decoded[stem] = {"format": mip.FORMAT_NAMES.get(source.format, hex(source.format)),
                         "width": width, "height": height, "clampU": source.clamp_u, "clampV": source.clamp_v,
                         "factor": source.factor, "alphaTransparent": any(pixels[i] < 255 for i in range(3, len(pixels), 4)),
                         "rgbaSHA256": hashlib.sha256(pixels).hexdigest(), "pngSHA256": hashlib.sha256(png_bytes).hexdigest(),
                         "sourceSHA256": source_hash}
    cache_path.write_text(json.dumps(decoded, sort_keys=True, separators=(",", ":")) + "\n")
    return decoded


def emit_chunks(kind, geometries, out, textures, mps, max_tris=16000, max_meshes=150):
    blend = {k for k, v in textures.items() if v["alphaTransparent"]}
    clamp = {k: (v["clampU"], v["clampV"]) for k, v in textures.items()}
    chunks = []
    batch = []
    tris = 0

    def flush():
        nonlocal batch, tris
        if not batch:
            return
        package = "watkins_glen_%s_%03d" % (kind, len(chunks))
        sc = scene_from_geometry(batch)
        header = "Original NR2003 Watkins Glen %s; Roblox axes and %.9g metres/stud" % (kind, mps)
        export.write_glb(sc, str(out / "glb" / (package + ".glb")), str(out / "textures"), mps, blend, clamp)
        desc = export.descriptor(sc, {"package": package, "kind": kind, "coordinateSpace": "original-world"}, mps)
        desc["format"] = "nr2003trackvisual/1"
        for dst, src in zip(desc["geometries"], batch):
            dst["source"] = src.get("source", {})
        export.write_json(desc, str(out / "json" / (package + ".json")))
        chunks.append({"name": package, "kind": kind, "file": "glb/" + package + ".glb",
                       "geometries": desc["geometries"], "tris": tris})
        batch, tris = [], 0

    for geom in geometries:
        validate_geometry(geom)
        for spatial in spatial_geometry(geom, mps):
            for g in split_geometry(spatial, max_tris):
                if batch and (tris + len(g["tris"]) > max_tris or len(batch) >= max_meshes):
                    flush()
                batch.append(g)
                tris += len(g["tris"])
    flush()
    return chunks


def read_glb(path):
    raw = Path(path).read_bytes()
    magic, version, size = struct.unpack_from("<III", raw)
    if (magic, version, size) != (0x46546c67, 2, len(raw)):
        raise ValueError("Invalid GLB header: " + str(path))
    n, tag = struct.unpack_from("<II", raw, 12)
    if tag != 0x4e4f534a:
        raise ValueError("Missing GLB JSON chunk")
    d = json.loads(raw[20:20+n])
    # All accessors/views must remain inside the binary chunk. This catches bad offsets,
    # partial writes and unexpected source buffers without depending on a renderer.
    for view in d["bufferViews"]:
        if view.get("byteOffset", 0) + view["byteLength"] > d["buffers"][0]["byteLength"]:
            raise ValueError("GLB buffer view overrun")
    return d


def write_visual_luau(data, path):
    for stale in path.parent.glob(path.stem + "Part*.lua"):
        stale.unlink()
    lines = ["-- GENERATED by watkinsglen_implementation/pipeline/convert_track.py.",
             "-- All bounds and mesh coordinates use Roblox studs, matching the car scale.", "local D = {}"]
    chunks = data["chunks"]
    for key, value in data.items():
        if key == "chunks":
            continue
        lines.append("D.%s = %s" % (key, export._lua(value)))
    modules, batch = [], []
    # Roblox source transfer has a 200,000-byte per-script limit. Keep source
    # descriptions in bounded modules rather than one multi-megabyte script.
    def flush():
        if not batch:
            return
        source = "-- GENERATED track visual chunks.\nreturn {\n" + ",\n".join(batch) + "\n}\n"
        name = path.stem + "Part" + str(len(modules) + 1)
        (path.parent / (name + ".lua")).write_text(source)
        modules.append((name, source))
        batch.clear()
    for chunk in chunks:
        source = export._lua(chunk)
        if len(source.encode()) > 180000:
            raise ValueError("Visual chunk metadata exceeds Roblox source module limit: " + chunk["name"])
        if batch and sum(len(x.encode()) for x in batch) + len(source.encode()) > 180000:
            flush()
        batch.append(source)
    flush()
    lines.append("D.chunks = {}")
    lines.append("for i = 1, %d do" % len(modules))
    lines.append('    local part = require(script.Parent:WaitForChild("%sPart" .. i))' % path.stem)
    lines.append("    for _, chunk in ipairs(part) do table.insert(D.chunks, chunk) end")
    lines.append("end")
    lines.append("return D")
    main_source = "\n".join(lines) + "\n"
    if len(main_source.encode()) >= 199000:
        raise ValueError("Visual main metadata exceeds Roblox source module limit")
    path.write_text(main_source)
    entries = [(path.stem, main_source)] + modules
    xml = ['<?xml version="1.0" encoding="utf-8"?><roblox version="4"><External>null</External>',
           '<Item class="Folder" referent="WG_VISUAL_DATA"><Properties><string name="Name">WatkinsGlenVisualData</string></Properties>']
    for i, (name, source) in enumerate(entries):
        xml.append('<Item class="ModuleScript" referent="WG_DATA_%d"><Properties><string name="Name">%s</string>'
                   '<ProtectedString name="Source">%s</ProtectedString></Properties></Item>' % (i, escape(name), escape(source)))
    xml.append('</Item></roblox>')
    (path.parent / "WatkinsGlenVisualData.rbxmx").write_text("".join(xml) + "\n")


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--track", type=Path, required=True)
    ap.add_argument("--shared", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--metres-per-stud", type=float, default=scale.METRES_PER_STUD)
    ap.add_argument("--geometry", type=Path, help="Recovered terrain/wall/scenery placement JSON")
    ap.add_argument("--generate-geometry", action="store_true", help="Run the original Luau track sampler and build all surface/wall geometry")
    ap.add_argument("--luau", type=Path, help="Luau CLI with native code generation, required with --generate-geometry")
    ap.add_argument("--work-dir", type=Path, default=REPO / "work" / "track_conversion", help="Intermediate original-query CSVs and geometry JSON")
    ap.add_argument("--road-tolerance", type=float, default=0.002, help="Sampled driving-surface mesh tolerance in metres")
    ap.add_argument("--terrain-tolerance", type=float, default=0.002, help="Sampled grass/sand/runoff mesh tolerance in metres")
    ap.add_argument("--include-library", action="store_true", help="Also export unplaced highest-detail model GLBs")
    ap.add_argument("--no-lightmap-bake", action="store_true", help="Diagnostic base-texture export without the original static light/shadow-map multiplication")
    ap.add_argument("--variable", action="append", default=[], help="Explicit 3DO draw state NAME=VALUE")
    a = ap.parse_args(argv)
    if a.geometry and a.generate_geometry:
        ap.error("Choose --geometry or --generate-geometry")
    if a.generate_geometry and not a.luau:
        ap.error("--generate-geometry requires --luau")
    if not math.isfinite(a.metres_per_stud) or a.metres_per_stud <= 0:
        raise ValueError("metres-per-stud must be finite and positive")
    for sub in ("glb", "textures", "json", "luau"):
        (a.out / sub).mkdir(parents=True, exist_ok=True)
    res = Resources(a.track, a.shared)
    variables = dict(RACE_DAY)
    for variable in a.variable:
        key, value = variable.split("=", 1)
        variables[key] = float(value)
    ptf_names = [n for n in res.files if n.endswith(".ptf")]
    if len(ptf_names) != 1:
        raise ValueError("Expected exactly one original PTF, found %d" % len(ptf_names))
    track_root, track_stream = ptf.parse(res.get(ptf_names[0]))
    track_metadata = ptf.metadata(track_root, track_stream)
    (a.out / "json" / "ptf_summary.json").write_text(json.dumps(track_metadata, indent=1) + "\n")
    (a.out / "json" / "ptf_descriptors.json").write_text(json.dumps(ptf.descriptor_graph(track_stream), separators=(",", ":")) + "\n")
    if a.generate_geometry:
        a.work_dir.mkdir(parents=True, exist_ok=True)
        (a.work_dir / ptf_names[0]).write_bytes(res.get(ptf_names[0]))
        sampler = ptf.OriginalSampler(REPO, a.luau, a.work_dir / "sampler")
        geometry = ptf.build_surfaces(track_root, ptf.original_section_spans(REPO), sampler,
                                      road_tolerance=a.road_tolerance, terrain_tolerance=a.terrain_tolerance)
        a.geometry = a.work_dir / "geometry.json"
        a.geometry.write_text(json.dumps(geometry, separators=(",", ":"), allow_nan=False))
    else:
        geometry = json.loads(a.geometry.read_text()) if a.geometry else {"terrain": [], "walls": []}
    terrain = [normalized_geometry(g) for g in geometry.get("terrain", [])]
    walls = [normalized_geometry(g) for g in geometry.get("walls", [])]
    placements = geometry.get("placements", ptf.placements(track_root))
    names = {p["model"].lower() for p in placements}
    # Export all original track models as a local library even when the recovered
    # geometry file omits a model. This makes the input coverage reviewable.
    names |= {n for n in res.files if n.endswith(".3do") and res.provenance[n]["role"] == "track"}
    models = {}
    textures = {n for n in res.files if n.endswith(".mip") and res.provenance[n]["role"] == "track"}
    switches = collections.Counter()
    for name in sorted(names):
        root, stream = obj3do.parse(res.get(name))
        sc = scene.build(root, {}, 0)
        for node in sc.nodes:
            if node["kind"] == "switch":
                switches[node["variable"]] += 1
        textures |= {export.base_texture(g["material"]) for g in sc.geometries} - {None}
        desc = export.descriptor(sc, {"file": name, "objects": len(stream.objects), "source": res.used[name]}, a.metres_per_stud)
        export.write_json(desc, str(a.out / "json" / (Path(name).stem + "_scene.json")))
        models[name] = [normalized_geometry(g) for g in flat_model(sc, variables)]
    for g in terrain + walls:
        textures |= set(g["material"]["textures"]) - {None}
    sky, sky_textures = preserve_sky(res, variables, a.out)
    textures |= sky_textures
    texture_meta = decode_textures(res, textures, a.out / "textures")
    lightmap_report = {}
    if not a.no_lightmap_bake:
        from lightmaps import bake
        terrain, lightmap_report = bake(terrain, track_stream, texture_meta, a.out / "textures")
    scenery = []
    for number, placement in enumerate(placements):
        name = placement["model"].lower()
        xf = (placement["position"], rig.euler(*placement["rotation"]))
        for index, g in enumerate(models[name]):
            transformed = transform_geometry(g, xf, "%s_%d_%d" % (Path(name).stem, number, index))
            transformed["source"] = {"kind": "TSO", "placement": number, "model": name,
                                     "position": placement["position"], "rotation": placement["rotation"]}
            scenery.append(transformed)
    chunks = []
    for kind, geoms in (("terrain", terrain), ("walls", walls), ("scenery", scenery)):
        chunks += emit_chunks(kind, geoms, a.out, texture_meta, a.metres_per_stud)
    # A standalone highest-detail library gives access to every original source
    # model. Global scenery GLBs, when available, already contain their placement.
    library = []
    if a.include_library:
        for name, geoms in models.items():
            for g in geoms:
                g["name"] = Path(name).stem + "_" + g["name"]
                g["source"] = {"kind": "library", "model": name}
            library += emit_chunks("library_" + Path(name).stem, geoms, a.out, texture_meta, a.metres_per_stud)
    for path in sorted((a.out / "glb").glob("*.glb")):
        read_glb(path)
    limitations = list(geometry.get("limitations", []))
    if not a.geometry:
        limitations.append("No recovered terrain/wall geometry supplied: placed original scenery only.")
    limitations.append("Visual state is a daytime race with full population, highest-detail LOD; source scene graphs preserve other authored branches. Dynamic flags and vehicles are not driven by game state. Original sky geometry/settings are retained in json/sky.json; sky and fog renderer effects are not installed.")
    visual = {"format": "nr2003trackvisual/1", "track": "Watkins Glen", "metresPerStud": a.metres_per_stud,
              "dimensions": original_track_dimensions(REPO, a.metres_per_stud),
              "axes": "roblox(x=-y_nr,y=z_nr,z=-x_nr)", "markers": export.MARKERS, "markerSize": export.MARKER_SIZE,
              "chunks": chunks, "placements": placements, "drawVariables": variables,
              "collision": "CanCollide=false/CanTouch=false; original lifted NR2003 contact world. Terrain CanQuery=true only for the existing chase-camera clearance raycast; NR2003TerrainQuery=true marks those parts.",
              "limitations": limitations}
    write_visual_luau(visual, a.out / "luau" / "NR2003WatkinsGlenVisualData.lua")
    write_installers(chunks, texture_meta, a.out, a.metres_per_stud)
    manifest = dict(visual, tool="watkinsglen_implementation/pipeline/convert_track.py", resources=res.used,
                    archives=res.archives, textures=texture_meta, library=library, switches=dict(switches),
                    geometryRecovery=geometry.get("recovery", {}), lightmapBake=lightmap_report, ptf=track_metadata,
                    sky={k: v for k, v in sky.items() if k not in ("allApplications", "selectedGeometry")},
                    totals={"trackModels": sum(res.provenance[n]["role"] == "track" for n in models),
                            "sharedModels": sum(res.provenance[n]["role"] == "shared" for n in models),
                            "placements": len(placements), "terrainTriangles": sum(c["tris"] for c in chunks if c["kind"] == "terrain"),
                            "terrainSourceTriangles": sum(len(g["tris"]) for g in geometry.get("terrain", [])),
                            "wallTriangles": sum(c["tris"] for c in chunks if c["kind"] == "walls"),
                            "sceneryTriangles": sum(c["tris"] for c in chunks if c["kind"] == "scenery"),
                            "scenerySourceTriangles": sum(len(g["tris"]) for g in scenery), "textures": len(texture_meta),
                            "worldChunks": len(chunks), "libraryChunks": len(library)})
    (a.out / "manifest.json").write_text(json.dumps(manifest, indent=1) + "\n")
    accuracy = geometry.get("recovery", {}).get("visualAccuracy")
    if accuracy:
        (a.out / "visual_accuracy.json").write_text(json.dumps(accuracy, indent=1) + "\n")
    expected_glbs = {c["file"].split("/")[-1] for c in chunks + library}
    for path in (a.out / "glb").glob("watkins_glen_*.glb"):
        if path.name not in expected_glbs:
            path.unlink()
    expected_installers = {"INSTALL_" + c["name"] + ".lua" for c in chunks}
    expected_installers.add("INSTALL_ALL_TRACK_VISUALS.lua")
    for path in (a.out / "studio").glob("INSTALL_*.lua"):
        if path.name not in expected_installers:
            path.unlink()
    print(json.dumps(manifest["totals"], indent=1))
    return manifest


if __name__ == "__main__":
    main()
