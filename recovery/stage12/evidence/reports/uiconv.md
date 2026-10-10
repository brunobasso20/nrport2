# uiconv: steering options, front end to simulation (NR2003.exe)

Label `uiconv`. Ghidra project `/opt/nrproj_5` (read-only). Scratch files and evidence are in `/opt/s12/work_uiconv/`:

* `g1/`, `g2/`: ExportSetPy pseudo-C and asm.
* `allfuncs.tsv`: ListFuncsPy over `.text`.
* `xref_a.tsv`, `scan_a.tsv`, `scan_b.tsv`.
* `msgmap.txt`: message id → object, payload, flags, handler and sender. Built by `regmap.py` from the image.
* `relscan.py`: E8/E9 rel32 call scanner over every initialised block.
* `emu.py` + `test_conv.py` → `conv_results.json`, `tables.md`: Unicorn runs of the original instruction bytes,
  checked against an exact rational x87 model.

Notation: **V** = verified (address/instruction cited); **I** = inferred; **U** = unresolved.

## 0. Architecture (V)

`taskStart` is at `005f8560`. It is called from `0043e839` with these arguments:

```
push 0 ; push 0x24 ; push 0x546f80 ; push 0x55cef0 ; push 0x57e070
```

There are three tasks. Each one tags its stack with `testStackUsageBegin` (`5cfda4`) and an ASCII name:

| task | thread | entry → function | tag | x87 CW |
|---|---|---|---|---|
| FG (foreground / front end) | `CreateThread` through protected thunk `010149a0`, called at `005f8644` (start `0x5f8800`, CREATE_SUSPENDED = 4) | `005f8800: call [7559a8]` → `0057e070` | `0057e075 push 0x74fe54` "FG" | no game code sets it (see §2) |
| BG (background / simulation) | `005f7e70`: `[755a08]=1` (bgIsRunning), `5f8fe0(&f72270, 5f7ea0, "bg")` | `005f7ea0: call [7559ac]` → `0055cef0` | `0055cef5 push 0x74deb8` "BG" | **0x077F** |
| SV | `005f7ec0`: `[755a0c]=1` (svIsRunning), `5f8fe0(&f72198, 5f7ef0, "sv")` | `005f7ef0: call [7559b0]` → `00546f80` | `00546f8e push 0x74c8fc` "SV" | **0x077F** |

The function names are Ghidra symbols from the export table:

* `fgIsRunning` = `[755a04]`, `bgIsRunning` = `[755a08]`, `svIsRunning` = `[755a0c]`.
* `inBackground` (`005f8870`) compares `GetCurrentThreadId` with `[f72274]`.
* The fgmsg source file is `psys\task\fgmsg.c` (string at `755ce4`).

## 1. controls.cfg apply block of 0043f1d0 (V)

### File format

`0043f1d0` opens the file and reads it in this order:

* `fileOpenRead(&f, "controls.cfg")` (`5cfdc2`, string at `72c6bc`).
* `piffReadChunkHeader`: the chunk id must be `0x43434647` ('CCFG') and the version must be 0.
* `_fileReadExact` (`5cfdb6`), in order:

| order | buffer | size | type |
|---|---|---|---|
| 1 | `894d3c` | 1 | u8 |
| 2 | `894d74` | 1 | u8 |
| 3 | `894de4` | 4 | i32 |
| 4 | `894d40` | 4 | i32 (linearity) |
| 5 | `894dd8` | 4 | i32 (steering momentum) |
| 6 | `894d7c` | 4 | i32 (throttle momentum) |
| 7 | `894ddc` | 4 | i32 (brake momentum) |
| 8 | `894d75` | 1 | u8 |
| 9 | `894d48` | 1 | u8 |
| 10 | `894d80` | 1 | u8 |
| 11 | `894de0` | 4 | i32 |
| 12 | `894dac` | 4 | i32 |
| 13 | `894d78` | 4 | i32 |
| 14 | `894d44` | 4 | i32 |

After that come `005d0e20(f)` and `0057a580(f)` (the bindings). The sends happen only if `0057a580` returns nonzero
(`0043f421 JZ 0043f592`).

The save function `0043f5e0` writes the same order from the UI globals:

```
72c5e8 72c5e9 894d38 72c5f0 894e18 894e1c 894e20 72c5f4 894e24 894d49 72c5ec 894e10 894e14 72c5f8
```

`0043f631` .. `0043f793` use `5cfd2c`.

### Exact instruction sequence (`0043f427`..`0043f590`)

