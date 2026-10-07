"""Build the ORIGINAL NR2003 Cup vehicle in Unicorn, using only original x86 code paths:
CRT static initializers -> car spec / tire profiles / setup descriptors
00559950 default setup completion -> setup copy -> 0054c1c0 tire init x4 -> 005b29c0 tree
-> 005b2f20 (0055e9b0 setup->runtime, callback generation) .
Synthetic host inputs are explicit (car slot, chassis_type, series). Never launches the game."""
import struct, json, sys
from nrx import *

BG_FLAG = 0xf7f000   # unused BSS byte used by the inBackground stub
CUP = 0              # series row of 00725ab8 (0 = 110in wheelbase Cup car)
CHASSIS_TYPE = 2     # track.chassis_type: 1 sspdway, 2 spdway (default), 3 short, 4 road
SLOT = 0xc12030      # 00562f70(0)

def heap_stubs(m):
    def heapalloc(mm, esp): return mm.alloc(max(mm.u32(esp + 12), 16)), 12
    def memalloc(mm, esp):
        p = mm.alloc(max(mm.u32(esp + 8), 16)); mm.w32(mm.u32(esp + 4), p); return 0, 0
    def virtualalloc(mm, esp): return mm.alloc(max(mm.u32(esp + 8), 16)), 16
    m.stubs.update({'HeapAlloc': heapalloc, 'GetProcessHeap': lambda mm, esp: (1, 0),
                    'InitializeCriticalSection': lambda mm, esp: (0, 4),
                    'EnterCriticalSection': lambda mm, esp: (0, 4),
                    'LeaveCriticalSection': lambda mm, esp: (0, 4),
                    'VirtualAlloc': virtualalloc, 'GlobalAlloc': lambda mm, esp: (mm.alloc(max(mm.u32(esp+8),16)), 8),
                    '?_memAlloc@@YA?AW4success@@PAPAXK@Z': memalloc,
                    'timeGetTime': lambda mm, esp: (1000, 0), 'GetTickCount': lambda mm, esp: (1000, 0)})

POW_X87 = bytes.fromhex('d9c9 d9e4 dfe0 9e 7507 ddd8 ddd8 d9ee c3'
                        'd9f1 d9c0 d9fc dce9 d9c9 d9f0 d9e8 dec1 d9fd ddd9 c3'.replace(' ', ''))
FTOL_X87 = bytes.fromhex('83ec0c d97c2408 668b442408 80cc0c 6689442 40a d96c240a df3c24 d96c2408 8b0424 8b542404 83c40c c3'.replace(' ', ''))
def install_pow(m):
    # 006c5018 is the encrypted CRT _ftol (ST0 -> EDX:EAX, truncation, pops ST0).
    m.uc.mem_write(0x6c5018, FTOL_X87)
    # 006c5c40 is an encrypted (SecuROM) CRT _CIpow: ST1=x, ST0=y -> ST0=x^y.
    # Replaced by an x87 FYL2X/F2XM1/FSCALE sequence (x==0 -> 0). Documented adaptation.
    m.uc.mem_write(0x6c5c40, POW_X87)

def boot(trace=False):
    m = Machine()
    heap_stubs(m)
    # Critical-section wrappers route to SecuROM thunks; single-threaded emulation needs no lock.
    for a in (0x5f5870, 0x5f5880, 0x5f5890, 0x5f58a0): m.patch_ret(a)
    install_pow(m)
    # taskGetRate (005f7c50): game task rate. taskStart's rate argument is not visible in the
    # exe; the function's own constant fallback is 0x24 = 36 Hz (288 Hz physics = 8 substeps/frame).
    m.patch_ret(0x5f7c50, eax=36)
    # inServer (005f8890) and inBackground (005f8870) compare GetCurrentThreadId with stored ids
    # through SecuROM-routed API pointers. Offline single-player: inServer=false. inBackground is
    # true on the simulation (bg task) thread that runs 005b2190 and false on the foreground thread
    # that builds the car (bgRequestFGAction(00551760)). The flag byte lives at BG_FLAG.
    m.patch_ret(0x5f8890, eax=0)
    m.uc.mem_write(0x5f8870, b'\x0f\xb6\x05' + struct.pack('<I', BG_FLAG) + b'\xc3')   # movzx eax, byte [BG_FLAG]; ret
    m.uc.mem_write(BG_FLAG, b'\x00')
    table = [m.u32(a) for a in range(0x71b004, 0x71e7a4, 4)]
    for fn in table:
        try: m.call(fn, limit=2_000_000)
        except Exception as e: m.init_errors = getattr(m, 'init_errors', 0) + 1
    return m

