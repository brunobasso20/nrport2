#!/usr/bin/env python3
"""Independently inspect exported GLB buffers, images and import calibration data."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess
import xml.etree.ElementTree as ET

import numpy as np
from PIL import Image


def inspect_glb(path):
    data = path.read_bytes()
    magic, version, size = struct.unpack_from("<III", data)
    assert (magic, version, size) == (0x46546C67, 2, len(data)), path
    count, tag = struct.unpack_from("<II", data, 12)
    assert tag == 0x4E4F534A
    gltf = json.loads(data[20:20 + count])
    start = 20 + count
    binary_length, binary_tag = struct.unpack_from("<II", data, start)
    assert binary_tag == 0x004E4942 and start + 8 + binary_length == len(data)
    binary = memoryview(data)[start + 8:]
    types = {5126: "<f4", 5125: "<u4", 5123: "<u2", 5121: "u1"}
    components = {"SCALAR": 1, "VEC2": 2, "VEC3": 3, "VEC4": 4}

    def accessor(index):
        a = gltf["accessors"][index]
        view = gltf["bufferViews"][a["bufferView"]]
        start = view.get("byteOffset", 0) + a.get("byteOffset", 0)
        width = components[a["type"]]
        array = np.frombuffer(binary, dtype=types[a["componentType"]], count=a["count"] * width, offset=start)
        return array.reshape((a["count"], width))

    meshes = {}
    for mesh in gltf["meshes"]:
        primitive = mesh["primitives"][0]
        positions = accessor(primitive["attributes"]["POSITION"])
        assert np.isfinite(positions).all(), (path, mesh["name"], "positions")
        triangles = accessor(primitive["indices"]).reshape((-1, 3))
        assert triangles.max() < len(positions), (path, mesh["name"], "indices")
        for channel in ("NORMAL", "TEXCOORD_0"):
            if channel in primitive["attributes"]:
                value = accessor(primitive["attributes"][channel])
                assert len(value) == len(positions) and np.isfinite(value).all(), (path, mesh["name"], channel)
        meshes[mesh["name"]] = {"minimum": positions.min(axis=0), "maximum": positions.max(axis=0),
                                 "triangles": len(triangles), "vertices": len(positions)}
    for marker, expected in {"O": (0, 0, 0), "X": (4, 0, 0), "Y": (0, 4, 0), "Z": (0, 0, 4)}.items():
        item = meshes["NR2003_MARKER_" + marker]
        centre = (item["minimum"] + item["maximum"]) * 0.5
        assert np.max(np.abs(centre - np.asarray(expected) - 0.0625)) < 1e-6, (path, marker)
    return meshes


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("assets", type=Path)
    ap.add_argument("--luau-compile", type=Path)
    a = ap.parse_args(argv)
    manifest = json.loads((a.assets / "manifest.json").read_text())
    report = {"files": 0, "meshes": 0, "triangles": 0, "textures": 0, "installersCompiled": 0,
              "maxMeshTriangles": 0, "maxMeshDimensionStuds": 0.0, "sourceModules": 0,
              "maxSourceBytes": 0, "boundsDifferenceStuds": 0.0}
    for chunk in manifest["chunks"] + manifest.get("library", []):
        meshes = inspect_glb(a.assets / chunk["file"])
        report["files"] += 1
        for geometry in chunk["geometries"]:
            mesh = meshes[geometry["name"]]
            assert mesh["triangles"] == geometry["tris"] and mesh["vertices"] == geometry["verts"]
            assert mesh["triangles"] <= 16000
            dimension = float(np.max(mesh["maximum"] - mesh["minimum"]))
            assert dimension <= 1800.002, (chunk["name"], geometry["name"], dimension, "BasePart size")
            error = max(np.max(np.abs(mesh["minimum"] - geometry["min"])),
                        np.max(np.abs(mesh["maximum"] - geometry["max"])))
            assert error < 0.005, (chunk["name"], geometry["name"], error)
            report["boundsDifferenceStuds"] = max(report["boundsDifferenceStuds"], float(error))
            report["meshes"] += 1
            report["triangles"] += mesh["triangles"]
            report["maxMeshTriangles"] = max(report["maxMeshTriangles"], mesh["triangles"])
            report["maxMeshDimensionStuds"] = max(report["maxMeshDimensionStuds"], dimension)
    for stem, texture in manifest["textures"].items():
        path = a.assets / "textures" / (stem + ".png")
        with Image.open(path) as image:
            image.load()
            assert image.size == (texture["width"], texture["height"]) and image.mode == "RGBA"
            if "rgbaSHA256" in texture:
                assert hashlib.sha256(image.tobytes()).hexdigest() == texture["rgbaSHA256"]
        report["textures"] += 1
    if a.luau_compile:
        for path in sorted(list((a.assets / "studio").glob("*.lua")) + list((a.assets / "luau").glob("*.lua"))):
            subprocess.run([str(a.luau_compile), str(path)], check=True, stdout=subprocess.DEVNULL)
            report["installersCompiled"] += 1
    for path in sorted(a.assets.rglob("*.rbxmx")):
        xml = ET.parse(path)
        for source in xml.findall('.//ProtectedString[@name="Source"]'):
            size = len((source.text or "").encode())
            assert size < 199000, (path, "Roblox source transfer limit", size)
            report["sourceModules"] += 1
            report["maxSourceBytes"] = max(report["maxSourceBytes"], size)
    print(json.dumps(report, indent=1))
    (a.assets / "validation.json").write_text(json.dumps(report, indent=1) + "\n")


if __name__ == "__main__":
    main()
