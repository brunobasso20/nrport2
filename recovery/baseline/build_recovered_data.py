"""Generate Lua data solely from the included exported memory, not guessed specs."""
import csv
import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TABLES = ROOT / "recovery" / "tables"
COMMIT = "03bcafb44cf63464493f1864edbd9f781fac24f4"

def lua(value):
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=True)
    if isinstance(value, (int, float)):
        return repr(value)
    if isinstance(value, list):
        return "{ " + ", ".join(lua(v) for v in value) + " }"
    if isinstance(value, dict):
        return "{ " + ", ".join("["+lua(k)+"] = "+lua(v) for k, v in value.items()) + " }"
    raise TypeError(value)

blob = (TABLES / "00727290.bin").read_bytes()
count = struct.unpack_from("<I", blob, 0x72c2e0-0x727290)[0]
assert count == 16
components = []
for i in range(count):
    record = blob[i*0x505:(i+1)*0x505]
    name = record[:32].split(b"\0")[0].decode("ascii")
    parent = record[32:64].split(b"\0")[0].decode("ascii")
    fields = {f"0x{offset:02x}": struct.unpack_from("<f", record, offset)[0]
              for offset in [0x44,0x48,0x4c,0x51,0x55,0x59,0x5d,0x61,0x65,0x69]}
    components.append(dict(index=i,address=f"{0x727290+i*0x505:08x}",name=name,
        parentName=parent,flags=struct.unpack_from("<I",record,0x40)[0],
        rawFieldsF32=fields,rawHex=record.hex()))

surface_keys = list(csv.DictReader((TABLES/"surface_defaults.tsv").open(), delimiter="\t", quoting=csv.QUOTE_NONE))
surface_values = struct.unpack("<20f", (TABLES/"006f6570.bin").read_bytes())
surfaces = [dict(index=i,key=r["key"],base=surface_values[i]) for i,r in enumerate(surface_keys)]
track_keys = ["track_tire_wear","track_tire_heat","track_tire_wear_loss","track_tire_wear_exp"]
track_values = struct.unpack("<4f", (TABLES/"0074b9d8.bin").read_bytes())
angle_scale = struct.unpack_from("<f", (TABLES/"006e9700.bin").read_bytes(), 0xf0)[0]
data = dict(sourceCommit=COMMIT,recordBytes=0x505,angleScale=angle_scale,
    components=components,surfaces=surfaces,trackDefaults=dict(zip(track_keys,track_values)))
lines = ["-- Generated from included Ghidra memory exports; embedded pre-setup defaults only.",
    "-- Not a calibrated/drivable car tune. Preserve raw records for future recovery.",
    "return {",f"    sourceCommit = {lua(COMMIT)},", "    recordBytes = 0x505,",
    f"    angleScale = {angle_scale!r},",f"    trackDefaults = {lua(data['trackDefaults'])},",
    "    surfaces = {"]
lines += ["        "+lua(v)+"," for v in surfaces]
lines += ["    },", "    components = {"]
lines += ["        "+lua(v)+"," for v in components]
lines += ["    },", "}"]
(ROOT/"lua"/"RecoveredData.lua").write_text("\n".join(lines)+"\n")
(ROOT/"recovery"/"embedded_baseline.json").write_text(json.dumps(data,indent=2)+"\n")
print(f"Recovered {count} component records, {len(surfaces)} surface factors; angle scale {angle_scale}")