```
0043f45c..0043f466  EAX = (byte[894d3c]!=0) ? 0 : (byte[894d74]!=0 ? 1 : 3)
0043f46b PUSH EAX ; 0043f46c CALL 00570ec0          ; int32 (shift method)
0043f479..0043f489  PUSH ([894d38]==2||[894d38]==1) ? [894d38] : 0
0043f48b CALL 00570ef0                              ; int32 (gearbox type)
0043f490 FILD  dword ptr [0x00894d40]               ; int32 -> ST0 (exact)
0043f496 MOV   ECX,[0x894d40] ; 0043f49c ADD ESP,4 ; 0043f49f MOV [0x72c5f0],ECX
0043f4a5 FMUL  dword ptr [0x006ea4a4]               ; * f32 0x3c23d70a (0.009999999776482582), rounded by CW.PC/RC
0043f4ab PUSH  ECX                                   ; reserves the 4-byte argument slot
0043f4ac FSTP  dword ptr [ESP]                       ; -> float32, rounded by CW.RC
0043f4af CALL  00570f20                              ; linearity
0043f4b4 FILD  dword ptr [0x00894dd8] ; MOV EDX,[894dd8] ; MOV [894e18],EDX
0043f4c6 FSTP  dword ptr [ESP]       ; 0043f4c9 CALL 00570f50   ; steering momentum  (float)int
0043f4ce FILD  dword ptr [0x00894d7c] ; ... MOV [894e1c],EAX
0043f4de FSTP  dword ptr [ESP]       ; 0043f4e1 CALL 00570f80   ; throttle momentum  (float)int
0043f4e6 FILD  dword ptr [0x00894ddc] ; ... MOV [894e20],ECX
0043f4f8 FSTP  dword ptr [ESP]       ; 0043f4fb CALL 00570fb0   ; brake momentum     (float)int
0043f500 MOV AL,[894d75] ; PUSH EAX ; MOV [72c5f4],AL ; CALL 00570fe0   ; u8 (callee reads only [ESP+4] byte)
0043f510 MOV AL,[894d48] ; PUSH EAX ; MOV [894e24],AL ; CALL 00571010   ; u8
0043f520 MOV AL,[894d80] ; PUSH EAX ; MOV [894d49],AL ; CALL 00570e00   ; u8
0043f53c ADD ESP,0xc     (the float slot stays)
0043f530 FILD [894de0] ; MOV [72c5ec],EDX ; 0043f545 FSTP [ESP] ; CALL 00570e30   ; (float)int FF strength
0043f54d FILD [894dac] ; MOV [894e10],EAX ; 0043f55d FSTP [ESP] ; CALL 00570e60   ; (float)int FF damping
0043f565 FILD [894d78] ; MOV [894e14],ECX ; 0043f577 FSTP [ESP] ; CALL 00570e90   ; (float)int FF latency
0043f57f [72c5f8] = [894d44] ; ESI = 1 ; JMP 0043f5bf (ADD ESP,4)
```

The return values of the senders are ignored. There is no clamping on the front-end side of this path. The int
values from the file are sent as they are; the UI setters clamp them to 0..100.

### Numeric result

The linearity value is `f32_RC( RND_PC,RC( int × 0.01f ) )`. For |int| < 2^29 the product is exact in 53 and 64
bits. With PC = 24 it is rounded once by RC. So the result is a single RC rounding of the exact product, independent
of PC.

Unicorn checks of the original bytes `0043f490`..`0043f4af` against the exact model under CW 0x027f, 0x007f, 0x037f,
0x077f and 0x067f, for 119 ints (−3..105, 127, 128, 255, 256, 1000, 12345, 2^24±1, 2^29+1, ±2^31):

* There were **0 mismatches**.
* 0x027f = 0x007f = 0x037f bit for bit.
* RC = down (0x077f) differs from RC = nearest for 40 of 0..100:
  7, 11, 14, 17, 19, 22, 25, 28, 31, 34, 35, 37, 38, 41, 44, 47, 50, 51, 55, 56, 57, 61, 62, 63, 68, 69, 70, 74, 75,
  76, 81, 82, 83, 87, 88, 89, 93, 94, 95, 100.
* Using double 0.01 instead of the f32 constant would differ for 30 of 0..100, including 20 and 80. Under RN,
  80 → `0x3f4ccccc` (exact tie, ties-to-even), not `0x3f4ccccd`.

The momentum and FF payloads are `(float)int`: exact for |int| ≤ 2^24, and also verified with 0 mismatches.

## 2. Control word per task

### FG (runs 0043f1d0)

The FG path to `0043f1d0` is verified (V), all direct calls:

```
005f8800 call [7559a8]=0057e070
  → 0057e0ab call 0057e0e0
  → 0057e0ea call 004888f0
  → 004888f5 call 00444bb0              (player profile load)
  → 00444f9e call 0043f1c0
  → 0043f1c0 JMP 0043f1d0
```

`00444bb0` then calls `00441e50`, then `00443180` at `00444fa8` (driver aids + steering assist send), then
`00443fc0`.

The second caller is the controls-dialog OK path `004a22d0`..`004a2307`:

```
445ed0 ? (444fc0 ? 0043f5e0 save : error 0x3217) ; 004a22f8 call 0043f1c0 ; 441e50 ; 00443180 ; 443fc0
```

