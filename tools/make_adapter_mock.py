"""Generate tests/stage67/adapter_mock.luau: runs the REAL Roblox/CupChassisAdapter.lua (and the
Stage 5 helper modules it requires) under a minimal Roblox API mock in the Luau CLI.
Checks frame conversions, contact planes from raycasts, pose, fixed-step loop, shifting,
telemetry/render snapshot encoding, collision boundary and reset."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
# Stage 5 helper modules: the full bench tree (Stage 5 package + Stage 6/7/8 patches) has them in place
stage5 = root
def src(p): return p.read_text()
bundle = {
    'Core.NR2003CupVehicle': src(root / 'core/NR2003CupVehicle.lua'),
    'Core.CupTune': src(root / 'core/CupTune.lua'),
    'Core.NR2003FixedStep': src(stage5 / 'core/NR2003FixedStep.lua'),
    'Core.NR2003Math': src(stage5 / 'core/NR2003Math.lua'),
    'Core.Float32': src(stage5 / 'core/Float32.lua'),
    'Core.Surface': src(stage5 / 'core/Surface.lua'),
    'Core.RecoveredData': src(stage5 / 'core/RecoveredData.lua'),
    'Core.MathUtil': src(stage5 / 'core/MathUtil.lua'),
    'Core.TestTune': src(stage5 / 'core/TestTune.lua'),
    'Roblox.RenderSnapshot': src(stage5 / 'roblox/RenderSnapshot.lua'),
    'Roblox.CupChassisAdapter': src(root / 'roblox/CupChassisAdapter.lua'),
    'Roblox.Stage67SelfTest': src(root / 'roblox/Stage67SelfTest.lua'),
    'Roblox.Stage8SelfTest': src(root / 'roblox/Stage8SelfTest.lua'),
    'Roblox.Stage9SelfTest': src(root / 'roblox/Stage9SelfTest.lua'),
}
if (root / 'roblox/Stage10SelfTest.lua').exists():
    bundle['Roblox.Stage10SelfTest'] = src(root / 'roblox/Stage10SelfTest.lua')
def long_string(text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return '[' + eq + '[\n' + text + ']' + eq + ']'
parts = ['local SOURCES = {}\n']
for k, v in bundle.items(): parts.append('SOURCES[%r] = %s\n' % (k, long_string(v)))
parts.append((root / 'tools/adapter_mock_body.luau').read_text())
(root / 'tests/stage67/adapter_mock.luau').write_text(''.join(parts), newline='\n')
print('written', sum(len(v) for v in bundle.values()))
