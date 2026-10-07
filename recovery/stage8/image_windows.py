"""Memory windows of the Luau core image (core/NR2003Cup/NR2003CupImage*.lua): the exact set of
original memory the Luau runtime owns. Used to diff original builds and to carry original
machine snapshots into the Luau tests."""
import re, base64
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
BASE = 0x6e9000


def windows(root=ROOT):
    out = []
    for p in sorted((root / 'core/NR2003Cup').glob('NR2003CupImage*.lua')):
        for off, b64 in re.findall(r'\{(\d+),"([A-Za-z0-9+/=]*)"\}', p.read_text()):
            data = base64.b64decode(b64)
            out.append((BASE + int(off), data))
    out.sort()
    return out


def read_windows(m, wins):
    return [(a, bytes(m.uc.mem_read(a, len(d)))) for a, d in wins]


def diff(wins_a, wins_b, gran=16):
    """[(address, bytes_b)] chunks (granularity gran) where b differs from a"""
    out = []
    for (a, da), (b, db) in zip(wins_a, wins_b):
        assert a == b and len(da) == len(db)
        for o in range(0, len(da), gran):
            if da[o:o + gran] != db[o:o + gran]:
                if out and out[-1][0] + len(out[-1][1]) == a + o:
                    out[-1] = (out[-1][0], out[-1][1] + db[o:o + gran])
                else:
                    out.append((a + o, db[o:o + gran]))
    return out
