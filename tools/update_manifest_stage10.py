"""Update MANIFEST.json for 3.9.0-stage10 (version/status fields + sha256 of every package file) and write the list
of new/changed files relative to the Stage 9 manifest (stage10_changes.json, used for CHANGED_FILES.txt)."""
import json, hashlib
from pathlib import Path
root = Path(__file__).resolve().parents[1]
man_path = root / 'MANIFEST.json'
man = json.loads(man_path.read_text(encoding='utf-8'))
base_path = root / 'tools/stage9_manifest_files.json'
if man.get('version') == '3.8.0-stage9':
    previous = dict(man['files'])
    base_path.write_text(json.dumps(previous, indent=0) + '\n', encoding='utf-8', newline='\n')
else:
    previous = json.loads(base_path.read_text(encoding='utf-8'))
man['version'] = '3.9.0-stage10'
man['completedThroughRoadmapStage'] = 10
man['studioPlayVerified'] = {'stage5': True, 'stage6_7': True, 'stage8': True, 'stage9': False, 'stage10': False}
man['nextRoadmapStages'] = [11]
man['stage10'] = {
    'validation': 'automatic PASS (tests/stage10/RESULTS_STAGE10.txt); manual Studio validation pending',
    'finding': 'NR2003 applies a garage setup by rebuilding the car; the build regenerates the x87 callbacks with value-dependent emitter decisions (0057c8d0/0057c900/0057ca60/005b9970), so the Stage 6/7 code is the default-setup specialisation',
    'garage': 'NR2003CupSetup: descriptor table c05150, 29 converters 00423dc0..004241f0, garage API 005582d0/00558320/00557e40/005581d0/005580f0/005583e0/00558380, defaults 00557d20/00559950, .sto validation 00558da0/004247e0; bit-exact under CW 0x027f and 0x077f',
    'build': 'NR2003CupBuild + BuildCode1..6 + BuildData1..2: the original car-build sequence (00559820 ... 005b2f20 ... 0054d610) lifted from x86 (388 functions), run on the core memory; decision hooks follow the natural (strict) or generic tables',
    'structures': {'image': 'shipped default build, restored bit for bit',
                   'natural': '60358 emitter events / 1690 literal calls of the default; strict check -> the setup\'s own original code',
                   'generic': '181 forced no-fold events, 187 literal classes (NR2003CupJITG1..4); validated on 121 unseen setups; float32-rounding difference only at fold sites'},
    'coreChanges': ['NR2003CupCore: host exports _pristine/imageSize/_jitTable/_jitLoad (image and callbacks unchanged)',
                    'NR2003CupDriver: brake/inertia cells re-bound after a rebuild (_bindDriverCells)'],
    'deferred': ['pit-stop adjustments 005601c0 / 00550f10 (recovered, not ported)', 'steering ratio use (Stage 12)',
                 'fuel burn, tyre/brake/engine thermal, wear, damage (Stage 11)'],
    'adapter': ['Setup_<item> car attributes (display units) through 005581d0 and the original build at reset',
                'SetupStructure / SetupApplySeconds / SetupError outputs, one Output line per applied setup'],
}
skip = {'MANIFEST.json', 'tools/stage9_manifest_files.json', 'tools/stage10_changes.json'}
files = {}
for p in sorted(root.rglob('*')):
    if not p.is_file(): continue
    rel = p.relative_to(root).as_posix()
    if rel in skip or '/__pycache__/' in '/' + rel or rel.endswith('.pyc') or rel.startswith('recovery/stage6_7/out/'):
        continue
    if rel.startswith('.git/') or rel.endswith('_diag.luau') or rel.startswith('tests/stage10/_work/'): continue
    if rel.startswith('recovery/stage10/footprint') or rel.endswith('fold_only.pkl'): continue
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
(root / 'tools/stage10_changes.json').write_text(json.dumps({'new': new, 'changed': changed, 'removed': removed}, indent=1) + '\n',
                                                  encoding='utf-8', newline='\n')
print('manifest files', len(files), '| new', len(new), 'changed', len(changed), 'removed', len(removed))
for k in changed: print('  changed', k)
print('  new (non-evidence):', [k for k in new if '/evidence/' not in k and 'fixtures' not in k])
print('  removed:', removed)
