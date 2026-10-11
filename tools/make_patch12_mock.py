"""Generate tests/stage12/patch12_mock.luau: executes the ORIGINAL PATCH_STAGE6_7.lua .. PATCH_STAGE11.lua and then
PATCH_STAGE12.lua (+ parts / INSTALL / ROLLBACK) against the mock Studio DataModel of tools/patch_mock_body.luau
(up to its scenario section). Checks (tools/patch12_mock_tail.luau): baseline refusal, locally modified module refusal,
in-place install with instance identity kept, one-line self-test edits, backup of only the changed instances,
idempotent re-run, verified rollback, automatic revert on a failing self-test, split install, no SavePlace."""
import subprocess
from pathlib import Path
root = Path(__file__).resolve().parents[1]


def long_string(name, text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return 'local %s = [%s[\n%s]%s]\n' % (name, eq, text, eq)


def lua_str(text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return '[%s[\n%s]%s]' % (eq, text, eq)


def base(path): return subprocess.run(['git', 'show', '626eabe:' + path], cwd=root, capture_output=True, check=True).stdout.decode('utf-8')


rd = lambda f: (root / f).read_text(encoding='utf-8')
src = {n: rd(f) for n, f in (('PATCH67', 'PATCH_STAGE6_7.lua'), ('PATCH8', 'PATCH_STAGE8.lua'), ('PATCH9', 'PATCH_STAGE9.lua'),
                             ('PATCH10', 'PATCH_STAGE10.lua'), ('PATCH11', 'PATCH_STAGE11.lua'), ('PATCH12', 'PATCH_STAGE12.lua'),
                             ('INSTALL12', 'PATCH_STAGE12_INSTALL.lua'), ('ROLLBACK12', 'PATCH_STAGE12_ROLLBACK.lua'))}
mock = rd('tools/patch_mock_body.luau')
head = mock[:mock.index('local passed, failed = 0, 0')]
tail = rd('tools/patch12_mock_tail.luau')
parts = sorted(root.glob('PATCH_STAGE12_PART*.lua'), key=lambda p: int(p.stem[len('PATCH_STAGE12_PART'):]))
split = 'local PARTS12 = {}\n'
for k, p in enumerate(parts, 1):
    split += long_string('P%d' % k, p.read_text(encoding='utf-8')) + 'PARTS12[%d] = P%d\n' % (k, k)
# the real Stage 5 presentation modules of a bench (the mock's stage5() only stubs them)
st5 = 'local STAGE5_SOURCES = {\n'
for n in ('Cockpit', 'RenderSnapshot', 'RenderPresentation'):
    st5 += '\t[%r] = %s,\n' % (n, lua_str(base('roblox/%s.lua' % n)))
st5 += '}\n'
exp = 'local EXPECTED_EDIT_LEN = {\n'
for n in ('Stage67SelfTest', 'Stage8SelfTest', 'Stage9SelfTest', 'Stage10SelfTest', 'Stage11SelfTest'):
    exp += '\t%s = %d,\n' % (n, len(rd('roblox/%s.lua' % n).encode('utf-8')))
exp += '}\n'
out = ''.join(long_string(n, s) for n, s in src.items()) + split + st5 + exp + head + tail
(root / 'tests/stage12').mkdir(parents=True, exist_ok=True)
(root / 'tests/stage12/patch12_mock.luau').write_text(out, encoding='utf-8', newline='\n')
print('written', len(out))
