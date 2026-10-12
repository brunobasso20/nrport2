"""Stage 11 lift set: the ORIGINAL functions of the per-frame runtime systems (frame end 00554520, collision
damage 00549c40, collision record entry 0054a760, pit service 00550f10) lifted from x86 to Luau with the
Stage 10 lifter (recovery/stage10/lift10.py: Stage 6/7 conventions + round-toward-negative signed zero).

Builtins = the Stage 6/7 / Stage 10 builtins (SecuROM-encrypted CRT helpers, task/thread queries, critical
sections) + three host boundaries (documented in orig_stage11.py; identical in the Unicorn reference):
  005547a0  car world/replay state record into the track system (005a02b0)       -> B_ret
  00592dc0  damage change -> replay recorder / multiplayer session                -> B_ret
  005d08d0  force-feedback device output (Stage 13)                               -> B_ret
Indirect call targets (car vtable slots 1..3 = 00566aa0/00566ab0/00566ac0) are lifted explicitly."""
import os, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage10')); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from lift10 import Lifter10
from lift import X


class Lifter11(Lifter10):
    """Lifter10 + MSVC switches whose bounds check is separated from the 'ja' by instructions that leave the
    flags alone (0054aa20: cmp edi,3 / fstp st(0) / ja / jmp [edi*4+tbl])."""
    FLAG_NEUTRAL = ('fstp', 'fld', 'fxch', 'mov', 'lea', 'fst')

    def jump_table(self, i, prev):
        r = Lifter10.jump_table(self, i, prev)
        if r is not None: return r
        op = i.operands[0]; m = op.mem
        if op.type != X.X86_OP_MEM or m.base or not m.index or m.scale != 4: return None
        seq = [x for x in prev if x is not None]
        if not seq or seq[-1].mnemonic != 'ja': return None
        for x in reversed(seq[:-1]):
            if x.mnemonic == 'cmp':
                if x.operands[0].type != X.X86_OP_REG or x.operands[0].reg != m.index or x.operands[1].type != X.X86_OP_IMM:
                    return None
                n = x.operands[1].imm + 1
                data = self.read(m.disp & 0xffffffff, 4 * n)
                return self.reg32(m.index), [int.from_bytes(data[4 * k:4 * k + 4], 'little') for k in range(n)]
            if x.mnemonic.split()[0] not in self.FLAG_NEUTRAL: return None
            if x.mnemonic in ('mov', 'lea') and x.operands[0].type == X.X86_OP_REG and x.operands[0].reg == m.index:
                return None
        return None

    estack = []
    def effect(self, f):
        self.estack.append(f)
        try:
            return Lifter10.effect(self, f)
        except Exception as e:
            if not getattr(e, 'chain', None): e.chain = ' <- '.join('%06x' % x for x in reversed(self.estack))
            raise
        finally:
            self.estack.pop()

    def _inst(self, i, lid):
        # one-operand MUL / IMUL (EDX:EAX = EAX * r/m32), e.g. MSVC division by a constant: exact 64-bit product
        # through 16-bit limbs (MUL64 / IMUL64 in the module prelude)
        mn, ops = i.mnemonic, i.operands
        if mn in ('mul', 'imul') and len(ops) == 1:
            if ops[0].size != 4: raise Exception('mul size at %x' % i.address)
            fn = 'IMUL64' if mn == 'imul' else 'MUL64'
            return ['do local lo, hi, ov = %s(EAX, %s); EAX = lo; EDX = hi; FC = ov; FO = ov end' % (fn, self.rd(ops[0]))], False
        return Lifter10._inst(self, i, lid)

# helpers emitted in the prelude of every Stage 11 code part
PRELUDE11 = '''
local log = math.log
-- IEEE 754 sign of an exact zero sum under round-toward-negative (game CW 0x077f)
local function ZADD(x, y)
	if x == 0 and y == 0 and 1 / x > 0 and 1 / y > 0 then return 0 end
	return -0.0
end
local function B_ret() ESP = band(ESP + 4) end
local function B_ret16() ESP = band(ESP + 20) end
-- 005f58d0(out, point) ADAPTER (no track loaded, identical machine-code stub in the Unicorn reference):
-- out[0..2] = point, the track-query fields +0x0c..+0x57 written by 0051370a cleared
local function B_trackPoint()
	-- Watkins Glen port: with a track loaded (NR2003CupTrack) the ORIGINAL 005f58d0 -> 0051370a runs on it
	local tp = ctx.trackPoint
	if tp then
		EAX, ECX, EDX = tp(r32(ESP + 4), r32(ESP + 8))
		ESP = band(ESP + 4)
		return
	end
	local out, pos = r32(ESP + 4), r32(ESP + 8)
	local z = r32(pos + 8)
	w32(out, r32(pos)); w32(out + 4, r32(pos + 4)); w32(out + 8, z)
	for k = 0x0c, 0x54, 4 do w32(out + k, 0) end
	EAX = 0; ECX = 0; EDX = z
	ESP = band(ESP + 4)
end
-- exact 32 x 32 -> 64 bit products (x86 MUL / one-operand IMUL): lo, hi, overflow flag
local function MUL64(a, b)
	a = band(a); b = band(b)
	local al, ah, bl, bh = band(a, 0xffff), rshift(a, 16), band(b, 0xffff), rshift(b, 16)
	local low = al * bl
	local mid = ah * bl + al * bh
	local t = low + (mid % 65536) * 65536
	local lo = t % 4294967296
	local hi = (ah * bh + (mid - mid % 65536) / 65536 + (t - lo) / 4294967296) % 4294967296
	return lo, hi, hi ~= 0
end
local function IMUL64(a, b)
	a = band(a); b = band(b)
	local lo, hi = MUL64(a, b)
	if a >= 0x80000000 then hi = (hi - b) % 4294967296 end
	if b >= 0x80000000 then hi = (hi - a) % 4294967296 end
	local ext = lo >= 0x80000000 and 0xffffffff or 0
	return lo, hi, hi ~= ext
end
'''

