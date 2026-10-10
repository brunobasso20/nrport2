# Race settings record `c0692a` +0x4c: bit 25 (Arcade driving mode), bit 29 (hardcore "Driving Aids") and the other bits

Label: bit25 (report updated in a continuation run: sections 7a to 7c and the bits table). Scratch and evidence: `/opt/s12/work_bit25/` (`ev1..ev3` Ghidra exports, `*.txt/*.tsv` scans, `vt_slots.txt`,
`rsrc_strings.txt`, `ev_*.txt` disassembly, `spec_cmp.txt`). Ghidra project copy used: `/opt/nrproj_1` (read-only).

## Answer

* **Bit 25 (0x02000000) is the race option "Driving Mode", Arcade vs Simulation.** 1 = **Arcade**, 0 = Simulation.
  * ini key `DrivingMode`, description string `"arcade mode?"`, a bool ProfileValue in **player.ini** (profile id 0x14).
    It exists in each track-selection screen section: `[Testing]`, `[Single Race]`, `[World Championship]`,
    `[Multiplayer Host]`, `[Multiplayer Client]`, `[Dedicated Server]`.
  * UI: radio group `radDrivingMode` on the `trksel_*.win` screens. Item 0 = "Arcade", item 1 = "Simulation".
  * **Default: false, which is Simulation.** The backing bytes are in uninitialised .data and nothing else writes them
    before the ProfileValue constructor copies the value.
  * It is a **per-session race option**, not a difficulty level or a controls option. In multiplayer the host or
    dedicated server picks it, and the record carries it to every client, so it is enforced on everyone.
    * The client screen's "send" slot (`004cee10`) does nothing.
    * The client copies bit 25 back into its own `DrivingMode` variable.
    * The server browser shows it as the `A` flag.
* **Bit 29 (0x20000000) is the multiplayer "Hardcore Mode = Driving Aids" flag.**
  * ini key `hardcoreMode` (int, `"force hardcore visuals and/or driving aids for everyone?"`), plus `hardcoreModeLast`.
    Both are only in `[Multiplayer Host]`, `[Multiplayer Client]` and `[Dedicated Server]`.
  * UI: `chkHardcoreMode` with the `ddnHardcoreMode` list (`lstHardcoreMode`): "Visual", "Driving Aids", "Both".
  * Encoding: mode 1 (Visual) sets bit 19 (0x80000); mode 2 (Driving Aids) sets bit 29; mode 3 (Both) sets bits 19 and 29.
  * Default: hardcoreMode 0, which means off.
  * The in-game help text describes the effect: Driving Aids mode turns off "anti-lock brakes, stability control,
    steering assistance, and traction control … for all competitors". Visual mode forces cockpit view with smoke
    and windshield buildup.
  * On Testing, Single Race and World Championship the getter returns an unregistered, never-written .bss variable,
    so these bits are always 0 there.

## 1. Where the record is built: `004c5400` (shared track-selection base class)

`004c5400` is `__thiscall(this = screen, rec)`. It is called directly from `004c53cd`, `004d40ba`, `004d4f20`, `004d5a09`
and `004d6305`. The callers were found with an E8 rel32 scan; the `004c53c0` caller is vtable slot +0x134. It does three
things:

1. Zeroes rec+0x44..0x66 (`004c5497 STOSD.REP` with ECX = 8, then STOSW and STOSB).
2. Fills every race field by calling **virtual getters on the screen object**. Each getter returns a pointer to the
   option's backing variable.
3. Calls vt+0x13c.

The +0x4c bit writes (asm in `ev_builder_bits.txt` and `ev1/004c5400.asm`):

