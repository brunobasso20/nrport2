"""dev: 'notdriven' without any steering (same launch, same driver-off stop) -- original rows + 4 allframe twins"""
import sys, json
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage11'))
import gen_fixtures12 as G, gen_fixtures11 as G11, scenarios12 as SC, orig_stage12 as O
from multiprocessing import Pool
def law(k):
    c = SC.law_notdriven(k); c['steerAxis'] = 0.0; return c
def run(seed):
    o = SC.make('notdriven'); flat = O.flat()
    rows = [[0] + G.observe(o)]
    for k in range(36 * 12):
        if seed: seed = G11.state_noise(o, seed)
        c = law(k)
        for t in range(8): o.step_driver(c, flat)
        if (k + 1) % 9 == 0: rows.append([k + 1] + G.observe(o))
    return rows
if __name__ == '__main__':
    with Pool(4) as p: res = p.map(run, [0, 201, 202, 203, 204])
    json.dump(res, open('/opt/s12/nosteer.json', 'w')); print('done')
