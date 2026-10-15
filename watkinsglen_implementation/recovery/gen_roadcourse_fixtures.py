"""Independent original x86 road-course references for launch and concrete contact.

The old V5 references inherited chassis_type=2. These runs explicitly select 4,
load stock setup files through 00558830, and turn every boolean aid off.
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
import orig_setup as S

CASES={'pit_fast':('fast',(341.13,-19.61,0),144),
       'pit_easy':('easy',(341.13,-19.61,0),144),
       'concrete_fast':('fast',(799.8,-2.8,0),144)}

def controls(frame,curve):
    throttle=1 if frame>=24 else 0
    return dict(originalPedals=True,throttle=throttle,throttleControl=throttle,throttleDigital=True,
                brakeControl=0,brakeDigital=True,clutch=1,steerLeft=1 if curve and 126<=frame<128 else 0,
                steerRight=0,steerDigital=True,shiftUp=frame==18)


def main():
    fixtures={}
    for name,(setup,start,frames) in CASES.items():
        begun=time.monotonic()
        W.SNAPSHOT['on']=False;W.SNAPSHOT['trace']=False;W.SNAPSHOT['eips']=set()
        W.configure(os.environ['WG_TRACK'],os.environ['WG_SHARED'],os.environ['SERVER_MEM'],rts_mem=os.environ['RTS_MEM'])
        st=[0.]*45;st[4]=.42;st[9]=1
        o=W.OriginalWorld(chassis_type=4,state=st,enter=False,damage_level=0,
                          weather=dict(temperature=70,wind_mph=0,wind_dir=0,conditions=0,night=0),
                          ffb=dict(enabled=False),device=dict(capable=False),steer_options=dict(momentum=0))
        m=o.m;m.uc.mem_write(S.BG_FLAG,b'\0');m.fpcw=0x027f
        data=(Path(os.environ['WG_TRACK'])/(setup+'.cup.sim')).read_bytes();i=data.index(b'DGTS');v,n=struct.unpack_from('<II',data,i+4)
        p=m.alloc(n,data[i+12:i+12+n]);assert m.call(0x558830,0,v,p,n,ecx=S.GARAGE)==n;assert m.call(0x558da0,ecx=S.GARAGE)
        m.fpcw=0x077f;S.apply(m,{i:m.u32(S.GARAGE+4*i) for i in range(184)})
        m.uc.mem_write(S.BG_FLAG,b'\1');m.uc.mem_write(0xbf6f04,b'\0\0\0');m.w32(0xbf6f08,0)
        spec=m.u32(S.SLOT+0x58a)
        static={a:m.u32(a) for a in range(spec,spec+0x1c8,4)}
        for w in range(4):
            tire=0xbf3a20+w*0xa39;profile=m.u32(tire+0x70)
            assert profile==0x8b0fa0
            for a in range(profile,profile+0x90,4):static[a]=m.u32(a)
        o.enter(start);rows=[];print(name,'placed',time.monotonic()-begun,flush=True)
        for frame in range(frames):
            for _ in range(8):o.step_driver(controls(frame,name=='concrete_fast'))
            wheels=[]
            for w in range(4):
                t=0xbf3a20+w*0xa39
                wheels.append([m.u32(t+0x2c0),m.f32(t+0x2d8),m.f32(t+0x2dc),m.f32(t+0x2e0),m.f32(t+0x2ec)])
            rows.append(dict(state=o.state(),wheels=wheels,throttle=m.u32(0xbf6390),clutch=m.u32(0xbf6eb0),gear=m.i32(0x74c97c)))
        fixtures[name]=dict(setup=setup,start=start,rows=rows,static=static)
        print(name,'complete',time.monotonic()-begun,flush=True)
    out=ROOT/'watkinsglen_implementation/roadcourse/tests';out.mkdir(parents=True,exist_ok=True)
    def lua(v):
        if isinstance(v,dict):return '{'+','.join('['+json.dumps(str(k))+']='+lua(x) for k,x in v.items())+'}'
        if isinstance(v,(list,tuple)):return '{'+','.join(map(lua,v))+'}'
        if isinstance(v,str):return json.dumps(v)
        return repr(v)
    (out/'driving_fixtures.lua').write_text('-- Original x86 1.2.0.1; road-course chassis; real file reader; raw keyboard; all aids off.\nreturn '+lua(fixtures)+'\n')

if __name__=='__main__':main()
