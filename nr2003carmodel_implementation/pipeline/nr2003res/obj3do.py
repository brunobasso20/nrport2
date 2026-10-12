"""Papyrus typed object stream (.3do) reader.

Wire format: OpenNR-Tools docs/formats/3do-ptf.md + 3do-ptf-descriptors.md and src/fs/papyrus_descriptors.cpp
(each body cross-referenced there to its NR2003.exe reader, e.g. TransformDescriptor FUN_005e07f0,
PlainVertexList FUN_005e11f0, attribute trailer FUN_005e0c40). Every class used by the NR2003 Cup car files is
read completely (the cursor must land exactly on the next object); an unknown class raises instead of guessing.

Objects become `Node` instances: `cls` (class name without "Descriptor"), `name` (descriptor header name, often
empty), `version`, plus class fields. Shared objects (back references) are the same Python object.
"""
import struct


class FormatError(ValueError):
    pass


class Node:
    def __init__(self, cls, handle):
        self.cls = cls
        self.handle = handle
        self.name = ""
        self.version = 0

    def __repr__(self):
        return "<%s %r #%d>" % (self.cls, self.name, self.handle)


class Stream:
    def __init__(self, data):
        self.d = data
        self.p = 0
        self.objects = {}
        self.classes = {}

    # primitive readers -------------------------------------------------------------------------
    def u8(self):
        v = self.d[self.p]
        self.p += 1
        return v

    def u32(self):
        v = struct.unpack_from("<I", self.d, self.p)[0]
        self.p += 4
        return v

    def i32(self):
        v = struct.unpack_from("<i", self.d, self.p)[0]
        self.p += 4
        return v

    def f32(self):
        v = struct.unpack_from("<f", self.d, self.p)[0]
        self.p += 4
        return v

    def f64(self):
        v = struct.unpack_from("<d", self.d, self.p)[0]
        self.p += 8
        return v

    def f64s(self, n):
        v = struct.unpack_from("<%dd" % n, self.d, self.p)
        self.p += 8 * n
        return list(v)

    def u32s(self, n):
        v = struct.unpack_from("<%dI" % n, self.d, self.p)
        self.p += 4 * n
        return list(v)

    def raw(self, n):
        v = self.d[self.p:self.p + n]
        self.p += n
        return v

    def lp_string(self):
        n = self.u32()
        if n == 0:
            return ""
        b = self.raw(n)
        return b.split(b"\0", 1)[0].decode("latin-1")

    def bbox(self):
        return self.f64s(6)

    # sized arrays (rts.dll transferPointer: u32 allocation size, then the data) ----------------
    def alloc(self, expected, who, allow_zero=False):
        got = self.u32()
        if got != expected and not (allow_zero and got == 0):
            raise FormatError("%s: allocation size %d != %d at 0x%x" % (who, got, expected, self.p - 4))
        return got

    def channel(self, n, who):
        sz = self.u32()
        if sz == 0:
            return None
        if sz != n * 8:
            raise FormatError("%s: channel size %d != %d at 0x%x" % (who, sz, n * 8, self.p - 4))
        return self.f64s(n)

    def u32_channel(self, n, who):
        sz = self.u32()
        if sz == 0:
            return None
        if sz != n * 4:
            raise FormatError("%s: channel size %d != %d" % (who, sz, n * 4))
        return self.u32s(n)

    # objects -------------------------------------------------------------------------------------
    def obj(self):
        h = self.u32()
        if h == 0:
            return None
        if h in self.objects:
            return self.objects[h]
        ch = self.u32()
        if ch == 0:
            raise FormatError("class handle 0 at 0x%x" % (self.p - 4))
        if ch not in self.classes:
            self.classes[ch] = self.lp_string()
        cname = self.classes[ch]
        reader = READERS.get(cname)
        if reader is None:
            raise FormatError("no reader for class %r at 0x%x" % (cname, self.p))
        node = Node(cname[:-len("Descriptor")] if cname.endswith("Descriptor") else cname, h)
        self.objects[h] = node            # registered before the body: shared references and cycles
        node.version = self.u32()         # common descriptor header
        nl = self.u32()
        if nl:
            node.name = self.raw(nl).split(b"\0", 1)[0].decode("latin-1")
        reader(self, node)
        return node


