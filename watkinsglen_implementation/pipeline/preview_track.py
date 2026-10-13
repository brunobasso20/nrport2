#!/usr/bin/env python3
"""Plot the converted terrain in original metres, using decoded texture colours."""
import argparse
import json
import os
from pathlib import Path
import struct

os.environ.setdefault("MPLCONFIGDIR", str(Path(__file__).resolve().parents[2] / "work" / "matplotlib"))
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.collections import PolyCollection
import numpy as np
from PIL import Image


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("assets", type=Path)
    ap.add_argument("--out", type=Path, required=True)
    a = ap.parse_args()
    m = json.loads((a.assets / "manifest.json").read_text())
    colours = {}
    for stem in m["textures"]:
        with Image.open(a.assets / "textures" / (stem + ".png")) as im:
            pixels = np.asarray(im.convert("RGBA").resize((32, 32)), dtype=float) / 255
            alpha = pixels[:, :, 3:4]
            colours[stem] = (pixels[:, :, :3] * alpha).sum(axis=(0, 1)) / max(alpha.sum(), 1)
    polygons, shades = [], []
    for chunk in m["chunks"]:
        if chunk["kind"] != "terrain":
            continue
        raw = (a.assets / chunk["file"]).read_bytes()
        count = struct.unpack_from("<I", raw, 12)[0]
        gltf = json.loads(raw[20:20 + count])
        binary = memoryview(raw)[28 + count:]
        def accessor(index, dtype, width):
            acc = gltf["accessors"][index]
            view = gltf["bufferViews"][acc["bufferView"]]
            return np.frombuffer(binary, dtype=dtype, count=acc["count"] * width,
                                 offset=view.get("byteOffset", 0)).reshape((-1, width))
        for geometry, mesh in zip(chunk["geometries"], gltf["meshes"]):
            primitive = mesh["primitives"][0]
            positions = accessor(primitive["attributes"]["POSITION"], "<f4", 3)
            triangles = accessor(primitive["indices"], "<u4", 1).reshape((-1, 3))
            # Inverse of Roblox(-NR.y, NR.z, -NR.x) / metresPerStud.
            original = positions[:, [2, 0]] * -m["metresPerStud"]
            polygons.extend(original[triangles])
            colour = colours.get(geometry["texture"], np.array([.6, .6, .6]))
            shades.extend([colour] * len(triangles))
    fig, ax = plt.subplots(figsize=(12, 9), facecolor="#eef0eb")
    ax.set_facecolor("#eef0eb")
    ax.add_collection(PolyCollection(polygons, facecolors=shades, edgecolors="none", rasterized=True))
    ax.autoscale_view()
    ax.set_aspect("equal")
    ax.set_xlabel("Original world X (metres)")
    ax.set_ylabel("Original world Y (metres)")
    ax.set_title("Watkins Glen — converted original terrain", loc="left", pad=14)
    ax.text(0, 1.015, "%d terrain triangles · %d authored sections · %.2f m per Roblox stud" % (
        m["totals"]["terrainTriangles"], m["ptf"]["parsedSegments"], m["metresPerStud"]),
        transform=ax.transAxes, color="#4e554b", fontsize=9)
    ax.grid(alpha=.12)
    fig.tight_layout()
    a.out.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(a.out, dpi=180)
    plt.close(fig)


if __name__ == "__main__":
    main()
