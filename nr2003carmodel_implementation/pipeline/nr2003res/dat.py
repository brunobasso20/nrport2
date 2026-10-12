"""Papyrus DAT archive reader (OpenNR-Tools docs/formats/dat.md; NR2003.exe resource system)."""
import os
import struct
from . import dcl


class DatEntry:
    __slots__ = ("flags", "size", "stored", "offset", "name")

    def __init__(self, flags, size, stored, offset, name):
        self.flags, self.size, self.stored, self.offset, self.name = flags, size, stored, offset, name

    @property
    def compressed(self):
        return bool(self.flags & 0x0200)


class DatArchive:
    def __init__(self, path):
        self.path = path
        self.data = open(path, "rb").read()
        self.hash = struct.unpack_from("<I", self.data, 0)[0]
        self.entries = []
        p, toc_end, d = 10, len(self.data), self.data
        while p < toc_end and len(d) - p >= 15:
            flags, usize, csize, doff, nlen = struct.unpack_from("<HIIIB", d, p)
            if not (0 < nlen <= 200 and (flags & 0xF000) == 0 and 10 <= doff <= len(d) and csize <= len(d)):
                break
            name = d[p + 15:p + 15 + nlen]
            if d[p + 15 + nlen] != 0:
                break
            name = name.decode("latin-1")
            if os.path.isabs(name) or ".." in name.replace("\\", "/").split("/"):
                raise ValueError("unsafe entry name %r" % name)
            self.entries.append(DatEntry(flags, usize, csize, doff, name))
            toc_end = min(toc_end, doff)
            p += 16 + nlen
        self.by_name = {e.name.lower(): e for e in self.entries}

    def read(self, entry):
        if isinstance(entry, str):
            entry = self.by_name[entry.lower()]
        raw = self.data[entry.offset:entry.offset + entry.stored]
        if entry.compressed:
            return dcl.decompress(raw, entry.size)
        return raw

    def __contains__(self, name):
        return name.lower() in self.by_name
