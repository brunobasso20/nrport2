"""Generate SETUP_MAP.md: the 184 NR2003 Cup setup items, from the ORIGINAL descriptor table (via the generated
core/NR2003Cup/NR2003CupSetupData.lua), the Stage 10 semantic map (setup_semantics.py), the dynamic destination
analysis (evidence/item_destinations.json: one garage step, ORIGINAL build, memory diff) and the test fixtures
(tests/stage10/fixtures: conversion vectors, per-item builds).
Usage: python gen_setup_map.py <SETUP_MAP.md>"""
import sys, re, json, struct
from pathlib import Path
HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(HERE))
import setup_semantics as SEM

def f(u): return struct.unpack('<f', struct.pack('<I', u & 0xffffffff))[0]
def i32(u): return u - (1 << 32) if u & 0x80000000 else u

def load_data():
    src = (ROOT / 'core/NR2003Cup/NR2003CupSetupData.lua').read_text()
    items = {}
    for m in re.finditer(r'\[(\d+)\]=\{(i=\d+[^\n]*)\},\n', src):
        d = {}
        for k, v in re.findall(r'(\w+)=("[^"]*"|0x[0-9a-f]+|-?\d+|nil)', m.group(2)):
            d[k] = v.strip('"') if v.startswith('"') else (None if v == 'nil' else int(v, 0))
        items[int(m.group(1))] = d
    cup = [int(x, 0) for x in re.search(r'cupDefault = \{\[0\]=([^}]*)\}', src).group(1).split(',')]
    return items, cup

def fmt(v, t):
    if t == 3: return str(i32(v))
    x = f(v)
    s = ('%.4f' % x).rstrip('0').rstrip('.')
    return s if s not in ('-0', '') else '0'

CONV_DESC = {
    'F_ID': 'identidade float', 'I_ID': 'identidade int', 'PCT_TO_FRAC': '×0,01f (FILD/FMUL/FSTP)',
    'INT_TO_FLOAT': 'int → float', 'DEG_TO_RAD': '×0,0174533 (graus → rad)',
    'FSPRING_LBIN_TO_NM': 'lb/pol × 175 × (−0,3136 = −0,56²) → N/m na roda', 'RSPRING_LBIN_TO_NM': 'lb/pol × 175 × (−0,7225 = −0,85²) → N/m na roda',
    'IN_TO_M': '×0,0254', 'TOE_IN_TO_RAD': '× −0,0358423 (−1/27,9 pol) → rad', 'LB_TO_KG': '×0,4536 (lb → kg)',
    'GAL_TO_KG': '/0,3524 (gal → kg)', 'SPOILER_DEG_TO_INT': 'graus − 45', 'K_TO_C': '—',
    'STAGGER_IN_TO_M': '×0,0254 ×0,1592357 (pol de circunferência → m de raio)'
}

def runtime_dest(i, sem, dyn):
    ev = sem['evidence']
    rt = [p.strip() for p in ev.split(';') if p.strip().startswith(('RT', 'DER'))]
    s = '; '.join(rt) if rt else ''
    if dyn is not None:
        c = dyn['counts']
        parts = []
        for k, lbl in (('tire', 'pneu'), ('rec', 'registro'), ('glob', 'global'), ('constcell', 'cél. const'), ('varcell', 'cél. var'), ('item', 'itens deriv.'), ('jit', 'código')):
            if c.get(k): parts.append('%s %d' % (lbl, c[k]))
        s += (' · ' if s else '') + 'DYN: ' + (', '.join(parts) if parts else 'nenhuma célula do build muda')
    return s or '—'

