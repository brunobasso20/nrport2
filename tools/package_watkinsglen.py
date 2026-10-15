#!/usr/bin/env python3
"""Build a Studio ZIP from hydrated assets, refusing Git LFS pointer payloads."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import zipfile

ROOT = Path(__file__).resolve().parents[1]
TRACK = ROOT / 'watkinsglen_implementation'


def check_binary(path):
    with path.open('rb') as stream:
        header = stream.read(12)
    if path.suffix == '.glb':
        if len(header) != 12 or struct.unpack('<III', header) != (0x46546C67, 2, path.stat().st_size):
            raise ValueError(f'{path}: not a complete binary GLB; run git lfs pull first')
    elif path.suffix == '.png' and header[:8] != b'\x89PNG\r\n\x1a\n':
        raise ValueError(f'{path}: not a binary PNG; run git lfs pull first')


def build(target):
    paths = list((TRACK / 'assets').rglob('*'))
    paths += list((TRACK / 'studio').rglob('*'))
    paths += list((TRACK / 'validation').rglob('*'))
    paths += [TRACK / 'downloads/README_DOWNLOAD.md', TRACK / 'downloads/README_VISUAL_FIX.md',
              TRACK / 'downloads/README_VISUAL_RECOVERY.md', TRACK / 'downloads/README_PHYSICS_V4.md']
    paths += [TRACK / name for name in ('README.md', 'VALIDATION.md', 'RUNTIME_VALIDATION.md',
                                     'SURFACE_RECOVERY.md', 'STUDIO_AUDIT.md')]
    files = sorted(p for p in paths if p.is_file() and p.suffix != '.zip')
    for path in files:
        if path.suffix in ('.glb', '.png'):
            check_binary(path)
    counts = {extension: sum(p.suffix == extension for p in files) for extension in ('.glb', '.png')}
    if counts != {'.glb': 88, '.png': 426}:
        raise ValueError(f'Unexpected final asset counts: {counts}')
    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = target.with_suffix('.zip.partial')
    try:
        with zipfile.ZipFile(temporary, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
            for path in files:
                archive.write(path, path.relative_to(TRACK).as_posix())
        with zipfile.ZipFile(temporary) as archive:
            if archive.testzip() is not None:
                raise ValueError('ZIP CRC check failed')
            for entry in archive.infolist():
                if Path(entry.filename).suffix in ('.glb', '.png'):
                    with archive.open(entry) as stream:
                        header = stream.read(12)
                    if entry.filename.endswith('.glb'):
                        assert struct.unpack('<III', header) == (0x46546C67, 2, entry.file_size)
                    else:
                        assert header[:8] == b'\x89PNG\r\n\x1a\n'
        temporary.replace(target)
    finally:
        temporary.unlink(missing_ok=True)
    digest = hashlib.sha256()
    with target.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    report = {'file': target.name, 'sha256': digest.hexdigest(), 'bytes': target.stat().st_size,
              'glbs': counts['.glb'], 'pngs': counts['.png'], 'entries': len(files), 'zipCRCVerified': True}
    (target.parent / 'package_info.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


def build_visual_fix():
    target = TRACK / 'downloads/WatkinsGlen_Visual_Installer_Fix.zip'
    target.parent.mkdir(parents=True, exist_ok=True)
    files = {
        'NR2003TrackVisualInstallers.rbxmx': TRACK / 'assets/studio/NR2003TrackVisualInstallers.rbxmx',
        'INSTALL_ALL_TRACK_VISUALS.lua': TRACK / 'assets/studio/INSTALL_ALL_TRACK_VISUALS.lua',
        'README_FIRST.md': TRACK / 'downloads/README_VISUAL_FIX.md',
    }
    with zipfile.ZipFile(target, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
        for name, source in files.items():
            archive.write(source, name)
    with zipfile.ZipFile(target) as archive:
        assert archive.testzip() is None
        assert b'NR2003TrackVisualInstallersV3' in archive.read('NR2003TrackVisualInstallers.rbxmx')
        assert b'np.float' not in archive.read('NR2003TrackVisualInstallers.rbxmx')
    print('Visual installer fix:', target.name, target.stat().st_size, 'bytes')


def build_visual_recovery():
    target = TRACK / 'downloads/WatkinsGlen_Visual_Recovery.zip'
    files = {
        'NR2003TrackVisualInstallers.rbxmx': TRACK / 'assets/studio/NR2003TrackVisualInstallers.rbxmx',
        'INSTALL_ALL_TRACK_VISUALS.lua': TRACK / 'assets/studio/INSTALL_ALL_TRACK_VISUALS.lua',
        'README_FIRST.md': TRACK / 'downloads/README_VISUAL_RECOVERY.md',
    }
    for source in sorted((TRACK / 'assets/glb').glob('watkins_glen_scenery_*.glb')):
        check_binary(source)
        files['glb/' + source.name] = source
    assert sum(name.endswith('.glb') for name in files) == 4
    with zipfile.ZipFile(target, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
        for name, source in files.items():
            archive.write(source, name)
    with zipfile.ZipFile(target) as archive:
        assert archive.testzip() is None
        assert b'NR2003TrackVisualInstallersV3' in archive.read('NR2003TrackVisualInstallers.rbxmx')
    print('Visual recovery:', target.name, target.stat().st_size, 'bytes')


def build_physics_installer():
    target = TRACK / 'downloads/WatkinsGlen_Physics_Installer_V5.zip'
    files = {
        'NR2003_WatkinsGlen_InstallV5.rbxmx': TRACK / 'studio/NR2003_WatkinsGlen_InstallV5.rbxmx',
        'INSTALL_WATKINSGLEN_V5.lua': TRACK / 'studio/INSTALL_WATKINSGLEN_V5.lua',
        'README_FIRST.md': TRACK / 'downloads/README_PHYSICS_V5.md',
        'VALIDATION.md': TRACK / 'handling/VALIDATION.md',
    }
    with zipfile.ZipFile(target, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
        for name, source in files.items():
            archive.write(source, name)
    with zipfile.ZipFile(target) as archive:
        assert archive.testzip() is None
        assert b'NR2003_WatkinsGlen_InstallV5' in archive.read('INSTALL_WATKINSGLEN_V5.lua')
    print('Physics installer:', target.name, target.stat().st_size, 'bytes')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--out', type=Path, default=TRACK / 'downloads/WatkinsGlen_Studio_Package.zip')
    build_visual_fix()
    build_visual_recovery()
    build_physics_installer()
    build(parser.parse_args().out)
