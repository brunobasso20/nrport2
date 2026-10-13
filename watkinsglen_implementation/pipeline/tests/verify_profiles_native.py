import sys,struct,math,json
from pathlib import Path
sys.path.insert(0,'watkinsglen_implementation/pipeline')
import ptf,render_recovery as R
from unicorn import Uc,UC_ARCH_X86,UC_MODE_32,UC_HOOK_CODE
from unicorn.x86_const import *

uc=Uc(UC_ARCH_X86,UC_MODE_32)
for p in Path('work/render_completion/dxg_memory').glob('*.bin'):
 base=int(p.stem,16);data=p.read_bytes();sz=(len(data)+4095)//4096*4096
 if base==0xffdff000:continue
 uc.mem_map(base,sz);uc.mem_write(base,data)
uc.mem_map(0x20000000,0x200000);uc.mem_map(0x30000000,0x10000)
uc.mem_map(0x40000000,0x1000);uc.mem_write(0x40000000,b'\xcc')
uc.reg_write(UC_X86_REG_FPCW,0x037f)
next_alloc=[0x20100000]
def u32(p):return struct.unpack('<I',uc.mem_read(p,4))[0]
def w32(p,x):uc.mem_write(p,struct.pack('<I',x))
def hook(uc,a,sz,data):
 if a==0x100603c6:
  sp=uc.reg_read(UC_X86_REG_ESP);out,n=u32(sp+4),u32(sp+8)
  alloc=next_alloc[0];next_alloc[0]+=(n+15)&~15;w32(out,alloc)
  uc.reg_write(UC_X86_REG_EAX,1);uc.reg_write(UC_X86_REG_ESP,sp+4);uc.reg_write(UC_X86_REG_EIP,u32(sp))
 elif a==0x100603c0:
  sp=uc.reg_read(UC_X86_REG_ESP);uc.reg_write(UC_X86_REG_ESP,sp+4);uc.reg_write(UC_X86_REG_EIP,u32(sp))
 elif a==0x40000000:uc.emu_stop()
uc.hook_add(UC_HOOK_CODE,hook)
root,s=ptf.parse(Path('work/watkins_glen.ptf').read_bytes())
seen=set();out=[]
for seg in root.segments:
 for wall in seg.w_sections:
  if not wall.wall_profile_kind:continue
  key=(wall.cubic_profile,wall.height_start,wall.height_end)
  if key in seen:continue
  seen.add(key)
  state,desc,profile=0x20000000,0x20001000,0x20002000
  uc.mem_write(state,b'\x00'*256);uc.mem_write(desc,b'\x00'*256)
  uc.mem_write(profile,wall.cubic_profile);w32(desc+0x4d,profile)
  uc.mem_write(desc+0x15,struct.pack('<d',wall.height_start));uc.mem_write(desc+0x1d,struct.pack('<d',wall.height_end))
  sp=0x3000f000;w32(sp,0x40000000);w32(sp+4,desc)
  uc.reg_write(UC_X86_REG_ESP,sp);uc.reg_write(UC_X86_REG_ECX,state)
  uc.emu_start(0x10047350,0x40000000,count=10000)
  count=struct.unpack_from('<I',wall.cubic_profile,4)[0];ptr=u32(state+0x80)
  pts=[struct.unpack('<fff',uc.mem_read(ptr+j*12,12)) for j in range(count)]
  a=u32(state+0x84);b=u32(state+0x88)
  uv0=struct.unpack('<%df'%count,uc.mem_read(a,4*count));uv1=struct.unpack('<%df'%count,uc.mem_read(b,4*count))
  base0,base1=struct.unpack('<ff',uc.mem_read(state+0x90,8))
  hs,he=struct.unpack('<dd',uc.mem_read(desc+0x15,16))
  py=R.dxg_wall_profile(wall)
  native={'points':pts,'uv0':uv0,'uv1':uv1,'base':(base0,base1),'height':(hs,he)}
  expected=[[p['lateral'],p['height'],p['arcLength']] for p in py['points']]
  mismatches=[]
  for j,values in enumerate(expected):
   for k,v in enumerate(values):
    if struct.pack('<f',v)!=struct.pack('<f',pts[j][k]):mismatches.append((j,k,v,pts[j][k]))
  for j,p in enumerate(py['points']):
   for k,n in [('uvFractionStart',uv0[j]),('uvFractionEnd',uv1[j])]:
    if struct.pack('<f',p[k])!=struct.pack('<f',n):mismatches.append((j,k,p[k],n))
  print(wall.handle,native,'mismatches',mismatches)
  out.append({'wall':wall.handle,'native':native,'python':py,'mismatches':mismatches})
Path('work/render_completion/profile_verification.json').write_text(json.dumps(out,indent=2))
