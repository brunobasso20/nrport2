"""Recover the road-course vehicle selection omitted by the V4/V5 track host.

Run with original NR2003/server/rts exports and supplied WG_TRACK / WG_SHARED.
Generate setup-independent road build callbacks and placed callbacks with the
ORIGINAL x86 emitter. Values come from chassis_type=4, not grip tuning.
"""
import base64
import hashlib
import json
import os
from pathlib import Path
import pickle
import re
import struct
import time

import gen_placed as G
import orig_setup as S
from emitter_control import LiteralControl, install, fold_table

ROOT=G.REPO
OUT=ROOT/'watkinsglen_implementation/core/NR2003Cup'
REPORT=ROOT/'watkinsglen_implementation/roadcourse'
NAMES=('default','fast','easy','qualify','jasper')


def policy(tables):
    f,lf,la=tables
    force={({'Z':'z','0':'z','O':'o','2':'o','N':'a','n':'a'}[c],i)
           for i,c in enumerate(f) if c in 'Z0O2Nn'}
    owners,follow={},{}
    for i,(append,address) in enumerate(zip(lf,la)):
        if append:follow[i]='append';owners[address]=i
        else:follow[i]=('m',owners[address])
    return force,follow


def summary(m,tab):
    end=m.u32(0xebbcec)
    return {'pool':m.u32(0xd47d60),'litTop':m.u32(0xec02c4),'codeEnd':end,
            'nlit':len(tab[1]),'nfold':len(tab[0]),'slots':[m.u32(s) for s in G.SLOT_ORDER],
            'codeSHA256':hashlib.sha256(bytes(m.uc.mem_read(0xead280,end-0xead280))).hexdigest()}


def block(name,t,r):
    f,lf,la=t
    return ('%s = {fold = "%s",\nlitf = "%s",\nlita = "%s",\n'%(name,f,
            ''.join('1' if x else '0' for x in lf),base64.b64encode(struct.pack('<'+'I'*len(la),*la)).decode())+
            'ref = {pool = %d, litTop = %d, codeEnd = %d, nlit = %d, nfold = %d, slots = {%s}}},\n'%(
                r['pool'],r['litTop'],r['codeEnd'],r['nlit'],r['nfold'],','.join(map(str,r['slots']))))


def setup_file(m,name):
    if name=='default':return None
    m.fpcw=0x027f
    data=(Path(os.environ['WG_TRACK'])/(name+'.cup.sim')).read_bytes()
    at=data.index(b'DGTS');v,n=struct.unpack_from('<II',data,at+4)
    p=m.alloc(n,data[at+12:at+12+n])
    assert m.call(0x558830,0,v,p,n,ecx=S.GARAGE)==n
    assert m.call(0x558da0,ecx=S.GARAGE)
    items={i:m.u32(S.GARAGE+4*i) for i in range(184)}
    m.fpcw=0x077f
    return items


def generate_generic():
    tables=pickle.load(open(ROOT/'recovery/stage10/generic_tables.pkl','rb'))['tables']
    force,follow=policy(tables)
    for attempt in range(8):
        ref=None;report={};again=False
        for name in NAMES:
            m=S.boot();S.prepare(m,chassis_type=4);items=setup_file(m,name)
            fc=G.IndexControl(m,force);lc=LiteralControl(m,follow);install(m,fc,lc);S.apply(m,items)
            if lc.violations:
                for _,i,j in lc.violations:follow[i]='append'
                print('Widen road literals',name,lc.violations,flush=True);again=True;break
            tab=(fold_table(fc.seq,force),[follow[i]=='append' for i in range(len(lc.seq))],
                 [lc.addr_of[i] for i in range(len(lc.seq))])
            if ref is not None:
                dif=[(i,a,b) for i,(a,b) in enumerate(zip(ref[0],tab[0])) if a!=b and a not in 'nN']
                if dif:
                    for i,a,b in dif:force.add(('a' if a in 'kzonN' else 'z' if a in '01Z' else 'o',i))
                    print('Widen road cells',name,dif,flush=True);again=True;break
                assert ref[1:]==tab[1:]
            else:ref=tab;base=m
            report[name]=summary(m,tab);print('Road garage',name,report[name],flush=True)
        if not again:return ref,report,base
    raise AssertionError('Road build policy did not converge')


