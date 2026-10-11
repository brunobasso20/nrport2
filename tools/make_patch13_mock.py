"""Generate tests/stage13/patch13_mock.luau: executes the ORIGINAL PATCH_STAGE6_7.lua .. PATCH_STAGE12.lua and
PATCH_STAGE12_1.lua (the published Stage 12.1) and then PATCH_STAGE13.lua (+ parts / INSTALL / ROLLBACK) against the mock
Studio DataModel of tools/patch_mock_body.luau (up to its scenario section). Checks (tools/patch13_mock_tail.luau): baseline
refusal, locally modified module refusal, install (sources in place with instance identity kept, two new modules),
backup of only the changed instances + ADDED markers, idempotent re-run, verified rollback to Stage 12.1 (added modules
removed), the Stage 12.1 rollback refusing a Stage 13 bench, automatic revert on a failing self-test, split install, no
SavePlace."""
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
                             ('ROLLBACK12', 'PATCH_STAGE12_ROLLBACK.lua'), ('PATCH121', 'PATCH_STAGE12_1.lua'),
                             ('INSTALL121', 'PATCH_STAGE12_1_INSTALL.lua'), ('ROLLBACK121', 'PATCH_STAGE12_1_ROLLBACK.lua'),
                             ('PATCH13', 'PATCH_STAGE13.lua'), ('INSTALL13', 'PATCH_STAGE13_INSTALL.lua'),
                             ('ROLLBACK13', 'PATCH_STAGE13_ROLLBACK.lua'))}
mock = rd('tools/patch_mock_body.luau')
head = mock[:mock.index('local passed, failed = 0, 0')]
tail = rd('tools/patch13_mock_tail.luau')
parts = sorted(root.glob('PATCH_STAGE13_PART*.lua'), key=lambda p: int(p.stem[len('PATCH_STAGE13_PART'):]))
split = 'local PARTS13 = {}\n'
for k, p in enumerate(parts, 1):
    split += long_string('P%d' % k, p.read_text(encoding='utf-8')) + 'PARTS13[%d] = P%d\n' % (k, k)
# the real Stage 5 presentation modules of a bench (the mock's stage5() only stubs them)
st5 = 'local STAGE5_SOURCES = {\n'
for n in ('Cockpit', 'RenderSnapshot', 'RenderPresentation'):
    st5 += '\t[%r] = %s,\n' % (n, lua_str(base('roblox/%s.lua' % n)))
st5 += '}\n'
# the Stage 13 sources the patch must install (working tree)
new = 'local NEW13 = {\n'
for key, path in (('ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupDriver', 'core/NR2003Cup/NR2003CupDriver.lua'),
                  ('ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupFrame', 'core/NR2003Cup/NR2003CupFrame.lua'),
                  ('ReplicatedStorage.NR2003Lab.Core.NR2003CupVehicle', 'core/NR2003CupVehicle.lua'),
                  ('ReplicatedStorage.NR2003Lab.Core.CupTune', 'core/CupTune.lua'),
                  ('ReplicatedStorage.NR2003Lab.Roblox.CupChassisAdapter', 'roblox/CupChassisAdapter.lua'),
                  ('StarterPlayer.StarterPlayerScripts.NR2003Client', 'roblox/Client.client.lua'),
                  ('ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupFFB', 'core/NR2003Cup/NR2003CupFFB.lua'),
                  ('ReplicatedStorage.NR2003Lab.Roblox.Stage13SelfTest', 'roblox/Stage13SelfTest.lua')):
    new += '\t[%r] = %s,\n' % (key, lua_str(rd(path)))
new += '}\n'
out = ''.join(long_string(n, s) for n, s in src.items()) + split + st5 + new + head + tail
(root / 'tests/stage13').mkdir(parents=True, exist_ok=True)
(root / 'tests/stage13/patch13_mock.luau').write_text(out, encoding='utf-8', newline='\n')
print('written', len(out))