```
004c54c8 MOV EBX,[EBP+0x4c] ; 004c54d0 AND EBX,0xffffff80   (bits 0..6 cleared)
004c54fe AND EBX,0xfffef0ff ; 004c550b OR EDI,0x80           (bits 8..11,16 cleared, bit 7 = 1)
004c561b CALL [EAX+0xec]  -> AND 1, SHL 0x1e  -> bit 30
004c565e CALL [EDX+0xf4]  -> AND 1, SHL 0x18  -> bit 24
004c5694 CALL 00595520 / 004c569d CALL 00595770(track, !bit24) -> AND 0xf, SHL 0xc -> bits 12..15
004c56b7 CALL [EDX+0xf8]  -> AND 1, SHL 0x14  -> bit 20
004c56d9 CALL [EDX+0xfc]  -> AND 3, SHL 0x11  -> bits 17..18
004c5711 CALL [EAX+0x10c] ; 004c5717 MOV CL,[EAX] ; 004c571b AND ECX,1 ; 004c571e AND EBX,0xfdffffff
004c5724 SHL ECX,0x19 ; 004c572b XOR EDI,EBX ; 004c572d MOV [EBP+0x4c],EDI      <== BIT 25 WRITER
004c5730 CALL [EDX+0x110] -> SHL 0x16, mask 0xc00000 -> bits 22..23 (damage)
004c574b CALL [EDX+0x114] -> AND 1, SHL 0x15 -> bit 21
004c576d CALL [EDX+0x118] ; 004c5773 MOV EAX,[EAX] ; switch:
   0: 004c57a4 AND EDI,0xdff7ffff        (clear 19,29)
   1: 004c5796 AND EDI,0xdfffffff ; OR EDI,0x80000   (bit 19)
   2: 004c5788 AND EDI,0xfff7ffff ; OR EDI,0x20000000 (bit 29)   <== BIT 29 WRITER
   3: 004c5780 OR EDI,0x20080000           (19+29)
004c57ae MOV [EBP+0x4c],EDI
004c57e5 CALL [EDX+0x12c] -> SHL 0x1a, mask 0x1c000000 -> bits 26..28 (wind direction)
```

### Which variable each getter slot returns (`vt_slots.txt`)

The derived screen vtables were found by comparing their entries with the abstract base `6f1fc8`, whose slots point
to purecall `006c4ac0`. The screen-to-vtable assignment comes from the ini section names registered next to each
constructor.

| vtable | screen (ini section) | +0x10c → | +0x118 → |
|---|---|---|---|
| `6f2218` | Dedicated Server | `8d4521` = DrivingMode | `8d452c` = hardcoreMode |
| `6f2488` | Multiplayer Client | `8d5309` = DrivingMode | `8d5314` = hardcoreMode |
| `6f26c8` | Multiplayer Host | `8d6341` = DrivingMode | `8d634c` = hardcoreMode |
| `6f2908` | Testing (`trksel_test.win`) | `8d6cb9` = DrivingMode | `8d6cc4` (unregistered) |
| `6f2b48` | Single Race (`trksel_single.win`) | `8d7a39` = DrivingMode | `8d7a44` (unregistered) |
| `6f2d88` | World Championship (`trksel_champ.win`) | `971d41` = DrivingMode | `971d4c` (unregistered) |

Each getter is a plain `mov eax, imm; ret`, for example `004d25f0 mov eax,0x8d7a39 ; ret` and
`004cd230 mov eax,0x8d452c ; ret`. The DamageModel getter `004cd200` clamps the value to 0..3.

The unregistered variables (`8d6cc4`, `8d7a44`, `971d4c`) have no other immediate references in .text (`immfind.py`).
They are .bss, so they are always 0, and single-player records never get bits 19 or 29.

### ini registrations

The `optscan.py` output is in `opts_all.txt`. `ProfileValue::ProfileValue(int file, section, key, desc, SaveOption, SaveOption)`
is the rts.dll import, resolved through IAT `6e96d0` → name RVA `313922`; `005cfd02` is a `jmp [6e96d0]` thunk.

