"""Update MANIFEST.json for 3.11.1-stage12.1 (version/status fields + sha256 of every package file) and write the list
of new/changed files relative to the Stage 12 manifest (stage12_1_changes.json, used for CHANGED_FILES.txt)."""
import json, hashlib
from pathlib import Path
root = Path(__file__).resolve().parents[1]
man_path = root / 'MANIFEST.json'
man = json.loads(man_path.read_text(encoding='utf-8'))
base_path = root / 'tools/stage12_manifest_files.json'
if man.get('version') == '3.11.0-stage12':
    previous = dict(man['files'])
    base_path.write_text(json.dumps(previous, indent=0) + '\n', encoding='utf-8', newline='\n')
else:
    previous = json.loads(base_path.read_text(encoding='utf-8'))
man['version'] = '3.11.1-stage12.1'
man['completedThroughRoadmapStage'] = 12
man['studioPlayVerified'] = dict(man['studioPlayVerified'], stage12=True, stage12_1=False)
man['nextRoadmapStages'] = [13]
man['stage12']['validation'] = ('automatic PASS (tests/stage12/RESULTS_STAGE12.txt 47/47, tests/stage12/REGRESSION_STAGE12.txt); '
                                'manual Studio validation done by the user (2026-10-11)')
man['stage12_1'] = {
    'base': 'published Stage 12 (3.11.0-stage12, commit b531e60); the Stage 12 deliverables are frozen (tools/build_stage12.py rebuilds them byte for byte)',
    'validation': 'automatic PASS (tests/stage12/run.luau 52/52, adapter mock 66/66, PATCH_STAGE12_1 mock 20/20, regression 6/7-12 unchanged: '
                  'tests/stage12/REGRESSION_STAGE12_1.txt); manual Studio validation pending (VALIDACAO.md, 10 items)',
    'hostOptions': ['lockDegrees: replaces only the x pi constant of the 00551e80 tail (360 / nil = pi_f32, bit for bit the original; other values NOT original)',
                    'cockpitLimit: "original" = 005662d0 limit 2.79 rad, "lock" = the steering lock, or degrees (NOT original)',
                    'momentumKeys / momentumAxis: momentum per input device through the original setter 005500c0 at each frame start (values original, switch per device NOT original)'],
    'benchDefaults': ['CupTune.driver: steeringLockDegrees 360, setupSteeringRatio 12 (garage item 0x30 through the ORIGINAL garage pipeline when Setup_steeringRatio is absent), '
                      'momentumKeys nil (image rate 0.033), momentumAxis 0 (no slew, no sine), cockpitLimit "lock"'],
    'adapter': ['attributes SteeringLockDegrees, SteeringMomentumKeys, SteeringMomentumAxis, CockpitWheelClamp; applied SteeringLockApplied',
                'HUD DIRECAO line: every angle + = right'],
    'deliverables': ['PATCH_STAGE12_1.lua', 'PATCH_STAGE12_1_PART1..2.lua + PATCH_STAGE12_1_INSTALL.lua', 'NR2003_Patch_Stage12_1.rbxmx',
                     'PATCH_STAGE12_1_ROLLBACK.lua'],
}
skip = {'MANIFEST.json', 'tools/stage11_manifest_files.json', 'tools/stage12_changes.json', 'tools/stage12_manifest_files.json',
        'tools/stage12_1_changes.json'}
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
(root / 'tools/stage12_1_changes.json').write_text(json.dumps({'new': new, 'changed': changed, 'removed': removed}, indent=1) + '\n',
                                                    encoding='utf-8', newline='\n')
print('manifest files', len(files), '| new', len(new), 'changed', len(changed), 'removed', len(removed))
for k in changed: print('  changed', k)
print('  new:', new)
print('  removed:', removed)
