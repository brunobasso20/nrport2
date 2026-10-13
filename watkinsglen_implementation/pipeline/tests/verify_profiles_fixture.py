#!/usr/bin/env python3
"""Check Python wall profiles against captured original DXG10047350 float bits."""
import json
from pathlib import Path
import struct
import sys

PIPELINE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PIPELINE))
import ptf
import render_recovery


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: verify_profiles_fixture.py <original watkins_glen.ptf>")
    root, stream = ptf.parse(Path(sys.argv[1]).read_bytes())
    fixtures = json.loads((PIPELINE / "tests/fixtures/dxg_wall_profiles.json").read_text())
    comparisons = 0
    for fixture in fixtures:
        assert fixture["mismatches"] == []
        wall = stream.objects[fixture["wall"]]
        actual = render_recovery.dxg_wall_profile(wall)
        expected = fixture["native"]
        for point, native, uv0, uv1 in zip(actual["points"], expected["points"], expected["uv0"], expected["uv1"]):
            for result, reference in zip((point["lateral"], point["height"], point["arcLength"],
                                          point["uvFractionStart"], point["uvFractionEnd"]), (*native, uv0, uv1)):
                assert struct.pack("<f", result) == struct.pack("<f", reference), (wall.handle, result, reference)
                comparisons += 1
        for result, reference in zip((actual["baseUVFractionStart"], actual["baseUVFractionEnd"]), expected["base"]):
            assert struct.pack("<f", result) == struct.pack("<f", reference)
            comparisons += 1
        for result, reference in zip((actual["lowerHeightStart"], actual["lowerHeightEnd"]), expected["height"]):
            assert struct.pack("<d", result) == struct.pack("<d", reference)
            comparisons += 1
    assert len(fixtures) == 3
    print(json.dumps({"originalProfileTypes": len(fixtures), "numericBitComparisons": comparisons,
                      "float32Comparisons": comparisons-2*len(fixtures), "float64Comparisons": 2*len(fixtures),
                      "mismatches": 0}))


if __name__ == "__main__":
    main()