| constructor call | section | key | description | backing | type vtable |
|---|---|---|---|---|---|
| `004cc7fa` | Dedicated Server | DrivingMode | "arcade mode?" | `8d4521` | `6ed680` (bool) |
| `004cc8fa` | Dedicated Server | hardcoreMode | "force hardcore visuals and/or driving aids for everyone?" | `8d452c` | `6ec710` (int) |
| `004cc97a` | Dedicated Server | hardcoreModeLast | "last used non-zero hardcore mode setting" | `8d4530` | int |

The same keys are registered for the other sections:

* Multiplayer Client: `004ce3fa`, `004ce4fa`, `004ce57a`.
* Multiplayer Host: `004cfafa`, `004cfbfa`, `004cfc7a`.
* DrivingMode only: Testing `004d0aba`, Single Race `004d1f4a`, World Championship `004d368a`.

**Profile file id 0x14 is player.ini.** This was checked at two calls:

* `00444d57 push 0x72e194 "player.ini" ; push 0x14 ; call 5cfd26` (`ProfileManager::Load`, IAT `6e96b8`).
* `00445031 push "player.ini" ; push 0x14 ; call 5cfd44` (`ProfileManager::Save`).

**Default.** For example, `004cc7ff mov al,[0x8d4521] ; mov [0x8d3a4e],al ; mov [0x8d3a4f],al` copies the backing byte
into the ProfileValue as its default. All the backing variables are above 0x761000, in the uninitialised .data block
(blocks.tsv: `.data 761000 … false`). Apart from these constructors and their getters, nothing writes them before use.
So the default is 0, which is Simulation, no hardcore and damage index 0.

## 2. UI to record: the click handlers, which are also bit 25/29 writers

UI dispatch table `0x742e70..0x7432c8` holds entries of {name, flags, kind, 0, handler thunk, arg}:

* `0x743148`: `radDrivingMode` → thunk `004cbb10` (`jmp [eax+0x1ac]`) → **`004c8d00`**.
* `0x743190`: `chkHardcoreMode` → `004cbbd0` (`jmp [eax+0x1b8]`) → **`004c8ec0`**.
* `0x7431a8`: `ddnHardcoreMode` → `004cba10` (`jmp [eax+0x1bc]`) → **`004c8f80`**.
* `ddnDamage` → `004c8d70`, and `chkMechFailures` → `004c8e50`.

Each handler copies the current record `8d3288` (0x2b dwords + 1 byte), changes the bits, and passes the copy to vt+0x138.
It only does this when `[8d33a1] != 0`, a flag that `004c3090` sets once `8d3288` holds a valid record (`004c314c`).

```
004c8d39 test ecx,ecx ; 004c8d3b sete dl ; 004c8d43 shl edx,0x19 ; xor ; 004c8d48 and edx,0x2000000 ; xor
004c8d52 mov [esp+0x5c],ecx   (= copy+0x4c)  -> bit25 = (radio index == 0)  => index 0 = Arcade
004c8ec0: arg<1 -> AND 0xdff7ffff ; else by hardcoreModeLast (vt+0x11c): 1 -> |0x80000 ; 2 -> |0x20000000 ; else |0x20080000
004c8f80: selected list value: 1 -> bit19, 2 -> bit29, else both
004c8e50: bit21 = checkbox (chkMechFailures)
```

The base vt+0x138 is `004c5890`, which calls `005712d0`. That function copies the 0xad-byte record into mailbox `c5f518`
under lock `c6f6a4`, and the mailbox is registered as channel 0x58 at `0056f951`. On the multiplayer client, vt+0x138
is `004cee10` (`mov eax,1 ; ret 8`), so **the client cannot change the settings**.

## 3. Record to UI and variables (the inverse, which shows the encoding)

`004c5f50` is called from vt+0x14c `004c5c10` when the incoming record's +0x40 differs from `8d33d4`, and also from
`004c2b67` and `004c7e7a`:

