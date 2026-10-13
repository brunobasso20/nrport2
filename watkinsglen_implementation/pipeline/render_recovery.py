"""Small, source-derived helpers for the original NR2003 track renderer.

Evidence is recovered from the original rendserv.dll and rend_dxg.dll. See
DXG10047350/10048b40 (cubic walls), DXG100496f0 (painted details),
1001cf60/1001dd20 (wall boundary curves), 1001e450 (UV corner
coefficients), 1001e530 (wall end-cap coordinates), and 10020bf0/10021340/
100217b0 (wall compiler).  These helpers do not replace the continuous
NR2003 collision and surface query runtime.
"""
from __future__ import annotations

import math
import struct


def f32(value):
    """The native renderer stores its coefficients and vertices as float32."""
    return struct.unpack("<f", struct.pack("<f", value))[0]


def uv_coefficients(corners, fraction_start, fraction_end):
    """Transcribe rendserv.dll 1001e450, including its float32 stores.

    The descriptor corners are f64 [start-left, end-left, end-right,
    start-right].  Fractions refer to the two endpoint profile widths.
    Native null coordinate channels produce two zero coefficients; a NaN
    present in an authored channel propagates rather than being repaired.
    """
    if corners is None:
        return 0.0, 0.0
    if len(corners) != 4:
        raise ValueError("native track UV channel must contain four corners")
    start = (1.0 - fraction_start) * corners[0] + fraction_start * corners[3]
    end = (1.0 - fraction_end) * corners[1] + fraction_end * corners[2]
    return f32(start), f32(end - start)


def renderer_uv(coords, longitudinal_fraction, fraction_start,
                fraction_end=None, channels=(0, 1)):
    """Evaluate source UV coefficients for a native renderer profile strip.

    Terrain base coordinates use channels 0/1; the shipped Watkins Glen
    light/shadow maps use 16/17.  Interpolation/export trailers are not inputs
    to the runtime UV evaluator.  This function intentionally preserves NaNs.
    """
    if coords is None or getattr(coords, "cls", None) != "TextureCoords":
        raise ValueError("track renderer requires TextureCoords descriptor")
    if fraction_end is None:
        fraction_end = fraction_start
    t = f32(longitudinal_fraction)
    result = []
    for channel_index in channels:
        start, delta = uv_coefficients(coords.channels[channel_index],
                                       fraction_start, fraction_end)
        result.append(f32(start + t * delta))
    return result


def wall_authoring_state(wall):
    """Decode the v7 40-byte cubic profile, used by the DirectX renderer.

    The software rendserv.dll wall compiler does not consume this profile,
    but the game's rend_dxg.dll 10047350 DOES.  This backend distinction is
    why a negative field search in rendserv alone cannot prove runtime
    inertness.  The payload is [f32 targetHeight, u32 subdivisions, 4f32 X,
    4f32 Z], not ten float coefficients or four interleaved vec2 points.
    """
    if wall.wall_profile_kind == 0:
        return None
    if wall.wall_profile_kind != 1 or len(wall.cubic_profile) != 40:
        raise ValueError("unsupported serialized wall authoring payload")
    first, word, *values = struct.unpack("<fI8f", wall.cubic_profile)
    return {"targetHeight": first, "subdivisions": word,
            "lateralControlPoints": values[:4], "heightControlPoints": values[4:],
            "bytesHex": wall.cubic_profile.hex(),
            "sourceRenderer": "rend_dxg.dll10047350"}


def dxg_wall_profile(wall):
    """Transcribe DirectX cubic wall extrusion and its arc-length UV mapping.

    Native 10047350 samples j/count for j=1..count (the origin is implicit),
    negates the authored X cubic, optionally scales a positive target height,
    subtracts the profile height from the wall's straight lower section, and
    accumulates the polyline lengths used for the entire side-face V mapping.
    Native 10048b40 adds every returned lateral/height pair to that lower wall
    section when compiling the two side boundaries.
    """
    authored = wall_authoring_state(wall)
    if authored is None:
        return None
    count = authored["subdivisions"]
    if count < 1 or count > 1 << 16:
        raise ValueError("invalid DirectX wall-profile subdivision count")
    xs, zs = authored["lateralControlPoints"], authored["heightControlPoints"]
    points = []
    max_height = 0.0
    for index in range(1, count + 1):
        t = f32(index / count)
        s = f32(1.0 - t)
        weights = (s * s * s, s * s * t * 3.0, s * t * t * 3.0, t * t * t)
        lateral = f32(-sum(weights[i] * xs[i] for i in range(4)))
        height = f32(sum(weights[i] * zs[i] for i in range(4)))
        points.append({"lateral": lateral, "height": height})
        max_height = max(max_height, height)
    target_height = authored["targetHeight"]
    profile_height = max_height
    if target_height > 0.0 and max_height > 0.0:
        profile_height = target_height
        scale = f32(target_height / max_height)
        for point in points:
            point["lateral"] = f32(scale * point["lateral"])
            point["height"] = f32(scale * point["height"])
    # The native wall heights are f64; 10047583/1004759c store the subtraction
    # back as f64.  Narrowing 4 - f32(.6) here loses the source's UV bits.
    lower_start = max(0.0, wall.height_start - profile_height)
    lower_end = max(0.0, wall.height_end - profile_height)
    previous_lateral = previous_height = arc_length = 0.0
    for point in points:
        dx = f32(point["lateral"] - previous_lateral)
        dz = f32(point["height"] - previous_height)
        arc_length = f32(math.sqrt(dx * dx + dz * dz) + arc_length)
        point["arcLength"] = arc_length
        previous_lateral, previous_height = point["lateral"], point["height"]
    for endpoint, lower_height in (("Start", lower_start), ("End", lower_end)):
        # Native stores this sum as f64.  Arc length is f32; lower wall
        # height remains the f64 difference from 10047583/1004759c.
        total_length = arc_length + lower_height
        if total_length <= 0.0:
            raise ValueError("DirectX wall side has zero UV arc length")
        for point in points:
            point["uvFraction" + endpoint] = f32(1.0 - (point["arcLength"] + lower_height) / total_length)
    return {"points": points, "lowerHeightStart": lower_start,
            "lowerHeightEnd": lower_end, "profileHeight": profile_height,
            "totalProfileArcLength": arc_length,
            "baseUVFractionStart": f32(1.0 - lower_start / (arc_length + lower_start)),
            "baseUVFractionEnd": f32(1.0 - lower_end / (arc_length + lower_end)),
            "source": "rend_dxg.dll10047350/10048b40",
            "authored": authored}


