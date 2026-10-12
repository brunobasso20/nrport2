#!/usr/bin/env python3
"""OpenNR2003_Roblox_CARMODEL_changed_files.zip: every file this milestone adds or changes relative to the published
Stage 13 (commit STAGE13_COMMIT), as listed by git (tracked + staged; ignored files excluded), plus CHANGED_FILES.txt and
MANIFEST.json (sha256). No original NR2003 asset is in the list (the converted package stays outside the repository)."""
import hashlib
import json
import subprocess
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
STAGE13_COMMIT = 'c64ad5e'
OUT = ROOT / 'OpenNR2003_Roblox_CARMODEL_changed_files.zip'


def git(*a):
    return subprocess.run(['git', *a], cwd=ROOT, capture_output=True, check=True, text=True).stdout.splitlines()


def main():
    changed = sorted(set(git('diff', '--name-only', '--cached', STAGE13_COMMIT)) | set(git('diff', '--name-only', STAGE13_COMMIT)))
    changed = [p for p in changed if p != OUT.name and (ROOT / p).is_file()]
    added = set(git('diff', '--name-only', '--diff-filter=A', '--cached', STAGE13_COMMIT))
    manifest = {"version": "1.0.0-carmodel", "base": "3.12.0-stage13 (%s)" % STAGE13_COMMIT, "stage14Started": False,
                "physicsChanged": False, "originalAssetsIncluded": False, "files": {}}
    lines = ["# nr2003carmodel (1.0.0-carmodel) — arquivos novos/alterados em relação ao Stage 13 publicado (%s)" % STAGE13_COMMIT,
             "# (sha256 em MANIFEST.json). Física / estágios 1–13: nenhum arquivo de código alterado fora de",
             "# nr2003carmodel_implementation/; fora dele só documentação (CHANGELOG, PORT_MAP, ROADMAP_STATUS)."]
    for p in changed:
        data = (ROOT / p).read_bytes()
        manifest["files"][p] = {"sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}
        lines.append("%-90s %s" % (p, "(novo)" if p in added else "(alterado)"))
    with zipfile.ZipFile(OUT, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        z.writestr('CHANGED_FILES.txt', "\n".join(lines) + "\n")
        z.writestr('MANIFEST.json', json.dumps(manifest, indent=1) + "\n")
        for p in changed:
            z.write(ROOT / p, p)
    print(OUT.name, len(changed), "files", OUT.stat().st_size, "bytes")


if __name__ == '__main__':
    main()
