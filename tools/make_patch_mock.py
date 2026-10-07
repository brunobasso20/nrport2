"""Generate tests/stage67/patch_mock.luau: executes PATCH_STAGE6_7.lua against a mock Studio
DataModel (install path incl. the real self-test, then a forced-failure revert path)."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
patch = (root / 'PATCH_STAGE6_7.lua').read_text()
eq = '='
while (']' + eq + ']') in patch: eq += '='
body = (root / 'tools/patch_mock_body.luau').read_text()
(root / 'tests/stage67/patch_mock.luau').write_text('local PATCH = [' + eq + '[\n' + patch + ']' + eq + ']\n' + body)
print('written')