def main(out):
    items, cup = load_data()
    dyn = {}
    p = HERE / 'evidence' / 'item_destinations.json'
    if p.exists(): dyn = {int(k): v for k, v in json.loads(p.read_text()).items()}
    itemfx = {}
    fx = ROOT / 'tests/stage10/fixtures/items_fixture.lua'
    if fx.exists():
        for m in re.finditer(r'\{item=(\d+), tag="([^"]+)", k=(-?\d+), raw=(\d+), structure="(\w+)"', fx.read_text()):
            itemfx.setdefault(int(m.group(1)), []).append((m.group(2), m.group(5)))
    L = []
    L.append('| Item (end.) | Nome semântico | Exibição → armazenado | Unidade | Faixa (padrão Cup) | Passo | Conversão (toInternal / toDisplay) | Destino em tempo de execução | Reinício / recálculo | Status | Confiança | Validação |')
    L.append('|---|---|---|---|---|---|---|---|---|---|---|---|')
    PIT = {0, 1, 2, 3, 45, 46, 49, 59, 64}
    NOT_RECALC = {112, 121, 137, 138, 139, 140, 149, 150, 151, 152}
    conf = {'IDENTIFIED': 'alta', 'INFERRED': 'média', 'UNKNOWN': 'baixa'}
    for i in range(184):
        d = items[i]; s = SEM.S[i]
        addr = '0x%02x · c055c0+0x%x' % (i, 4 * i)
        if d.get('desc'):
            addr += ' · desc %06x' % d['desc']
            t = d['type']
            ti0 = d.get('toInternal') or ''
            stored = 'int32' if ti0 in ('I_ID', 'FRAC_TO_PCT', 'FLOAT_TO_INT') else 'float32'
            if ti0 in ('PCT_TO_FRAC', 'INT_TO_FLOAT', 'FSPRING_LBIN_TO_NM', 'RSPRING_LBIN_TO_NM', 'LB_TO_KG', 'GAL_TO_KG', 'SPOILER_DEG_TO_INT'): stored = 'float32'
            disp = ('int' if t == 3 else 'float') + ' → ' + stored
            rng = '%s..%s (%s)' % (fmt(d['min'], t), fmt(d['max'], t), fmt(d['default'], t))
            step = fmt(d['step'], t)
            ti, td = d.get('toInternal'), d.get('toDisplay')
            conv = '%s `%06x` / %s `%06x`' % (ti or '—', d.get('toInternalAddr', 0), td or '—', d.get('toDisplayAddr', 0))
            if ti in CONV_DESC: conv += ' — ' + CONV_DESC[ti]
            adjustable = ti is not None and d['step'] != 0
        else:
            disp, rng, step = 'interno', '—', '—'
            conv = s['conv']
            adjustable = False
        if i < 71:
            reinit = 'rebuild do carro (garagem → pista)' + ('; ajustável em pit stop (`005601c0`/`00550f10`, não portado)' if i in PIT else '')
            if i in (41, 42, 59, 61, 48): reinit += '; lido do setup ativo em tempo de execução'
        elif i in NOT_RECALC:
            reinit = 'não recalculado por `00559820` (vem do padrão/arquivo .sto)'
        else:
            reinit = 'recalculado por `00559820`/build a cada aplicação'
        status = 'ORIGINAL'
        if i == 48: status = 'ORIGINAL (armazenamento/conversão); uso em tempo real = Stage 12 PROVISIONAL'
        elif i in (49,) or 71 <= i <= 92: status = 'ORIGINAL; consumo em tempo real = Stage 11 (congelado)'
        elif not adjustable and d.get('desc'): status = 'ORIGINAL (fixo no Cup: passo 0)'
        val = []
        if d.get('desc'): val.append('conv. bit a bit (2 CW)')
        if i in itemfx:
            tags = itemfx[i]
            val.append('build mín/máx/±1 = original (%s)' % ', '.join(sorted(set(st for _, st in tags))))
        if not val: val.append('derivado: build = original (fixtures nomeados)')
        L.append('| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |' % (
            addr, s['name'], disp, s['unit'], rng, step, conv, runtime_dest(i, s, dyn.get(i)), reinit, status,
            conf[s['status']], '; '.join(val)))
    head = open(HERE / 'setup_map_head.md').read()
    Path(out).write_text(head + '\n'.join(L) + '\n' + open(HERE / 'setup_map_tail.md').read())
    print('written', out)

if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else str(ROOT / 'SETUP_MAP.md'))
