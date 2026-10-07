"""Update MANIFEST.json for 3.7.0-stage8: version/status fields + sha256 of every package file."""
import json, hashlib
from pathlib import Path
root = Path(__file__).resolve().parents[1]
man_path = root / 'MANIFEST.json'
man = json.loads(man_path.read_text(encoding='utf-8'))
man['version'] = '3.7.0-stage8'
man['completedThroughRoadmapStage'] = 8
man['studioPlayVerified'] = {'stage5': True, 'stage6_7': True, 'stage8': False}
man['stage67']['validation'] = 'automatic PASS (tests/stage67/RESULTS_STAGE67.txt); manual Studio validation PASS (user, before Stage 8)'
man['stage8'] = {
    'validation': 'automatic PASS (tests/stage8/RESULTS_STAGE8.txt); manual Studio validation pending',
    'brakeInputChain': '00552d00 + 00553080 (+00554f50, 005f7570, 00550130, 005524f0 not-driven) hand-ported, bit-exact vs original (3000 + 1500 vectors)',
    'brakeTorque': 'original generated force code 005610b0 x4 + 00561040 (unchanged Stage 6/7 core)',
    'setup': 'garage item 0x28 (50..90 %, default 74) -> 00423de0 -> 0055e9b0 Kb cells (3800 N*m max: 2812 / 987.99994)',
    'fade': 'none in the shipped original (0054f3d0 / 0054f610 unreferenced); brake temperature 0054f260 frozen (Stage 11)',
    'abs': 'none for the Cup car; braking help driver aid (bf6f04) ported, default off',
    'adapter': ['keyboard brake = digital binding', 'no driver = 005524f0 not-driven', 'SetupBrakeBias attribute at reset', 'brake telemetry/HUD'],
}
skip = {'MANIFEST.json'}
files = {}
for p in sorted(root.rglob('*')):
    if not p.is_file(): continue
    rel = p.relative_to(root).as_posix()
    if rel in skip or '/__pycache__/' in '/' + rel or rel.endswith('.pyc') or rel.startswith('recovery/stage6_7/out/'):
        continue
    if rel.endswith('_diag.luau'): continue
    files[rel] = hashlib.sha256(p.read_bytes()).hexdigest()
man['files'] = files
man_path.write_text(json.dumps(man, indent=1, ensure_ascii=False) + '\n', encoding='utf-8', newline='\n')
print('manifest files', len(files))
