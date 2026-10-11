import sys, json, struct
names = ['c8 input', 'c0 cur', 'b8 target', 'e80', 'e88 ramp', 'slewL', 'slewR', 'lf', 'rf', 'speed', 'hubLF', 'hubRF', 'draw1554']
a = json.load(open(sys.argv[1])); b = json.load(open(sys.argv[2]))
def f(u): return struct.unpack('<f', struct.pack('<I', u))[0]
first = {}; nd = 0; worst = {}
for ra, rb in zip(a, b):
    for ph in (1, 2):
        for i, (x, y) in enumerate(zip(ra[ph], rb[ph])):
            if x != y:
                nd += 1
                first.setdefault(names[i], (ra[0], ph, '%08x' % x, '%08x' % y, f(x), f(y)))
                d = abs(f(x) - f(y)) / max(abs(f(x)), abs(f(y)), 1e-30)
                worst[names[i]] = max(worst.get(names[i], 0), d)
print('frames', len(a), 'differing cells', nd)
for k, v in first.items(): print('  first', k, v, 'worst rel %.3g' % worst[k])
