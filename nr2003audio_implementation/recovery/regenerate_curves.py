"""Regenerate numeric fixtures from original NR2003.exe memory; no audio files."""
from pathlib import Path
import argparse,json,random,sys
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'pipeline'))
from native_curves import NativeCurves

def lua(v):
    if isinstance(v,dict):return '{'+','.join('['+json.dumps(k)+']='+lua(x) for k,x in v.items())+'}'
    if isinstance(v,list):return '{'+','.join(lua(x) for x in v)+'}'
    return json.dumps(v)

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--memory',type=Path,required=True);a=ap.parse_args()
    native=NativeCurves(a.memory);cases=[]
    inputs=[(0,[1000,.1,9000,.9,0]),(0,[100,.5,100,.7,0]),
        (1,[4500,1200,.05,.1,1800,1,0]),(1,[5000,750,0,0,750,1,800]),
        (2,[0,0,.333,.1,.666,.9,1,1,0,10000,0,1])]
    for kind,parameters in inputs:
        curve=native.compile(kind,parameters)
        xs=[-20000,-100,0,100,999,1000,3000,4100,4500,4600,4999,5000,5400,8000,9000,10000,20000]
        rng=random.Random(10+kind);xs+=[rng.uniform(-1000,12000) for _ in range(30)]
        cases.append({'curve':curve,'vectors':[[x,native.evaluate(x)] for x in xs]})
    out=HERE.parent/'tests/curve_golden.json';out.write_text(json.dumps(cases,indent=2)+'\n')
    out.with_suffix('.lua').write_text('-- Original NR2003.exe response kernels executed in Unicorn; CRT bridges documented.\nreturn '+lua(cases)+'\n')
    print('Regenerated',sum(len(c['vectors']) for c in cases),'original curve vectors')
if __name__=='__main__':main()