def _transformable(s, n):
    n.flag_a, n.flag_b = s.u32(), s.u32()
    n.bbox = s.bbox()


def r_empty(s, n):
    pass


def r_group(s, n):
    _transformable(s, n)
    n.magic = s.u32()
    cnt = s.u32()
    s.alloc(cnt * 4, "Group")
    n.children = [s.obj() for _ in range(cnt)]


def r_lod(s, n):
    _transformable(s, n)
    n.magic = s.u32()
    cnt = s.u32()
    n.center = s.f64s(3)
    n.enabled = s.u8() if n.magic > 1 else None
    s.alloc(cnt * 8, "LodSwitch distances")
    n.distances = s.f64s(cnt)
    s.alloc(cnt * 4, "LodSwitch children")
    n.children = [s.obj() for _ in range(cnt)]


def r_state(s, n):
    _transformable(s, n)
    n.magic = s.u32()
    n.state_name = s.lp_string()
    n.enabled = s.u8() if n.magic >= 2 else None
    cnt = s.u32()
    n.default = s.f64()
    s.alloc(cnt * 8 + 8, "StateSwitch values")
    n.values = s.f64s(cnt + 1)
    s.alloc(cnt * 4, "StateSwitch children")
    n.children = [s.obj() for _ in range(cnt)]


def r_transform(s, n):
    _transformable(s, n)
    n.magic = s.u32()
    n.translation = s.f64s(3)
    n.rotation = s.f64s(3)            # (yaw/heading, pitch, roll) -- Rz(h) Ry(p) Rx(r), 005f6f20
    n.child = s.obj()


def r_animated(s, n):
    r_transform(s, n)
    n.axis = n.rotation
    n.anim_magic = s.u32()
    n.channel = s.lp_string()
    cnt = s.u32()
    s.alloc(cnt * 32, "AnimatedTransform keys")
    n.keys = []
    for _ in range(cnt):
        t = s.u32()
        q = struct.unpack_from("<4f", s.d, s.p)
        tr = struct.unpack_from("<3f", s.d, s.p + 16)
        s.p += 28
        n.keys.append((t, q, tr))


def r_billboard(s, n):
    _transformable(s, n)
    n.magic = s.u32()
    n.pivot = s.f64s(3)
    n.axis = s.f64s(3)
    n.child = s.obj()


def r_selflight(s, n):
    _transformable(s, n)
    n.magic = s.u32()
    n.diffuse_set, n.specular_set, n.ambient_set = s.u8(), s.u8(), s.u8()
    n.diffuse, n.specular, n.ambient = s.f64s(3), s.f64s(3), s.f64s(3)
    n.child = s.obj()


def r_portal(s, n):
    n.node_magic, n.magic = s.u32(), s.u32()
    n.target = s.obj()
    cnt = s.u32()
    s.alloc(cnt * 4, "Portal")
    n.indices = s.u32s(cnt)


def r_shape(s, n):
    n.node_magic, n.magic = s.u32(), s.u32()
    n.appearance = s.obj()
    n.geometry = s.obj()


def r_geometry(s, n):
    n.magic = s.u32()
    n.vertex_list = s.obj()
    n.primitive = s.obj()


def r_prim(s, n):
    n.flag_a = s.u32()
    n.next = s.obj()
    n.magic = s.u32()
    cnt = s.u32()
    if cnt > 0x4098:
        raise FormatError("primitive index count %d > runtime cap" % cnt)
    s.alloc(cnt * 4, n.cls)
    n.indices = s.u32s(cnt)


