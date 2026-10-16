"""Bundle the actual installer and transaction code into a minimal Studio mock."""
from pathlib import Path
from track1_patch_rules import ADAPTER_RULES,HUD_RULE
from build_track1 import literal
ROOT=Path(__file__).resolve().parents[1]
prefix=(ROOT/'tools/adapter_mock_body.luau').read_text().split('-- world: ground plane',1)[0]
parts=[prefix]
for key,path in [('INSTALLER','track1_implementation/studio/installer_template.luau'),
                 ('JOURNAL','track1_implementation/studio/transaction.lua'),
                 ('SURFACE','core/NR2003Track1Surface.lua'),('HOST','roblox/NR2003Track1.lua')]:
    parts.append('local '+key+'='+literal((ROOT/path).read_text())+'\n')
old=(ROOT/'roblox/CupChassisAdapter.lua').read_text()
for marker,before,after in reversed(ADAPTER_RULES):
    assert old.count(after)==1,marker
    old=old.replace(after,before,1)
parts.append('local BASE_ADAPTER='+literal(old)+'\n')
parts.append('local RULES={'+','.join('{'+','.join(literal(v) for v in r)+'}' for r in ADAPTER_RULES)+'}\n')
parts.append('local HUD_RULE={'+','.join(literal(v) for v in HUD_RULE)+'}\n')
parts.append((ROOT/'tests/track1/installer_body.luau').read_text())
(ROOT/'tests/track1/generated_installer.luau').write_text(''.join(parts))
print('Built track1 installer mock from actual sources')
