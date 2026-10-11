"""Update MANIFEST.json for 3.10.0-stage11 (version/status fields + sha256 of every package file) and write the list
of new/changed files relative to the Stage 10 manifest (stage11_changes.json, used for CHANGED_FILES.txt)."""
import json, hashlib
from pathlib import Path
root = Path(__file__).resolve().parents[1]
man_path = root / 'MANIFEST.json'
man = json.loads(man_path.read_text(encoding='utf-8'))
base_path = root / 'tools/stage10_manifest_files.json'
if man.get('version') == '3.9.0-stage10':
    previous = dict(man['files'])
    base_path.write_text(json.dumps(previous, indent=0) + '\n', encoding='utf-8', newline='\n')
else:
    previous = json.loads(base_path.read_text(encoding='utf-8'))
man['version'] = '3.10.0-stage11'
man['completedThroughRoadmapStage'] = 11
man['studioPlayVerified'] = {'stage5': True, 'stage6_7': True, 'stage8': True, 'stage9': False, 'stage10': False, 'stage11': False}
man['nextRoadmapStages'] = [12]
man['stage11'] = {
    'validation': 'automatic PASS (tests/stage11/RESULTS_STAGE11.txt); manual Studio validation pending',
    'runtime': 'ORIGINAL frame end 00554520 + collision frame 00549c40 lifted from x86 (216 functions, NR2003CupFrameCode1..4), '
               'image supplement NR2003CupFrameData1, host NR2003CupFrame; runtime mode "original" (production) or "frozen" (Stage 6-10 frame end, regression only)',
    'systems': ['engine thermal / fuel burn / levels / leaks / wear / random failure / power x rho (0051aac0)',
                'fuel mass and inertia -> fuel component record (005605c0)',
                'tyres: 3-zone surface/carcass temperatures, hot pressure, stiffness, wear, grip, blow-out (0054d610 / 0054e9f0)',
                'brake temperature (0054f260; no fade in the exe)',
                'random component failures -> broken flags read by the drivetrain (0051c3d0)',
                'collision damage: zone tree 00433610, body zones, engine damage, leaks, wheel / tyre impacts (00549c40 / 0054a760)'],
    'events': ['collision record 0054a760', 'pit tyre change 00550f10', 'car placed on track 00550a50 subset',
               'race options damage (00547e90) and consumption, random seed'],
    'host': ['getBGCount / getIntCount +1 per frame', 'world record synced from the exported state',
             'one-car race order around 00549c40', 'track-system collision object c7e75c with zeroed parts (PROVISIONAL)',
             'roster series field car+0x596 = 1 (PROVISIONAL)', 'replay / sound / FFB / damage sync = ret'],
    'integrationChanges': ['NR2003CupDriver: V._frameStart11 + switchable frame end', 'NR2003CupVehicle: loads Stage 11 before the garage',
                           'Stage 6-10 suites and self-tests: V.setRuntimeMode("frozen")'],
    'inheritedOpenItem': 'Stage 6/7 runtime lift: exact-zero sums +0 (x87 RC-down: -0); quasi-static creep divergence (overrev)',
    'adapter': ['RaceDamageLevel / RaceConsumptionRate / RosterSeries / RandomSeed / Stage11Runtime attributes',
                'TEST-only DamageTestImpact / PitTyresTest', 'tyre telemetry from the original cells, Stage 11 HUD line'],
}
skip = {'MANIFEST.json', 'tools/stage10_manifest_files.json', 'tools/stage11_changes.json'}
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
(root / 'tools/stage11_changes.json').write_text(json.dumps({'new': new, 'changed': changed, 'removed': removed}, indent=1) + '\n',
                                                  encoding='utf-8', newline='\n')
print('manifest files', len(files), '| new', len(new), 'changed', len(changed), 'removed', len(removed))
for k in changed: print('  changed', k)
print('  new (non-evidence):', [k for k in new if '/evidence/' not in k and 'fixtures' not in k])
print('  removed:', removed)