BASE, TOP = 0x6e9000, 0xf80000
BUILTINS = {0x6c5018: 'B_ftol', 0x6c5c40: 'B_pow', 0x5f5870: 'B_nop', 0x5f5880: 'B_nop', 0x5f5890: 'B_nop',
            0x5f58a0: 'B_nop', 0x5f8870: 'B_inBackground', 0x5f8890: 'B_inServer', 0x5cfcfc: 'B_rdtsc',
            0x5f7c50: 'B_taskGetRate',
            0x5547a0: 'B_ret', 0x592dc0: 'B_ret', 0x5d08d0: 'B_ret',
            0x557650: 'B_ret',   # collision sound event (005576a0 audio / 00501870 replay event recorder)
            0x5f58d0: 'B_trackPoint',   # world point -> track point record (0051370a track query): no track loaded
            0x425e20: 'B_ret',          # host-only setup file paths (as the Stage 10 build)
            0x540b80: 'B_ret16'}        # multiplayer engine-block sync (as the Stage 10 build)
ROOTS = [0x554520,          # frame end of the player car (005b2190 tail)
         0x549c40,          # collision damage frame (0055bfd0, after 005b2190)
         0x54a760,          # collision record entry (track contact code 00576e00 / 0057xxxx)
         0x550f10,          # pit service: tyre change (pressure, wear, thermal reset)
         0x5486a0,          # damage component decode (telemetry)
         0x563080, 0x550c40, 0x550c60, 0x5512d0,   # 00550a50 car placed on track: repair, engine, fuel, tyres
         0x5f5a60, 0x5f5ac0,                       # 005543f0 world record pose (host sync)
         0x547e90,          # race option 'damage' -> damage scale bef700 (session start 0055be60)
         0x433610]          # collision-damage zone tree (car-model load 00432d90; 00433660, pool 00547e60)
INDIRECT = [0x566aa0, 0x566ab0, 0x566ac0]   # car vtable slots 1, 2, 3 (ECX = car)


def memreader():
    MEM = Path(os.environ['NR2003_MEM']); blocks = []
    for line in (MEM / 'blocks.tsv').read_text().splitlines()[1:]:
        n, st, sz, ini = line.split('\t'); blocks.append((int(st, 16), int(sz)))
    cache = {}
    def read(a, n):
        for st, sz in blocks:
            if st <= a < st + sz:
                if st not in cache: cache[st] = (MEM / ('%08x.bin' % st)).read_bytes()
                return cache[st][a - st:a - st + n]
        raise KeyError(hex(a))
    return read


def lift_all(read=None, roots=ROOTS, indirect=INDIRECT):
    read = read or memreader()
    L = Lifter11(read, dict(BUILTINS), BASE)
    L.signed_zero_rtn = True
    L.hooks = {}
    work = [(f, None) for f in list(roots) + list(indirect)]
    parent = {}
    while work:
        f, p = work.pop()
        if f in L.funcs or f in L.builtins: continue
        parent.setdefault(f, p)
        try:
            new = L.lift(f)
        except Exception as e:
            chain = []; x = f
            while x is not None: chain.append('%06x' % x); x = parent.get(x)
            raise RuntimeError('%s (call chain %s; x87 effect chain %s)' % (e, ' <- '.join(chain), getattr(e, 'chain', '')))
        work += [(c, f) for c in new]
    for f in indirect:
        assert L.effect(f) == 0, 'indirect target %x has an x87 effect' % f
    return L


def call_graph(L):
    g = {}
    for f in L.funcs:
        ins, leaders, calls = L.discover(f)
        g[f] = sorted(c for c in calls)
    return g


if __name__ == '__main__':
    L = lift_all()
    print('lifted', len(L.funcs), 'functions')
    print('indirect sites', [(hex(a), t) for a, t in L.indirect_sites])
    g = call_graph(L)
    for f in sorted(g):
        print('%06x -> %s' % (f, ' '.join('%06x' % c for c in g[f])))
