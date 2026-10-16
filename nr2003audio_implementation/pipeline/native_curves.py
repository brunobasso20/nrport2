"""Compile nonlinear CES curves using the recovered original x86 constructors.

Requires a private ExportMemoryPy.py dump of NR2003.exe and unicorn==2.1.4.
The encrypted CRT pow/ftol/modf helpers use explicit x87 bridges. This is the
same kind of host boundary as the existing physics reference, not a listening
test or a claim of binary identity with the encrypted CRT.
"""
from pathlib import Path
import struct

F32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
BITS=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
POW=bytes.fromhex('d9c9d9e4dfe09e7507ddd8ddd8d9eec3d9f1d9c0d9fcdce9d9c9d9f0d9e8dec1d9fdddd9c3')
FTOL=bytes.fromhex('83ec0cd97c2408668b44240880cc0c668944240ad96c240adf3c24d96c24088b04248b54240483c40cc3')
MODF=bytes.fromhex('83ec04d93c24668b042480cc0c6689442402d96c2402dd442408d9c0d9fcd92c248b442410dd10dee983c404c3')

class NativeCurves:
    def __init__(self,memory):
        from unicorn import Uc,UC_ARCH_X86,UC_MODE_32
        from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_ECX,UC_X86_REG_FPCW,UC_X86_REG_EIP
        self.regs=UC_X86_REG_ESP,UC_X86_REG_ECX,UC_X86_REG_FPCW,UC_X86_REG_EIP
        self.u=Uc(UC_ARCH_X86,UC_MODE_32);u=self.u
        u.mem_map(0x400000,0x1000000)
        for p in Path(memory).glob('*.bin'):
            a=int(p.stem,16)
            if 0x400000<=a and a+p.stat().st_size<=0x1400000:u.mem_write(a,p.read_bytes())
        # Fail on an incompatible executable rather than running another build's
        # addresses and silently producing arbitrary response curves.
        if bytes(u.mem_read(0x4e98f0,3))!=bytes.fromhex('83ec20'):
            raise ValueError('Reference memory is not the supported OpenNR2003 NR2003.exe image')
        u.mem_map(0x2000000,0x200000);u.mem_write(0x2000000,b'\xf4')
        for a,b in [(0x6c5c40,POW),(0x6c5018,FTOL),(0x6c6a24,MODF)]:u.mem_write(a,b)
        self.obj,self.out=0x2010000,0x2020000

    def f(self,a):return struct.unpack('<f',self.u.mem_read(a,4))[0]
    def call(self,address,args=()):
        esp,ecx,cw,eip=self.regs;stack=0x21ff000
        self.u.mem_write(stack,struct.pack('<'+'I'*(len(args)+1),0x2000000,*args))
        self.u.reg_write(esp,stack);self.u.reg_write(ecx,self.obj);self.u.reg_write(cw,0x37f)
        self.u.emu_start(address,0x2000000,count=5000000)
        if self.u.reg_read(eip)!=0x2000000:raise RuntimeError('Original curve did not return')

    def initialize(self,kind,p):
        u,o=self.u,self.obj
        vt,init,self.evaluate_address={0:(0x6f3864,0x4e9c20,0x4e9bd0),
            1:(0x6f3884,0x4e98f0,0x4e9570),2:(0x6f38b0,0x4e93c0,0x4e9250)}[kind]
        u.mem_write(o,b'\0'*0x1000);u.mem_write(o,struct.pack('<I',vt))
        u.mem_write(o+(12 if kind==0 else 4),struct.pack('<'+'f'*len(p),*p))
        if kind==1:u.mem_write(o+0x861,struct.pack('<3I',0x4e9500,0x4e9510,0x4e9540))
        if kind==2:
            u.mem_write(o+0x84d,struct.pack('<3I',0x4e9130,0x4e9180,0x4e9200))
            u.mem_write(o+0x2c,struct.pack('<f',1/(p[9]-p[8]) if p[8]!=p[9] else 1))
        self.call(init)

    def evaluate(self,x):
        self.call(self.evaluate_address,(self.out,BITS(x),0))
        return self.f(self.out+4)

    def compile(self,kind,p):
        self.initialize(kind,p);o=self.obj
        if kind==0:
            return {'kind':0,**({'constant':p[1]} if p[0]==p[2] else
                {'intercept':self.f(o+4),'slope':self.f(o+8)})}
        if kind==1:
            def side(table,domain,baseline):
                ys=[self.f(o+table+8*i+4) for i in range(128)]
                return {'min':self.f(o+domain),'inv':self.f(o+domain+8),
                    'baseline':self.f(o+baseline),'y':ys+[ys[-1]]}
            return {'kind':1,'center':self.f(o+4),'half':self.f(o+0x1c)*0.5,'peak':self.f(o+0x18),
                'left':side(0x21,0x429,0xc),'right':side(0x435,0x83d,0x10)}
        ys=[self.f(o+0x39+8*i) for i in range(256)]
        return {'kind':2,'min':self.f(o+0x24),'inv':self.f(o+0x2c),
            'slopeLeft':self.f(o+0x83d),'slopeRight':self.f(o+0x845),'y':ys+[ys[-1]]}

def compile_curve(kind,p,native=None):
    if kind in (3,4):return {'kind':kind}
    if kind==0:
        x0,y0,x1,y1,_=p
        if x0==x1:return {'kind':0,'constant':y0}
        slope=F32((y1-y0)/(x1-x0))
        return {'kind':0,'slope':slope,'intercept':F32(y0-slope*x0)}
    if native is None:
        raise ValueError('Nonlinear original CES curve requires --reference-memory (no guessed envelope fallback)')
    return native.compile(kind,p)