This is UI vtable code (`004a2340` in vtable `006f1480`). That it runs on FG is **I**: the UI is the front end, but
the vtable dispatch is not statically traced.

`0057a580` (called inside `0043f1d0`) is written to be called from the FG: if `inBackground` it hands the work to
FG through `bgRequestFGAction`, otherwise it wraps the work in `fgDisableBG` / `fgEnableBG`.

Which code writes the FPU control word (V):

* `ScanOperandPy "FLDCW"` over the whole program finds FLDCW only in:
  * the game helpers `00567704` (fninit + set RC/PC), `0056772e` (fnsave + set), `00567767` (RC only) and
    `0056778b` (PC only);
  * the CRT (`006cd762`, `006cd8aa`, `006cda50`, `006cdab7`, `006cfe20`, `006d692f` = `_control87`);
  * the protection sections (`0102d968`..`010341e5`).
* `relscan.py` (every E8/E9 in every initialised block) lists all callers of `00567704`: `00546f9c` and `005470a4`
  (SV), `0055cf51` (BG loop) and `0055d145` (BG init `0055d0e0`).
* `0056772e` is called from `00510bb3`, `0053739c` and `0053856c`. Each restores the state with `FRSTOR` (`0056775d`
  at `00510eda`, `005385d4`/`005385ea`, `00537452`/`005374a4`).
* `00567767` and `0056778b` have no callers and no stored pointers.
* `_controlfp` (`006d6964`) is called only by `006cbbf0` = `_controlfp(_PC_53, _MCW_PC)`. That is reached only from
  `006d6984` inside `006d697a` (`fninit` + set precision), which has no callers or pointers.

So no game or CRT code sets the CW on FG.

The FG CW is therefore the OS initial value for a new thread, 0x027F on Windows NT (PC = 53, RC = nearest, masked)
(**I**: an OS fact, not observable in the exe). If a third-party DLL used on FG changed PC (for example a D3D device
without FPU_PRESERVE → 0x007F), §1 shows the payloads do not change. Only a round-down RC on FG would change them,
and nothing in the image does that (**U** for external DLLs).

### Message dispatcher and the task that runs it (V)

The table base is **`0x00752370`**: 0x6f entries of `{u32 flags, u32 handler}`. `0x752540` is entry 0x3a, and
the car options are entries 0x42..0x51 at `752580`..`7525f8`. Names come from `005ba9a0` / jump table `005babc0`.

The dispatcher is `005bad80(id, payload)`:

```
CALL 0055a5a0 (EAX=[c067d0], game state)
LEA ECX,[EAX+EAX*2] ; EAX=1 ; SHL EAX,CL
TEST [ESI*8+0x752370],EAX ; JE skip
CALL [ESI*8+0x752374] (payload ptr)
```

Registration:

* `0056f382 push 0x5bad80 ; call 005f8d40`
* `005f8d40` → `5f8d70`: `[f72748]=cb`, then `ringbufInit(f72734, 0x21, 4, f726b0)` through `5cff00` →
  `rts.dll!ringbufInit`.
* `0056f380` also builds every message object with `005f8df0(obj, id, payload)`. The object layout is:
  `[0]='!DAM'`, `[4]=id`, `[8]=pending`, `[9]=payload ptr`, `[0xd]='SWOC'`.

Posting is done by `005f8da0` (can post) and `005f8e20` (post):

* Both require `bgIsRunning` (`[755a08]`).
* `can post` is `ringbufAvail > 0 && obj.pending == 0`.
* `post` sets `pending = 1` and calls `ringbufWrite(f72734, &obj)`. A full ring asserts "Too many messages posted!"
  (`fgmsg.c` line 0xa0).
* So a second send of a still-pending message is refused (the sender returns 0 and the payload is not overwritten).
  The payload is read by the handler at dispatch time.

The drain is `005f8ec0`:

* It loops `ringbufUsed(f72734)` times: `ringbufRead` then `005f8f00` → `[f72748](obj.id, obj.payload)` →
  `pending = 0`.
* It is called only from `0055cf68`, inside the **BG** loop of `0055cef0` (rel32 scan finds no other caller).

The BG CW (V):

* Init `0055d0e0` calls `0056f380` at `0055d128`, then at `0055d137`..`0055d145`
  `push 3 ; push 1 ; call 00567704`, then `0055a4f0(0)` (state 0).
* Every loop iteration runs:

```
0055cf41 CALL 005676f0 (FNSTCW)
0055cf46 CMP EAX,0x77f
JZ ; else PUSH 3 ; PUSH 1 ; CALL 00567704
```

  The only calls between that and the drain at `0055cf68` are `005f7ff0` and `0055a620`, which are plain
  loads/stores.