def generate_placed():
    text=(OUT/'NR2003CupTrackBuild.lua').read_text()
    f,lf,la=re.search(r'placedGeneric = \{fold = "([^"]+)",\s*litf = "([^"]+)",\s*lita = "([^"]+)"',text).groups()
    tab=f,[c=='1' for c in lf],struct.unpack('<'+'I'*len(lf),base64.b64decode(la))
    force,follow=policy(tab)
    # This speedway-shared literal differs for the road specification, also at
    # placement. Allocate a real literal containing the original road value.
    follow[915]='append'
    for attempt in range(8):
        ref=None;report={};again=False
        for name in NAMES:
            file=None if name=='default' else Path(os.environ['WG_TRACK'])/(name+'.cup.sim')
            m,t,r=G.run('placedGeneric',force_override=force,follow_override=follow,setup_file=file,chassis_type=4)
            if ref is not None:
                dif=[(i,a,b) for i,(a,b) in enumerate(zip(ref[0],t[0])) if a!=b and a not in 'nN']
                if dif:
                    for i,a,b in dif:force.add(('a' if a in 'kzonN' else 'z' if a in '01Z' else 'o',i))
                    print('Widen road placed cells',name,dif,flush=True);again=True;break
                assert ref[1:]==t[1:]
            else:ref=t;base=m
            report[name]=summary(m,t);print('Road placement',name,report[name],flush=True)
        if not again:return ref,report,base,text
    raise AssertionError('Road placement policy did not converge')


def main():
    generic,greport,gm=generate_generic()
    jit,_,natives,_=G.translate(gm);assert not natives-G.core_natives()
    G.emit_modules(OUT,'NR2003CupJITWG',jit,'-- Original road-course chassis generic callbacks; generated by gen_roadcourse.py.\n')
    images={}
    for ch in (2,4):
        m=S.boot();S.prepare(m,chassis_type=ch);images[ch]=S.snapshot(m)
    a,b=images[2],images[4]
    inputs={i:struct.unpack_from('<I',b,i)[0] for i in range(0,len(a),4) if a[i:i+4]!=b[i:i+4]}
    assert len(inputs)==8,'Unexpected original chassis-selection footprint'
    spec='-- Generated by gen_roadcourse.py from original chassis_type=4.\nreturn {\nchassisType=4,spec=0x723c70,executableVersion="1.2.0.1",\n'
    spec+='inputs={'+','.join('[%d]=0x%08x'%v for v in sorted(inputs.items()))+'},\n'
    spec+=block('generic',generic,greport['default'])+'}\n'
    (OUT/'NR2003CupWatkinsGlenSpec.lua').write_text(spec)
    placed,preport,pm,text=generate_placed()
    jit,_,natives,_=G.translate(pm);assert not natives-G.core_natives()
    G.emit_modules(OUT,'NR2003CupJITPG',jit,'-- Original road-course chassis placed callbacks; generated by gen_roadcourse.py.\n')
    replacement=block('placedGeneric',placed,preport['default']).rstrip()
    text,n=re.subn(r'placedGeneric = \{fold = ".*?slots = \{[^}]*\}\}\},',lambda _:replacement,text,flags=re.S)
    assert n==1
    (OUT/'NR2003CupTrackBuild.lua').write_text(text)
    REPORT.mkdir(parents=True,exist_ok=True)
    (REPORT/'emitter_report.json').write_text(json.dumps({'chassis':4,'inputs':inputs,'garage':greport,'placed':preport},indent=2)+'\n')


if __name__=='__main__':main()
