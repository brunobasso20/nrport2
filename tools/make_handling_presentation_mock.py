#!/usr/bin/env python3
"""Run the actual track HUD callback and actual presentation buffer in Luau."""
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
def quote(text):
    eq='='
    while ']'+eq+']' in text:eq+='='
    return '['+eq+'[\n'+text+']'+eq+']'

client=(ROOT/'nr2003carmodel_implementation/roblox/Bench/Client.client.lua').read_text()
callback=client.split('telemetry.OnClientEvent:Connect(function(data)\n',1)[1].split('\nend)\n-- Stage 13 presentation',1)[0]
materials=re.search(r'local surfaceNames=(\{.*?\})\nlocal hint=',client,re.S)[1]
hud='return function(data)\n'+callback+'\nend\n'
mock=ROOT/'watkinsglen_implementation/tests/adapter_track.luau'
out=ROOT/'work/handling_audit/hud_mock.luau'
code=mock.read_text().replace(
    'if not ok then ok, v = pcall(require, "../core/NR2003Cup/" .. m) end',
    'if not ok then ok, v = pcall(require, "../../watkinsglen_implementation/core/NR2003Cup/" .. m) end')
code+='\nlocal HUD_CALLBACK='+quote(hud)+'\nlocal HUD_MATERIALS='+materials+'\n'
code+=(ROOT/'watkinsglen_implementation/handling/tests/hud_mock_body.luau').read_text()
out.write_text(code)
geometry=(ROOT/'tools/adapter_mock_body.luau').read_text().split('-- world: ground plane',1)[0]
parts=[geometry,'local SOURCES={}\n']
for name in ('RenderConfig','RenderPresentation','RenderSnapshot','SnapshotBuffer'):
    parts.append('SOURCES["'+name+'"]='+quote((ROOT/'roblox'/ (name+'.lua')).read_text())+'\n')
parts.append((ROOT/'watkinsglen_implementation/handling/tests/presentation_mock_body.luau').read_text())
(ROOT/'work/handling_audit/presentation_mock.luau').write_text(''.join(parts))