```
004c69d3 call [eax+0x10c] ; 004c69d9 mov ecx,[edi+0x4c] ; shr ecx,0x19 ; and cl,1 ; 004c69e2 mov [eax],cl   DrivingMode = bit25
004c69e9 call [edx+0x10c] ; test cl,cl ; je -> push 1 ; else push 0 ; 004c6a0b call 0060a670(radio)   (arcade -> item 0)
004c6a21 call [eax+0x110] ; shr 0x16 ; and 3 -> DamageModel
004c6b44 call [edx+0x118] ; ecx = ((rec4c>>0x1d)&1)*2 | ((rec4c>>0x13)&1) ; 004c6b5c mov [eax],ecx   hardcoreMode = 2*b29 + b19
004c6b63.. if hardcoreMode != 0 -> hardcoreModeLast = hardcoreMode ; chkHardcoreMode = (mode != 0)
```

The labels come from the .rsrc string tables (`rsrc_strings.txt`, UTF-16):

* `0x1147ad2`: "Arcade", "Simulation", then the damage names "None", "Arcade", "Realistic", "Moderate".
* `0x114b79c`: "Visual", "Driving Aids", "Both".
* Help text `0x1147484`: "Arcade mode has fewer rules to follow and features a relatively easy-to-drive car with
  unrealistically high levels of power and grip. Simulation mode features the full set of NASCAR rules and an
  ultra-realistic physics model …".
* Help text `0x114a230`: "If checked, a Hardcore Mode can be selected. If the Visual mode is selected, all competitors
  will be forced to race from the cockpit view, with smoke and windshield buildup enabled. If the Driving Aids mode is
  selected, anti-lock brakes, stability control, steering assistance, and traction control will be disabled for all
  competitors."
* Server list help `0x115dcb8`: "Hardcore Mode setting. A=Driving Aids Disabled, V=Driving View Restrictions …";
  `0x115defa`: "Driving mode setting. A=Arcade, S=Simulation."

## 4. Transport and the other writers of +0x4c (whole-record copies)

| function | writes | context |
|---|---|---|
| `0055a660` | `0056e6b0(c0692a, src)` copies 0x2b dwords + 1 byte | called from `005b6190` (msg 0x42: copy if game state 3, or state 4 after `00567140`/`0055a910`, and rec+0x40 ≠ `c0696a`), and from the replay loader `00500fd0` (`0050111d`, after the "YLPR" v5 header) and `005012ba` |
| `0055a650` | `0056e680(c0692a)` clears byte 0, byte 0x20, +0x40, +0x67 and +0x44..+0x66 | session reset `0055b140` |
| `004f9780` | copies 0xad bytes into **server** record `bebd38` | from `004fa040` and `004fa398` (server side, read via `00544bf0`) |
| `005712d0` | mailbox `c5f518` | UI → sim |
| `004c3120` | UI current record `8d3288` | screen receives or builds a record |
| `00546d30` | parses the server rules string (`%d%c%c…`) back into the record +0x44 block; char[3] != '-' → bit 25; char[7] 'D'/'V'/other → bits 29/19 | server browser |
| `00546c20` | builds that string from `bebd7c` (= bebd38+0x44) at `00547360`; char 4 = `A` if bit 25; char 8 = `-`/`D`/`V`/`B` for bits 19 and 29 | server advertisement |

**Not the race record:** `0054b4c0`, `0054b4f0` and `0054b550` (`AND EDX,0xfdffffff` at `0054b52f`), and also
`00547f50`/`00547f60`, operate on `[ecx+0xc]` of a damage or car struct with a timer at +0x64. Their callers are
`00549290`, `0054a330`, `0054aa20`, `005202f0`, `00520170`, `0052c640` and `00547fa0`.

## 5. Every reader of bit 25 (a sweep of all `shr …,0x19` / `0x2000000` instructions in .text, `sweep25.txt`)

* Physics and sim, through `0055a770` (`c0692a`):
  * `00552720`: the steering yaw-rate limiter (`local_28 *= local_14`).
  * `00552410`: the linearity remap 0.34 + 0.66·L.
  * `004233a0`: **chassis_type forced to 0 in arcade.**
  * `00424230/290/2f0/350/3d0/430`: default setup file names `"arcade"` + `.acd` versus `"easy"`/`"fast"` + `.sim`.
    Callers are `00481166`, `0055965d`, `0055940b`, `00572ec2` and others.
