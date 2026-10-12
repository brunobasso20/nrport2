"""Papyrus .car container (OpenNR-Tools docs/formats/car.md): CARF { CTYP, CINI, CTEX, CREW }.
CTEX = the car paint (the runtime replacement of the model's card.mip), CREW = pit crew texture; both are MIPs."""
import struct
from .mip import Mip


def _tag(raw):
    return raw[::-1].decode("latin-1")


def chunks(data, p=0, end=None):
    end = len(data) if end is None else end
    while p + 12 <= end:
        tag = _tag(data[p:p + 4])
        size = struct.unpack_from("<I", data, p + 8)[0]
        yield tag, p + 12, size
        p += 12 + size
        while p < end and data[p] == 0x20:
            p += 1


class CarFile:
    def __init__(self, data):
        outer = list(chunks(data))
        if not outer or outer[0][0] != "CARF":
            raise ValueError("not a CARF container")
        _, body, size = outer[0]
        self.parts = {tag: data[o:o + n] for tag, o, n in chunks(data, body, body + size)}
        self.ini = self.parts.get("CINI", b"").decode("latin-1")
        self.type = struct.unpack_from("<I", self.parts["CTYP"])[0] if "CTYP" in self.parts else None

    def texture(self, tag="CTEX"):
        return Mip(self.parts[tag]) if tag in self.parts else None

    def driver(self):
        out, sec = {}, None
        for line in self.ini.splitlines():
            line = line.strip()
            if line.startswith("[") and line.endswith("]"):
                sec = line[1:-1]
            elif "=" in line and sec == "Driver":
                k, v = line.split("=", 1)
                out[k.strip()] = v.strip()
        return out
