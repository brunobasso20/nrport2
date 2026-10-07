"""Stage 10 harness: the ORIGINAL NR2003 Cup car build split at the setup application point.

  boot()                         CRT initializers (descriptors, default setups c03350/c055c0)
  prepare(m)                     build path up to the garage values: spec, 00425690, 0051a730, 00559950 x2
  P = snapshot                   pre-application state (what the Luau setup application starts from)
  apply(m, items)                garage items -> c055c0, then the ORIGINAL application sequence:
                                 00559820 (derived items), 00550c40 (engine), 00550c60 (fuel),
                                 00550bc0 (tyres), 005b29c0 (tree), 005b2f20 (setup -> runtime cells +
                                 callback generation), 0054d610 x4
The split reproduces recovery/stage6_7/orig_vehicle.build() exactly (same calls, same order, same FPU
control word 0x077f), so apply(m, {}) == the Stage 6/7 post-build image."""
import os, sys, struct
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from orig_runtime import *          # noqa: F401,F403  (Machine, boot, build helpers, GAME_FPCW, STATE)
import orig_vehicle as OV

SLOT = OV.SLOT
ACTIVE = 0xc055c0                   # active setup (read by 0055e9b0 / 00557d60)
GARAGE = 0xc03350                   # current garage setup
APPLY_STACK = 0x1f000000 - 0x1000

def boot():
    m = OV.boot()
    m.fpcw = GAME_FPCW
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0          # gen_runtime.canonical_state()
    for i, v in enumerate(st): m.wf(STATE + 4 * i, v)
    return m

def prepare(m, chassis_type=OV.CHASSIS_TYPE, series=OV.CUP):
    spec = m.u32(0x725ab8 + 4 * (chassis_type + series * 6))
    m.w32(0xc06926, 0)
    m.call(0x579cd0)
    m.patch_ret(0x425e20)
    m.w32(SLOT + 0x58e, chassis_type); m.w32(SLOT + 0x592, 0); m.w32(SLOT + 0x596, series)
    m.w32(SLOT + 0x58a, spec)
    m.w32(SLOT + 0x582, m.u32(spec + 0x1bc)); m.w32(SLOT + 0x586, m.u32(spec + 0x1c0))
    m.call(0x425690, GARAGE)
    m.call(0x425690, ACTIVE)
    m.call(0x51a730, SLOT, m.u32(spec), m.u32(spec + 0x98), ecx=SLOT + 0xc)
    m.call(0x559950, SLOT + 0x58e, ecx=ACTIVE)
    m.call(0x559950, SLOT + 0x58e, ecx=GARAGE)
    m.patch_ret(0x540b80, pop=16)
    return spec

APPLY_CALLS = [  # (entry, args, ecx) of the ORIGINAL application sequence after the garage values
    (0x559820, (), GARAGE), (0x559820, (), ACTIVE), (0x550c40, (), None), ('w32', SLOT + 0x5b2, 0),
    (0x550c60, (), None), (0x550bc0, (SLOT,), None), (0x5b29c0, (), None), ('w32', 0xbf6e1c, 0x727290),
    ('wf', 0xbf6d58 + 12, 1.0),
    # 005b2f20(root, bf6d40), body call by call (identical sequence):
    (0x57dcd0, (0,), None), (0x57c930, (), None), (0x55e9b0, (), None), ('zcells',),
    (0x5b4060, (0x727290,), None), ('w32', 0xe84664, 0xe84474), ('w32', 0xe847c8, 0xbf6d40),
    (0x5b4560, (0x727290,), None), ('w32', 0xe84664, 0xe84474), (0x5b3f50, (0x727290,), None),
    (0x5b2fb0, (0x727290,), None), (0x5b9ce0, (), None), (0x57dcd0, (2,), None),
    (0x5b3090, (0x727290,), None), (0x57dcd0, (1,), None),
    (0x54d610, (), 0xbf3a20), (0x54d610, (), 0xbf3a20 + 0xa39), (0x54d610, (), 0xbf3a20 + 2 * 0xa39),
    (0x54d610, (), 0xbf3a20 + 3 * 0xa39)]

# step boundaries of APPLY_CALLS matching build_host.luau STEPS (index of the last call of each step)
STEP_ENDS = [0, 1, 3, 4, 5, 8, 9, 10, 11, 12, 13, 16, 18, 19, 20, 21, 22, 23, 27]

def apply(m, items=None, on_step=None):
    # garage values: the garage edits c03350, which 00559360 copies to the active setup c055c0 at
    # session start; 0051a730 (gear ratios) reads c03350, 0055e9b0 reads c055c0
    for item, raw in (items or {}).items():
        m.w32(ACTIVE + 4 * item, raw); m.w32(GARAGE + 4 * item, raw)
    for n, c in enumerate(APPLY_CALLS):
        if c[0] == 'w32': m.w32(c[1], c[2])
        elif c[0] == 'wf': m.wf(c[1], c[2])
        elif c[0] == 'zcells':                 # 005b2f20: 0057c990(cell, 0) for cells e84474..e84494
            for cell in range(0xe84474, 0xe84498, 4): m.call(0x57c990, cell, 0)
        else:
            entry, args, ecx = c
            r = m.call(entry, *args, ecx=ecx, limit=200_000_000)
            if entry == 0x5b29c0: assert r == 1
        if on_step and n in STEP_ENDS: on_step(STEP_ENDS.index(n) + 1)

def snapshot(m, lo=0x6e9000, hi=0xf80000):
    return bytes(m.uc.mem_read(lo, hi - lo))
