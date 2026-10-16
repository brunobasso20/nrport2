"""Small, checked source insertions shared by the repo and Studio installer.

No whole-file adapter replacement: preserve prediction, assists and local changes
outside these integration points. A missing/ambiguous anchor aborts before writes.
"""
ADAPTER_RULES = [
    ("-- TRACK1_HOST_V1", 'local M={};M.__index=M',
     '-- TRACK1_HOST_V1\nlocal track1Module=script.Parent:FindFirstChild("NR2003Track1")\n'
     'local Track1=track1Module and require(track1Module)\nlocal M={};M.__index=M'),
    ("-- TRACK1_ATTACH_V1", '    if TrackHost then TrackHost.attach(self) end',
     '    -- TRACK1_ATTACH_V1\n    if Track1 then Track1.attach(self) end\n'
     '    if TrackHost then TrackHost.attach(self) end'),
    ("-- TRACK1_AVATAR_V1", '    if self.originalTrack and not self.clientSimulation and options.prepareSpawn~=false then',
     '    -- TRACK1_AVATAR_V1\n    if self.track1 and not self.clientSimulation and options.prepareSpawn~=false then\n'
     '        Track1.prepareDriverSpawn(self)\n    end\n'
     '    if self.originalTrack and not self.clientSimulation and options.prepareSpawn~=false then'),
    ("-- TRACK1_ORIGIN_V1", 'function M:groundOrigin(pivot)\n',
     'function M:groundOrigin(pivot)\n    -- TRACK1_ORIGIN_V1\n    if self.track1 then return Track1.origin(self) end\n'),
    ("-- TRACK1_PARAMETERS_V1", '    if self.car:GetAttribute("AeroSession")==false then',
     '    -- TRACK1_PARAMETERS_V1\n    if self.track1 then Track1.applySurface(self) end\n'
     '    if self.car:GetAttribute("AeroSession")==false then'),
    ("-- TRACK1_QUERY_V1", '    self.params.FilterDescendantsInstances=occupant and {self.car,occupant.Parent} or {self.car}',
     '    -- TRACK1_QUERY_V1\n    self.params.FilterDescendantsInstances=self.track1 and {self.track1Col}\n'
     '        or (occupant and {self.car,occupant.Parent} or {self.car})'),
    ("-- TRACK1_NO_BOUNDARY_CLIP_V1", '    if not self.originalTrack and not teleport and self.rootCF then',
     '    -- TRACK1_NO_BOUNDARY_CLIP_V1: asphalt has no host-made barrier response.\n'
     '    if not self.originalTrack and not self.track1 and not teleport and self.rootCF then'),
    ("-- TRACK1_TELEMETRY_V1", '    local pedal,target,tickValue,coreBrake=self.core:brakeState()',
     '    -- TRACK1_TELEMETRY_V1\n    if self.track1 then track=Track1.telemetry(self) end\n'
     '    local pedal,target,tickValue,coreBrake=self.core:brakeState()'),
    ("-- TRACK1_CLEANUP_V1", 'function M:destroy()\n',
     'function M:destroy()\n    -- TRACK1_CLEANUP_V1\n    if Track1 then Track1.clearDriverSpawn(self) end\n'),
]
HUD_RULE = ('trackTitle.Text=string.format("WG | setup %s',
            'trackTitle.Text=string.format((tr.name=="track1" and "TRACK1" or "WG").." | setup %s')

def patch_adapter(source):
    source=source.replace('\r\n','\n')
    for marker,old,new in ADAPTER_RULES:
        if marker in source:
            if source.count(marker)!=1 or new not in source:
                raise ValueError(f'Partially edited track1 hook: {marker}')
            continue
        if source.count(old)!=1:
            raise ValueError(f'Unsupported adapter: expected one anchor for {marker}')
        source=source.replace(old,new,1)
    return source

if __name__=='__main__':
    from pathlib import Path
    path=Path(__file__).resolve().parents[1]/'roblox/CupChassisAdapter.lua'
    path.write_text(patch_adapter(path.read_text()),encoding='utf-8',newline='\n')
