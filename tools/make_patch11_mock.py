"""Generate tests/stage11/patch11_mock.luau: executes the ORIGINAL PATCH_STAGE6_7.lua, PATCH_STAGE8.lua, PATCH_STAGE9.lua,
PATCH_STAGE10.lua and then PATCH_STAGE11.lua against a mock Studio DataModel (install path incl. the five real
self-tests, forced Stage 11 failure -> revert path, refusal without Stage 10, split install). The DataModel mock is
the Stage 6/7 one (tools/patch_mock_body.luau, up to its scenario section)."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]


def long_string(name, text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return 'local %s = [%s[\n%s]%s]\n' % (name, eq, text, eq)


src = {n: (root / f).read_text(encoding='utf-8') for n, f in (('PATCH67', 'PATCH_STAGE6_7.lua'), ('PATCH8', 'PATCH_STAGE8.lua'),
                                                             ('PATCH9', 'PATCH_STAGE9.lua'), ('PATCH10', 'PATCH_STAGE10.lua'),
                                                             ('PATCH11', 'PATCH_STAGE11.lua'))}
mock = (root / 'tools/patch_mock_body.luau').read_text(encoding='utf-8')
head = mock[:mock.index('local passed, failed = 0, 0')]
tail = (root / 'tools/patch11_mock_tail.luau').read_text(encoding='utf-8')
parts = sorted(root.glob('PATCH_STAGE11_PART*.lua'), key=lambda p: int(p.stem[len('PATCH_STAGE11_PART'):]))
split = 'local PARTS11 = {}\n'
for k, p in enumerate(parts, 1):
    split += long_string('P%d' % k, p.read_text(encoding='utf-8')) + 'PARTS11[%d] = P%d\n' % (k, k)
split += long_string('INSTALL11', (root / 'PATCH_STAGE11_INSTALL.lua').read_text(encoding='utf-8'))
out = ''.join(long_string(n, s) for n, s in src.items()) + split + head + tail
(root / 'tests/stage11').mkdir(parents=True, exist_ok=True)
(root / 'tests/stage11/patch11_mock.luau').write_text(out, encoding='utf-8', newline='\n')
print('written', len(out))
