"""Update MANIFEST.json for 3.11.0-stage12 (version/status fields + sha256 of every package file) and write the list
of new/changed files relative to the Stage 11 manifest (stage12_changes.json, used for CHANGED_FILES.txt)."""
import json, hashlib
from pathlib import Path
root = Path(__file__).resolve().parents[1]
man_path = root / 'MANIFEST.json'
man = json.loads(man_path.read_text(encoding='utf-8'))
base_path = root / 'tools/stage11_manifest_files.json'
if man.get('version') == '3.10.0-stage11':
    previous = dict(man['files'])
    base_path.write_text(json.dumps(previous, indent=0) + '\n', encoding='utf-8', newline='\n')
else:
    previous = json.loads(base_path.read_text(encoding='utf-8'))
man['version'] = '3.11.0-stage12'
man['completedThroughRoadmapStage'] = 12
man['studioPlayVerified'] = {'stage5': True, 'stage6_7': True, 'stage8': True, 'stage9': False, 'stage10': False, 'stage11': False,
                             'stage12': False}
man['nextRoadmapStages'] = [13]
man['stage12'] = {
    'validation': 'automatic PASS (tests/stage12/RESULTS_STAGE12.txt 47/47, tests/stage12/REGRESSION_STAGE12.txt); manual Studio validation pending (VALIDACAO.md, 15 items)',
    'runtime': 'ORIGINAL steering chain hand-ported from x86 (core/NR2003Cup/NR2003CupSteering + NR2003CupDriver frame start / tick lines); '
               'steering mode "original" (production) or "provisional" (Stage 6-11 host road-wheel target, regression suites only)',
    'chain': ['device layer 0057abc0 (HOST): controls 7 left / 8 right, binding type; analog axis split by sign',
              '00552d00 slew + sin shaping (Stage 8 port reused)',
              '00552720 processed input: speed sensitivity through the linearity, arcade yaw limiter (validation only)',
              '00551e80 tail: linearity exponent (analog only), x pi, / 00554fb0 ratio (setup item 0x30, 7:1 below 8.94 m/s, ramp to 17.88 m/s), ramps',
              '005539c0 per-tick ramp + toe -> prescribed hub coordinates (states 15 / 21)',
              'option setters 005502f0 / 005500c0 / 00550110 / 00550210 + controls.cfg conversion (0043f1d0)',
              'cockpit steering-wheel angle 005662d0'],
    'notPorted': ['steering assistance > 0 (track racing line): refused', 'arcade driving mode (race bit 25; chassis spec 0 at build 004233a0): refused',
                  'replay / network quantisation 005beac0', 'force feedback / steering torque (Stage 13)'],
    'integrationChanges': ['NR2003CupDriver: target from the original tail, change record C1 (sign of exact-zero sums), V._frameStartOnly',
                           'NR2003CupVehicle: installs NR2003CupSteering after the garage',
                           'Stage 6-11 suites and self-tests: V.setSteeringMode("provisional")'],
    'adapter': ['keys -> digital controls, gamepad Thumbstick1 -> analog axis, legacy steer = keys',
                'SteeringLinearity / SteeringMomentum / SteeringLowSpeedOverride attributes (+ Setup_steeringRatio)',
                'cockpit wheel = original angle (Cockpit.updateAngle, RenderSnapshot FLAG_WHEEL_ANGLE)',
                'telemetry hubSteerAngle / roadWheelAngle (measured) / steeringWheelAngle / steering; DIRECAO line on the T panel'],
    'docCorrections': ['SETUP_MAP: items 0x3a / 0x9f..0xa4 are the rear differential ramps, not steering; item 0x30 run-time use = Stage 12 ORIGINAL'],
}
skip = {'MANIFEST.json', 'tools/stage11_manifest_files.json', 'tools/stage12_changes.json'}
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
(root / 'tools/stage12_changes.json').write_text(json.dumps({'new': new, 'changed': changed, 'removed': removed}, indent=1) + '\n',
                                                  encoding='utf-8', newline='\n')
print('manifest files', len(files), '| new', len(new), 'changed', len(changed), 'removed', len(removed))
for k in changed: print('  changed', k)
print('  new (non-evidence):', [k for k in new if '/evidence/' not in k and 'fixtures' not in k])
print('  removed:', removed)
