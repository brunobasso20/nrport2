#!/usr/bin/env python3
"""Exercise actual track avatar placement and SeatAccess with delayed character creation."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]


def quote(source):
    eq = '='
    while ']' + eq + ']' in source:
        eq += '='
    return '[' + eq + '[\n' + source + ']' + eq + ']'


geometry = (root / 'tools/adapter_mock_body.luau').read_text().split('-- world: ground plane', 1)[0]
parts = [geometry]
for name, path in [('HOST', 'roblox/NR2003WatkinsGlen.lua'),
                   ('ACCESS', 'roblox/SeatAccess.lua'), ('CONFIG', 'roblox/DriverConfig.lua')]:
    parts.append('local ' + name + '_SOURCE = ' + quote((root / path).read_text()) + '\n')
parts.append((root / 'watkinsglen_implementation/tests/spawn_mock_body.luau').read_text())
output = root / 'work/wg_spawn_mock/mock.luau'
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(''.join(parts))
