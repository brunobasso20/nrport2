"""Exercise the real Roblox adapter against the recovered track, using the existing CLI API mock."""
from pathlib import Path
root=Path(__file__).resolve().parents[2]
paths=['Core.NR2003CupVehicle','Core.CupTune','Core.NR2003FixedStep','Core.NR2003Math','Core.Float32','Core.Surface','Core.RecoveredData','Core.MathUtil','Core.TestTune','Roblox.RenderSnapshot','Roblox.CupChassisAdapter','Roblox.NR2003WatkinsGlen']
body=(root/'tools/adapter_mock_body.luau').read_text().split('local ctl = Adapter.new(car, TestTune, {})')[0]
old='local ok, v = pcall(require, "../../core/NR2003Cup/" .. m)'
body=body.replace(old,old+'\n            if not ok then ok, v = pcall(require, "../core/NR2003Cup/" .. m) end')
def long(s):
    eq='='
    while ']'+eq+']' in s: eq+='='
    return '['+eq+'[\n'+s+']'+eq+']'
text='local SOURCES = {}\n'
for name in paths:
    rel=name.replace('.', '/')+'.lua'
    rel=rel.replace('Core/','core/').replace('Roblox/','roblox/')
    text+=f'SOURCES["{name}"] = {long((root/rel).read_text())}\n'
text+=body+(root/'watkinsglen_implementation/tests/adapter_track_body.luau').read_text()
(root/'watkinsglen_implementation/tests/adapter_track.luau').write_text(text)