* `00567704(rc=1, pc=3)`: `FNINIT`, CW = `(1<<10)|(3<<8)|0x3f` = 0x073F, then `FLDCW`. The code compares the
  read-back with 0x077F, so reserved bit 6 is expected to read as 1 (**I**; Unicorn reads back 0x073F, which would
  only make the BG re-run `00567704` every tick).
* Effective: masked, **PC = 64-bit extended, RC = toward −∞**.
* SV (`00546f9c`, and per frame `00547094`..`005470a4`) does the same.

## 3. Message IDs and every global they set (V)

`msgmap.txt` lists every message. Handlers are the thunks `005bb0xx`; the payload is a pointer.

| id | name (`005ba9a0`) | FE sender ← source | handler → setter | sim global written |
|---|---|---|---|---|
| 0x42 | fgmsgCarSetForceFeedbackOnOff | `00570e00` u8 ← 894d80 (UI 894d49) | `005bb010` → `00550270` | `bf6f1c` (u8) |
| 0x43 | fgmsgCarSetFFStrength | `00570e30` f32 ← (float)72c5ec | `005bb020` → `00550290` | `74c9a4` (f32 copy; image 80.0) |
| 0x44 | fgmsgCarSetFFDamping | `00570e60` f32 ← (float)894e10 | `005bb030` → `005502d0` | `bf6f24` (f32 copy) |
| 0x45 | fgmsgCarSetFFLatency | `00570e90` f32 ← (float)894e14 | `005bb040` → `005502b0` | `bf6f20` (f32 copy) |
| 0x46 | fgmsgCarSetShiftMethod | `00570ec0` i32 (0/1/3) | `005bb050` → `00550340` | `74c974` = arg; `74c980` = arg==0 ? 0.12f (`3df5c28f`) : (`bf6f0c`!=0 ? 0.045f `3d3851ec` : 0.09f `3db851ec`) |
| 0x47 | fgmsgCarSetGearboxType | `00570ef0` i32 (0/1/2) | `005bb060` → `00550380` | `bf6f0c` = arg if arg∈{0,1,2}; then `74c980` is recomputed as for 0x46 |
| **0x48** | **fgmsgCarSetSteeringLinearity** | `00570f20` f32 ← f32(int×0.01f) | `005bb070` (dword copy) → `005502f0` | **`bf6f00`**: x<0 → 0; x≥1 or NaN → 1.0; else bit copy (−0 kept) |
| **0x49** | **fgmsgCarSetSteeringMomentum** | `00570f50` f32 ← (float)int | `005bb080` → `005500c0(0, m)` | **`74c990`** (control 7/8 rate) |
| 0x4a | fgmsgCarSetThrottleMomentum | `00570f80` | `005bb0a0` → `005500c0(1, m)` | `74c994` |
| 0x4b | fgmsgCarSetBrakeMomentum | `00570fb0` | `005bb0c0` → `005500c0(2, m)` | `74c998` |
| **0x4c** | **fgmsgCarSetBoostSteering** (= UI chkSterngRatio, 72c5f4) | `00570fe0` u8 ← 894d75 | `005bb0e0` (MOV CL,[EAX]) → `00550110` | **`74c9a0`** (u8 copy; 2 and 255 are stored as they are) |
| 0x4d | fgmsgControlsSetAnyDrivingKeys (UI chkAnyDrivingKeys, 894e24) | `00571010` u8 | `005bb0f0` → `0057a520` | `d3b02c` (input binding filter, `0057bf6a`; not steering math) |
| 0x4e | fgmsgCarSetBrakingHelp | `00571040` u8 ← `00442ff0()` | `005bb100` → `00550120` | `bf6f04` |
| 0x4f | fgmsgCarSetThrottleHelp | `00571070` u8 ← `00443010()` | `005bb110` → `00550170` | `bf6f05` |
| 0x50 | fgmsgCarSetStabilityControl | `005710a0` u8 ← `00443030()` | `005bb120` → `005501c0` | `bf6f06` |
| **0x51** | **fgmsgCarSetSteeringHelp** (assistance) | `005710d0` i32 ← `00443050()` = [895c7c] | `005bb130`: `XOR EAX,EAX ; MOV AL,[ECX] ; FILD ; FSTP f32` → `00550210` | **`bf6f08`** = f32_RD(byte × 0.01f) |

All of 0x42..0x51 have flags `0x9201`. They are applied only when the game state `[c067d0]` is 0, 3, 4 or 5
(bits 0, 9, 12, 15). In any other state the message is consumed without calling the handler. The state is set by
`0055a4f0`: BG init sets 0; the session code sets 3, 4, 5 or 6; 7 ends the BG loop (`0055cf38`). The meaning of each
state is **U**.

### Sole writers (findptr)

| global | sole writer(s) |
|---|---|
| `bf6f00` | `005502f0` |
| `bf6f08` | `00550210` |
| `74c990`..`74c998` | `005500c0` |
| `74c99c` (2.5) | none (read only, `00552d7d`) |
| `74c9a0` | `00550110`, and the profile value |

