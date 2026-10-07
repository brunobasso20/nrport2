"""Run numeric and adapter regressions. This does not execute Roblox Studio."""
from pathlib import Path
import shutil,subprocess,json,hashlib,xml.etree.ElementTree as ET
root=Path(__file__).resolve().parents[1]
runtime=shutil.which('lua5.3') or shutil.which('lua5.4') or shutil.which('lua') or shutil.which('luatex')
if not runtime:raise SystemExit('Install Lua 5.3+ or LuaTeX')
prefix=[runtime]+(['--luaonly'] if Path(runtime).name=='luatex' else [])
tests=['check_syntax','test_baseline','test_physics','test_original_core','test_core_dynamics','test_seat_access','test_stage5','test_render_snapshots']
log=[]
for name in tests:
    r=subprocess.run(prefix+['tests/'+name+'.lua'],cwd=root,text=True,capture_output=True)
    output=r.stdout+r.stderr;log.append('['+name+']\n'+output);print(output,end='',flush=True)
    if r.returncode:raise SystemExit(r.returncode)
for kit,source in [('NR2003_Install','INSTALL_STUDIO.lua'),('NR2003_Patch_Stage5','PATCH_STAGE5.lua')]:
    doc=ET.parse(root/(kit+'.rbxmx'))
    assert doc.find('.//ProtectedString').text=='return function()\n'+(root/source).read_text()+'\nend\n'
fixture=json.loads((root/'tests/fixtures/original_x86.json').read_text())
for name,digest in fixture['metadata']['memorySHA256'].items():
    assert hashlib.sha256((root/'recovery/vehicle_core'/name).read_bytes()).hexdigest()==digest,name
log.append('[package]\nPASS: installer/patch XML match Lua; original memory hashes match\n')
manual=root/'tests/MANUAL_STUDIO_VALIDATION.txt'
if manual.exists():
    log.append(manual.read_text().rstrip()+'\n')
(root/'tests/RESULTS.txt').write_text('\n'.join(log));print(log[-2],end='')
if manual.exists(): print(log[-1],end='')