def build(m, chassis_type=CHASSIS_TYPE, series=CUP, log=print):
    spec = m.u32(0x725ab8 + 4 * (chassis_type + series * 6))
    log('car spec %08x' % spec)
    m.w32(0xc06926, 0)
    # 00579cd0 (run by track load 00573010 before the car): material-pair contact tables
    # (rows 0x11..0x13 x 20 surfaces). Rows 0x11/0x13 (tire: 0054cab0, 0054d610, 00558780) are
    # track independent; row 0x12 scales with the track value b8f258 (left 0 = not tire related).
    m.call(0x579cd0)
    # Host-only string/file paths (setup file names) are not physics: 00425e20 builds paths.
    m.patch_ret(0x425e20)

    m.w32(SLOT + 0x58e, chassis_type); m.w32(SLOT + 0x592, 0); m.w32(SLOT + 0x596, series)
    m.w32(SLOT + 0x58a, spec)
    m.w32(SLOT + 0x582, m.u32(spec + 0x1bc)); m.w32(SLOT + 0x586, m.u32(spec + 0x1c0))
    # 00425690: setup gear choice indices -> ratios (reverse negated, neutral 0)
    m.call(0x425690, 0xc03350)
    m.call(0x425690, 0xc055c0)
    # 0051a730(this=slot+0xc, engine set, spec[0x26]) - engine/gear set selection
    m.call(0x51a730, SLOT, m.u32(spec), m.u32(spec + 0x98), ecx=SLOT + 0xc)
    # 00559950: default setup completion for c055c0 and c03350 (as 0055aa60 does)
    m.call(0x559950, SLOT + 0x58e, ecx=0xc055c0)
    m.call(0x559950, SLOT + 0x58e, ecx=0xc03350)
    # 00559820 -> 00425ad0: setup derived values run after every setup load (00558aa0):
    # ARB rates (0x63/0x64), shock coefficients (0x81-0x88), corner weights, ride heights, gears...
    m.call(0x559820, ecx=0xc03350)
    m.call(0x559820, ecx=0xc055c0)
    # 00550c40 -> 0051a020(engine object = slot+0xc, 10.0): engine torque/friction tables from the
    # engine set (0051a4a0 cubic fit, 0051a3c0, 0051a680), ignition/running state (+0x554), limiter.
    m.patch_ret(0x540b80, pop=16)   # multiplayer sync of the engine block (00538b20 object) - host only
    m.call(0x550c40)
    m.w32(SLOT + 0x5b2, 0)
    # 00550c60: store fuel load (spec+0x24 = 62.47 kg full cell, or setup 0x31) in the obfuscated
    # double read back by 0055e9b0. Negative record mass = 'variable mass' flag (005b4060).
    m.call(0x550c60)
    m.call(0x550bc0, SLOT)                 # 0054c1c0 x4 with 0056ed60 tire profile per wheel
    roots = m.call(0x5b29c0)               # link the 16 static component records (returns root count)
    assert roots == 1
    root = 0x727290                        # 'chassis' record (parent 'inertial')
    log('root %08x' % root)
    m.w32(0xbf6e1c, root)
    # initial pose block bf6d40 (pos xyz at d40/d48/d50 + orientation at d58) left at 00551520 layout
    m.wf(0xbf6d58 + 12, 1.0)
    m.call(0x5b2f20, root, 0xbf6d40, limit=200_000_000)
    # 0054d610: per-frame tire property/thermal update (36 Hz in-game). Run once so that the
    # load/pressure/temperature-derived tire fields are initialized (thermal evolution = Stage 11).
    for w in range(4): m.call(0x54d610, ecx=0xbf3a20 + w * 0xa39)
    return spec, root