* `004233a0`: `call 55a770 ; neg al ; sbb eax,eax ; not eax ; and eax,[871ad4]`. Here `871ad4` is the track.ini
  `[track] chassis_type` ProfileValue ("1-sspdway, 2-spdway, 3-short, 4-road", registered at `0042334a` with profile
  id 0x28). Its callers include:
  * session start `0055b1d8`, which calls `004233c0` and then `00424710`;
  * car build `00562e9f`: `mov [car+0x58e],eax`, then `00432cf0` (spec = `[0x725ab8 + 4*(series*6+chassis)]`) into car+0x58a;
  * `00432d10`, `00411f4e`, `0042b055`, `004f619a` and `0053fad9`.

  For series 0/1, chassis 0 is spec **`0x8945b8`**, which the static initialiser `0042da20` builds at run time. The
  Cup reference used by the port is chassis 2, spec `0x7238e0`. See section 7.
* AI (server record `bebd38`):
  * `0052c180`: `ai_arcade_grip_modifier` 0.78, `ai_arcade_drag_modifier` 1.0 and `ai_arcade_qual_modifier` 1.0
    (`[ai_track]` table at `74b178..`).
  * `0052f539`: tyre wear × `ai_arcade_tire_wear` 0.4.
  * `0051aceb`: AI fuel use × `ai_arcade_fuel_use` 1.0 (only in the server thread and only for AI cars, `+0x59b`).
  * `00415519`: bit 25 is passed to `00534e40`.
* Damage: `005205ec` multiplies by 0.6 (`6ea504`) in arcade (`00520550`, called from `0040e4e8`; the record is
  `c0692a` or `bebd38`).
* UI and records: `0045ae20`/`0045ae70`/`0045aec0` (per-track record tables `0045ad40/70/a0` receive the flag),
  `004c6692`/`004c7c97`/`004c8481`/`004c5571` (`0045ad10(arcade,0,track)`, auto AI strength; it ignores the flag in
  this build), `0048bc82`/`0048bd9e`, `004e065e`/`004e2010` (UI copy `977938`) and `0056ea25` (record compare).

## 6. Readers of bit 29

`00550130`/`00550180`/`005501d0`/`00550230` select the record by thread:

* `inServer` (`005f8890`): server record `bebd38` via `00544bf0`.
* `inBackground` (`005f8870`, the sim thread): `c0692a`.
* Any other thread: the raw option value.

When bit 29 is set they return 0 / 0 / 0 / 0.0f (`6ea454` = 0.0). The aid each one gates, mapped through the
parallel message-name and handler tables at `005baae0..` and `005bb100..`:

| getter | variable | aid | setter | message |
|---|---|---|---|---|
| `00550130` | `bf6f04` | braking help (ABS) | `00550120` | `fgmsgCarSetBrakingHelp` |
| `00550180` | `bf6f05` | throttle help (traction control) | `00550170` | `fgmsgCarSetThrottleHelp` |
| `005501d0` | `bf6f06` | stability control | `005501c0` | `fgmsgCarSetStabilityControl` |
| `00550230` | `bf6f08` | steering help | `00550210` | `fgmsgCarSetSteeringHelp` |

Bit 29 is also read by the rules string (`00546c20`) and the compare (`0056e99b`).

Bit 19 (Visual) is read by:

* `00411530` and `00411550`, which force 1, presumably smoke and windshield buildup;
* `00566450` in the cockpit wheel function `005662d0`;
* `00583150`, which forces bit 1 of `[750130]`.

## 7. The other bits of +0x4c

