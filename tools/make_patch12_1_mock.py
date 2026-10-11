"""Generate tests/stage12/patch12_1_mock.luau: executes the ORIGINAL PATCH_STAGE6_7.lua .. PATCH_STAGE12.lua (the published
Stage 12) and then PATCH_STAGE12_1.lua (+ parts / INSTALL / ROLLBACK) against the mock Studio DataModel of
tools/patch_mock_body.luau (up to its scenario section). Checks (tools/patch12_1_mock_tail.luau): baseline refusal, locally
modified module refusal, in-place install with instance identity kept, backup of only the changed instances, idempotent
re-run, verified rollback to Stage 12, the Stage 12 rollback refusing a 12.1 bench, automatic revert on a failing
self-test, split install, no SavePlace."""
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
# Since Stage 13 the Stage 12.1 sources are read from the published Stage 12.1 commit (the working tree is Stage 13)
def published121(path): return subprocess.run(['git', 'show', '5d9f5ee:' + path], cwd=root, capture_output=True, check=True).stdout.decode('utf-8')
src = {n: rd(f) for n, f in (('PATCH67', 'PATCH_STAGE6_7.lua'), ('PATCH8', 'PATCH_STAGE8.lua'), ('PATCH9', 'PATCH_STAGE9.lua'),
                             ('PATCH10', 'PATCH_STAGE10.lua'), ('PATCH11', 'PATCH_STAGE11.lua'), ('PATCH12', 'PATCH_STAGE12.lua'),
                             ('ROLLBACK12', 'PATCH_STAGE12_ROLLBACK.lua'), ('PATCH121', 'PATCH_STAGE12_1.lua'),
                             ('INSTALL121', 'PATCH_STAGE12_1_INSTALL.lua'), ('ROLLBACK121', 'PATCH_STAGE12_1_ROLLBACK.lua'))}
mock = rd('tools/patch_mock_body.luau')
head = mock[:mock.index('local passed, failed = 0, 0')]
tail = rd('tools/patch12_1_mock_tail.luau')
parts = sorted(root.glob('PATCH_STAGE12_1_PART*.lua'), key=lambda p: int(p.stem[len('PATCH_STAGE12_1_PART'):]))
split = 'local PARTS121 = {}\n'
for k, p in enumerate(parts, 1):
    split += long_string('P%d' % k, p.read_text(encoding='utf-8')) + 'PARTS121[%d] = P%d\n' % (k, k)
# the real Stage 5 presentation modules of a bench (the mock's stage5() only stubs them)
st5 = 'local STAGE5_SOURCES = {\n'
for n in ('Cockpit', 'RenderSnapshot', 'RenderPresentation'):
    st5 += '\t[%r] = %s,\n' % (n, lua_str(base('roblox/%s.lua' % n)))
st5 += '}\n'
# the Stage 12.1 sources the patch must install (working tree)
new = 'local NEW121 = {\n'
for key, path in (('ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupSteering', 'core/NR2003Cup/NR2003CupSteering.lua'),
                  ('ReplicatedStorage.NR2003Lab.Core.CupTune', 'core/CupTune.lua'),
                  ('ReplicatedStorage.NR2003Lab.Roblox.CupChassisAdapter', 'roblox/CupChassisAdapter.lua'),
                  ('StarterPlayer.StarterPlayerScripts.NR2003Client', 'roblox/Client.client.lua'),
                  ('ReplicatedStorage.NR2003Lab.Roblox.Stage12SelfTest', 'roblox/Stage12SelfTest.lua')):
    new += '\t[%r] = %s,\n' % (key, lua_str(published121(path)))
new += '}\n'
out = ''.join(long_string(n, s) for n, s in src.items()) + split + st5 + new + head + tail
(root / 'tests/stage12').mkdir(parents=True, exist_ok=True)
(root / 'tests/stage12/patch12_1_mock.luau').write_text(out, encoding='utf-8', newline='\n')
print('written', len(out))
