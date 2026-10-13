#!/usr/bin/env python3
"""Build the track-only Studio patch against fingerprints of the supplied NR2003Lab model.

No uploaded scripts or original game executable are executed. The XML contains
individual source ModuleScripts; its small Apply module reads their Source
without requiring the multi-megabyte physics runtime.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import xml.etree.ElementTree as ET
import zipfile

ROOT = Path(__file__).resolve().parents[1]
STUDIO = ROOT / 'watkinsglen_implementation/studio'
TRACK = ROOT / 'watkinsglen_implementation/core/NR2003Cup'
BASELINE = ROOT / 'tools/watkinsglen_studio_baseline.json'
LIMIT = 199000
HOOKS = (
    'Core.NR2003CupVehicle',
    'Core.NR2003Cup.NR2003CupGarage',
    'Core.NR2003Cup.NR2003CupBuild',
    'Core.NR2003Cup.NR2003CupFrame',
    'Core.NR2003Cup.NR2003CupFrameCode1',
    'Core.NR2003Cup.NR2003CupFrameCode2',
    'Core.NR2003Cup.NR2003CupFrameCode3',
    'Core.NR2003Cup.NR2003CupFrameCode4',
    'Core.NR2003Cup.NR2003CupDriver',
)


def normalize(source: str) -> str:
    return source.replace('\r\n', '\n').replace('\r', '\n')


def fingerprint(source: str) -> dict:
    data = normalize(source).encode('utf-8')
    h = 2166136261
    for byte in data:
        h = ((h ^ byte) * 16777619) & 0xffffffff
    return {'bytes': len(data), 'fnv32': h, 'sha256': hashlib.sha256(data).hexdigest()}


def read_source(path: Path) -> str:
    source = normalize(path.read_text(encoding='utf-8'))
    assert len(source.encode('utf-8')) < LIMIT, f'Source exceeds the per-module limit: {path}'
    return source


def lua(value) -> str:
    if value is None:
        return 'nil'
    if isinstance(value, bool):
        return 'true' if value else 'false'
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, list):
        return '{' + ','.join(lua(v) for v in value) + '}'
    return '{' + ','.join(f'[{lua(k)}]={lua(v)}' for k, v in value.items()) + '}'


def core_file(key: str) -> Path:
    return ROOT / 'core' / (key.removeprefix('Core.').replace('.', '/') + '.lua')


def build() -> dict[Path, bytes]:
    baseline = json.loads(BASELINE.read_text(encoding='utf-8'))
    originals = {entry['key']: entry for entry in baseline['scripts']}
    payloads, targets = {}, []

    def target(key: str, path: Path, cls: str = 'ModuleScript') -> None:
        source = read_source(path)
        payloads[key] = source
        old = originals.get(key)
        targets.append({'key': key, 'class': cls, 'file': str(path.relative_to(ROOT)),
                        'old': {k: old[k] for k in ('bytes', 'fnv32', 'sha256')} if old else None,
                        'new': fingerprint(source)})

    for key in HOOKS:
        target(key, core_file(key))
    available = {path.stem for path in TRACK.glob('*.lua')}
    required = {'NR2003CupTrack', 'NR2003CupTrackBuild'}
    groups = {}
    for prefix in ('NR2003CupTrackCode', 'NR2003CupTrackData', 'NR2003CupJITP', 'NR2003CupJITPG'):
        parts = sorted(int(match.group(1)) for name in available
                       if (match := re.fullmatch(re.escape(prefix) + r'([1-9][0-9]*)', name)))
        assert parts and parts == list(range(1, parts[-1] + 1)), f'Missing/invalid contiguous module group: {prefix}'
        groups[prefix] = parts[-1]
        required.update(f'{prefix}{i}' for i in parts)
    assert required == available, f'Missing or unexpected track modules: {required ^ available}'
    for name in sorted(required):
        target('Core.NR2003Cup.' + name, TRACK / (name + '.lua'))
    target('Roblox.CupChassisAdapter', ROOT / 'roblox/CupChassisAdapter.lua')
    target('Roblox.NR2003WatkinsGlen', ROOT / 'roblox/NR2003WatkinsGlen.lua')
    target('Server.NR2003Server', ROOT / 'nr2003carmodel_implementation/roblox/Bench/Server.server.lua', 'Script')
    targets.sort(key=lambda entry: entry['key'])

    changed = {entry['key'] for entry in targets}
    dependencies = []
    general = {'Core.CupTune', 'Core.NR2003FixedStep', 'Core.MathUtil', 'Core.TestTune', 'Roblox.ModeConfig'}
    for key, original in sorted(originals.items()):
        if key in changed or not (key.startswith('Core.NR2003Cup.') or key in general):
            continue
        accepted = [{k: original[k] for k in ('bytes', 'fnv32', 'sha256')}]
        if key == 'Core.TestTune':
            # The checkout changed only this module's version/solver description since the upload.
            current = fingerprint((ROOT / 'core/TestTune.lua').read_text(encoding='utf-8'))
            if current not in accepted:
                accepted.append(current)
        dependencies.append({'key': key, 'class': original['class'], 'accepted': accepted})

    support = {name: read_source(STUDIO / (name + '.lua')) for name in ('Apply', 'Support', 'Rollback')}
    manifest = {'schema': 1, 'track': 'watkins_glen', 'metresPerStud': 0.28,
                'baselineModelSHA256': baseline['uploaded_model_sha256'],
                'moduleGroups': groups,
                'targets': targets, 'dependencies': dependencies,
                'installerSources': {name: fingerprint(source) for name, source in support.items()}}
    digest = hashlib.sha256(json.dumps(manifest, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
    manifest['bundle'] = digest
    manifest_lua = '-- Generated by tools/build_watkinsglen.py; do not edit.\nreturn ' + lua(manifest) + '\n'
    assert len(manifest_lua.encode()) < LIMIT

    xml = ET.Element('roblox', version='4')
    ET.SubElement(xml, 'External').text = 'null'
    ET.SubElement(xml, 'External').text = 'nil'
    counter = 0

    def instance(parent, name: str, cls: str = 'Folder', source: str | None = None):
        nonlocal counter
        counter += 1
        item = ET.SubElement(parent, 'Item', {'class': cls, 'referent': f'RBX{counter}'})
        properties = ET.SubElement(item, 'Properties')
        ET.SubElement(properties, 'string', name='Name').text = name
        if source is not None:
            ET.SubElement(properties, 'ProtectedString', name='Source').text = source
        return item

    model = instance(xml, 'NR2003_WatkinsGlen_Install', 'Model')
    for name, source in support.items():
        instance(model, name, 'ModuleScript', source)
    instance(model, 'Manifest', 'ModuleScript', manifest_lua)
    sources = instance(model, 'Sources')
    folders = {'': sources}
    for key in sorted(payloads):
        parts = key.split('.')
        for i in range(1, len(parts)):
            prefix = '.'.join(parts[:i])
            if prefix not in folders:
                folders[prefix] = instance(folders['.'.join(parts[:i - 1])], parts[i - 1])
        # Even the server source is a non-executing ModuleScript in the installer payload.
        instance(folders['.'.join(parts[:-1])], parts[-1], 'ModuleScript', payloads[key])
    ET.indent(xml, space='  ')
    outputs = {
        STUDIO / 'NR2003_WatkinsGlen_Install.rbxmx': ET.tostring(xml, encoding='utf-8', xml_declaration=True),
        STUDIO / 'manifest.json': (json.dumps(manifest, indent=2, ensure_ascii=False) + '\n').encode(),
        STUDIO / 'Manifest.lua': manifest_lua.encode(),
        STUDIO / 'INSTALL_WATKINSGLEN.lua': (
            '-- Insert NR2003_WatkinsGlen_Install.rbxmx into Workspace; run after all visual installers, outside Play.\n'
            'require(workspace.NR2003_WatkinsGlen_Install.Apply)()\n').encode(),
        STUDIO / 'ROLLBACK_WATKINSGLEN.lua': (
            '-- Outside Play; restores the saved starting state, preserving imported car and track visual assets.\n'
            'require(game.ServerStorage.NR2003Backup_WatkinsGlen.Rollback)()\n').encode(),
    }
    parsed = ET.fromstring(outputs[STUDIO / 'NR2003_WatkinsGlen_Install.rbxmx'])
    source_nodes = parsed.findall('.//ProtectedString[@name="Source"]')
    assert len(source_nodes) == len(targets) + 4
    assert all(len((node.text or '').encode()) < LIMIT for node in source_nodes)
    print(json.dumps({'bundle': digest, 'patchedSources': len(targets), 'solverDependencyChecks': len(dependencies),
                      'largestSourceBytes': max(len((node.text or '').encode()) for node in source_nodes),
                      'rbxmxBytes': len(outputs[STUDIO / 'NR2003_WatkinsGlen_Install.rbxmx'])}, indent=2))
    return outputs


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Check that generated installer files are current')
    parser.add_argument('--zip', action='store_true', help='Also create a compact track physics patch ZIP')
    args = parser.parse_args()
    outputs = build()
    for path, content in outputs.items():
        if args.check:
            assert path.exists() and path.read_bytes() == content, f'Stale generated file: {path.relative_to(ROOT)}'
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(content)
    if args.zip:
        assert not args.check, '--zip cannot be combined with --check'
        destination = STUDIO / 'WatkinsGlen_Physics_Patch.zip'
        with zipfile.ZipFile(destination, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
            for path in sorted(STUDIO.rglob('*')):
                if path.is_file() and path.suffix != '.zip':
                    archive.write(path, str(path.relative_to(ROOT)))
            for target in json.loads(outputs[STUDIO / 'manifest.json'])['targets']:
                archive.write(ROOT / target['file'], target['file'])
            # Include the checked dependency source files so the build can be
            # reproduced from the patch ZIP without the uploaded binary model.
            metadata = json.loads(outputs[STUDIO / 'manifest.json'])
            for check in metadata['dependencies']:
                key = check['key']
                path = core_file(key) if key.startswith('Core.') else ROOT / 'roblox' / (key.removeprefix('Roblox.') + '.lua')
                archive.write(path, str(path.relative_to(ROOT)))
            archive.write(Path(__file__), 'tools/build_watkinsglen.py')
            archive.write(BASELINE, 'tools/watkinsglen_studio_baseline.json')
        print(f'Patch ZIP: {destination.relative_to(ROOT)} ({destination.stat().st_size} bytes)')


if __name__ == '__main__':
    main()
