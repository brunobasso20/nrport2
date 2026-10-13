"""Bake the recovered NR2003 base/lightmap pass for Roblox's single UV set.

Original DXG 1002b9e0 -> 1002c6e0 -> 1002cf00 selects the base texture, then
D3DTOP_MODULATE (4) multiplies Appearance slot 2 using UV channels 16/17.
The base alpha is retained. Original textures and descriptors remain in assets.
The bake preserves that colour equation; GPU mip/filtering is platform dependent.
"""
from __future__ import annotations

import hashlib
import math

import numpy as np
from PIL import Image


def _corners(coords, channels):
    return np.asarray([[coords.channels[i][j] for i in channels] for j in (0, 3, 1, 2)], dtype=np.float64)


def _parameter(primary, points):
    """Invert the four authored UV corners, without a world-coordinate guess."""
    a = primary[0]
    b, c = primary[1]-a, primary[2]-a
    d = primary[3]-primary[1]-primary[2]+a
    initial = np.linalg.pinv(np.stack((b, c), axis=1))
    q = (points-a) @ initial.T
    for _ in range(12):
        u, v = q[:, 0], q[:, 1]
        error = a+u[:, None]*b+v[:, None]*c+(u*v)[:, None]*d-points
        du, dv = b+v[:, None]*d, c+u[:, None]*d
        det = du[:, 0]*dv[:, 1]-du[:, 1]*dv[:, 0]
        if np.any(np.abs(det) < 1e-15):
            raise ValueError("Noninvertible authored primary texture coordinates")
        q[:, 0] -= (error[:, 0]*dv[:, 1]-error[:, 1]*dv[:, 0])/det
        q[:, 1] -= (du[:, 0]*error[:, 1]-du[:, 1]*error[:, 0])/det
        if np.max(np.abs(error)) < 1e-10:
            break
    return q


def _map(corners, q):
    u, v = q[:, 0:1], q[:, 1:2]
    return ((1-u)*(1-v)*corners[0] + u*(1-v)*corners[1]
            + (1-u)*v*corners[2] + u*v*corners[3])


def _sample(pixels, uv, clamp_u, clamp_v):
    """Bilinear top-row-first texture sampling at pixel centres (D3D UV)."""
    h, w = pixels.shape[:2]
    x, y = uv[:, 0]*w-.5, uv[:, 1]*h-.5
    ix, iy = np.floor(x).astype(np.int64), np.floor(y).astype(np.int64)
    tx, ty = (x-ix)[:, None], (y-iy)[:, None]
    def address(i, n, clamp):
        return np.clip(i, 0, n-1) if clamp else i % n
    x0, x1 = address(ix, w, clamp_u), address(ix+1, w, clamp_u)
    y0, y1 = address(iy, h, clamp_v), address(iy+1, h, clamp_v)
    return ((1-tx)*(1-ty)*pixels[y0, x0]+tx*(1-ty)*pixels[y0, x1]
            +(1-tx)*ty*pixels[y1, x0]+tx*ty*pixels[y1, x1])


def _tile_geometry(g, lower, upper, name):
    """Clip original triangles in their UV domain; preserve their planar geometry."""
    def clip(vertices, axis, value, maximum):
        if not vertices:
            return []
        result = []
        previous = vertices[-1]
        before = previous[2][axis] <= value if maximum else previous[2][axis] >= value
        for current in vertices:
            after = current[2][axis] <= value if maximum else current[2][axis] >= value
            if before != after:
                t = (value-previous[2][axis])/(current[2][axis]-previous[2][axis])
                result.append(tuple(tuple(a+(b-a)*t for a, b in zip(pa, pb)) for pa, pb in zip(previous, current)))
            if after:
                result.append(current)
            previous, before = current, after
        return result
    out = dict(g, name=g["name"]+"_"+name, positions=[], normals=[], uvs=[], tris=[])
    span = upper-lower
    for triangle in g["tris"]:
        polygon = [(g["positions"][i], g["normals"][i], g["uvs"][i]) for i in triangle]
        for axis in range(2):
            polygon = clip(polygon, axis, lower[axis], False)
            polygon = clip(polygon, axis, upper[axis], True)
        for i in range(1, len(polygon)-1):
            vertices = [polygon[0], polygon[i], polygon[i+1]]
            p = np.asarray([v[0] for v in vertices])
            if np.linalg.norm(np.cross(p[1]-p[0], p[2]-p[0])) <= 1e-10:
                continue
            base = len(out["positions"])
            out["positions"].extend(v[0] for v in vertices)
            out["normals"].extend(v[1] for v in vertices)
            out["uvs"].extend(tuple((np.asarray(v[2])-lower)/span) for v in vertices)
            out["tris"].append((base, base+1, base+2))
    return out


