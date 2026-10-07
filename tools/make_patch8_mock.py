"""Generate tests/stage8/patch8_mock.luau: executes the ORIGINAL PATCH_STAGE6_7.lua and then
PATCH_STAGE8.lua against a mock Studio DataModel (install path incl. both real self-tests, forced
Stage 8 failure -> revert path, refusal without Stage 6/7). The DataModel mock is the Stage 6/7
one (tools/patch_mock_body.luau, up to its scenario section)."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]


def long_string(name, text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return 'local %s = [%s[\n%s]%s]\n' % (name, eq, text, eq)


p67 = (root / 'PATCH_STAGE6_7.lua').read_text(encoding='utf-8')
p8 = (root / 'PATCH_STAGE8.lua').read_text(encoding='utf-8')
mock = (root / 'tools/patch_mock_body.luau').read_text(encoding='utf-8')
head = mock[:mock.index('local passed, failed = 0, 0')]
tail = (root / 'tools/patch8_mock_tail.luau').read_text(encoding='utf-8')
out = long_string('PATCH67', p67) + long_string('PATCH8', p8) + head + tail
(root / 'tests/stage8').mkdir(parents=True, exist_ok=True)
(root / 'tests/stage8/patch8_mock.luau').write_text(out, encoding='utf-8', newline='\n')
print('written', len(out))
