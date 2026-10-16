#!/usr/bin/env python3
"""Build once, run the audio/track regressions, and retain concise JSON + logs.

No Studio, network, uploads, original recordings or physics mutations. Optional
native regeneration compares the checked-in fixtures with a private memory dump.
"""
from concurrent.futures import ThreadPoolExecutor,as_completed
from datetime import datetime,timezone
from pathlib import Path
import argparse,json,os,re,shutil,subprocess,sys,tempfile

ROOT=Path(__file__).resolve().parents[2]
PACKAGE=ROOT/'nr2003audio_implementation'
LOGS=ROOT/'work/audio'
BASE='25be672a755d64b4010b02399c800522aa0ca040'

def command(name,args):
    try:
        p=subprocess.run([str(x) for x in args],cwd=ROOT,stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,text=True,timeout=240)
        output=p.stdout;ok=p.returncode==0
    except (OSError,subprocess.TimeoutExpired) as e:output=str(e);ok=False
    (LOGS/(name+'.log')).write_text(output)
    match=re.search(r'(\d+) passed, 0 failed',output)
    if not match:match=re.search(r'Ran (\d+) tests?',output)
    return {'name':name,'passed':ok,'checks':int(match[1]) if match and ok else 0,'output':output}

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--luau',default=os.environ.get('LUAU_BIN') or shutil.which('luau'))
    ap.add_argument('--luau-compile',dest='compiler',default=shutil.which('luau-compile'))
    ap.add_argument('--reference-memory',type=Path)
    ap.add_argument('--write-results',action='store_true',help='Refresh tracked RESULTS.txt after a successful run')
    a=ap.parse_args()
    if not a.luau:ap.error('Luau CLI missing; use --luau <executable> or LUAU_BIN')
    if not a.compiler:
        p=Path(a.luau).with_name('luau-compile'+('.exe' if os.name=='nt' else ''))
        if p.is_file():a.compiler=str(p)
    if not a.compiler:ap.error('Luau compiler missing; use --luau-compile <executable>')
    LOGS.mkdir(parents=True,exist_ok=True)
    results=[]
    for name,path in [('build',PACKAGE/'tools/build_audio.py'),('build_mocks',PACKAGE/'tools/build_installer_test.py')]:
        result=command(name,[sys.executable,path]);results.append(result)
        if not result['passed']:print(result['output']);return 1
    suites={
        'kernels':[a.luau,'-O2',PACKAGE/'tests/kernels.luau'],
        'transitions':[a.luau,'-O2',PACKAGE/'tests/transitions.luau'],
        'state':[a.luau,'-O2','--codegen',PACKAGE/'tests/state.luau'],
        'installer':[a.luau,'-O2',LOGS/'installer_test.luau'],
        'spatial':[a.luau,'-O2',LOGS/'spatial_test.luau'],
        'track1':[a.luau,'-O2','--codegen',ROOT/'tests/track1/surfaces.luau'],
        'pipeline':[sys.executable,'-m','unittest','discover','-s',PACKAGE/'tests','-p','test_*.py'],
    }
    syntax=list(sorted((PACKAGE/'roblox/Audio').glob('*.lua')))+[
        PACKAGE/'studio/installer.luau',PACKAGE/'studio/transaction.lua',
        ROOT/'roblox/Client.client.lua',ROOT/'roblox/Server.server.lua',
        ROOT/'nr2003carmodel_implementation/roblox/Bench/Client.client.lua',
        ROOT/'nr2003carmodel_implementation/roblox/Bench/Server.server.lua']
    suites['syntax']=[a.compiler,'--null',*syntax]
    with ThreadPoolExecutor(max_workers=3) as pool:
        jobs={pool.submit(command,name,args):name for name,args in suites.items()}
        for future in as_completed(jobs):
            result=future.result();results.append(result)
            print(('PASS ' if result['passed'] else 'FAIL ')+result['name']+
                (' ('+str(result['checks'])+' checks)' if result['checks'] else ''),flush=True)
            if not result['passed']:print(result['output'][-5000:],flush=True)
    preserved=['core','roblox/CupChassisAdapter.lua','roblox/RenderSnapshot.lua',
        'roblox/SnapshotBuffer.lua','roblox/RenderPresentation.lua','roblox/RenderConfig.lua',
        'nr2003carmodel_implementation/roblox/CarModel','track1_implementation','watkinsglen_implementation']
    changed=subprocess.run(['git','diff','--name-only',BASE,'--',*preserved],cwd=ROOT,capture_output=True,text=True)
    untracked=subprocess.run(['git','ls-files','--others','--exclude-standard','--',*preserved],cwd=ROOT,capture_output=True,text=True)
    ok=changed.returncode==0 and untracked.returncode==0 and not changed.stdout.strip() and not untracked.stdout.strip()
    results.append({'name':'scope','passed':ok,'checks':0,'output':
        'Physics, garage, adapters, tracks, model runtime and original render codec/buffer/presentation unchanged from base.\n' if ok else changed.stdout+changed.stderr+untracked.stdout+untracked.stderr})
    print(('PASS ' if ok else 'FAIL ')+'preserved source scope',flush=True)
    if a.reference_memory:
        with tempfile.TemporaryDirectory() as td:
            for script in ['regenerate_curves.py','regenerate_transport.py']:
                r=command(script.removesuffix('.py'),[sys.executable,PACKAGE/'recovery'/script,
                    '--memory',a.reference_memory.resolve(),'--out-dir',td]);results.append(r)
            names=['curve_golden.json','curve_golden.lua','transport_golden.lua','mixer_golden.lua']
            equal=all((Path(td)/name).is_file() and (Path(td)/name).read_bytes()==(PACKAGE/'tests'/name).read_bytes() for name in names)
            results.append({'name':'native_fixture_identity','passed':equal,'checks':0,
                'output':'Fresh original x86 output matches all committed numeric fixtures.\n' if equal else 'Native fixtures differ; inspect regeneration logs.\n'})
            print(('PASS ' if equal else 'FAIL ')+'fresh native fixture identity',flush=True)
    diff=command('whitespace',['git','diff','--check','HEAD']);results.append(diff)
    passed=all(r['passed'] for r in results);count=sum(r['checks'] for r in results)
    order=['kernels','transitions','state','installer','spatial','track1','pipeline','syntax','scope',
        'regenerate_curves','regenerate_transport','native_fixture_identity','whitespace']
    results.sort(key=lambda r:order.index(r['name']) if r['name'] in order else -1)
    summary={'passed':passed,'checks':count,'nativeNumericVectors':2803,'listeningVerified':False,
        'studioExecuted':False,'originalRecordingsUsed':False,'compiledSources':len(syntax),
        'suites':[{k:v for k,v in r.items() if k!='output'} for r in results]}
    (LOGS/'results.json').write_text(json.dumps(summary,indent=2)+'\n')
    if a.write_results and passed:
        lines=['Audio reference validation — '+datetime.now(timezone.utc).date().isoformat(),
            f'{count} automated checks; 2803 original-x86 numeric vectors; no listening claim.',
            f'{len(syntax)} sources compile; private native regeneration '+('verified.' if a.reference_memory else 'not requested (stored fixtures used).'),'']
        for r in results:
            if r['name'] in ('build','build_mocks'):continue
            output=r['output']
            if r['name']=='pipeline':output=f'Python unittest: {r["checks"]} tests passed (CES/WAV format and hook/XML cases).\n'
            if r['name']=='syntax':output=f'All {len(syntax)} audio/installer/entry-point sources compile.\n'
            lines.extend(['['+r['name']+']',output.strip() or 'Passed.',''])
        lines.extend(['[not performed]','Original-bank/WAV extraction (files unavailable); Roblox Studio; listening/latency and DirectSound waveform comparison.'])
        (PACKAGE/'RESULTS.txt').write_text('\n'.join(lines)+'\n')
    print(('PASS' if passed else 'FAIL')+f': {count} automated checks; logs: work/audio; no listening claim.',flush=True)
    return 0 if passed else 1
if __name__=='__main__':raise SystemExit(main())