def bake(geometries, stream, texture_meta, texture_dir, max_texture_size=4096):
    """Return terrain with the recovered slot-2 colour pass baked into its base map."""
    result, report = [], {"sourceStrips": 0, "bakedTextures": 0, "texels": 0, "maxTextureSize": max_texture_size,
        "shader": "Original rend_dxg.dll1002cf00 stage1 D3DTOP_MODULATE4 RGB; base alpha retained",
        "uvStreams": ["TextureCoords0/1", "TextureCoords16/17"],
        "limitation": "Finite colour bake uses largest original MIP and bilinear sampling; Roblox regenerates mipmaps and performs its own lighting/filtering. It cannot reproduce every original view-dependent GPU sample bit for bit."}
    images = {}
    def image(stem):
        if stem not in images:
            with Image.open(texture_dir / (stem+".png")) as im:
                images[stem] = np.asarray(im.convert("RGBA"), dtype=np.float64)
        return images[stem]
    for g in geometries:
        textures = g["material"]["textures"]
        if len(textures) < 3 or not textures[2]:
            result.append(g)
            continue
        descriptor = stream.objects[g["source"]["descriptor"]]
        coords = descriptor.w_section
        primary, light = _corners(coords, (0, 1)), _corners(coords, (16, 17))
        base_stem, light_stem = textures[0].removesuffix(".mip"), textures[2].removesuffix(".mip")
        base_pixels, light_pixels = image(base_stem), image(light_stem)
        base_info, light_info = texture_meta[base_stem], texture_meta[light_stem]
        low, high = np.min(np.asarray(g["uvs"]), axis=0), np.max(np.asarray(g["uvs"]), axis=0)
        pixel_span = (high-low)*np.asarray([base_pixels.shape[1], base_pixels.shape[0]])
        tile_counts = np.maximum(1, np.ceil(pixel_span/max_texture_size).astype(int))
        report["sourceStrips"] += 1
        for x in range(tile_counts[0]):
            for y in range(tile_counts[1]):
                lower = low+(high-low)*np.asarray([x, y])/tile_counts
                upper = low+(high-low)*np.asarray([x+1, y+1])/tile_counts
                size = np.maximum(1, np.ceil((upper-lower)*[base_pixels.shape[1], base_pixels.shape[0]]).astype(int))
                stem = "baked_f_%05d_%02d_%02d" % (descriptor.handle, x, y)
                tiled = _tile_geometry(g, lower, upper, stem)
                if not tiled["tris"]:
                    continue
                width, height = map(int, size)
                output = np.empty((height, width, 4), dtype=np.uint8)
                # Bounded row batches keep the full track conversion below a
                # texture-sized temporary-memory spike.
                for start in range(0, height, 128):
                    end = min(height, start+128)
                    xx, yy = np.meshgrid((np.arange(width)+.5)/width, (np.arange(start, end)+.5)/height)
                    uv = np.stack((xx.ravel(), yy.ravel()), axis=1)*(upper-lower)+lower
                    secondary = _map(light, _parameter(primary, uv))
                    base_colour = _sample(base_pixels, uv, base_info["clampU"], base_info["clampV"])
                    shadow = _sample(light_pixels, secondary, light_info["clampU"], light_info["clampV"])
                    rgba = np.concatenate((base_colour[:, :3]*shadow[:, :3]/255, base_colour[:, 3:4]), axis=1)
                    output[start:end] = np.clip(np.rint(rgba), 0, 255).astype(np.uint8).reshape((end-start, width, 4))
                png_path = texture_dir / (stem+".png")
                Image.fromarray(output, "RGBA").save(png_path)
                texture_meta[stem] = {"format": "RGBA8 source-derived MODULATE bake", "width": width, "height": height,
                    "clampU": True, "clampV": True, "alphaTransparent": bool(np.any(output[:, :, 3] < 255)),
                    "factor": 1.0, "rgbaSHA256": hashlib.sha256(output.tobytes()).hexdigest(),
                    "pngSHA256": hashlib.sha256(png_path.read_bytes()).hexdigest(),
                    "sourceTextures": [base_stem, light_stem], "blend": "RGB=base*light/255; alpha=base.alpha",
                    "uvDomain": [lower.tolist(), upper.tolist()]}
                tiled["material"] = dict(g["material"], textures=[stem+".mip"]+[None]*6)
                tiled["source"] = dict(g["source"], bakedLightmap={"base": base_stem, "lightmap": light_stem,
                    "shader": "rend_dxg.dll1002cf00", "baseChannels": [0, 1], "lightChannels": [16, 17],
                    "uvDomain": [lower.tolist(), upper.tolist()]})
                result.append(tiled)
                report["bakedTextures"] += 1
                report["texels"] += width*height
    return result, report
