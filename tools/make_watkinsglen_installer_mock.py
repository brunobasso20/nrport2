#!/usr/bin/env python3
"""Build a read-only Studio installer mock using extracted original NR2003Lab scripts.
Requires work/rbxm_audit/extracted from the original uploaded model audit.
Run with the Luau CLI; source payloads are compared, not required as simulation code.
"""
from pathlib import Path
import json

root = Path(__file__).resolve().parents[1]
manifest = json.loads((root / 'watkinsglen_implementation/studio/manifest.json').read_text())
rows = json.loads((root / 'work/rbxm_audit/extracted/scripts.json').read_text())
originals = {row['path'].removeprefix('NR2003Lab/').replace('/', '.'): row for row in rows}
originals['Server.NR2003Server'] = next(row for row in rows if row['path'] == 'NR2003Server')
required = {row['key'] for row in manifest['dependencies']} | {row['key'] for row in manifest['targets'] if row['old']}

def quote(value):
    eq = '='
    while ']' + eq + ']' in value:
        eq += '='
    return '[' + eq + '[\n' + value + ']' + eq + ']'

chunks = ['local TEMPLATES = {}\n']
for name in ['Apply', 'Support', 'Rollback', 'Manifest']:
    chunks.append('TEMPLATES.' + name + ' = ' + quote((root / 'watkinsglen_implementation/studio' / (name + '.lua')).read_text()) + '\n')
chunks.append('local ORIGINALS = {}\n')
for key in sorted(required):
    row = originals[key]
    source = (root / 'work/rbxm_audit/extracted' / row['source_file']).read_text()
    chunks.append('ORIGINALS[' + json.dumps(key) + '] = {class=' + json.dumps(row['class']) + ',source=' + quote(source) + '}\n')
chunks.append('local PAYLOADS = {}\n')
for row in manifest['targets']:
    chunks.append('PAYLOADS[' + json.dumps(row['key']) + '] = ' + quote((root / row['file']).read_text()) + '\n')
chunks.append((root / 'watkinsglen_implementation/tests/studio_installer_mock_body.luau').read_text())
output = root / 'work/wg_install_mock/mock.luau'
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(''.join(chunks))
