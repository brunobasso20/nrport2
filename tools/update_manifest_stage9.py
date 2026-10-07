"""Update MANIFEST.json for 3.8.0-stage9 (version/status fields + sha256 of every package file) and write
the list of new/changed files relative to the Stage 8 manifest (stage9_changes.json, used for CHANGED_FILES.txt
and the delivery zip)."""
import json, hashlib
from pathlib import Path
root = Path(__file__).resolve().parents[1]
man_path = root / 'MANIFEST.json'
man = json.loads(man_path.read_text(encoding='utf-8'))
previous = dict(man['files']) if man.get('version') == '3.7.0-stage8' else json.loads(
    (root / 'tools/stage8_manifest_files.json').read_text(encoding='utf-8'))
if man.get('version') == '3.7.0-stage8':
    (root / 'tools/stage8_manifest_files.json').write_text(json.dumps(previous, indent=0) + '\n', encoding='utf-8', newline='\n')
man['version'] = '3.8.0-stage9'
man['completedThroughRoadmapStage'] = 9
man['studioPlayVerified'] = {'stage5': True, 'stage6_7': True, 'stage8': True, 'stage9': False}
man['nextRoadmapStages'] = [10]
man['stage8']['validation'] = 'automatic PASS (tests/stage8/RESULTS_STAGE8.txt); manual Studio validation PASS (user, before Stage 9)'
man['stage9'] = {
    'validation': 'automatic PASS (tests/stage9/RESULTS_STAGE9.txt); manual Studio validation pending',
    'finding': 'the original aero natives ran inside the generated core with rho = 0 and factors = 0 (car build alone never runs the session start or the per-frame car update): no aero force before Stage 9',
    'forces': 'original generated 00561a80 + 00561b70 -> 00410280 (curves, angular damping, stall 00410b50, damage 00410910) into the chassis spatial force; unchanged Stage 6/7 modules, now validated (5000 vectors, worst 4.5e-6 rel)',
    'sessionAir': '005a3c00 subset + 005a3ba0 + 005a3be0 hand-ported, bit-exact (1576 + 2500 vectors); default 70 F / sun / day -> rho 1.08119202 kg/m^3',
    'perFrame': '005637e0 subset (factors 1.0, airspeed, drafting) before 005b2190 frame start',
    'drafting': '005afd80 + 005b0230 + 00567818 + 00516daa hand-ported, bit-exact (3000 race rings); interface setDraftEnvironment, no other cars on the bench',
    'setup': 'garage items 0x3b grille tape (00423de0) and 0x3d rear spoiler (004241d0), read at run time by 00410280',
    'imageFix': '16 cells of the aero damage tables (0071fa00..0071fa3c) outside the Stage 6/7 image windows restored by NR2003CupAero (generated modules unchanged)',
    'deferred': ['dynamic weather 005a4cc0 (mapped, not ported)', 'multi-car drafting inputs (Stage 14 / track)', 'aero damage evolution and tape/airspeed thermal consumers (Stage 11)', 'track query 0051370a (host geometry)'],
    'adapter': ['weather / TrackNorth / AeroSession attributes', 'SetupGrilleTape / SetupSpoiler attributes', 'track normal from contact planes', 'DraftTestGap phantom car (TEST ONLY)', 'aero telemetry + HUD line'],
}
skip = {'MANIFEST.json', 'tools/stage8_manifest_files.json', 'tools/stage9_changes.json'}
files = {}
for p in sorted(root.rglob('*')):
    if not p.is_file(): continue
    rel = p.relative_to(root).as_posix()
    if rel in skip or '/__pycache__/' in '/' + rel or rel.endswith('.pyc') or rel.startswith('recovery/stage6_7/out/'):
        continue
    if rel.endswith('_diag.luau'): continue
    data = p.read_bytes()
    h = hashlib.sha256(data).hexdigest()
    if rel in previous and previous[rel] != h:
        # files restored from the Stage 5/6-7/8 zips may differ only by line endings
        if hashlib.sha256(data.replace(b'\r\n', b'\n')).hexdigest() == previous[rel]:
            h = previous[rel]
    files[rel] = h
man['files'] = files
man_path.write_text(json.dumps(man, indent=1, ensure_ascii=False) + '\n', encoding='utf-8', newline='\n')
new = sorted(k for k in files if k not in previous)
changed = sorted(k for k in files if k in previous and previous[k] != files[k])
removed = sorted(k for k in previous if k not in files)
(root / 'tools/stage9_changes.json').write_text(json.dumps({'new': new, 'changed': changed, 'removed': removed}, indent=1) + '\n',
                                                 encoding='utf-8', newline='\n')
print('manifest files', len(files), '| new', len(new), 'changed', len(changed), 'removed', len(removed))
for k in changed: print('  changed', k)
print('  new (non-evidence):', [k for k in new if '/evidence/' not in k and 'fixtures' not in k])
print('  removed:', removed)