def _attributes(s, nv, who, version_gated):
    magic = s.u32()
    if magic > 3:
        raise FormatError("%s: attribute magic %d" % (who, magic))
    count = (24 if magic > 2 else 20) if version_gated else 24
    return magic, [s.channel(nv, who) for _ in range(count)]


def r_pvl(s, n):
    n.type_code, n.flag = s.u32(), s.u32()
    nv = s.i32()
    if nv < 0 or nv > 0x4098:
        raise FormatError("PlainVertexList vertex count %d" % nv)
    n.count = nv
    ch = [s.channel(nv, "PlainVertexList") for _ in range(7)]
    n.position = (ch[0], ch[1], ch[2])
    n.reserved = ch[3]
    n.normal = (ch[4], ch[5], ch[6])
    n.attr_magic, n.attributes = _attributes(s, nv, "PlainVertexList", False)


def r_region_morph(s, n):
    n.parent_magic, n.magic = s.u32(), s.u32()
    nv = s.u32()
    if nv > 0x4098:
        raise FormatError("RegionMorphVertexList vertex count %d" % nv)
    n.count = nv
    ch = [s.channel(nv, "RegionMorphVertexList") for _ in range(8)]
    n.position = (ch[0], ch[1], ch[2])
    n.reserved = ch[3]
    n.normal = (ch[4], ch[5], ch[6])
    n.extra = ch[7]
    n.attr_magic, n.attributes = _attributes(s, nv, "RegionMorphVertexList", True)
    nr = s.u32()
    n.regions = []
    for _ in range(nr):
        name = s.lp_string()
        a, b, cnt = s.u32(), s.u32(), s.u32()
        rch = [s.channel(cnt, "RegionMorph region") for _ in range(8)]
        idx = s.u32_channel(cnt, "RegionMorph region indices")
        n.regions.append({"name": name, "a": a, "b": b, "count": cnt, "channels": rch, "indices": idx})


def r_texture(s, n):
    n.magic = s.u32()
    n.texture = s.lp_string()
    n.flags = s.u8() if n.magic >= 2 else None


def r_appearance(s, n):
    n.magic = s.u32()
    n.textures = [s.obj() for _ in range(6)]
    n.textures.append(s.obj() if n.magic >= 2 else None)
    n.ambient, n.diffuse, n.specular = s.f64s(3), s.f64s(3), s.f64s(3)
    n.shininess, n.reflectivity, n.opacity = s.f64(), s.f64(), s.f64()
    n.envmap_index = s.f32()


READERS = {
    "EmptyDescriptor": r_empty,
    "GroupDescriptor": r_group,
    "LodSwitchDescriptor": r_lod,
    "StateSwitchDescriptor": r_state,
    "TransformDescriptor": r_transform,
    "AnimatedTransformDescriptor": r_animated,
    "BillboardDescriptor": r_billboard,
    "SelfLightingDescriptor": r_selflight,
    "PortalDescriptor": r_portal,
    "ShapeDescriptor": r_shape,
    "GeometryDescriptor": r_geometry,
    "TriListDescriptor": r_prim,
    "TriStripDescriptor": r_prim,
    "TriFanDescriptor": r_prim,
    "PlainVertexListDescriptor": r_pvl,
    "RegionMorphVertexListDescriptor": r_region_morph,
    "TextureDescriptor": r_texture,
    "AppearanceDescriptor": r_appearance,
}


def parse(data):
    """Parse a whole .3do; returns (root, stream). Raises unless the stream is consumed exactly."""
    s = Stream(data)
    root = s.obj()
    if s.p != len(data):
        raise FormatError("trailing %d bytes after the root object" % (len(data) - s.p))
    return root, s


def children(n):
    """Direct scene children of a node, in stream order (None entries kept out)."""
    out = []
    for attr in ("children",):
        out += [c for c in getattr(n, attr, []) or [] if c is not None]
    for attr in ("child",):
        c = getattr(n, attr, None)
        if c is not None:
            out.append(c)
    return out
