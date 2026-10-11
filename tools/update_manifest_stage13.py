"""Update MANIFEST.json for 3.12.0-stage13 (version/status fields + sha256 of every package file) and write the list
of new/changed files relative to the Stage 12.1 manifest (stage13_changes.json, used for CHANGED_FILES.txt)."""
import json, hashlib
from pathlib import Path
root = Path(__file__).resolve().parents[1]
man_path = root / 'MANIFEST.json'
man = json.loads(man_path.read_text(encoding='utf-8'))
base_path = root / 'tools/stage12_1_manifest_files.json'
if man.get('version') == '3.11.1-stage12.1':
    previous = dict(man['files'])
    base_path.write_text(json.dumps(previous, indent=0) + '\n', encoding='utf-8', newline='\n')
else:
    previous = json.loads(base_path.read_text(encoding='utf-8'))
man['version'] = '3.12.0-stage13'
man['completedThroughRoadmapStage'] = 13
man['studioPlayVerified'] = dict(man['studioPlayVerified'], stage9=True, stage10=True, stage11=True, stage12=True, stage12_1=True,
                                 stage13=False)
man['nextRoadmapStages'] = [14]
man['stage12_1']['validation'] = ('automatic PASS (tests/stage12/run.luau 52/52, adapter mock 66/66, PATCH_STAGE12_1 mock 20/20, regression 6/7-12 '
                                  'unchanged: tests/stage12/REGRESSION_STAGE12_1.txt); manual Studio validation done by the user (informed 2026-10-11); '
                                  'deliverables frozen since Stage 13 (tools/build_stage12_1.py rebuilds them byte for byte from 5d9f5ee)')
man['stage13'] = {
    'base': 'published Stage 12.1 (3.11.1-stage12.1, commit 5d9f5ee); the Stage 12 and 12.1 deliverables are frozen',
    'executableImage': 'OpenNR2003 Ghidra project (github.com/TChapman500/OpenNR2003, owner TChapman500) exported read-only with recovery/ghidra_tools/ExportMemoryPy.py (NR2003_MEM)',
    'original': ['00554d30 per tick (005539c0 @00553a64): front tyre statistics', 'FFB block of the frame end 00554520 (0055464c..0055479d)',
                 '00550070 / 0054fed0 / 00550030 / 00550680: controls suspended (also the 005524f0 gate) and FF effect acquisition',
                 '00550270 / 00550290 / 005502d0 / 005502b0: options of messages 8..11 (controls.cfg integers)',
                 'exact x87 arithmetic (64-bit significand, round toward -inf); the lifted double-model copy of the block is skipped'],
    'adapter': ['device layer (DirectInput): capable / acquire / sink(axis, force, _ftol(force x 10000))', '005f79a0 served directly',
                'control-7 binding type change while FF is on / acquired -> 00550070(0)', 'no driver seated -> 00550070(1)',
                'Roblox output: car attributes FFBForce / FFBMagnitude / FFBActive, HUD line FFB, gamepad large motor |force|'],
    'benchDefaults': ['CupTune.driver: ffbEnabled true with the image values (strength 80, damping 0, latency 0), ffbDevice true, ffbRumble true'],
    'validation': ('automatic PASS (tests/stage13/run.luau 40/40: L1 bit-exact, L2 21168 + 5400 original calls bit-exact, L3 32 Stage 12 restarts, '
                   'L4 7 scenarios in 4x the envelope of 14 twins with identical device-call sequences, L5 7 errors + the double model detected; '
                   'adapter mock 77/77; PATCH_STAGE13 mock 22/22; regression 6/7-12: tests/stage13/REGRESSION_STAGE13.txt); '
                   'manual Studio validation pending (VALIDACAO.md, 10 items)'),
    'deliverables': ['PATCH_STAGE13.lua', 'PATCH_STAGE13_PART1..2.lua + PATCH_STAGE13_INSTALL.lua', 'NR2003_Patch_Stage13.rbxmx',
                     'PATCH_STAGE13_ROLLBACK.lua'],
}
skip = {'MANIFEST.json', 'tools/stage11_manifest_files.json', 'tools/stage12_changes.json', 'tools/stage12_manifest_files.json',
        'tools/stage12_1_changes.json', 'tools/stage12_1_manifest_files.json', 'tools/stage13_changes.json'}
files = {}
for p in sorted(root.rglob('*')):
    if not p.is_file(): continue
    rel = p.relative_to(root).as_posix()
    if rel in skip or '/__pycache__/' in '/' + rel or rel.endswith('.pyc') or rel.startswith('recovery/stage6_7/out/'):
        continue
    if rel.startswith('.git/') or rel.endswith('_diag.luau') or rel.startswith('tests/stage10/_work/'): continue
    if rel.startswith('recovery/stage10/footprint') or rel.endswith('fold_only.pkl'): continue
    if rel.startswith('recovery/stage11/footprint11_') or rel.startswith('recovery/stage11/out/'): continue
    if rel.startswith('tests/stage11/dev/') and rel.endswith('.lua'): continue
    if rel.startswith('recovery/stage12/out/') or rel.endswith('.zip'): continue
    data = p.read_bytes()
    h = hashlib.sha256(data).hexdigest()
    if rel in previous and previous[rel] != h:
        if hashlib.sha256(data.replace(b'\r\n', b'\n')).hexdigest() == previous[rel]:
            h = previous[rel]
    files[rel] = h
man['files'] = files
man['runtimeLuaFiles'] = sum(1 for k in files if (k.startswith('core/') or k.startswith('roblox/')) and k.endswith('.lua'))
man_path.write_text(json.dumps(man, indent=1, ensure_ascii=False) + '\n', encoding='utf-8', newline='\n')
new = sorted(k for k in files if k not in previous)
changed = sorted(k for k in files if k in previous and previous[k] != files[k])
removed = sorted(k for k in previous if k not in files)
(root / 'tools/stage13_changes.json').write_text(json.dumps({'new': new, 'changed': changed, 'removed': removed}, indent=1) + '\n',
                                                    encoding='utf-8', newline='\n')
print('manifest files', len(files), '| new', len(new), 'changed', len(changed), 'removed', len(removed))
for k in changed: print('  changed', k)
print('  new:', new)
print('  removed:', removed)
