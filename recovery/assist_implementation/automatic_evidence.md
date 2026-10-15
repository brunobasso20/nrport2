# Original automatic selection evidence

Reference: verified NR2003.exe 1.2.0.1; simulation control word 0x077f. This module chooses requests; original lifted 00553d70 executes them.

## Integration and state

- Original 00551e80 calls 005536b0 after frame ramp preparation when gearbox bf6f0c != 2, no pending request bf63cc, and 00552400 reports automatic (74c974 == 0).
- 005542e0 reports auto-clutch when 74c974 != 3. The original UI modes are 0 automatic, 1 manual with auto-clutch, 3 manual without auto-clutch.
- InitializeAutomaticOriginal reproduces 00562f90 after setup/engine/spec changes. It reads GARAGE c03350 ratios 0x66..0x6e, computes c53438 ratios and c53418 reciprocals, c08728 engine-set RPM minus 100, and c533f8 downshift thresholds using bdbd00 track type.
- PredictedRPMOriginal reproduces 00553920 using ACTIVE c055c0 ratios, the two original rear tyre-profile radii selected by 0056ed60 (including track direction), and constants 60 / 3.0473451614379883. The old runtime image omitted global table 00734368; production reads the identical profile objects already bound at each rear tyre's +0x70 by the original build. Native fixtures assert those pointers equal the original table lookup, and a fresh vehicle integration run drives and shifts without applying fixture contexts.
- Selector 005536b0 compares the retained x87 predicted RPM against the upshift threshold, but the downshift compares the float32-down stored RPM; the final downshift comparison includes equality (00553878 TEST AH,0x41).
- Requests 00552450/480 write bf63cc = 1 / 5 and clear bf6e98 only when bf6ea0 is 0, 3 or 4. Selected-gear updates bf6e23 happen before this gate.

## Shift option setters, original disassembly

### 00550340 shift method

```text
00550340 mov eax, dword ptr [esp + 4]
00550344 test eax, eax
00550346 jne 0x550358
00550348 mov dword ptr [0x74c980], 0x3df5c28f
00550352 mov dword ptr [0x74c974], eax
00550357 ret
00550358 mov ecx, dword ptr [0xbf6f0c]
0055035e mov dword ptr [0x74c980], 0x3db851ec
00550368 test ecx, ecx
0055036a je 0x550376
0055036c mov dword ptr [0x74c980], 0x3d3851ec
00550376 mov dword ptr [0x74c974], eax
0055037b ret
```

### 00550380 gearbox type

```text
00550380 mov eax, dword ptr [esp + 4]
00550384 test eax, eax
00550386 je 0x550392
00550388 cmp eax, 1
0055038b je 0x550392
0055038d cmp eax, 2
00550390 jne 0x550397
00550392 mov dword ptr [0xbf6f0c], eax
00550397 mov eax, dword ptr [0x74c974]
0055039c test eax, eax
0055039e jne 0x5503ab
005503a0 mov dword ptr [0x74c980], 0x3df5c28f
005503aa ret
005503ab mov eax, dword ptr [0xbf6f0c]
005503b0 mov dword ptr [0x74c980], 0x3db851ec
005503ba test eax, eax
005503bc je 0x5503c8
005503be mov dword ptr [0x74c980], 0x3d3851ec
005503c8 ret
```

Timing setters copy exact bits: automatic 0x3df5c28f (~0.12 s); manual sequential 0x3db851ec (~0.09 s); manual selected/direct gearbox 0x3d3851ec (~0.045 s).

## Differential regression

automatic_reference.py executes ORIGINAL 00562f90, 00553920 and 005536b0 in Unicorn for Cup default and the official 1.2.0.1 Watkins fast setup. The Luau regression checks 50 initializer cells, 102 predicted-RPM cases including threshold neighbours, and 588 selector states bit for bit, including modes, skipped gears, idle/neutral/reverse cases, keys, shift phases and request timers. Predicted RPM doubles differ at most 1.24e-16 relative; every float32-down result matches.

## Other aid inventory

- ABS: bf6f04, setter/getter 00550120/00550130; force-input path 00553080 is already ported in NR2003CupDriver. UI string 0113d90a is Anti-Lock Brakes; help at 0113f99c identifies keyboard braking as default-on.
- TC: bf6f05, setter/getter 00550170/00550180; original 00552df0 throttle processing is already ported when originalPedals is enabled. Digital pedal ramps remain active even when TC is off.
- Stability: bf6f06, setter/getter 005501c0/005501d0; chassis-force routine 00561e50 is already lifted in NR2003CupCore. It needs body velocity and original coefficients, not a racing line.
- Steering: bf6f08, setter/getter 00550210/00550230; positive assistance in 00552720 requires car-world record +0x5ae, racing-line data bd7960 and alternate-line selection helpers. Earlier Stage 12 refuses this branch.
- Race settings bit 29 at c0692a+0x4c forces these four aid getters off. It does not gate automatic shifting or auto-clutch.
- No separate player opposite-lock or spin-recovery toggle was established. crashing_recovery_* strings belong AI defaults. Stability and assisted steering contain the relevant velocity/slip recovery behavior; do not invent another gain.
