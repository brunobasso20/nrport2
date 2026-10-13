"""Strict Papyrus PTF object graph reader and descriptor-driven visual mesh builder.

Wire bodies are transcribed from the NR2003 descriptor readers documented in
OpenNR-Tools src/fs/papyrus_descriptors.cpp (619motorsports/OpenNR-Tools).
The registry is private: reading a PTF never modifies the shared car 3DO parser.
Unknown classes, inconsistent allocation prefixes and trailing bytes fail.
All geometry remains in NR2003 metres and axes; the final exporter changes axes.

OpenNR-Tools reference notice:
MIT License
Copyright (c) 2026 Jackie
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
from __future__ import annotations

import math
import base64
import copy
import json
import hashlib
import os
import re
import struct
import subprocess
import sys
from collections import Counter
from pathlib import Path
from types import SimpleNamespace

CAR_PIPELINE = Path(__file__).resolve().parents[2] / "nr2003carmodel_implementation" / "pipeline"
if str(CAR_PIPELINE) not in sys.path:
    sys.path.insert(0, str(CAR_PIPELINE))
from nr2003res import obj3do, scene  # noqa: E402
try:
    from . import render_recovery
except ImportError:
    import render_recovery

FormatError = obj3do.FormatError


class Stream(obj3do.Stream):
    def need(self, size):
        if size < 0 or self.p + size > len(self.d):
            raise FormatError("PTF truncated at 0x%x: need %d bytes" % (self.p, size))

    def raw(self, size):
        self.need(size)
        return super().raw(size)

    def u8(self):
        self.need(1)
        return super().u8()

    def u32(self):
        self.need(4)
        return super().u32()

    def i32(self):
        self.need(4)
        return super().i32()

    def f32(self):
        self.need(4)
        return super().f32()

    def f64(self):
        self.need(8)
        return super().f64()

    def f64s(self, count):
        self.need(count * 8)
        return super().f64s(count)

    def u32s(self, count):
        self.need(count * 4)
        return super().u32s(count)

    def obj(self):
        begin = self.p
        handle = self.u32()
        if handle == 0:
            return None
        if handle in self.objects:
            return self.objects[handle]
        class_handle = self.u32()
        if class_handle == 0:
            raise FormatError("PTF class handle 0 at 0x%x" % begin)
        if class_handle not in self.classes:
            self.classes[class_handle] = self.lp_string()
        cname = self.classes[class_handle]
        reader = READERS.get(cname)
        if reader is None:
            raise FormatError("no PTF reader for %r at 0x%x" % (cname, self.p))
        node = obj3do.Node(cname.removesuffix("Descriptor"), handle)
        node.stream_start = begin
        self.objects[handle] = node
        node.version = self.u32()
        node.name = self.lp_string()
        reader(self, node)
        node.stream_end = self.p
        return node


def _count(s, who, cap=1 << 20):
    count = s.u32()
    if count > cap:
        raise FormatError("%s count %d exceeds %d" % (who, count, cap))
    return count


def _magic(s, who, maximum, minimum=0):
    v = s.u32()
    if not minimum <= v <= maximum:
        raise FormatError("%s version %d outside [%d,%d]" % (who, v, minimum, maximum))
    return v


def _refs(s, who, conditional_alloc=False):
    count = _count(s, who)
    if count or not conditional_alloc:
        s.alloc(count * 4, who)
    return [s.obj() for _ in range(count)]


def _narrow(value):
    return struct.unpack("<f", struct.pack("<f", value))[0]


def r_track(s, n):
    n.magic = _magic(s, "Track", 8)
    n.num_segments = s.i32()
    if not 0 <= n.num_segments <= 1 << 20:
        raise FormatError("Track num_segments %d" % n.num_segments)
    n.flag = None
    n.scalars = None
    n.legacy_scalars = []
    if n.magic >= 3:
        n.flag = s.u8()
        if n.magic == 8:
            n.scalars = s.f64s(3)
            n.scalar_d_u32 = s.u32()
        else:
            n.legacy_scalars = s.f64s(5 + (8 if n.magic >= 5 else 0) + (8 if n.magic >= 6 else 0))
    n.records_e_raw = b""
    if n.magic >= 7:
        count = _count(s, "Track records_e", 1 << 16)
        s.alloc(count * 48, "Track records_e")
        n.records_e_raw = s.raw(count * 48)
    n.single_child = None
    n.children_c = []
    if n.magic == 2 or n.magic > 3:
        n.single_child = s.obj()
        n.children_c = _refs(s, "Track children_c")
    n.children_b = _refs(s, "Track children_b")
    s.alloc(n.num_segments * 4, "Track segments")
    n.segments = [s.obj() for _ in range(n.num_segments)]
    n.tsos = [v for v in n.children_b + n.children_c if v is not None and v.cls == "TSOReference"]


def r_segment(s, n):
    n.magic = _magic(s, "Segment", 2, 1)
    n.x_sections = _refs(s, "Segment x_sections", True)
    n.f_sections = _refs(s, "Segment f_sections", True)
    n.w_sections = _refs(s, "Segment w_sections", True)
    n.segment_kind = s.i32()
    if n.segment_kind == -1:
        return
    n.pos_a, n.pos_b, n.angle_c, n.pos_d, n.pos_e, n.angle_f = s.f64s(6)
    n.flag_a, n.flag_b = s.u8(), s.u8()
    n.records_12_raw = n.records_16_raw = b""
    for size in (12, 16):
        count = _count(s, "Segment records_%d" % size)
        if count:
            s.alloc(count * size, "Segment records_%d" % size)
            setattr(n, "records_%d_raw" % size, s.raw(count * size))


def _seam(s):
    result = {"kind": s.u8()}
    if result["kind"]:
        result.update(parameter0=s.f32(), parameter1=s.f32())
    if result["kind"] == 2:
        result.update(source_boundary_index=s.u8(), target_boundary_index=s.u8())
    return result


def r_xsection(s, n):
    n.magic = _magic(s, "X_Section", 3)
    read_float = s.f32 if n.magic >= 3 else lambda: _narrow(s.f64())
    n.lateral_start, n.height_start, n.slope_start = read_float(), s.f64(), read_float()
    n.lateral_end, n.height_end, n.slope_end = read_float(), s.f64(), read_float()
    n.visual_curve_mode = s.u8() if n.magic >= 2 else 0
    n.start_seam = _seam(s) if n.magic >= 3 else {"kind": 0}
    n.end_seam = _seam(s) if n.magic >= 3 else {"kind": 0}


def _runtime_slot(n, offset):
    """Exact descriptor trailer gate at +0xc..+0x20, from 005e6a50/005e7270.

    X_Section uses a packed layout; Appearance uses six texture pointers.
    Unsupported polymorphic gates fail rather than assume pointer contents.
    """
    if n is None:
        return 0
    if n.cls == "Appearance":
        return int(n.textures[(offset - 12) // 4] is not None)
    if n.cls == "X_Section":
        body = bytearray(0x18)
        struct.pack_into("<ffBd", body, 0, n.lateral_start, n.lateral_end, n.visual_curve_mode, n.height_start)
        struct.pack_into("<f", body, 17, n.slope_start)
        return struct.unpack_from("<I", body, offset - 12)[0]
    raise FormatError("unsupported trailer gate class %s #%d" % (n.cls, n.handle))


SLOT_OFFSETS = (0x0C, 0x10, 0x18, 0x14, 0x1C, 0x20)


def _nonempty(n):
    return any(_runtime_slot(n, off) for off in (0x0C, 0x10, 0x14, 0x18, 0x20))


def _f_trailers(s, source):
    blocks = []
    for offset in SLOT_OFFSETS:
        block = {"source_field_nonzero": bool(_runtime_slot(source, offset))}
        if block["source_field_nonzero"]:
            block["gate"] = s.u8()
            if block["gate"] == 0:
                # Interleaved flags/values: the two flags are not adjacent.
                block["pairs"] = [(s.u8(), s.f64()) for _ in range(2)]
                block["triple_f64"] = s.f64s(3)
        blocks.append(block)
    return blocks


def r_fsection(s, n):
    n.magic = _magic(s, "F_Section", 5)
    read_float = s.f32 if n.magic >= 5 else lambda: _narrow(s.f64())
    n.lateral_start, n.lateral_end = read_float(), read_float()
    n.boundary_mode = s.u8() if n.magic >= 3 else 0
    n.query_tag = s.u32() if n.magic >= 4 else 1
    n.surface_code = s.u32()
    n.x_section = s.obj()
    n.w_section = None
    n.trailer_blocks = []
    if _nonempty(n.x_section):
        n.w_section = s.obj()
        n.trailer_blocks = _f_trailers(s, n.x_section)


def _w_trailers(s, source):
    blocks = []
    for offset in SLOT_OFFSETS:
        block = {"source_field_nonzero": bool(_runtime_slot(source, offset))}
        if block["source_field_nonzero"]:
            block["gate"] = s.u8()
            if block["gate"] == 0:
                block["entries"] = [(s.u8(), s.f64(), s.f64()) for _ in range(2)]
        blocks.append(block)
    return blocks


def r_wsection(s, n):
    n.magic = _magic(s, "W_Section", 7)
    read_float = s.f32 if n.magic >= 6 else lambda: _narrow(s.f64())
    n.lateral_start, n.lateral_end = read_float(), read_float()
    n.boundary_mode = s.u8() if n.magic >= 3 else 0
    n.query_tag = s.u32() if n.magic >= 4 else 1
    (n.height_start, n.height_end, n.visual_face_offset_start, n.visual_face_offset_end,
     n.collision_half_thickness_start, n.collision_half_thickness_end) = s.f64s(6)
    n.height_offset_mode = s.i32()
    if n.height_offset_mode == -1:
        raise FormatError("W_Section invalid height_offset_mode -1")
    n.wall_profile_kind = s.u32() if n.magic >= 7 else 0
    n.cubic_profile = s.raw(40) if n.wall_profile_kind == 1 else b""
    n.surface_code = s.u32()
    n.records = []
    count = _count(s, "W_Section records", 1 << 16) if n.magic >= 5 else 1
    for _ in range(count):
        record = {"longitudinal_position": s.f64() if n.magic >= 5 else 0.0, "inner": []}
        for _ in range(5):
            pair = {"child_a": s.obj(), "child_b": None, "interpolation_blocks": []}
            if _nonempty(pair["child_a"]):
                pair["child_b"] = s.obj()
                pair["interpolation_blocks"] = _w_trailers(s, pair["child_a"])
            record["inner"].append(pair)
        n.records.append(record)


def r_texturecoords(s, n):
    n.magic = _magic(s, "TextureCoords", 1, 1)
    n.count = _count(s, "TextureCoords", 0x4098)
    n.attr_magic = _magic(s, "TextureCoords attributes", 3)
    n.channels = [None] * 24
    slots = list(range(4)) + (list(range(4, 8)) if n.attr_magic > 2 else []) + list(range(8, 24))
    for index in slots:
        n.channels[index] = s.channel(n.count, "TextureCoords channel %d" % index)


def r_tso(s, n):
    n.magic = _magic(s, "TSO", 3)
    n.name_a = s.lp_string()
    n.name_b = s.lp_string() if n.magic >= 2 else ""
    n.flag = s.u8() if n.magic >= 3 else None


def r_tsoref(s, n):
    n.magic = _magic(s, "TSOReference", 6)
    n.xform = s.f64s(6)
    n.child = s.obj()
    n.reference_name = ""
    n.conditional_flag = 0
    n.skip_payload = None
    n.inline_payload = b""
    n.extra_records = b""
    if n.magic == 1:
        return
    if n.magic >= 4:
        n.conditional_flag = s.u32()
    n.skip_payload = s.u8()
    if n.magic < 5 or not n.skip_payload:
        n.inline_payload = s.raw(44)
    if n.magic != 2:
        n.extra_records = s.raw(_count(s, "TSOReference extra_records", 1 << 16) * 40)
    if n.magic >= 6:
        n.reference_name = s.lp_string()


def r_detail(s, n):
    n.magic = s.u32()
    n.child = s.obj()
    n.scalars = s.f64s(5)
    s.alloc(32, "TrackDetail buf32a")
    n.buf32a = s.raw(32)
    s.alloc(32, "TrackDetail buf32b")
    n.buf32b = s.raw(32)


def r_groove(s, n):
    n.magic = s.u32()
    n.count = _count(s, "TrackGroove")
    n.child = s.obj()
    n.scalar = s.f64()
    n.channels = []
    for _ in range(5):
        s.alloc(n.count * 8, "TrackGroove")
        n.channels.append(s.f64s(n.count))


def r_raceline(s, n):
    n.magic = s.u32()
    n.count = _count(s, "TrackRaceLine")
    n.child = s.obj()
    n.scalars = s.f64s(3)
    n.channels = []
    for _ in range(2):
        s.alloc(n.count * 8, "TrackRaceLine")
        n.channels.append(s.f64s(n.count))


def r_appnode(s, n):
    obj3do._transformable(s, n)
    n.magic, n.app_id = s.u32(), s.u32()
    n.data = s.raw(_count(s, "AppNode data", 1 << 24))
    n.child = s.obj()


READERS = dict(obj3do.READERS, **{
    "TrackDescriptor": r_track, "SegmentDescriptor": r_segment,
    "X_SectionDescriptor": r_xsection, "F_SectionDescriptor": r_fsection, "W_SectionDescriptor": r_wsection,
    "TextureCoordsDescriptor": r_texturecoords, "TSODescriptor": r_tso, "TSOReferenceDescriptor": r_tsoref,
    "TrackDetailDescriptor": r_detail, "TrackGrooveDescriptor": r_groove, "TrackRaceLineDescriptor": r_raceline,
    "AppNodeDescriptor": r_appnode,
})


def parse(data):
    """Read exactly one complete PTF; return (Track Node, Stream)."""
    stream = Stream(data)
    root = stream.obj()
    if root is None or root.cls != "Track":
        raise FormatError("PTF root must be TrackDescriptor")
    if stream.p != len(data):
        raise FormatError("PTF trailing %d bytes at 0x%x" % (len(data) - stream.p, stream.p))
    root._source_sha256 = hashlib.sha256(data).hexdigest()
    return root, stream


def placements(root):
    """TSOReferences in on-disk order; original x,y,z,heading,pitch,roll."""
    out = []
    for index, ref in enumerate(root.tsos):
        if ref.child is None or ref.child.cls != "TSO":
            raise FormatError("TSOReference #%d child is not TSO" % ref.handle)
        model = ref.child.name_a
        out.append({"index": index, "handle": ref.handle, "model": model,
                    "referenceName": ref.reference_name,
                    "position": list(ref.xform[:3]), "rotation": list(ref.xform[3:]),
                    "secondaryModel": ref.child.name_b, "modelFlags": ref.child.flag,
                    "conditionalFlag": ref.conditional_flag})
    return out


def metadata(root, stream=None):
    """Counts, placements and source descriptors, without inventing runtime fields."""
    out = {"declaredSegments": root.num_segments, "parsedSegments": len(root.segments),
           "placements": placements(root), "sections": []}
    for index, segment in enumerate(root.segments):
        out["sections"].append({"index": index, "kind": segment.segment_kind,
                                "xSections": len(segment.x_sections), "fSections": len(segment.f_sections),
                                "wSections": len(segment.w_sections)})
    if stream:
        out.update(bytesConsumed=stream.p, objectClasses=dict(Counter(n.cls for n in stream.objects.values())))
    return out


def descriptor_graph(stream):
    """JSON-safe descriptor image, retaining references and every raw payload."""
    def value(v):
        if isinstance(v, obj3do.Node):
            return {"ref": v.handle}
        if isinstance(v, bytes):
            return {"bytesHex": v.hex()}
        if isinstance(v, float) and not math.isfinite(v):
            return {"nonfiniteF64BitsHex": struct.pack("<d", v).hex()}
        if isinstance(v, (list, tuple)):
            return [value(x) for x in v]
        if isinstance(v, dict):
            return {str(k): value(x) for k, x in v.items()}
        return v
    return {str(h): {k: value(v) for k, v in n.__dict__.items() if not k.startswith("_")} for h, n in stream.objects.items()}


def _lerp(a, b, t):
    return a + (b - a) * t


def _normal(a, b, c):
    u = [b[i] - a[i] for i in range(3)]
    v = [c[i] - a[i] for i in range(3)]
    out = [u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0]]
    size = math.sqrt(sum(x * x for x in out))
    return [x / size for x in out] if size else [0.0, 0.0, 1.0]


def _uv(coords, t, fraction):
    if coords is None or coords.cls != "TextureCoords":
        raise FormatError("textured PTF face lacks authored TextureCoords")
    return render_recovery.renderer_uv(coords, t, fraction)


def rebase_terrain_uvs(geometries, root):
    """Reapply runtime-narrowed corners without resampling unchanged positions.

    The previous exporter used f64 corners. Its UV values uniquely determine
    their original bilinear-map location for the source's nondegenerate maps.
    Degenerate maps accept a solution only if its old UV reconstructs exactly.
    No replacement wrapping, tiling or guessed UVs are introduced.
    """
    coordinates = {f.handle: f.w_section for segment in root.segments for f in segment.f_sections if f.w_section}
    rebuilt = 0
    maximum_change = maximum_position_change = maximum_normal_change = 0.0
    for geometry in geometries:
        co = coordinates[geometry["source"]["descriptor"]]
        coefficients = [[ch[0], ch[1] - ch[0], ch[3] - ch[0], ch[2] - ch[1] - ch[3] + ch[0]] for ch in co.channels[:2]]
        cache = {}
        output = []
        for previous in geometry["uvs"]:
            key = tuple(previous)
            if key not in cache:
                t, fraction = .5, .5
                for _ in range(16):
                    residual = [a + b * t + c * fraction + d * t * fraction - previous[i]
                                for i, (a, b, c, d) in enumerate(coefficients)]
                    if max(map(abs, residual)) <= 1e-9:
                        break
                    jt = [ch[1] + ch[3] * fraction for ch in coefficients]
                    jf = [ch[2] + ch[3] * t for ch in coefficients]
                    determinant = jt[0] * jf[1] - jf[0] * jt[1]
                    if abs(determinant) > 1e-20:
                        t -= (residual[0] * jf[1] - residual[1] * jf[0]) / determinant
                        fraction -= (jt[0] * residual[1] - jt[1] * residual[0]) / determinant
                    else:
                        # Rank-one maps still admit an exact source solution.
                        choices = [(abs(jt[i]), i, 0) for i in range(2)] + [(abs(jf[i]), i, 1) for i in range(2)]
                        strength, i, direction = max(choices)
                        if strength <= 1e-20:
                            break
                        if direction == 0:
                            t -= residual[i] / jt[i]
                        else:
                            fraction -= residual[i] / jf[i]
                reconstructed = [a + b * t + c * fraction + d * t * fraction for a, b, c, d in coefficients]
                if max(abs(reconstructed[i] - previous[i]) for i in range(2)) > 1e-8:
                    raise FormatError("cannot exactly recover original UV map location for " + geometry["name"])
                cache[key] = _uv(co, t, fraction)
            updated = cache[key]
            maximum_change = max(maximum_change, *(abs(updated[i] - previous[i]) for i in range(2)))
            output.append(updated)
        geometry["uvs"] = output
        geometry["source"]["uvMethod"] = "rendserv1001e450Float32UVEndpointCoefficients"
        # Nine significant decimal digits uniquely identify an IEEE float32.
        # Parsing CSV to a Python double retains the decimal rounding error;
        # narrowing restores the exact native point/normal, without a query.
        for point in geometry["positions"]:
            previous = point[:]
            point[:] = [_narrow(v) for v in point]
            maximum_position_change = max(maximum_position_change, math.dist(previous, point))
        for normal in geometry["normals"]:
            previous = normal[:]
            normal[:] = [_narrow(v) for v in normal]
            maximum_normal_change = max(maximum_normal_change, math.dist(previous, normal))
        rebuilt += len(output)
    return {"vertices": rebuilt, "maximumUVChange": maximum_change,
            "UVCompiler": "rendserv1001e450 source-f64 interpolation then f32 endpoint coefficients",
            "maximumPositionDecimalRecoveryMetres": maximum_position_change,
            "maximumNormalDecimalRecovery": maximum_normal_change}


def _boundary_lateral(segment, boundary, t, world, delta=0.0):
    start, end = boundary.lateral_start + delta, boundary.lateral_end + delta
    if getattr(boundary, "boundary_mode", 0) == 0:
        return _lerp(start, end, t)
    if boundary.boundary_mode != 1:
        raise FormatError("unsupported PTF boundary_mode %d" % boundary.boundary_mode)
    # Mode 1 authors a straight world chord between offset endpoints. Project
    # its point into the original runtime's tangent/lateral basis at this t.
    ax = segment.pos_a - math.sin(segment.angle_c) * start
    ay = segment.pos_b + math.cos(segment.angle_c) * start
    bx = segment.pos_d - math.sin(segment.angle_f) * end
    by = segment.pos_e + math.cos(segment.angle_f) * end
    return (_lerp(ax, bx, t) - world["x"]) * -world["ty"] + (_lerp(ay, by, t) - world["y"]) * world["tx"]


def _new_geometry(name, appearance, source):
    if appearance is None or appearance.cls != "Appearance":
        raise FormatError("rendered PTF face lacks authored Appearance")
    return {"name": name, "material": scene._material(appearance, False),
            "positions": [], "normals": [], "uvs": [], "tris": [], "source": source}


def _append_quad(geometry, positions, normals, uvs):
    base = len(geometry["positions"])
    geometry["positions"].extend(positions)
    geometry["uvs"].extend(uvs)
    tris = [(0, 1, 2), (2, 1, 3)]
    if normals is None:
        normal = _normal(positions[0], positions[1], positions[2])
        normals = [normal] * 4
    else:
        normal = _normal(positions[0], positions[1], positions[2])
        if sum(normal[i] * normals[0][i] for i in range(3)) < 0:
            tris = [(c, b, a) for a, b, c in tris]
    geometry["normals"].extend(normals)
    for tri in tris:
        a, b, c = (positions[x] for x in tri)
        area2 = sum(x * x for x in [
            (b[1] - a[1]) * (c[2] - a[2]) - (b[2] - a[2]) * (c[1] - a[1]),
            (b[2] - a[2]) * (c[0] - a[0]) - (b[0] - a[0]) * (c[2] - a[2]),
            (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0]),
        ])
        if area2 > 1e-16:
            geometry["tris"].append([base + x for x in tri])


def _refine_terrain(specs, queries, query_index, samples, sample_many, tolerance, terrain_tolerance):
    """Audit actual triangle interpolation; refine failures using original samples.

    Seven locations per quad cover both triangle centroids and all five distinct
    triangle-edge midpoints. This is a sampled accuracy criterion, not a proof
    of a uniform error bound between samples. All source x/y/z use float32
    requests, exactly the runtime query boundary.
    """
    driving_codes = {1, 2, 3, 9, 12}
    weights = ((.5, .5, 0, 0), (0, .5, 0, .5), (0, 0, .5, .5), (.5, 0, .5, 0),
               (0, .5, .5, 0), (1 / 3, 1 / 3, 1 / 3, 0), (0, 1 / 3, 1 / 3, 1 / 3))
    def point_id(coords):
        coords = tuple(_narrow(v) for v in coords)
        if coords not in query_index:
            query_index[coords] = len(queries)
            queries.append(coords)
        return query_index[coords]
    def fetch_pending():
        if len(samples) < len(queries):
            new = sample_many(queries[len(samples):])
            if len(new) != len(queries) - len(samples):
                raise FormatError("original sampler returned incorrect adaptive sample count")
            samples.extend(new)
    def audits(spec):
        _, ids, _ = spec
        return [point_id([sum(w[i] * queries[ids[i]][k] for i in range(4)) for k in range(2)]) for w in weights]
    def errors(spec, ids):
        _, vertices, _ = spec
        out = []
        for weights_at_point, query_id in zip(weights, ids):
            original = samples[query_id]
            interpolated = [sum(weights_at_point[i] * samples[vertices[i]][k] for i in range(4)) for k in ("x", "y", "z")]
            delta = [interpolated[i] - original[k] for i, k in enumerate(("x", "y", "z"))]
            out.append({"distance": math.sqrt(sum(x * x for x in delta)), "vertical": abs(delta[2]),
                        "dlong": queries[query_id][0], "dlat": queries[query_id][1],
                        "geometry": spec[0]["name"], "surfaceCode": spec[0]["source"]["surfaceCode"]})
        return out
    def worst(records):
        return max(records, key=lambda e: e["distance"]) if records else None

    initial_count = len(specs)
    audit_ids = [audits(spec) for spec in specs]
    fetch_pending()
    initial_errors = [e for spec, ids in zip(specs, audit_ids) for e in errors(spec, ids)]
    initial_driving = [e for spec, ids in zip(specs, audit_ids) if spec[0]["source"]["surfaceCode"] in driving_codes
                       for e in errors(spec, ids)]
    road = list(zip(specs, audit_ids))
    stable, stable_errors = [], []
    rounds = 0
    for rounds in range(10):
        failed = []
        for spec, ids in road:
            checked = errors(spec, ids)
            threshold = tolerance if spec[0]["source"]["surfaceCode"] in driving_codes else terrain_tolerance
            if max(e["distance"] for e in checked) <= threshold:
                stable.append(spec)
                stable_errors.extend(checked)
            else:
                failed.append(spec)
        if not failed:
            break
        print("Adaptive terrain pass %d: refining %d quads" % (rounds + 1, len(failed)), file=sys.stderr, flush=True)
        refined = []
        for geometry, vertices, uvs in failed:
            def mid(a, b):
                return point_id([(queries[vertices[a]][k] + queries[vertices[b]][k]) * .5 for k in range(2)])
            m01, m02, m13, m23 = mid(0, 1), mid(0, 2), mid(1, 3), mid(2, 3)
            center = point_id([sum(queries[q][k] for q in vertices) * .25 for k in range(2)])
            def uv_mid(a, b):
                return [(uvs[a][k] + uvs[b][k]) * .5 for k in range(2)]
            uv01, uv02, uv13, uv23 = uv_mid(0, 1), uv_mid(0, 2), uv_mid(1, 3), uv_mid(2, 3)
            uvc = [sum(v[k] for v in uvs) * .25 for k in range(2)]
            refined.extend([
                (geometry, [vertices[0], m01, m02, center], [uvs[0], uv01, uv02, uvc]),
                (geometry, [m01, vertices[1], center, m13], [uv01, uvs[1], uvc, uv13]),
                (geometry, [m02, center, vertices[2], m23], [uv02, uvc, uvs[2], uv23]),
                (geometry, [center, m13, m23, vertices[3]], [uvc, uv13, uv23, uvs[3]]),
            ])
        road = [(spec, audits(spec)) for spec in refined]
        fetch_pending()
    else:
        raise FormatError("visual refinement did not reach road %.6g m / terrain %.6g m sampled tolerances in 10 passes" % (tolerance, terrain_tolerance))
    driving_errors = [e for e in stable_errors if e["surfaceCode"] in driving_codes]
    final_driving = worst(driving_errors)
    final_central = worst([e for e in driving_errors if abs(e["dlat"]) <= 25])
    if final_driving and final_driving["distance"] > tolerance:
        raise FormatError("road visual accuracy exceeds requested sampled tolerance")
    def lateral_span(spec):
        return max(abs(queries[spec[1][2]][1] - queries[spec[1][0]][1]),
                   abs(queries[spec[1][3]][1] - queries[spec[1][1]][1]))
    return stable, {
        "criterion": "original005150fa vs mesh-linear interpolation at 5 triangle-edge midpoints and 2 triangle centroids per quad",
        "scope": "all authored terrain; driving surface codes1,2,3,9,12; central driving subset |dlat|<=25m",
        "toleranceMetres": tolerance, "terrainToleranceMetres": terrain_tolerance,
        "initialQuads": initial_count, "finalQuads": len(stable),
        "refinementPasses": rounds, "checkedDrivingPoints": len(driving_errors), "checkedTerrainPoints": len(stable_errors),
        "initialWorstTerrain": worst(initial_errors), "initialWorstDriving": worst(initial_driving),
        "finalWorstDriving": final_driving, "finalWorstCentralDriving": final_central,
        "finalWorstTerrain": worst(stable_errors),
        "finalWorstDrivingVertical": max(driving_errors, key=lambda e: e["vertical"]) if driving_errors else None,
        "initialWidestQuadMetres": max(map(lateral_span, specs)),
        "finalWidestDrivingQuadMetres": max(lateral_span(spec) for spec in stable if spec[0]["source"]["surfaceCode"] in driving_codes),
        "limitation": "sampled criterion does not establish a uniform bound between checks; original collision continues to use the continuous recovered runtime",
    }


def build_surfaces(root, section_spans, sample_many, max_step=2.0, road_tolerance=0.002, terrain_tolerance=0.002,
                   existing_terrain=None, existing_recovery=None, project_world_many=None):
    """Generate authored terrain and standard wall faces over ORIGINAL queries.

    section_spans: original loaded records {index,kind,start,length} in PTF order.
    sample_many: callable([(dlong,dlat),...]) -> list of dictionaries containing
    x,y,z,nx,ny,nz,tx,ty from ORIGINAL 005150fa. It must raise on query failures.
    No Roblox raycasts or replacement contact mathematics enter this function.

    The finite visual tessellation is distinct from the continuous collision
    runtime. Software rendserv wall compiler 10020bf0 ignores W's profile
    payload, while the primary DirectX backend consumes it in 10047350.
    UVs interpolate the four authored corners; original seam stitching and
    TrackDetail overlays still require renderer recovery.
    """
    if max_step <= 0 or road_tolerance <= 0 or terrain_tolerance <= 0:
        raise ValueError("visual step and tolerances must be positive")
    if len(section_spans) != len(root.segments):
        raise FormatError("original runtime section count differs from PTF")
    stations = []
    centers_queries = []
    custom_wall_handles = []
    invalid_wall_uvs = set()
    wall_profile_transitions = set()
    wall_cap_count = 0
    for index, (segment, span) in enumerate(zip(root.segments, section_spans)):
        if span["index"] != index or segment.segment_kind == -1:
            raise FormatError("PTF/runtime section ordering mismatch at %d" % index)
        if span["length"] <= 0 or len(segment.x_sections) < 2:
            raise FormatError("section %d lacks a positive span or authored profile" % index)
        turn = (segment.angle_f - segment.angle_c + math.pi) % (2 * math.pi) - math.pi
        subdivisions = max(1, math.ceil(span["length"] / max_step), math.ceil(abs(turn) / .01))
        times = {k / subdivisions for k in range(subdivisions + 1)}
        # Every material/profile crossing becomes a station. Between these
        # stations a lateral strip has a stable set of profile boundaries.
        for x in segment.x_sections:
            for f in segment.f_sections:
                if getattr(f, "boundary_mode", 0) != 0:
                    continue
                a = x.lateral_start - f.lateral_start
                b = x.lateral_end - f.lateral_end
                if a * b < 0:
                    times.add(a / (a - b))
        for wall in segment.w_sections:
            if wall.wall_profile_kind:
                custom_wall_handles.append(wall.handle)
            for record in wall.records:
                t = record["longitudinal_position"]
                if not 0 <= t <= 1:
                    raise FormatError("wall record station outside [0,1]")
                times.add(t)
        rows = []
        for t in sorted(times):
            dlong = _lerp(span["start"], span["start"] + span["length"], t)
            # Runtime cumulative station is authoritative at shared endpoints.
            if t == 1 and index + 1 < len(section_spans):
                dlong = section_spans[index + 1]["start"]
            rows.append({"t": t, "dlong": dlong, "query": len(centers_queries)})
            centers_queries.append((dlong, 0.0))
        stations.append(rows)
    center_samples = sample_many(centers_queries)
    if len(center_samples) != len(centers_queries):
        raise FormatError("original sampler returned incorrect center sample count")
    for rows in stations:
        for row in rows:
            row["world"] = center_samples[row["query"]]

    queries, query_index = [], {}
    terrain_specs, wall_specs = [], []
    profile_specs = []
    dxg_profiles = {}
    def query(row, lateral):
        key = (_narrow(row["dlong"]), _narrow(lateral))
        if key not in query_index:
            query_index[key] = len(queries)
            queries.append(key)
        return query_index[key]

    terrain_buckets, wall_buckets = {}, {}
    if existing_terrain is not None:
        terrain_buckets = {g["name"]: g for g in existing_terrain if g["source"].get("sourceClass") != "TrackDetail"}
    for index, segment in enumerate(root.segments):
        rows = stations[index]
        for fi, (f, next_f) in enumerate(zip(segment.f_sections, segment.f_sections[1:])):
            if existing_terrain is not None:
                break
            if f.x_section is None:
                continue                         # untextured/sentinel source: no invented appearance
            geometry = _new_geometry("terrain_%03d_%02d" % (index, fi), f.x_section,
                                     {"segment": index, "descriptor": f.handle, "surfaceCode": f.surface_code,
                                      "queryTag": f.query_tag, "uvMethod": "authoredFourCornerBilinear"})
            terrain_buckets[(index, fi)] = geometry
            for a, b in zip(rows, rows[1:]):
                t0, t1 = a["t"], b["t"]
                lo0 = _boundary_lateral(segment, f, t0, a["world"])
                lo1 = _boundary_lateral(segment, f, t1, b["world"])
                hi0 = _boundary_lateral(segment, next_f, t0, a["world"])
                hi1 = _boundary_lateral(segment, next_f, t1, b["world"])
                if hi0 <= lo0 or hi1 <= lo1:
                    continue
                bounds = [(lo0, lo1), (hi0, hi1)]
                for x in segment.x_sections:
                    x0, x1 = _lerp(x.lateral_start, x.lateral_end, t0), _lerp(x.lateral_start, x.lateral_end, t1)
                    if lo0 < x0 < hi0 or lo1 < x1 < hi1:
                        bounds.append((min(hi0, max(lo0, x0)), min(hi1, max(lo1, x1))))
                bounds = sorted(set(bounds), key=lambda v: sum(v))
                for left, right in zip(bounds, bounds[1:]):
                    q = [query(a, left[0]), query(b, left[1]), query(a, right[0]), query(b, right[1])]
                    fractions = [(left[0] - lo0) / (hi0 - lo0), (left[1] - lo1) / (hi1 - lo1),
                                 (right[0] - lo0) / (hi0 - lo0), (right[1] - lo1) / (hi1 - lo1)]
                    uvs = [_uv(f.w_section, t, frac) for t, frac in zip((t0, t1, t0, t1), fractions)]
                    terrain_specs.append((geometry, q, uvs))

        for wi, wall in enumerate(segment.w_sections):
            if not wall.records:
                continue
            profile = render_recovery.dxg_wall_profile(wall)
            if profile:
                dxg_profiles[wall.handle] = profile
                wall = copy.copy(wall)
                wall.height_start, wall.height_end = profile["lowerHeightStart"], profile["lowerHeightEnd"]
            top_params = [render_recovery.wall_top_parameters(segment, wall, side) for side in (-1, 1)]
            for side, parameters in zip((-1, 1), top_params):
                if parameters["requiresProfileTransition"]:
                    wall_profile_transitions.add((wall.handle, side))
            top_boundaries = [SimpleNamespace(lateral_start=p["lateralStart"], lateral_end=p["lateralEnd"],
                                              boundary_mode=wall.boundary_mode) for p in top_params]
            def source_profile_uv(coords, face):
                if not profile or face not in (0, 2):
                    return coords
                coords = copy.copy(coords)
                coords.channels = list(coords.channels)
                start, end = profile["baseUVFractionStart"], profile["baseUVFractionEnd"]
                for channel in (1, 5, 9, 13, 17, 21):
                    if coords.channels[channel] is not None:
                        coords.channels[channel] = [1.0, 1.0, end, start] if face == 0 else [start, end, 1.0, 1.0]
                return coords
            def wall_queries(a, b):
                times = (a["t"], b["t"])
                widths = [_lerp(wall.visual_face_offset_start, wall.visual_face_offset_end, t) for t in times]
                lat = [_boundary_lateral(segment, wall, t, row["world"]) for t, row in zip(times, (a, b))]
                indices = [query(a, lat[0] - widths[0]), query(b, lat[1] - widths[1]),
                           query(a, lat[0] + widths[0]), query(b, lat[1] + widths[1])]
                verticals = []
                for boundary, parameters in zip(top_boundaries, top_params):
                    for t, row in zip(times, (a, b)):
                        indices.append(query(row, _boundary_lateral(segment, boundary, t, row["world"])))
                        # 1001dd20 adds endpoint offsets without changing slope:
                        # the offset follows the cubic Hermite zero-slope blend.
                        verticals.append(_lerp(parameters["verticalOffsetStart"], parameters["verticalOffsetEnd"],
                                               t * t * (3.0 - 2.0 * t)))
                return indices, verticals
            for a, b in zip(rows, rows[1:]):
                t0, t1 = a["t"], b["t"]
                mid = (t0 + t1) * .5
                ri = max((k for k, r in enumerate(wall.records) if r["longitudinal_position"] <= mid), default=0)
                record = wall.records[ri]
                range_start = record["longitudinal_position"]
                range_end = wall.records[ri + 1]["longitudinal_position"] if ri + 1 < len(wall.records) else 1.0
                if range_end <= range_start:
                    raise FormatError("wall record span is not positive")
                q0, q1 = (t0 - range_start) / (range_end - range_start), (t1 - range_start) / (range_end - range_start)
                samples, verticals = wall_queries(a, b)
                for face, order, across in ((0, (0, 1, 4, 5), (0, 0, 1, 1)),
                                            (1, (4, 5, 6, 7), (0, 0, 1, 1)),
                                            (2, (3, 2, 7, 6), (1, 1, 0, 0))):
                    pair = record["inner"][face]
                    if pair["child_a"] is None:
                        continue
                    coords = pair["child_b"]
                    coords = source_profile_uv(coords, face)
                    invalid_uv = coords is not None and any(not math.isfinite(v) for ch in coords.channels[:2] if ch for v in ch)
                    if invalid_uv:
                        invalid_wall_uvs.add((wall.handle, ri, face))
                    key = (index, wi, ri, face)
                    if key not in wall_buckets:
                        wall_buckets[key] = _new_geometry("wall_%03d_%02d_%02d_%d" % key, pair["child_a"],
                            {"segment": index, "descriptor": wall.handle, "surfaceCode": wall.surface_code,
                             "queryTag": wall.query_tag, "face": face, "record": ri,
                             "heightOffsetMode": wall.height_offset_mode,
                             "bankNormal": wall.height_offset_mode == 0,
                             "topParameters": top_params, "sourceWallCompiler": "rendserv10021340/1001cf60/1001dd20",
                             "dxgProfile": profile,
                             "uvMethod": "rendserv1001e450Float32UVEndpointCoefficients"})
                        if invalid_uv:
                            wall_buckets[key]["material"]["textures"] = []
                            wall_buckets[key]["source"].update(
                                rawUVBits=[[struct.pack("<d", v).hex() for v in ch] if ch else None for ch in coords.channels[:2]],
                                invalidUVRendering="untextured original appearance constants because original sampler NaN is undefined")
                    times = (q1, q0, q1, q0) if face == 2 else (q0, q1, q0, q1)
                    uvs = [[0.0, 0.0]] * 4 if invalid_uv else [_uv(coords, t, frac) for t, frac in zip(times, across)]
                    wall_specs.append((wall_buckets[key], samples, verticals, order, uvs))
                if profile:
                    for side_index, (side, face) in enumerate(((-1, 0), (1, 2))):
                        pair = record["inner"][face]
                        if pair["child_a"] is None:
                            continue
                        previous_parameters = top_params[side_index]
                        previous_uv_start, previous_uv_end = profile["baseUVFractionStart"], profile["baseUVFractionEnd"]
                        for band, point in enumerate(profile["points"]):
                            level = copy.copy(wall)
                            level.lateral_start = _narrow(wall.lateral_start + point["lateral"])
                            level.lateral_end = _narrow(wall.lateral_end + point["lateral"])
                            level.height_start = _narrow(wall.height_start + point["height"])
                            level.height_end = _narrow(wall.height_end + point["height"])
                            upper = render_recovery.wall_top_parameters(segment, level, side)
                            key = (index, wi, ri, face, band)
                            if key not in wall_buckets:
                                wall_buckets[key] = _new_geometry("wall_profile_%03d_%02d_%02d_%d_%d" % key, pair["child_a"],
                                    {"segment": index, "descriptor": wall.handle, "surfaceCode": wall.surface_code,
                                     "queryTag": wall.query_tag, "face": face, "record": ri, "profileBand": band,
                                     "sourceWallCompiler": "rend_dxg10047350/10048b40", "dxgProfile": profile})
                            indices, offsets, uvs = [], [], []
                            parameters_at_level = (previous_parameters, upper)
                            for params, (v_start, v_end) in zip(parameters_at_level,
                                ((previous_uv_start, previous_uv_end), (point["uvFractionStart"], point["uvFractionEnd"]))):
                                boundary = SimpleNamespace(lateral_start=params["lateralStart"], lateral_end=params["lateralEnd"], boundary_mode=wall.boundary_mode)
                                for row, qtime in ((a, q0), (b, q1)):
                                    t = row["t"]
                                    indices.append(query(row, _boundary_lateral(segment, boundary, t, row["world"])))
                                    offsets.append(_lerp(params["verticalOffsetStart"], params["verticalOffsetEnd"], t * t * (3 - 2 * t)))
                                    u = _uv(pair["child_b"], qtime, 1 if face == 0 else 0)[0]
                                    uvs.append([u, _narrow(_lerp(v_start, v_end, t))])
                            if face == 2:
                                indices = [indices[k] for k in (1, 0, 3, 2)]
                                offsets = [offsets[k] for k in (1, 0, 3, 2)]
                                uvs = [uvs[k] for k in (1, 0, 3, 2)]
                            profile_specs.append((wall_buckets[key], indices, offsets, uvs))
                            previous_parameters, previous_uv_start, previous_uv_end = upper, point["uvFractionStart"], point["uvFractionEnd"]
                    left_pair, right_pair = record["inner"][0], record["inner"][2]
                    if left_pair["child_a"] is not None and right_pair["child_a"] is not None:
                        point = profile["points"][-1]
                        level = copy.copy(wall)
                        level.lateral_start = _narrow(wall.lateral_start + point["lateral"])
                        level.lateral_end = _narrow(wall.lateral_end + point["lateral"])
                        level.height_start = _narrow(wall.height_start + point["height"])
                        level.height_end = _narrow(wall.height_end + point["height"])
                        key = (index, wi, ri, "profile_top")
                        if key not in wall_buckets:
                            wall_buckets[key] = _new_geometry("wall_profile_top_%03d_%02d_%02d" % (index, wi, ri), left_pair["child_a"],
                                {"segment": index, "descriptor": wall.handle, "surfaceCode": wall.surface_code,
                                 "queryTag": wall.query_tag, "face": "profileTopBridge", "record": ri,
                                 "sourceWallCompiler": "rend_dxg10049430/10048b40",
                                 "secondaryAppearance": scene._material(right_pair["child_a"], False)})
                        indices, offsets, uvs = [], [], []
                        for side, pair, across in ((-1, left_pair, 1), (1, right_pair, 0)):
                            params = render_recovery.wall_top_parameters(segment, level, side)
                            boundary = SimpleNamespace(lateral_start=params["lateralStart"], lateral_end=params["lateralEnd"], boundary_mode=wall.boundary_mode)
                            for row, qtime in ((a, q0), (b, q1)):
                                t = row["t"]
                                indices.append(query(row, _boundary_lateral(segment, boundary, t, row["world"])))
                                offsets.append(_lerp(params["verticalOffsetStart"], params["verticalOffsetEnd"], t * t * (3 - 2 * t)))
                                uvs.append([_uv(pair["child_b"], qtime, across)[0], _narrow(_lerp(point["uvFractionStart"], point["uvFractionEnd"], t))])
                        profile_specs.append((wall_buckets[key], indices, offsets, uvs))
            for cap in render_recovery.wall_cap_sources(wall):
                row = rows[0] if cap["endpoint"] == 0 else rows[-1]
                samples, verticals = wall_queries(row, row)
                geometry = _new_geometry("wall_cap_%03d_%02d_%d" % (index, wi, cap["face"]), cap["appearance"],
                    {"segment": index, "descriptor": wall.handle, "surfaceCode": wall.surface_code,
                     "queryTag": wall.query_tag, "face": cap["face"], "record": cap["record"],
                     "heightOffsetMode": wall.height_offset_mode, "bankNormal": wall.height_offset_mode == 0,
                     "sourceWallCompiler": "rendserv10020bf0/1001e530", "topParameters": top_params,
                     "uvMethod": "authoredWallCapFourCornersFloat32"})
                coords = cap["coords"]
                corner_order = (3, 0, 2, 1) if cap["endpoint"] == 0 else (0, 3, 1, 2)
                uvs = [[_narrow(coords.channels[0][k]) if coords and coords.channels[0] else 0.0,
                        _narrow(coords.channels[1][k]) if coords and coords.channels[1] else 0.0] for k in corner_order]
                if not coords or not coords.channels[0] or not coords.channels[1]:
                    geometry["source"]["baseUVChannelAbsent"] = True
                if coords and coords.channels[16] and coords.channels[17]:
                    geometry["source"]["secondaryUVs16_17"] = [[_narrow(coords.channels[16][k]), _narrow(coords.channels[17][k])] for k in corner_order]
                key = (index, wi, cap["record"], cap["face"])
                wall_buckets[key] = geometry
                order = (2, 0, 6, 4) if cap["endpoint"] == 0 else (0, 2, 4, 6)
                wall_specs.append((geometry, samples, verticals, order, uvs))
                wall_cap_count += 1

    samples = sample_many(queries)
    if len(samples) != len(queries):
        raise FormatError("original sampler returned incorrect vertex sample count")
    uv_rebase = None
    if existing_terrain is None:
        terrain_specs, visual_accuracy = _refine_terrain(terrain_specs, queries, query_index, samples, sample_many, road_tolerance, terrain_tolerance)
    else:
        visual_accuracy = existing_recovery["visualAccuracy"]
        if visual_accuracy["toleranceMetres"] > road_tolerance or visual_accuracy["terrainToleranceMetres"] > terrain_tolerance:
            raise FormatError("reused terrain does not meet requested visual tolerances")
        uv_rebase = rebase_terrain_uvs(list(terrain_buckets.values()), root)
        visual_accuracy = dict(visual_accuracy)
        visual_accuracy["nativeFloat32DecimalRecoveryBoundMetres"] = 2 * uv_rebase["maximumPositionDecimalRecoveryMetres"]
        visual_accuracy["auditStorage"] = "legacy nine-digit decimal audit; corrected native-f32 vertex displacement bounded by the reported decimal recovery bound"
    for geometry, indices, uvs in terrain_specs:
        selected = [samples[k] for k in indices]
        _append_quad(geometry, [[s[k] for k in ("x", "y", "z")] for s in selected],
                     [[s[k] for k in ("nx", "ny", "nz")] for s in selected], uvs)
    for geometry, indices, verticals, order, uvs in wall_specs:
        selected = [samples[k] for k in indices]
        positions = [[s[k] for k in ("x", "y", "z")] for s in selected]
        for i, vertical in enumerate(verticals):
            positions[4 + i][2] = _narrow(positions[4 + i][2] + vertical)
        _append_quad(geometry, [positions[k] for k in order], None, uvs)
    for geometry, indices, offsets, uvs in profile_specs:
        positions = [[samples[q][key] for key in ("x", "y", "z")] for q in indices]
        for position, offset in zip(positions, offsets):
            position[2] = _narrow(position[2] + offset)
        _append_quad(geometry, positions, None, uvs)
    if project_world_many is None:
        project_world_many = getattr(sample_many, "project_world", None)
    if project_world_many is None:
        raise FormatError("TrackDetail export requires the original world-projection callback")
    details, detail_recovery = render_recovery.build_track_details(root, sample_many, project_world_many)
    for detail in details:
        terrain_buckets[detail["name"]] = detail
    limitations = [
        "Visual meshes use finite tessellation (maximum centerline step %.6g m); contact uses the original continuous runtime." % max_step,
        "Texture stages beyond the recovered base/lightmap pass and original X-section seam triangulation are retained as descriptors; the exporter uses the recovered continuous surface for mesh geometry.",
    ]
    if wall_profile_transitions:
        limitations.append("%d wall boundary sides cross different endpoint X-profile chords; shifted ground uses the original continuous query, while the native renderer boundary-transition compiler is not yet lifted." % len(wall_profile_transitions))
    if invalid_wall_uvs:
        limitations.append("%d authored wall faces contain nonfinite UV coordinates copied unchanged by rendserv 1001e530; raw bits retained, geometry exported with the original constant appearance colors and unused finite UVs because the original texture sampler result is undefined." % len(invalid_wall_uvs))
    return {"terrain": [g for g in terrain_buckets.values() if g["tris"]],
            "walls": [g for g in wall_buckets.values() if g["tris"]], "placements": placements(root),
            "limitations": limitations,
            "recovery": {"positionSampler": "NR2003.exe 005150fa ORIGINAL lifted code",
                         "ptfSHA256": getattr(root, "_source_sha256", None),
                         "coordinateSystem": "NR2003 metres X/Y horizontal Z up",
                         "centerSamples": len(centers_queries), "vertexSamples": len(queries),
                         "visualAccuracy": visual_accuracy,
                         "reusedTerrainUVRebase": uv_rebase,
                         "trackDetails": detail_recovery, "wallCaps": wall_cap_count,
                         "wallProfileTransitionSides": sorted(wall_profile_transitions),
                         "customWallDescriptorHandles": custom_wall_handles,
                         "customWallProfilePolicy": "DirectX10047350/10048b40 cubic profile extrusion and arc-length UV mapping; all three serialized profile kinds verified against ORIGINAL10047350 in Unicorn",
                         "dxgProfiles": dxg_profiles,
                         "nonfiniteUVWallFaces": sorted(invalid_wall_uvs),
                         "surfaceCodes": sorted({f.surface_code for seg in root.segments for f in seg.f_sections}),
                         "wallSurfaceCodes": sorted({w.surface_code for seg in root.segments for w in seg.w_sections})}}


def original_section_spans(repo):
    """Read spans from the ORIGINAL loaded memory image, without rebuilding arcs."""
    repo = Path(repo)
    image = (repo / "core/NR2003Cup/NR2003CupImage1.lua").read_text()
    match = re.search(r"return\s*\{base=(\d+)", image)
    if not match:
        raise FormatError("cannot determine core image base")
    base = int(match.group(1))
    parts = sorted((repo / "watkinsglen_implementation/core/NR2003Cup").glob("NR2003CupTrackData*.lua"))
    if not parts:
        raise FormatError("original loaded TrackData image is missing")
    memory = bytearray(max(int(re.search(r"top=(\d+)", p.read_text()).group(1)) for p in parts))
    for path in parts:
        for offset, data in re.findall(r'\{(\d+),"([A-Za-z0-9+/=]+)"\}', path.read_text()):
            address = base + int(offset)
            payload = base64.b64decode(data, validate=True)
            if address + len(payload) > len(memory):
                raise FormatError("original TrackData image exceeds declared top")
            memory[address:address + len(payload)] = payload
    count = struct.unpack_from("<I", memory, 0xBAD920)[0]
    sections = struct.unpack_from("<I", memory, 0xBCF734)[0]
    if count == 0 or count > 1 << 20 or sections + count * 0x1550 > len(memory):
        raise FormatError("original loaded section array is invalid")
    out = []
    for index in range(count):
        kind, start, length = struct.unpack_from("<Iff", memory, sections + index * 0x1550)
        out.append({"index": index, "kind": kind, "start": start, "length": length})
    return out


class OriginalSampler:
    """Batch bridge to the committed Luau lift; scratch files stay under work/."""
    def __init__(self, repo, luau, work_dir):
        self.repo, self.luau, self.work_dir = Path(repo).resolve(), str(Path(luau).resolve()), Path(work_dir).resolve()
        self.work_dir.mkdir(parents=True, exist_ok=True)
        def module(path):
            rel = Path(os.path.relpath(path, self.work_dir)).as_posix()
            return rel if rel.startswith(".") else "./" + rel
        vehicle = module(self.repo / "core/NR2003CupVehicle")
        car_modules = module(self.repo / "core/NR2003Cup") + "/"
        track_modules = module(self.repo / "watkinsglen_implementation/core/NR2003Cup") + "/"
        helper = """-- Generated sampler bridge; the track mapping is ORIGINAL 005150fa.