| bit(s) | meaning | evidence |
|---|---|---|
| 0..6 | 7-bit field, constant 0 (builder `004c54d0 and ebx,0xffffff80`); compared in `0056e8e0` (mask 0x7f) | constant in this build; meaning unresolved |
| 7..8 | **one 2-bit field** (the compare `0056e9f7 test edi,0x180` tests it as one unit), constant **1** (builder clears bit 8 with `0xfffef0ff` and sets bit 7 with `or edi,0x80`); read by `00417f30` (`(bebd84 & 0x180) != 0`, always true) | constant in this build; meaning unresolved |
| 9 | 1-bit field, constant 0; compared (`0056e9d4 test edi,0x200`) | constant; meaning unresolved |
| 10 | 1-bit field, constant 0; compared (`0056e9e0 test edi,0x400`) | constant; meaning unresolved |
| 11 | 1-bit field, constant 0; compared (`0056e971 test bh,8`); read by `0053a7a5` (`c0692a`, `test ch,8` → `0059cd80`) and `00544fe9` (`bebd84`, `test ah,8`) | constant, so these branches are dead; meaning unresolved |
| 12..15 | **track.ini `[track] starting_grid_0` (FullPaceLap on) or `starting_grid_1` (FullPaceLap off)**, &0xf, default 1 for both. See 7a. Readers compare with 1 or 2 (`00407c3a`, `00408893`, `004200aa`, `0044df88` …) | source verified; value semantics unresolved |
| 16 | 1-bit field, constant 0 (`0xfffef0ff`); **not** compared by `0056e8e0` | constant; meaning unresolved |
| 17..18 | DoubleFileRestarts (vt+0xfc, &3); rules char `D` | verified |
| 19 | hardcore **Visual** | verified |
| 20 | YellowFlags (vt+0xf8); rules `Y`; read by `0053c782` and `00541757` | verified |
| 21 | mechanical failures (`chkMechFailures` handler `004c8e50`; builder vt+0x114, whose variable has no ini key); rules `M` | verified |
| 22..23 | DamageModel 0..3 (known; also `0055b1f3`, `0055bf95`) | verified |
| 24 | FullPaceLap (vt+0xf4); rules `L`; read by `00572cbe` (inverted), replay loader `00501103`, and as the selector for bits 12..15 | verified (key); role in `00538560` unresolved |
| **25** | **DrivingMode: Arcade** | verified |
| 26..28 | WindDirection 0..7 (vt+0x12c) | verified (matches the Stage 9 weather port) |
| **29** | **hardcore Driving Aids**, which forces the 4 aids off | verified |
| 30 | vt+0xec: `ASC` ("adaptive speed control?") in Single Race and World Championship; unregistered variables in MP/Testing; rules `S`; read by `0050f214` | verified for SP |
| 31 | never set by the builder | probably unused |

Other fields filled by the builder:

* +0x50 bits 0..1 = PitstopFrequency; bit 2 = AIStrengthType.
* +0x54 = !RealisticWeather.
* +0x58 = WeatherConditions; +0x5c = Temperature; +0x5d = WindSpeed.
* +0x60 = raceLength.
* +0x64 bit 0 = FixedSetup; bits 1..7 = auto AI strength 70..110.
* +0x48 bits 2..8 = NumAI + 1.
* +0x67 = 2 for a quick race, 4 for a full one.

### 7a. Bits 12..15 come from track.ini starting_grid_0/1 (continuation, verified)

* Builder: `004c5677 mov al,[ebp+0x4f] ; test al,1` (this is bit 24, FullPaceLap).
  * If set: `push 0`. Otherwise: `004c568e push 1`.
  * Then `00595520(track)` → `00595770(idx, flag)`, and `004c56a4 and eax,0xf ; shl eax,0xc` → +0x4c bits 12..15.
* `00595770`:
  * flag == 0 → `[idx*0x120 + 0xd8c568]` (entry +0x118);
  * flag != 0 → `[idx*0x120 + 0xd8c56c]` (entry +0x11c).