`74c9a0` is also a **profile value** "Control Options / steer_ratio / Enable low speed steering ratio override". The
static initialiser `0054fe60` stores `&74c9a0` in profile object `bf632c`, so the ini writes the sim global directly
without a message.

UI bindings (V):

* steeropt sliders, via `0043d0f0`: SterngMomt ↔ `894e18` (`0043f0e0` / `0043f0f0`); ThrotMomt ↔ `894e1c`; BrkMomt ↔
  `894e20`; SterngAsst ↔ `895c7c` (`00443050` / `00443060`; also ini "Control Options / steeringAssist",
  `00442cc0`); SterngLin ↔ `72c5f0`, shown as `100 − v` (`0043d9b0`) and clamped to 0..100 by `0043f0c0`.
* `chkSterngRatio` (`win+0x6d`) ↔ `72c5f4` through `0043f140`/`0043f150` (`0043d950` sets `(state != 0)`).
* `chkAnyDrivingKeys` ↔ `894e24` (`0043f160`/`0043f170`).
* Momentum, linearity and the override are sent **only** by `0043f1d0`. The UI setters only write the UI globals,
  and the values reach the sim when the dialog's OK saves `controls.cfg` and re-reads it (`004a22e2` then
  `004a22f8`).

### Sim-side conversions (Unicorn, original bytes, CW 0x077f, exact model 0 mismatches)

**`005500c0`**:

```
FLD m
FMUL 0.01f
FCOM 0
TEST AH,0x44 ; JP
p == 0  → 1.0
else    → FDIVR 1.0 ; FMUL f64 0x3f9110316a497970 (0.016663333999866692) ; FSTP f32
```

All steps are 64-bit with round-down. The port's double RN plus a round-down f32 store (`setMomentum`) matches for
m = 0..100 and −50, −1, 127, 255, 1000, 100000. Sample values: 0 → 1.0, 20 → `3daaa1ee`, 50 → `3d08818b`,
80 → `3caaa1ee`, 100 → `3c88818b`.

**`00550210`** (assist): `FLD; FMUL 0.01f; FSTP f32`, round-down:

* 100 → `3f7fffff` (0.99999994), 50 → `3effffff`, 1 → `3c23d70a`.
* 40 of 0..100 differ from RN.
* Bytes above 100 come from the low byte of the int.

## 4. No controls.cfg (V unless marked)

`0043f1d0` returns 0 before any send if any of these fail:

* `00445ef0` (player directory);
* the open;
* the header or any read;
* `0057a580`.

Nothing from §3 rows 0x42..0x4d is sent. Front-end statics are left as they are:

| global | value |
|---|---|
| `72c5e8` (shiftingHelp) | 1 |
| `72c5e9` | 1 |
| `72c5ec` (FF strength) | 50 |
| `72c5f0` (linearity) | 80, slider shows 20 |
| `72c5f4` (chkSterngRatio) | 1 |
| `72c5f8` | 1 |
| BSS `894e18`/`894e1c`/`894e20` (momentum) | 0 (I: zero-filled; the only code references are the getters/setters, loader and saver) |
| BSS `894e10`/`894e14`, `894e24`, `894d49`, `894d38` | 0 |

The sim keeps its image values:

| global | value |
|---|---|
| `bf6f00` | 0 (BSS) |
| `74c990` | `3d072b02` (0.033) |
| `74c994`, `74c998` | 1.0 |
| `74c99c` | 2.5 |
| `74c9a0` | 1, or the ini steer_ratio |
| `74c9a4` | 80.0 |
| `74c974` | 1 |
| `74c980` | 0.09 |
| `bf6f0c` | 0 |

The steering assist is sent anyway: `00444fa8 call 00443180` → `005710d0([895c7c])` runs on every player load
(`895c7c` is ini steeringAssist; BSS 0 by default). The UI defaults reach the sim only after the controls dialog OK
path saves and reloads the file. With the defaults that would be:

* linearity 80 → `bf6f00 = 0x3f4ccccc`;
* steering momentum 0 → `74c990 = 1.0` (no slew);
* throttle/brake momentum → 1.0;
* override 1;
* FF strength 50.0.

Whether a shipped default `controls.cfg` is copied into new player directories is **U**.

## Appendix: per-value table (0..100)

Columns:

* linearity payload under RN (0x027f, which equals 0x007f and 0x037f);
* the RD (0x077f) value, only where it differs;
* `74c990` after 0x49 (BG 0x077f);
* `bf6f08` after 0x51 (BG 0x077f).

