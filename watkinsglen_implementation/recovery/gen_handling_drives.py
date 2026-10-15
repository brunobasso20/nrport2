"""Original stock-setup drives with ORIGINAL throttle/clutch processing.

Unlike the older track fixtures, keyboard throttle is NOT injected as an
already-processed pedal. OriginalStage13 calls 00552df0 and 005534f0 in order.
"""
import json
import os
from pathlib import Path
import struct
import sys
import time

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'watkinsglen_implementation/recovery'))
sys.path.insert(0,str(ROOT/'recovery/stage10'))
import orig_world as W
import orig_setup as OS


def controls(frame):
    return dict(originalPedals=True,throttle=1 if 24<=frame<100 or frame>=112 else 0,
                throttleControl=1 if 24<=frame<100 or frame>=112 else 0,throttleDigital=True,
                brakeControl=1 if 100<=frame<108 else 0,brakeDigital=True,clutch=1,
                steerLeft=1 if 126<=frame<128 else 0,steerRight=0,steerDigital=True,shiftUp=frame==18)


def main():
    setups=json.loads((ROOT/'watkinsglen_implementation/handling/setup_sources.json').read_text())
    fixtures={}
    for name in ('fast','easy'):
        begin=time.monotonic()
        W.SNAPSHOT['on']=False;W.SNAPSHOT['trace']=False;W.SNAPSHOT['eips']=set()
        W.configure(os.environ['WG_TRACK'],os.environ['WG_SHARED'],os.environ['SERVER_MEM'],rts_mem=os.environ['RTS_MEM'])
        initial=[0.0]*45;initial[4]=.42;initial[9]=1
        o=W.OriginalWorld(state=initial,weather=dict(temperature=70,wind_mph=0,wind_dir=0,conditions=0,night=0),
                          ffb=dict(enabled=False),device=dict(capable=False),damage_level=0,enter=False,
                          steer_options=dict(momentum=0))
        m=o.m
        previous_bg=bytes(m.uc.mem_read(OS.BG_FLAG,1));m.uc.mem_write(OS.BG_FLAG,b'\0')
        m.fpcw=0x027f
        data=(Path(os.environ['WG_TRACK'])/setups[name]['file']).read_bytes()
        chunk=data.index(b'DGTS');version,size=struct.unpack_from('<II',data,chunk+4)
        packed=m.alloc(size,data[chunk+12:chunk+12+size])
        assert m.call(0x558830,0,version,packed,size,ecx=OS.GARAGE)==size
        assert m.call(0x558da0,ecx=OS.GARAGE)!=0
        m.fpcw=0x077f
        OS.apply(m,{i:m.u32(OS.GARAGE+4*i) for i in range(184)})
        m.uc.mem_write(OS.BG_FLAG,previous_bg)
        # Explicitly disable the three boolean aids and steering assistance.
        m.uc.mem_write(0xbf6f04,b'\0\0\0');m.w32(0xbf6f08,0)
        o.enter((255.0,-.21,0.0))
        rows=[]
        print(name,'original placed',round(time.monotonic()-begin,2),flush=True)
        for frame in range(144):
            command=controls(frame)
            for _ in range(8):o.step_driver(command)
            state=o.state()
            wheels=[]
            for w in range(4):
                t=0xbf3a20+w*0xa39
                wheels.append([m.u32(t+0x2c0),m.f32(t+0x2d8),m.f32(t+0x2dc),m.f32(t+0x2e0),m.f32(t+0x2ec)])
            rows.append(dict(state=state,wheels=wheels,throttle=m.u32(0xbf6390),clutch=m.u32(0xbf6eb0),gear=m.i32(0x74c97c)))
            if (frame+1)%36==0:print(name,'frame',frame+1,flush=True)
        fixtures[name]=rows
        print(name,'complete',round(time.monotonic()-begin,2),flush=True)
    out=ROOT/'watkinsglen_implementation/handling/tests/driving_fixtures.lua'
    def lua(value):
        if isinstance(value,dict):return '{'+','.join('['+json.dumps(str(k))+']='+lua(v) for k,v in value.items())+'}'
        if isinstance(value,list):return '{'+','.join(lua(v) for v in value)+'}'
        return repr(value)
    out.write_text('-- Original x86 stock-setup drives; no processed-throttle injection.\nreturn '+lua(fixtures)+'\n')


if __name__=='__main__':main()