* Track list builder `005952b0`:
  * It iterates `tracks\*\track.ini`, calling `0053741e push "track.ini" ; push 0x28 ; call 5cfd26`.
  * It fills `0059546f mov [eax+0xd8c568],[bde258]` and `00595481 mov [eax+0xd8c56c],[bde25c]`.
* The track.ini key tables are `74c130` (25 key names) and the parse switch `00537039 jmp [ecx*4+0x537324]`:
  * index 7 `starting_grid_0` → `005370e6 push 0xbde258 ; push "%d"`;
  * index 8 `starting_grid_1` → `005370fb push 0xbde25c ; push "%d"`.
* Defaults come from switch `00536d6d jmp [eax*4+0x536eec]`:
  * index 7 → `00536ddd mov [bde258],1`;
  * index 8 → `00536de8 mov [bde25c],1`.

So bits 12..15 hold starting_grid_0 when FullPaceLap is on and starting_grid_1 when it is off.

### 7b. Bits 0..11 and 16 are constants in this build (continuation, verified by sweep)

* `0056e8e0` is the record-equality test, applied to rec+0x44 (so `[esi+8]` is +0x4c). It tests these masks
  separately: 0x7f, 0x800, 0x80000, 0x20000000, 0x100000, 0x200000, 0x200, 0x400, **0x180**, 0x60000, 0xc00000,
  0xf000 and 0x2000000. That gives the bitfield boundaries 0..6 | 7..8 | 9 | 10 | 11 | 12..15 | 17..18 | 19 | 20 | 21 |
  22..23 | 25 | 29. Bits 16, 24, 26..28 and 30 are not compared.
* Whole-.text capstone sweep (`masks_lo.txt`, `masksweep.py`) for the masks 0xffffff80, 0xfffffe7f, 0xfffffdff,
  0xfffffbff, 0xfffff7ff, 0xfffeffff, 0xfffef0ff and 0xffff0fff:
  * The only hits on +0x4c are the builder's `004c54d0` and `004c54fe`.
  * Every other hit is on unrelated structs (car +0x139f, +0x19f, and so on).
* Byte and word writes to `[reg+0x4c..0x4f]` (`bytew.py`, `bytew.txt`): none of the hits in the record code
  (`004c2651`, `004f4a5b`/`004f4a88`, `005569d7`) is on the race record. They are other structs, checked by context.
* No immediate references exist to `c06976..79` or `bebd85/86`, and none to `8d32d4..d7` (the UI copy +0x4c).
  `bebd84`/`bebd87` are only read (`00415514`, `00417f30`, `004185f0`, `0041945b`, `0041951b`, `0041a9b8`,
  `0052c180`, `0053d6cd`, `00544fdd`, `004155e7`, `0041564f`).
* The server copy `004f9780` copies the record without modifying it (`004f979c`/`004f9829 rep movsd` into `bebd38`).
  The rules-string parser `00546d30` zero-fills +0x44..0x66 and sets only the rule bits.
* Conclusion: in NR2003 the fields are always:
  * bits 0..6 = 0;
  * bits 7..8 = 1;
  * bits 9, 10 and 11 = 0;
  * bit 16 = 0;
  * bit 31 = 0.

  The readers of bit 11 and of bits 7..8 are therefore constant-folded (bit 11 is never set, and bits 7..8 are
  always non-zero).

### 7c. Server to sim transport of the record (continuation, verified)

* Server send:
  * `00545667 push 0 ; push 0x42 ; push esi ; call 5c37f0`, then
    `00545678 push 0xbebd38 ; push 0xad ; push 0x42 ; push esi ; call 5c38b0` (in `005455d0`).
  * `00545e09`..`00545e27` (in `00545d20`) does the same.
  * The send is gated on `[conn+0x194]`, which is cleared after a successful send.