| v | linearity RN | linearity RD | steer rate 74c990 | assist bf6f08 |
|---|---|---|---|---|
| 0 | 00000000 (0) | same | 3f800000 (1) | 00000000 (0) |
| 1 | 3c23d70a (0.00999999978) | same | 3fd54a6a (1.66633344) | 3c23d70a (0.00999999978) |
| 2 | 3ca3d70a (0.0199999996) | same | 3f554a6a (0.833166718) | 3ca3d70a (0.0199999996) |
| 3 | 3cf5c28f (0.0299999993) | same | 3f0e319c (0.555444479) | 3cf5c28f (0.0299999993) |
| 4 | 3d23d70a (0.0399999991) | same | 3ed54a6a (0.416583359) | 3d23d70a (0.0399999991) |
| 5 | 3d4ccccc (0.049999997) | same | 3eaaa1ee (0.333266675) | 3d4ccccc (0.049999997) |
| 6 | 3d75c28f (0.0599999987) | same | 3e8e319c (0.277722239) | 3d75c28f (0.0599999987) |
| 7 | 3d8f5c29 (0.0700000003) | 3d8f5c28 | 3e73c2c2 (0.23804763) | 3d8f5c28 (0.0699999928) |
| 8 | 3da3d70a (0.0799999982) | same | 3e554a6a (0.20829168) | 3da3d70a (0.0799999982) |
| 9 | 3db851eb (0.0899999961) | same | 3e3d977a (0.18514815) | 3db851eb (0.0899999961) |
| 10 | 3dcccccc (0.099999994) | same | 3e2aa1ee (0.166633338) | 3dcccccc (0.099999994) |
| 11 | 3de147ae (0.109999999) | 3de147ad | 3e1b1ed8 (0.151484847) | 3de147ad (0.109999992) |
| 12 | 3df5c28f (0.119999997) | same | 3e0e319c (0.13886112) | 3df5c28f (0.119999997) |
| 13 | 3e051eb8 (0.129999995) | same | 3e03417c (0.128179491) | 3e051eb8 (0.129999995) |
| 14 | 3e0f5c29 (0.140000001) | 3e0f5c28 | 3df3c2c2 (0.119023815) | 3e0f5c28 (0.139999986) |
| 15 | 3e199999 (0.149999991) | same | 3de38293 (0.111088894) | 3e199999 (0.149999991) |
| 16 | 3e23d70a (0.159999996) | same | 3dd54a6a (0.10414584) | 3e23d70a (0.159999996) |
| 17 | 3e2e147b (0.170000002) | 3e2e147a | 3dc8be81 (0.0980196074) | 3e2e147a (0.169999987) |
| 18 | 3e3851eb (0.179999992) | same | 3dbd977a (0.0925740749) | 3e3851eb (0.179999992) |
| 19 | 3e428f5c (0.189999998) | 3e428f5b | 3db39cfa (0.0877017528) | 3e428f5b (0.189999983) |
| 20 | 3e4ccccc (0.199999988) | same | 3daaa1ee (0.0833166689) | 3e4ccccc (0.199999988) |
| 21 | 3e570a3d (0.209999993) | same | 3da281d6 (0.0793492049) | 3e570a3d (0.209999993) |
| 22 | 3e6147ae (0.219999999) | 3e6147ad | 3d9b1ed8 (0.0757424235) | 3e6147ad (0.219999984) |
| 23 | 3e6b851e (0.229999989) | same | 3d946049 (0.0724492744) | 3e6b851e (0.229999989) |
| 24 | 3e75c28f (0.239999995) | same | 3d8e319c (0.0694305599) | 3e75c28f (0.239999995) |
| 25 | 3e800000 (0.25) | 3e7fffff | 3d88818b (0.0666533336) | 3e7fffff (0.249999985) |
| 26 | 3e851eb8 (0.25999999) | same | 3d83417c (0.0640897453) | 3e851eb8 (0.25999999) |
| 27 | 3e8a3d70 (0.269999981) | same | 3d7cc9f8 (0.0617160499) | 3e8a3d70 (0.269999981) |
| 28 | 3e8f5c29 (0.280000001) | 3e8f5c28 | 3d73c2c2 (0.0595119074) | 3e8f5c28 (0.279999971) |
| 29 | 3e947ae1 (0.289999992) | same | 3d6b5af0 (0.0574597716) | 3e947ae1 (0.289999992) |
| 30 | 3e999999 (0.299999982) | same | 3d638293 (0.0555444472) | 3e999999 (0.299999982) |
| 31 | 3e9eb852 (0.310000002) | 3e9eb851 | 3d5c2bc8 (0.0537526906) | 3e9eb851 (0.309999973) |
| 32 | 3ea3d70a (0.319999993) | same | 3d554a6a (0.0520729199) | 3ea3d70a (0.319999993) |
| 33 | 3ea8f5c2 (0.329999983) | same | 3d4ed3cb (0.0504949503) | 3ea8f5c2 (0.329999983) |
| 34 | 3eae147b (0.340000004) | 3eae147a | 3d48be81 (0.0490098037) | 3eae147a (0.339999974) |
| 35 | 3eb33333 (0.349999994) | 3eb33332 | 3d430235 (0.0476095267) | 3eb33332 (0.349999964) |
| 36 | 3eb851eb (0.359999985) | same | 3d3d977a (0.0462870374) | 3eb851eb (0.359999985) |
| 37 | 3ebd70a4 (0.370000005) | 3ebd70a3 | 3d3877b5 (0.0450360365) | 3ebd70a3 (0.369999975) |
| 38 | 3ec28f5c (0.379999995) | 3ec28f5b | 3d339cfa (0.0438508764) | 3ec28f5b (0.379999965) |
| 39 | 3ec7ae14 (0.389999986) | same | 3d2f01fb (0.0427264981) | 3ec7ae14 (0.389999986) |
| 40 | 3ecccccc (0.399999976) | same | 3d2aa1ee (0.0416583344) | 3ecccccc (0.399999976) |
| 41 | 3ed1eb85 (0.409999996) | 3ed1eb84 | 3d267884 (0.0406422764) | 3ed1eb84 (0.409999967) |
| 42 | 3ed70a3d (0.419999987) | same | 3d2281d6 (0.0396746024) | 3ed70a3d (0.419999987) |
| 43 | 3edc28f5 (0.429999977) | same | 3d1eba5a (0.0387519374) | 3edc28f5 (0.429999977) |
| 44 | 3ee147ae (0.439999998) | 3ee147ad | 3d1b1ed8 (0.0378712118) | 3ee147ad (0.439999968) |
| 45 | 3ee66666 (0.449999988) | same | 3d17ac62 (0.0370296314) | 3ee66666 (0.449999988) |
| 46 | 3eeb851e (0.459999979) | same | 3d146049 (0.0362246372) | 3eeb851e (0.459999979) |
| 47 | 3ef0a3d7 (0.469999999) | 3ef0a3d6 | 3d11381c (0.0354539007) | 3ef0a3d6 (0.469999969) |
| 48 | 3ef5c28f (0.479999989) | same | 3d0e319c (0.0347152799) | 3ef5c28f (0.479999989) |
| 49 | 3efae147 (0.48999998) | same | 3d0b4ab8 (0.0340068042) | 3efae147 (0.48999998) |
| 50 | 3f000000 (0.5) | 3effffff | 3d08818b (0.0333266668) | 3effffff (0.49999997) |
| 51 | 3f028f5c (0.50999999) | 3f028f5b | 3d05d456 (0.0326732025) | 3f028f5b (0.509999931) |
| 52 | 3f051eb8 (0.519999981) | same | 3d03417c (0.0320448726) | 3f051eb8 (0.519999981) |
| 53 | 3f07ae14 (0.529999971) | same | 3d00c77e (0.0314402506) | 3f07ae14 (0.529999971) |
| 54 | 3f0a3d70 (0.539999962) | same | 3cfcc9f8 (0.030858025) | 3f0a3d70 (0.539999962) |
| 55 | 3f0ccccd (0.550000012) | 3f0ccccc | 3cf8315a (0.0302969702) | 3f0ccccc (0.549999952) |
| 56 | 3f0f5c29 (0.560000002) | 3f0f5c28 | 3cf3c2c2 (0.0297559537) | 3f0f5c28 (0.559999943) |
| 57 | 3f11eb85 (0.569999993) | 3f11eb84 | 3cef7bf9 (0.0292339195) | 3f11eb84 (0.569999933) |
| 58 | 3f147ae1 (0.579999983) | same | 3ceb5af0 (0.0287298858) | 3f147ae1 (0.579999983) |
| 59 | 3f170a3d (0.589999974) | same | 3ce75dbc (0.0282429382) | 3f170a3d (0.589999974) |
| 60 | 3f199999 (0.599999964) | same | 3ce38293 (0.0277722236) | 3f199999 (0.599999964) |
| 61 | 3f1c28f6 (0.610000014) | 3f1c28f5 | 3cdfc7c7 (0.0273169409) | 3f1c28f5 (0.609999955) |
| 62 | 3f1eb852 (0.620000005) | 3f1eb851 | 3cdc2bc8 (0.0268763453) | 3f1eb851 (0.619999945) |
| 63 | 3f2147ae (0.629999995) | 3f2147ad | 3cd8ad1e (0.0264497362) | 3f2147ad (0.629999936) |
| 64 | 3f23d70a (0.639999986) | same | 3cd54a6a (0.02603646) | 3f23d70a (0.639999986) |
| 65 | 3f266666 (0.649999976) | same | 3cd20260 (0.0256358981) | 3f266666 (0.649999976) |
| 66 | 3f28f5c2 (0.659999967) | same | 3cced3cb (0.0252474751) | 3f28f5c2 (0.659999967) |
| 67 | 3f2b851e (0.669999957) | same | 3ccbbd87 (0.0248706471) | 3f2b851e (0.669999957) |
| 68 | 3f2e147b (0.680000007) | 3f2e147a | 3cc8be81 (0.0245049018) | 3f2e147a (0.679999948) |
| 69 | 3f30a3d7 (0.689999998) | 3f30a3d6 | 3cc5d5b7 (0.0241497587) | 3f30a3d6 (0.689999938) |
| 70 | 3f333333 (0.699999988) | 3f333332 | 3cc30235 (0.0238047633) | 3f333332 (0.699999928) |
| 71 | 3f35c28f (0.709999979) | same | 3cc04313 (0.0234694835) | 3f35c28f (0.709999979) |
| 72 | 3f3851eb (0.719999969) | same | 3cbd977a (0.0231435187) | 3f3851eb (0.719999969) |
| 73 | 3f3ae147 (0.729999959) | same | 3cbafe9c (0.0228264853) | 3f3ae147 (0.729999959) |
| 74 | 3f3d70a4 (0.74000001) | 3f3d70a3 | 3cb877b5 (0.0225180183) | 3f3d70a3 (0.73999995) |
| 75 | 3f400000 (0.75) | 3f3fffff | 3cb6020f (0.0222177785) | 3f3fffff (0.74999994) |
| 76 | 3f428f5c (0.75999999) | 3f428f5b | 3cb39cfa (0.0219254382) | 3f428f5b (0.759999931) |
| 77 | 3f451eb8 (0.769999981) | same | 3cb147d3 (0.0216406938) | 3f451eb8 (0.769999981) |
| 78 | 3f47ae14 (0.779999971) | same | 3caf01fb (0.021363249) | 3f47ae14 (0.779999971) |
| 79 | 3f4a3d70 (0.789999962) | same | 3caccadd (0.0210928265) | 3f4a3d70 (0.789999962) |
| 80 | 3f4ccccc (0.799999952) | same | 3caaa1ee (0.0208291672) | 3f4ccccc (0.799999952) |
| 81 | 3f4f5c29 (0.810000002) | 3f4f5c28 | 3ca886a5 (0.020572016) | 3f4f5c28 (0.809999943) |
| 82 | 3f51eb85 (0.819999993) | 3f51eb84 | 3ca67884 (0.0203211382) | 3f51eb84 (0.819999933) |
| 83 | 3f547ae1 (0.829999983) | 3f547ae0 | 3ca47710 (0.0200763047) | 3f547ae0 (0.829999924) |
| 84 | 3f570a3d (0.839999974) | same | 3ca281d6 (0.0198373012) | 3f570a3d (0.839999974) |
| 85 | 3f599999 (0.849999964) | same | 3ca09867 (0.0196039211) | 3f599999 (0.849999964) |
| 86 | 3f5c28f5 (0.859999955) | same | 3c9eba5a (0.0193759687) | 3f5c28f5 (0.859999955) |
| 87 | 3f5eb852 (0.870000005) | 3f5eb851 | 3c9ce74b (0.0191532578) | 3f5eb851 (0.869999945) |
| 88 | 3f6147ae (0.879999995) | 3f6147ad | 3c9b1ed8 (0.0189356059) | 3f6147ad (0.879999936) |
| 89 | 3f63d70a (0.889999986) | 3f63d709 | 3c9960a8 (0.0187228471) | 3f63d709 (0.889999926) |
| 90 | 3f666666 (0.899999976) | same | 3c97ac62 (0.0185148157) | 3f666666 (0.899999976) |
| 91 | 3f68f5c2 (0.909999967) | same | 3c9601b2 (0.0183113553) | 3f68f5c2 (0.909999967) |
| 92 | 3f6b851e (0.919999957) | same | 3c946049 (0.0181123186) | 3f6b851e (0.919999957) |
| 93 | 3f6e147b (0.930000007) | 3f6e147a | 3c92c7da (0.0179175623) | 3f6e147a (0.929999948) |
| 94 | 3f70a3d7 (0.939999998) | 3f70a3d6 | 3c91381c (0.0177269503) | 3f70a3d6 (0.939999938) |
| 95 | 3f733333 (0.949999988) | 3f733332 | 3c8fb0c8 (0.0175403506) | 3f733332 (0.949999928) |
| 96 | 3f75c28f (0.959999979) | same | 3c8e319c (0.01735764) | 3f75c28f (0.959999979) |
| 97 | 3f7851eb (0.969999969) | same | 3c8cba55 (0.0171786938) | 3f7851eb (0.969999969) |
| 98 | 3f7ae147 (0.979999959) | same | 3c8b4ab8 (0.0170034021) | 3f7ae147 (0.979999959) |
| 99 | 3f7d70a3 (0.98999995) | same | 3c89e287 (0.0168316495) | 3f7d70a3 (0.98999995) |
| 100 | 3f800000 (1) | 3f7fffff | 3c88818b (0.0166633334) | 3f7fffff (0.99999994) |
