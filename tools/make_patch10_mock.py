"""Generate tests/stage10/patch10_mock.luau: executes the ORIGINAL PATCH_STAGE6_7.lua, PATCH_STAGE8.lua,
PATCH_STAGE9.lua and then PATCH_STAGE10.lua against a mock Studio DataModel (install path incl. the four real
self-tests, forced Stage 10 failure -> revert path, refusal without Stage 9). The DataModel mock is the Stage
6/7 one (tools/patch_mock_body.luau, up to its scenario section)."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]


def long_string(name, text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return 'local %s = [%s[\n%s]%s]\n' % (name, eq, text, eq)


p67 = (root / 'PATCH_STAGE6_7.lua').read_text(encoding='utf-8')
p8 = (root / 'PATCH_STAGE8.lua').read_text(encoding='utf-8')
p9 = (root / 'PATCH_STAGE9.lua').read_text(encoding='utf-8')
p10 = (root / 'PATCH_STAGE10.lua').read_text(encoding='utf-8')
mock = (root / 'tools/patch_mock_body.luau').read_text(encoding='utf-8')
head = mock[:mock.index('local passed, failed = 0, 0')]
tail = (root / 'tools/patch10_mock_tail.luau').read_text(encoding='utf-8')
parts = sorted(root.glob('PATCH_STAGE10_PART*.lua'), key=lambda p: int(p.stem[len('PATCH_STAGE10_PART'):]))
split = 'local PARTS10 = {}\n'
for k, p in enumerate(parts, 1):
    split += long_string('P%d' % k, p.read_text(encoding='utf-8')) + 'PARTS10[%d] = P%d\n' % (k, k)
split += long_string('INSTALL10', (root / 'PATCH_STAGE10_INSTALL.lua').read_text(encoding='utf-8'))
out = long_string('PATCH67', p67) + long_string('PATCH8', p8) + long_string('PATCH9', p9) + long_string('PATCH10', p10) + split + head + tail
(root / 'tests/stage10').mkdir(parents=True, exist_ok=True)
(root / 'tests/stage10/patch10_mock.luau').write_text(out, encoding='utf-8', newline='\n')
print('written', len(out))
