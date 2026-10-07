"""Run recovered ORIGINAL x86 functions in Unicorn, never launch NR2003.exe.
Requires unicorn==2.1.4. Input: the three memory exports from ExportVehicleCore.java.
Produces independent golden fixtures for core stages and drivetrain projection.
The host setup is synthetic and explicit; this is not recorded in-game telemetry.
"""
from pathlib import Path
import struct,json,hashlib
from unicorn import Uc,UC_ARCH_X86,UC_MODE_32
from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_EIP,UC_X86_REG_FPCW
ROOT=Path(__file__).resolve().parents[1]
MEM=ROOT/'recovery/vehicle_core'
F=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
bits=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
def lua(v):
    if v is None:return 'nil'
    if isinstance(v,bool):return 'true' if v else 'false'
    if isinstance(v,str):return json.dumps(v)
    if isinstance(v,(float,int)):return repr(v)
    if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
    return '{'+','.join('['+lua(k)+']='+lua(x) for k,x in v.items())+'}'
class Machine:
    def __init__(self):
        self.uc=Uc(UC_ARCH_X86,UC_MODE_32); self.uc.mem_map(0x400000,0x1000000)
        for base in (0x400000,0x6e9000,0x71b000):self.uc.mem_write(base,(MEM/f'{base:08x}.bin').read_bytes())
        self.uc.mem_map(0x2000000,0x1000000);self.heap=0x2000000;self.stack=0x2f00000;self.end=0x2fff000
        self.u32(0x74fe48,0x74fde0);self.u32(0x74fe4c,0x74fdf0);self.u32(0xd47d6c,1)
        self.uc.reg_write(UC_X86_REG_FPCW,0x037f)
        for start,end in ((0xe84420,0xe84d00),(0xeacf68,0xead280)):
            for a in range(start,end,4):self.u32(a,self.cell(0))
    def alloc(self,n):
        a=self.heap;self.heap+=(n+15)&~15;assert self.heap<self.stack-4096;return a
    def u32(self,a,v):self.uc.mem_write(a,struct.pack('<I',v&0xffffffff))
    def read32(self,a):return struct.unpack('<I',self.uc.mem_read(a,4))[0]
    def cell(self,v):a=self.alloc(4);self.uc.mem_write(a,struct.pack('<f',v));return a
    def set(self,a,values):
        for i,v in enumerate(values):self.uc.mem_write(self.read32(a+4*i),struct.pack('<f',v))
    def values(self,a,n):return [struct.unpack('<f',self.uc.mem_read(self.read32(a+4*i),4))[0] for i in range(n)]
    def pointers(self,values):
        a=self.alloc(4*len(values))
        for i,v in enumerate(values):self.u32(a+4*i,self.cell(v))
        return a
    def call(self,address,*args):
        self.uc.mem_write(self.stack,struct.pack('<'+'I'*(len(args)+1),self.end,*args))
        self.uc.reg_write(UC_X86_REG_ESP,self.stack)
        self.uc.emu_start(address,self.end,count=3000000)
        assert self.uc.reg_read(UC_X86_REG_EIP)==self.end,hex(address)
    def node(self,r):
        a=self.alloc(0x510);flags=r['flags'];self.u32(a+0x40,flags)
        for offset in range(0x95,0x505,4):self.u32(a+offset,self.cell(0))
        free=[i for i in range(3) if flags&(1<<i)];axis=(flags>>3)&3
        if axis:free.append(axis+2)
        elif flags&0x20:free.extend((3,4,5))
        self.u32(a+0x79,len(free))
        for i,v in enumerate(free):self.u32(a+0x7d+4*i,v)
        mask=[float(i==j and i not in free) for i in range(6) for j in range(6)]
        self.set(a+0x95,mask)
        mass=[r['mass']]*3+r['inertia']
        self.set(a+0x125,[mass[i] if i==j else 0 for i in range(6) for j in range(6)])
        self.set(a+0x1b5,r['offset'])
        self.call(0x5b8c40,a+0x1c1,*map(bits,r['angles']))
        eye=[float(i==j) for i in range(3) for j in range(3)]
        for offset in (0x221,0x251,0x2d9,0x309,0x339):self.set(a+offset,eye)
        for offset in (0x275,0x35d):self.set(a+offset,[0,0,0,1])
        return a
    def graph(self,records):
        nodes={r['name']:self.node(r) for r in records}; children={}
        for r in records:
            a=nodes[r['name']];p=nodes.get(r['parentName'],0);self.u32(a+0x6d,p)
            if p:children.setdefault(p,[]).append(a)
        for p,ch in children.items():
            self.u32(p+0x75,ch[0])
            for a,b in zip(ch,ch[1:]):self.u32(a+0x71,b)
        self.set(0xe84474,[0]*9);self.u32(0xe84664,0xe84474)
        root=nodes[records[0]['name']];self.call(0x5b39a0,root);self.call(0x5b2fb0,root)
        return root,nodes
def record(name,parent='inertial',flags=39,mass=1000,inertia=(200,300,400),offset=(0,0,0),angles=(0,0,0)):
    return dict(name=name,parentName=parent,flags=flags,mass=F(mass),inertia=list(map(F,inertia)),offset=list(map(F,offset)),angles=list(map(F,angles)))