def _endpoint_profile_pair(segment, lateral, endpoint):
    field = "lateral_start" if endpoint == 0 else "lateral_end"
    points = segment.x_sections
    if len(points) < 2:
        raise ValueError("wall requires at least two X_Section boundaries")
    # Native boundaries are authored in ascending lateral order.  At the
    # outer limits the first/last profile chord remains authoritative.
    ordered = [getattr(point, field) for point in points]
    if any(b < a for a, b in zip(ordered, ordered[1:])):
        raise ValueError("X_Section endpoint boundaries are not ordered")
    index = 0
    while index + 1 < len(points) - 1 and lateral >= ordered[index + 1]:
        index += 1
    return points[index], points[index + 1], index


def wall_top_parameters(segment, wall, side):
    """Recover endpoint parameters passed to native wall boundary compilation.

    ``side`` is -1 for the minus-lateral boundary and +1 for the plus boundary.
    Source 10021340 passes ``W.height_offset_mode == 0`` as the bank-normal
    flag to 1001cf60.  Therefore zero means bank-normal for VISUAL geometry;
    nonzero means world vertical.  This is the reverse of the earlier viewer
    header's annotation.

    Bank displacement uses the endpoint X_Section height chord, never the
    full three-dimensional driving normal.  The ground height is evaluated
    at the resulting shifted lateral boundary, then the returned vertical
    offset is added.  A crossing of different X profile pairs requires the
    original boundary-transition compiler; pairIndices reports this rather
    than silently claiming a complete visual lift.
    """
    if side not in (-1, 1):
        raise ValueError("wall boundary side must be -1 or +1")
    laterals = [wall.lateral_start + side * wall.visual_face_offset_start,
                wall.lateral_end + side * wall.visual_face_offset_end]
    heights = [wall.height_start, wall.height_end]
    pair_indices = []
    shifts = []
    for endpoint in (0, 1):
        left, right, index = _endpoint_profile_pair(segment, laterals[endpoint], endpoint)
        pair_indices.append(index)
        suffix = "start" if endpoint == 0 else "end"
        dl = getattr(left, "lateral_" + suffix) - getattr(right, "lateral_" + suffix)
        dh = getattr(left, "height_" + suffix) - getattr(right, "height_" + suffix)
        if wall.height_offset_mode == 0:
            if dl == 0 and dh == 0:
                theta = 0.0  # x87 fpatan(0,0)
            else:
                theta = math.atan2(dh, dl)
            shift = heights[endpoint] * math.sin(theta)
            vertical = heights[endpoint] * abs(math.cos(theta))
        else:
            shift, vertical = 0.0, heights[endpoint]
        laterals[endpoint] += shift
        heights[endpoint] = vertical
        shifts.append(shift)
    return {"lateralStart": laterals[0], "lateralEnd": laterals[1],
            "verticalOffsetStart": heights[0], "verticalOffsetEnd": heights[1],
            "lateralShiftStart": shifts[0], "lateralShiftEnd": shifts[1],
            "pairIndices": pair_indices,
            "requiresProfileTransition": pair_indices[0] != pair_indices[1],
            "source": "rendserv.dll10021340->1001cf60->1001dd20"}


