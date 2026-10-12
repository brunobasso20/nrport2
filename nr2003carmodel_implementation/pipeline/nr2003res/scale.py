"""NR2003 <-> Roblox unit and axis conversion (Python twin of roblox/NR2003Scale.lua; keep both identical).

NR2003 (physics, .3do models, .cam, tracks): right-handed, metres, +X forward, +Y left, +Z up.
Roblox (this port): studs, +X right, +Y up, -Z forward (CupChassisAdapter toLocal: (x, y, z) -> (-y, z, -x)).
METRES_PER_STUD is the bench constant used by every Stage 5-13 module (TestTune.metresPerStud = 0.28); a single
value shared by car, cameras and future tracks keeps original geometry aligned without manual scaling.
"""
METRES_PER_STUD = 0.28


def point(x, y, z, mps=METRES_PER_STUD):
    """NR2003 point (m) -> Roblox (studs)."""
    return (-y / mps, z / mps, -x / mps)


def vector(x, y, z):
    """NR2003 direction -> Roblox direction (no scaling)."""
    return (-y, z, -x)


def rotation(R):
    """Row-major NR2003 3x3 (columns = local axes in parent axes) -> Roblox 3x3 (B R B^T)."""
    r = R
    return (r[4], -r[5], r[3],
            -r[7], r[8], -r[6],
            r[1], -r[2], r[0])