def fixture(name,records):
    machine=Machine();root,nodes=machine.graph(records)
    forces={r['name']:[F((i+1)*.11*(j+1)*(1 if j%2==0 else -1)) for j in range(6)] for i,r in enumerate(records)}
    def apply(multiplier):
        for n,a in nodes.items():machine.set(a+0x39d,[F(x*multiplier) for x in forces[n]])
    fields={'translation':(0x2cd,3),'orientation':(0x35d,4),'velocity':(0x385,6),
        'totalVelocity':(0x3cd,6),'worldPosition':(0x32d,3),'worldRotation':(0x339,9),
        'momentum':(0x36d,6),'compositeInertia':(0x475,36)}
    def pack():return {n:{k:machine.values(a+off,size) for k,(off,size) in fields.items()} for n,a in nodes.items()}
    apply(1);machine.call(0x5b2fb0,root);steps=[]
    for tick in range(4):
        machine.u32(0xe84664,0xe84474);machine.call(0x5b39a0,root);machine.call(0x5b3180,root)
        predictor=pack();apply(1+.1*tick)
        machine.u32(0xe84664,0xe84474);machine.call(0x5b3e50,root);machine.call(0x5b3180,root)
        corrector=pack();apply(1+.2*tick);machine.call(0x5b2fb0,root)
        steps.append(dict(predictor=predictor,corrector=corrector))
    return dict(name=name,records=records,forces=forces,steps=steps)
def projection(gear,engagement):
    m=Machine();params=dict(engineInertia=F(.12),clutchInertia=F(.08),outputInertia=F(.12),wheelInertia=F(1.66),gearRatio=F(gear),finalDrive=F(3.7),clutchEngagement=F(engagement))
    for ptr,key,axis in ((0xc08318,'engineInertia',0),(0xc08500,'clutchInertia',0),(0xc08394,'outputInertia',0),(0xc084b4,'wheelInertia',1)):
        inertia=[0,0,0];inertia[axis]=params[key];node=m.node(record(key,flags=8 if axis==0 else 16,mass=0,inertia=inertia));m.u32(ptr,node)
    for a in range(0x74e7b8,0x74e848,4):m.u32(a,m.cell(0))
    setup=m.alloc(0x400);m.uc.mem_write(setup+0x66*4,struct.pack('<f',gear));m.uc.mem_write(setup+0x6e*4,struct.pack('<f',3.7))
    context=m.alloc(0x100);m.uc.mem_write(context+8,struct.pack('<f',-100))
    # Stub ONLY external setup/context getters. All arithmetic remains original x86.
    m.uc.mem_write(0x6c5018,b'\xb8'+struct.pack('<I',0)+b'\xc3')
    m.uc.mem_write(0x51c2d0,b'\xb8'+struct.pack('<I',context)+b'\xc3')
    m.uc.mem_write(0x557d60,b'\x8b\x44\x24\x04\x8d\x04\x85'+struct.pack('<I',setup)+b'\xc2\x04\x00')
    inp=m.alloc(8);m.uc.mem_write(inp,struct.pack('<ff',engagement,0));m.call(0x55fc50,inp)
    return dict(parameters=params,matrix=m.values(0x74e7b8,36))
if __name__=='__main__':
    baseline=json.loads((ROOT/'recovery/baseline/embedded_baseline.json').read_text());full=[]
    for r in baseline['components']:
        v=r['rawFieldsF32'];full.append(record(r['name'],r['parentName'],r['flags'],abs(v['0x5d']),
            [abs(v[k]) for k in ('0x61','0x65','0x69')],[v[k] for k in ('0x44','0x48','0x4c')],
            [F(v[k]*baseline['angleScale']) for k in ('0x51','0x55','0x59')]))
    single=[record('chassis')]
    tree=single+[record('slider','chassis',4,30,(1,2,3),(1,.5,-.2)),record('rotor','slider',16,0,(0,1.7,0))]
    rotated=[record('chassis',angles=(.3,-.2,.1)),record('slider','chassis',4,30,(1,2,3),(1,.5,-.2),(.1,.2,.3)),record('rotor','slider',16,0,(0,1.7,0),angles=(.2,-.1,.3))]
    result={'metadata':{'source':'NR2003.exe original x86 in Unicorn 2.1.4','dispatchMode':1,'fpcw':'0x037f','stepsPerCase':4,
        'memorySHA256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in MEM.glob('*.bin')}},
        'cases':[fixture(n,r) for n,r in (('single',single),('tree',tree),('rotated',rotated),('baseline16',full))],
        'drivetrain':[projection(g,e) for g in (0,2.5,1,-2.4) for e in (0,.5,.9,1)]}
    out=ROOT/'tests/fixtures';out.mkdir(exist_ok=True)
    (out/'original_x86.json').write_text(json.dumps(result,indent=2)+'\n')
    (out/'original_x86.lua').write_text('-- Generated by recovery/original_x86_reference.py; original x86 output.\nreturn '+lua(result)+'\n')
    print('Golden fixtures:',len(result['cases']),'core cases,',len(result['drivetrain']),'projection cases')