def wall_cap_sources(wall):
    """Native caps use face 3 in the first record and 4 in the last record.

    Proven by 10020bf0's first-record ``+0xc`` and last-record ``+0x10``
    Appearance reads, with coordinate partners at ``+0x20`` and ``+0x24``.
    Intermediate material records do not create end caps.
    """
    # DirectX 10047770 deliberately excludes cubic-profile end caps; the
    # generic software renderer's cap path must not override that gate.
    if not wall.records or wall.wall_profile_kind:
        return []
    result = []
    for endpoint, record_index, face in ((0, 0, 3), (1, len(wall.records) - 1, 4)):
        pair = wall.records[record_index]["inner"][face]
        if pair["child_a"] is not None:
            result.append({"endpoint": endpoint, "record": record_index,
                           "face": face, "appearance": pair["child_a"],
                           "coords": pair["child_b"]})
    return result


def build_track_details(root, sample_many, project_world_many, render_offset=0.0):
    """Build all original TrackDetail paint rectangles from native DX geometry.

    This is a transcription of rend_dxg.dll 100496f0.  ``sample_many`` takes
    (dlong,dlat) pairs and invokes original 005150fa. ``project_world_many``
    takes (x,y,z) triples and invokes original 005f58d0 -> 0051370a, returning
    dictionaries with ground ``z`` and ``nx,ny,nz``.  Neither callback may
    substitute Roblox raycasts or a replacement track model.

    The source creates exactly four vertices and two triangles per detail.
    Its yaw is an absolute WORLD XY angle, not a centerline-relative heading.
    Float32 half extents and corner stores mirror the source renderer; UV
    corners 2/3 are exchanged when writing the triangle strip.  The original
    geometry has no positional lift. ``render_offset`` is an explicit host
    rendering adaptation, if needed to display coplanar decals in Roblox;
    its value is recorded, and it never enters collision queries.
    """
    import ptf  # delayed because the PTF builder also imports these helpers

    details = [child for child in root.children_c
               if child is not None and child.cls == "TrackDetail"]
    if not details:
        return [], {"source": "rend_dxg.dll100496f0", "count": 0}
    centers = sample_many([(detail.scalars[0], detail.scalars[1]) for detail in details])
    if len(centers) != len(details):
        raise ValueError("incorrect original TrackDetail center sample count")
    requests = []
    geometries = []
    for detail_index, (detail, center) in enumerate(zip(details, centers)):
        if len(detail.scalars) != 5 or len(detail.buf32a) != 32 or len(detail.buf32b) != 32:
            raise ValueError("invalid source TrackDetail rectangle")
        dlong, dlat, width, length, yaw = detail.scalars
        half_width, half_length = f32(f32(width) * .5), f32(f32(length) * .5)
        cos_yaw, sin_yaw = math.cos(yaw), math.sin(yaw)
        for local_x, local_y in ((-half_width, -half_length),
                                  (half_width, -half_length),
                                  (-half_width, half_length),
                                  (half_width, half_length)):
            requests.append((f32(cos_yaw * local_x - sin_yaw * local_y + center["x"]),
                             f32(cos_yaw * local_y + sin_yaw * local_x + center["y"]),
                             center["z"]))
        geometry = ptf._new_geometry("track_detail_%03d" % detail_index, detail.child,
            {"descriptor": detail.handle, "sourceClass": "TrackDetail",
             "sourceRenderer": "rend_dxg.dll100496f0", "dlong": dlong, "dlat": dlat,
             "width": width, "length": length, "absoluteWorldYaw": yaw,
             "uvMethod": "authoredTrackDetailFourCornersFloat32",
             "renderOffsetMetres": render_offset, "collisionGeometry": False})
        u = struct.unpack("<4d", detail.buf32a)
        v = struct.unpack("<4d", detail.buf32b)
        geometry["uvs"] = [[f32(u[index]), f32(v[index])] for index in (0, 1, 3, 2)]
        geometries.append(geometry)
    projected = project_world_many(requests)
    if len(projected) != len(requests):
        raise ValueError("incorrect original TrackDetail projection sample count")
    for detail_index, geometry in enumerate(geometries):
        selected = projected[detail_index * 4:(detail_index + 1) * 4]
        positions = []
        normals = []
        for request, ground in zip(requests[detail_index * 4:(detail_index + 1) * 4], selected):
            normal = [ground[key] for key in ("nx", "ny", "nz")]
            position = [request[0], request[1], f32(ground["z"])]
            if render_offset:
                position = [position[i] + normal[i] * render_offset for i in range(3)]
            if not all(math.isfinite(value) for value in position + normal):
                raise ValueError("nonfinite original TrackDetail geometry")
            positions.append(position)
            normals.append(normal)
        uvs = geometry.pop("uvs")
        geometry["uvs"] = []
        ptf._append_quad(geometry, positions, normals, uvs)
    return geometries, {"source": "rend_dxg.dll100496f0", "count": len(geometries),
                        "vertices": len(requests), "triangles": sum(len(g["tris"]) for g in geometries),
                        "centerSampler": "original005150fa",
                        "cornerProjection": "original005f58d0->0051370a",
                        "renderOffsetMetres": render_offset,
                        "yawMeaning": "absolute world XY angle",
                        "heightMeaning": "projected smooth ground height at each authored corner"}