* Sim receive:
  * `[c08194]` is pumped by `005b5cb0` (called from `0055af04`, `0055b4e6`, `0055c561`, `0055ad08` and `0055afab`).
  * `005b5d1f` calls `005b6190`.
  * The message switch is `005b61c4 mov cl,[eax+0x5b6a70] ; jmp [ecx*4+0x5b69f4]`, and msg 0x42 → `005b626c`.
  * `005b626c` copies with `0055a660(payload)` into `c0692a` when the game state (`0055a5a0`) is 3, or when it is 4
    after `00567140` and `0055a910`, provided payload+0x40 differs from `0055a6f0()`.
* So every client's sim thread runs on the server's `bebd38` record. Bits 25 and 29 are **host- or server-enforced**
  in multiplayer.

### Chassis-0 ("arcade") car spec versus the Cup chassis-2 spec (inferred, from Unicorn)

`emu_spec.py` runs the static initialisers `0042c040`, `0042da20` and `0042cb90` on the file image and compares the
0x1c8 bytes at `8945b8` with those at `7238e0`. They differ only in these fields:

| offset | arcade (`8945b8`) | Cup (`7238e0`) |
|---|---|---|
| +0, +4 | ids 0 / 0 | 2 / 2 |
| +0x48 | 0.4726 | 0.4725 |
| +0x4c..+0x58 | 0, 0, 1, 1 | 4, 5, 4, 5 |
| +0x74 | 0.35 | 0.5 |
| +0x7c, +0x80 | −0.5497 | −0.3092 |
| +0x94 | 10000 | 21000 |
| +0xa8 | 0.7914 | 0.5214 |
| +0xac | −0.2714 | −0.2614 |
| +0xd8 | 0.0933 | 0.0833 |

Spec table `725ab8` (dumped in the continuation) is indexed as `[arg] + 6*[arg+8]` (`00432cf0`). Series 0/1 rows:
`8945b8, 723718, 7238e0, 723aa8, 723c70, 723550`; series 2: `724720 …`; series 3: `725008 …`.
So in arcade (chassis 0), series 0/1 use `8945b8`.

+0xa8..+0xe0 are the aero scalars of `00410280` according to PORT_MAP. The semantics of the other fields have not been
established, and the fact that `0042cb90` is the complete initialiser of `7238e0` has not been checked.

## Impact on the port

* `V` needs a session input `drivingMode` (`arcade` bool, default **false**) that sets settings +0x4c bit 25. It
  should be used only by:
  * `00552720`, the yaw-rate limiter;
  * `00552410`, the linearity remap;
  * `004233a0`, which selects chassis 0, a different car spec. The port must not reuse the Cup spec `7238e0` when
    arcade is on.

  It does not touch the tyre or solver code directly; no other physics reader of bit 25 exists in .text.
* Add a `hardcoreAids` session input for bit 29. When it is set, braking, throttle and stability help return 0 and
  steering help returns 0.0, on the sim thread through `c0692a`.
* Bit 19 (Visual) affects only presentation: cockpit view, smoke and windshield.
* Both are race or session options, not controls options. The defaults for the reference Cup car are Simulation and no
  hardcore, which matches the image (bits clear).
* Document in PORT_MAP:
  * the ini names `[<screen>] DrivingMode`, `hardcoreMode` and `hardcoreModeLast` in player.ini;
  * the encoding 1 = Visual (bit 19), 2 = Aids (bit 29), 3 = both;
  * the multiplayer enforcement: the host's record is authoritative, clients cannot send, and the server copy is `bebd38`.

## Unresolved

* Bits 0..11 and 16: their meaning (they are constants in this build, see 7b).
* Bits 12..15: what the starting_grid values 1 and 2 mean (the source key is now known).
* The host UI to server leg: mailbox channel 0x58 (`c5f518`) → `004fa040`/`004fa398` → `004f9780` (`bebd38`).
  This is inferred, not traced. The server to sim leg is verified (7c).
* The full contents and semantics of arcade spec `8945b8`, and whether chassis 0 also has other effects through
  `car+0x58e == 0` (for example the collision zone tree `00890490[0]`).
* Whether `chkMechFailures` (bit 21, no ini key) is persisted anywhere.