local Vehicle = require(%s)
local function get(name)
 for _, d in ipairs({%s,%s}) do
  local ok, m = pcall(require, d .. name)
  if ok then return m end
 end
end
local car = Vehicle.fromLoader(get)
local V = car.V
V.loadTrack()
for _, p in ipairs(require('./world_requests')) do
 local w, dlong, dlat
 if #p == 3 then
  w = V.projectTrackWorld(p[1],p[2],p[3])
  assert(w.valid, 'original world projection failed')
  dlong, dlat = w.dlong, w.dlat
 else
  w = V.trackToWorld(p[1],p[2])
  dlong, dlat = p[1],p[2]
 end
 print(string.format('%%.9g,%%.9g,%%.9g,%%.9g,%%.9g,%%.9g,%%.9g,%%.9g,%%.9g,%%.9g,%%.9g,%%d,%%d,%%d',
  dlong,dlat,w.x,w.y,w.z,w.bumpedZ,w.nx,w.ny,w.nz,w.tx,w.ty,w.surface,w.surfaceMetadata,w.hint))
end
""" % (json.dumps(vehicle), json.dumps(car_modules), json.dumps(track_modules))
        (self.work_dir / "export_world.luau").write_text(helper)
        self.calls = 0

    def __call__(self, queries):
        self.calls += 1
        request = "return {\n" + "".join("{" + ",".join("%.17g" % v for v in q) + "},\n" for q in queries) + "}\n"
        (self.work_dir / "world_requests.luau").write_text(request)
        print("Original track query batch %d: %d points" % (self.calls, len(queries)), file=sys.stderr, flush=True)
        csv_path = self.work_dir / ("samples_%d.csv" % self.calls)
        with csv_path.open("w") as out:
            subprocess.run([self.luau, "-O2", "--codegen", str(self.work_dir / "export_world.luau")],
                           cwd=self.repo, stdout=out, stderr=subprocess.PIPE, text=True, check=True, timeout=240)
        names = ("dlong", "dlat", "x", "y", "z", "bumpedZ", "nx", "ny", "nz", "tx", "ty", "surface", "metadata", "hint")
        result = []
        for line in csv_path.read_text().splitlines():
            fields = line.split(",")
            if len(fields) != len(names):
                raise FormatError("invalid original sampler output: " + line[:120])
            values = list(map(float, fields))
            if not all(map(math.isfinite, values)):
                raise FormatError("nonfinite original sampler output: " + line)
            # %.9g uniquely round-trips source float32. Narrowing is essential:
            # a Python float otherwise retains the decimal text approximation.
            values[:11] = [_narrow(v) for v in values[:11]]
            result.append(dict(zip(names, values)))
        return result

    def project_world(self, points):
        """ORIGINAL 005f58d0/0051370a world-point surface projection."""
        if any(len(p) != 3 for p in points):
            raise ValueError("world projection requires xyz triples")
        return self(points)


def main():
    import argparse
    parser = argparse.ArgumentParser(description=__doc__.split("\n", 1)[0])
    parser.add_argument("ptf", type=Path, help="extracted original .ptf")
    parser.add_argument("--luau", type=Path, required=True, help="Luau CLI with native code generation")
    parser.add_argument("--out", type=Path, required=True, help="geometry JSON for convert_track.py --geometry")
    parser.add_argument("--descriptors", type=Path, help="complete JSON descriptor graph including raw payloads")
    parser.add_argument("--work-dir", type=Path, help="intermediate sampler files (default: repo/work/ptf_geometry)")
    parser.add_argument("--max-step", type=float, default=2.0, help="visual tessellation centerline step in metres")
    parser.add_argument("--road-tolerance", type=float, default=0.002, help="road sampled mesh accuracy in metres")
    parser.add_argument("--terrain-tolerance", type=float, default=0.002, help="runoff/terrain sampled mesh accuracy in metres")
    parser.add_argument("--reuse-terrain", type=Path, help="reuse verified terrain geometry and resample only wall vertices")
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[2]
    root, stream = parse(args.ptf.read_bytes())
    sampler = OriginalSampler(repo, args.luau, args.work_dir or repo / "work/ptf_geometry")
    previous = json.loads(args.reuse_terrain.read_text()) if args.reuse_terrain else None
    if previous and previous["recovery"]["positionSampler"] != "NR2003.exe 005150fa ORIGINAL lifted code":
        raise FormatError("reused terrain was not generated by the original track sampler")
    if previous and previous["recovery"].get("ptfSHA256", root._source_sha256) != root._source_sha256:
        raise FormatError("reused terrain has a different source PTF digest")
    if previous and previous.get("placements") != placements(root):
        raise FormatError("reused terrain has different authored source placements")
    geometry = build_surfaces(root, original_section_spans(repo), sampler, args.max_step, args.road_tolerance, args.terrain_tolerance,
                              previous["terrain"] if previous else None, previous["recovery"] if previous else None)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(geometry, separators=(",", ":"), allow_nan=False))
    if args.descriptors:
        args.descriptors.parent.mkdir(parents=True, exist_ok=True)
        args.descriptors.write_text(json.dumps(descriptor_graph(stream), separators=(",", ":"), allow_nan=False))
    print("Exported %d terrain meshes and %d wall meshes" % (len(geometry["terrain"]), len(geometry["walls"])))


if __name__ == "__main__":
    main()
