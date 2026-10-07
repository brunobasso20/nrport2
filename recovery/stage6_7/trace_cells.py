"""Discover every memory cell the ORIGINAL vehicle runtime touches per physics tick.
Runs several scenarios through orig_runtime.Original with Unicorn read/write hooks active only
inside step(). Also records lookup-table bases passed to 005677d1 so whole tables are kept."""
import os, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
import json, struct, sys, pickle
from orig_runtime import *
from unicorn import UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_MEM_WRITE

def scenarios():
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0; st[34] = 420.0
    def drive(t):
        g = 2.0 if t < 3 else (3.0 if t < 5 else (4.0 if t < 7 else 5.0))
        return dict(gear=g, clutch=min(1.0, t), throttle=1.0 if t < 8 else 0.0, brake=0.0 if t < 8 else 1.0,
                    lfSteer=0.02 * math.sin(t), rfSteer=0.02 * math.sin(t))
    def reverse(t):
        return dict(gear=0.0, clutch=min(1.0, t), throttle=0.6)
    def park(t):
        return dict(gear=1.0, clutch=0.0, throttle=0.0, brake=1.0 if t > 0.5 else 0.0)
    return [('drive', st, drive, 288 * 10), ('reverse', st, reverse, 288 * 3), ('park', st, park, 288 * 2)]

import math
def run(trace=True):
    cells = {}; tables = set(); natives = {}
    for name, st, fn, n in scenarios():
        o = Original(state=st); m = o.m
        active = [False]
        def mem(uc, access, address, size, value, user):
            if not active[0]: return
            if 0x1ee00000 <= address < 0x1f100000: return
            if STUB <= address < STUB + 0x100000: return
            k = cells.get(address)
            w = access == UC_MEM_WRITE
            if k is None: cells[address] = [size, w, not w]
            else:
                k[0] = max(k[0], size); k[1] |= w; k[2] |= (not w)
        def lk(uc, address, size, user):
            if active[0]:
                esp = uc.reg_read(UC_X86_REG_ESP)
                tables.add(o.m.u32(esp + 4))
        def nat(uc, address, size, user):
            if active[0]: natives[address] = natives.get(address, 0) + 1
        if trace:
            m.uc.hook_add(UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE, mem)
            m.uc.hook_add(UC_HOOK_CODE, lk, begin=0x5677d1, end=0x5677d1)
        orig_step = o.step
        for k in range(n):
            active[0] = True
            s = o.step(fn(k / 288), flat(0.0, surface=1 if k % 600 < 500 else 5))
            active[0] = False
            if any(x != x for x in s): print(name, 'NaN at', k); break
        print(name, 'final', [round(x, 3) for x in s[:6]], 'cells', len(cells))
    return cells, tables

if __name__ == '__main__':
    from unicorn import UC_MEM_WRITE
    cells, tables = run()
    pickle.dump((cells, tables), open(str(HERE) + '/cells.pkl', 'wb'))
    print('cells', len(cells), 'tables', sorted(hex(t) for t in tables))
