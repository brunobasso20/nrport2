"""dev: rows of 'allframe' twins of a scenario (+-1 ulp on the whole 45-state vector once per frame, through the ORIGINAL
export / import, LCG seeds) -- the per-frame perturbation class of the port's inherited per-tick rounding"""
import sys, json, time
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage11'))
import gen_fixtures12 as G, gen_fixtures11 as G11, scenarios12 as SC, orig_stage12 as O
from multiprocessing import Pool
def run(args):
    name, seed = args
    session, frames, law, events, opts = SC.SCENARIOS[name]
    o = SC.make(name); m = o.m; flat = O.flat()
    rows = [[0] + G.observe(o)]
    for k in range(frames):
        seed = G11.state_noise(o, seed)
        c = law(k)
        for t in range(8): o.step_driver(c, flat)
        if (k + 1) % 9 == 0: rows.append([k + 1] + G.observe(o))
    return name, args[1], rows
if __name__ == '__main__':
    name = sys.argv[1]
    with Pool(4) as p: res = p.map(run, [(name, s) for s in (101, 102, 103, 104)])
    json.dump([r[2] for r in res], open('/opt/s12/allframe_%s.json' % name, 'w'))
    print('done', name)
