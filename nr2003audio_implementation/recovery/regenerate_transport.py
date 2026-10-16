"""Probe original CES transport decisions, with the original clock as host input.

No native code is patched. Callback lists are empty: this isolates 004eac30 /
004f02d0 state decisions from platform playback. Fixtures contain no recordings.
"""
from pathlib import Path
import argparse,json,random,struct,sys
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'pipeline'))
from native_curves import NativeCurves,BITS,F32

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--memory',type=Path,required=True)
    ap.add_argument('--out-dir',type=Path,default=HERE.parent/'tests');a=ap.parse_args()
    a.out_dir.mkdir(parents=True,exist_ok=True)
    native=NativeCurves(a.memory);u=native.u;o=native.obj
    shared,bank=0x2030000,0x2040000
    def i(addr,x):u.mem_write(addr,struct.pack('<I',x))
    def f(addr,x):u.mem_write(addr,struct.pack('<f',x))
    def d(addr,x):u.mem_write(addr,struct.pack('<d',x))
    rng=random.Random(2003);cases=[]
    for n in range(2400):
        phase=rng.randrange(4)
        rpm=F32(rng.choice([0,300,799.99,800,800.01,999.99,1000,1000.01,6000]))
        load=F32(rng.choice([0,.0000999,.0001,.0001001,.19999,.2,.20001,1]))
        gate=F32(rng.choice([-2.5,-2.49,-2,-1.5,-1.49,-1,-.51,-.5,0,800,10000]))
        intro,outro=rng.randrange(2),rng.randrange(2)
        rt,lt=rng.choice([(0,0),(1000,0),(0,.2),(1000,.2),(-1,-1)])
        rt,lt=F32(rt),F32(lt)
        now=rng.choice([-1,0,1,1.49999,1.5,1.50001,2]);last=1 if phase<2 else -1000
        u.mem_write(o,b'\0'*0x1000);u.mem_write(shared,b'\0'*0x100)
        i(o+0x14,shared);i(o+0x28,bank);u.mem_write(o+0x7c0,b'\x01\x01\x01')
        for off,value in [(0x290,intro),(0x2d4,intro),(0x3a0,outro),(0x3e4,outro)]:i(o+off,value)
        i(shared+0x1c,phase);d(shared+0x28,last)
        f(bank+0x1824,rt);f(bank+0x1828,lt);d(0xa6c238,now)
        native.call(0x4eac30,(BITS(rpm),BITS(load),BITS(1),1,BITS(gate)))
        result=struct.unpack('<I',u.mem_read(shared+0x1c,4))[0]
        stamp=struct.unpack('<d',u.mem_read(shared+0x28,8))[0]
        cases.append([phase,rpm,load,gate,intro,outro,rt,lt,now,last,result,stamp])
    target=a.out_dir/'transport_golden.lua'
    target.write_text('-- Original x86 CES transport; platform callback lists intentionally empty.\nreturn {\n'+
        ',\n'.join('{'+','.join(map(str,row))+'}' for row in cases)+'\n}\n')
    print('Regenerated',len(cases),'original transport vectors')
    from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_ESI,UC_X86_REG_EDI,UC_X86_REG_EBX,UC_X86_REG_EBP,UC_X86_REG_FPCW
    from regenerate_curves import lua
    stack=0x21ff000;car=0x2050000
    fade=[];aggregation=[];uniform=[];weights=[]
    for value in [0,.00001,.125,.25,.5,.75,1,1.25]:
        for step in [-.25,0,.25]:
            f(car+0x60,value);f(car+0x70,step)
            for reg,x in [(UC_X86_REG_ESP,stack),(UC_X86_REG_ESI,car),(UC_X86_REG_EBX,0),(UC_X86_REG_FPCW,0x37f)]:u.reg_write(reg,x)
            u.emu_start(0x5644d0,0x56450d,count=100)
            fade.append([F32(value),step,native.f(car+0x60)])
    for n in range(32):
        wheels=[]
        for j in range(4):
            w=[F32(rng.random()*2),F32(rng.random()*2),F32(rng.random()*2),rng.randrange(5)]
            wheels.append(w)
            for off,x in zip([0x11cb,0x11db,0x11eb],w):f(car+off+j*4,x)
            i(car+0x120b+j*4,w[3])
        i(stack+0x34,car+0x11db)
        for reg,x in [(UC_X86_REG_ESP,stack),(UC_X86_REG_EDI,car),(UC_X86_REG_EBX,car+0x11eb),(UC_X86_REG_EBP,car+0x120b),(UC_X86_REG_FPCW,0x37f)]:u.reg_write(reg,x)
        u.emu_start(0x563d35,0x563dbc,count=500)
        result=[native.f(car+off) for off in [0x11cb,0x11db,0x11eb]]+[struct.unpack('<I',u.mem_read(car+0x120b,4))[0]]
        aggregation.append({'wheels':wheels,'result':result})
    # Read the real x87 return value without a host floating-point replacement.
    u.mem_write(0x2000100,b'\xdd\x1d'+struct.pack('<I',native.out)+b'\xc3')
    for seed in [0,1,0x7fffffff,0x80000000,0xffffffff]+[rng.randrange(0x100000000) for _ in range(27)]:
        i(0xf6eae4,seed);native.call(0x5f56b0,(0,));native.call(0x2000100)
        uniform.append([seed,struct.unpack('<I',u.mem_read(0xf6eae4,4))[0],struct.unpack('<d',u.mem_read(native.out,8))[0]])
    for n in range(80):
        options=[0,.1,.25,.5,1,2] if n<64 else [0,.25,1,'inactive']
        values=[rng.choice(options) for _ in range(3)]
        if n>=64:values[n%3]='inactive'
        enabled=[rng.randrange(2) for _ in values]
        curves=[]
        for j,value in enumerate(values):
            if value=='inactive':curves.append(None);continue
            native.initialize(0,[0,value,0,value,0])
            ptr=0x2070000+j*0x1000;u.mem_write(ptr,bytes(u.mem_read(o,0x1000)));curves.append(ptr)
        native.initialize(0,[0,1,0,1,0]);u.mem_write(0x207f000,bytes(u.mem_read(o,0x1000)))
        u.mem_write(o,b'\0'*0x1000);u.mem_write(o+0x7c1,b'\x01\x01')
        i(o+0x70,len(values));i(0x7559c4,0)
        for j,ptr in enumerate(curves):
            sample=0x2060000+j*0x100;u.mem_write(sample,b'\0'*0x100)
            i(o+0x30+j*4,sample);i(sample+0xb9,j);i(o+0x610+j*4,1)
            i(sample+0x40+0x14,ptr or 0);i(sample+0x58+0x14,0 if ptr is None else 0x207f000)
            f(o+0x478+j*13,1)
        native.call(0x4eb260);native.call(0x2000100)
        weights.append({'values':values,'enabled':enabled,'weights':[native.f(o+0x694+j*8) for j in range(3)],
            'amplitude':struct.unpack('<d',u.mem_read(native.out,8))[0]})
    target=a.out_dir/'mixer_golden.lua'
    target.write_text('-- Original x86 instruction/routine probes; host memory inputs are explicit.\nreturn '+lua({'fade':fade,'aggregation':aggregation,'uniform':uniform,'weights':weights})+'\n')
    print('Regenerated',len(fade)+len(aggregation)+len(uniform)+len(weights),'original tire/random/mixer vectors')
if __name__=='__main__':main()
