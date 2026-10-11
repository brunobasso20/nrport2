# drawchain: the original cockpit steering-wheel drawing chain (NR2003.exe)

Label `drawchain`. Sources: Ghidra 11.1.2 headless on the private copy `/opt/nrproj_6` (read-only), image `/opt/nrmem`
(capstone and unicorn), existing exports `/opt/s12/ev*` and `recovery/stage11/evidence/b2`. Scratch files, scripts
and outputs are in `/opt/s12/work_drawchain/` (this session's new material is in `/opt/s12/work_drawchain/v2/`).
Nothing under `/home/user/nrport` was modified.

## 0. Verdict on the claim

| Part of the claim | Status | Evidence |
|---|---|---|
| `005662d0` is the car-model draw and is called from `00587aa5` | **VERIFIED** | `00587a90` is slot 2 of the car draw-object vtable `006f6de8` (installed at `00599a60`). It calls `005662d0` at `00587aa5` when `[model+0]!=0`, and `005660f0` otherwise |
| angle = clamp(-(`00554fb0()` * rec[+0xbc]), -2.79, +2.79) | **VERIFIED** (asm and execution) | `005664e2..00566525` |
| rec = `005ba130(obj)`: the interpolated copy at obj+0x2f0, or obj+0xf8+idx*0xfc | **VERIFIED** | `005ba130`/`005ba080`/`005ba150`. Also executed end to end |
| rec is "a 0xfc-byte copy of car+0x1498..car+0x1594" | **WRONG mechanism, right offset** | No such memcpy exists. `00565880` builds each field separately. rec+0x00..0x97 come from 0x98 bytes at `*(car+0x5ae)` (`MOVSD.REP` with 0x26 dwords at `00565a0a`). rec+0x98..0xf8 come from scattered car fields. **rec+0xbc <- car+0x1554** (`00565a7d`/`00565a83`). That 0x1498+0xbc=0x1554 is a coincidence |
| car+0x1554 = (bf6d7c + bf6d94) * 0.5 for the player car, written by `00551990` | **VERIFIED** | `005519c5..005519d9`. The car is `00562f70(0055ab00())` = the player car (`0055453c..00554644`) |
| bf6d7c / bf6d94 = states 15 / 21 (LF/RF prescribed hub steer) | VERIFIED by address arithmetic (bf6d40 + 4*15, + 4*21). Meaning taken from `STAGE12_STEERING_STATE_MAP.md` l.65 | — |
| remote/replay cars: `005a2db0`/`005a2fd0` dequantize packets that carry bf6360 (`00554fa0`) quantized by `005beac0(e0b6dc)` | **VERIFIED, but incomplete** | There are more producers and one more consumer (section 6). Producers also exist for car+0x1554 (`005a2720`) and for an AI-side expression (`005a2980`). A 7-bit variant (`e73404`, `005ab4f0` -> `005ac232`) exists too |
| which node is rotated | **'steer' node at model+0x13c** (not +0x2f4 / +0x2d8) | Binder `00429a80` at `0042a3a6..0042a3b4` (string `0x723270` "steer"). Rotation call at `00566811..0056682c` |
| axis / sign | the angle replaces the **third** Euler component (roll in Rz(h)·Ry(p)·Rx(r)) of 'steer'. The node's rest h,p are kept | section 4 (sign meaning partly inferred) |
| 'Animated Steering Wheel' option gates it | **NO**. The option does not gate the rotation. It only sets the 3do variable `steeringWheelEnable` = opt ? 0.0 : 1.0 | section 5 |

## 1. The chain (verified addresses)

```
sim frame end  00554520 -> 00551990(player car):  car+0x1554 = (bf6d7c + bf6d94) * 0.5          (005519c5..005519d9)
remote/AI/replay: 005a2db0 (005a2ebc) / 005a2fd0 (005a30d6) / msg-type-1 callback 005ac080 (005ac232): car+0x1554 = dequant(pkt)
snapshot  00599a80 (recovered; call sites 0059a4f6, 0059a5a1, 0059a642):
          drawobj = 0xd95740 + 0x3ec * car[0x5b2]  (48 static objects, ctor loop 00599a40)
          00565880(drawobj, car): slot = 005ba150(drawobj) = drawobj+0xf8+[ebbd78]*0xfc
                                  slot+0xbc = car+0x1554 (00565a7d MOV EDX,[EBP+0x1554] ; 00565a83 MOV [EAX+0xbc],EDX)
                                  stamp: 005ba070 -> [drawobj+8+idx*4] = [ebbd04]   (tail jump 00565b07)
render    0059aac0 -> 0059aa50: if [ebbd84]: t=[ebbd7c]; (drawobj+4)->vf0(t) = 005ba170 (vtable 006f6de4)
          005ba170: interp = drawobj+0x2f0;  interp+0xbc = wrap_pi(prev+0xbc + (cur+0xbc - prev+0xbc)*t)   (005ba37a..005ba3d6)
draw      drawobj->vf2 = 00587a90 -> 005662d0(model=[drawobj+0x24], drawobj)   (call at 00587aa5)
          rec = 005ba130(drawobj) = (005ba080(drawobj+4) ? drawobj+0x2f0 : drawobj+0xf8+idx*0xfc)
          a = -(00554fb0() * rec[0xbc]); clamp to [-2.79, 2.79]                                    (005664e2..00566525)
          if drawobj[0x30] & 1 (in-car camera):   model[0x13c]('steer')->vf2(model[0x28c], model[0x290], a)  (00566811..0056682c)
          else if model[0x2e0]('timeValue'):      timeValue = max(0, trunc(a*57.2957764 + 160.355225))*10  (0056685b..0056688f)
          front wheels (always): lfwheel/rfwheel->vf2(rec[0xbc] + 1.570795, model[0x264|0x270], rec[0xe8|0xec])   (005668cf..0056691e)
```

## 2. Draw-state record (who fills it, offsets)

### 2.1 Fill `00565880(drawobj, car)` (asm `recovery/stage11/evidence/b2/00565880.asm`)

* `00565883 MOV EBP,[ESP+0x14]`: EBP = arg2 = car. `005658a9 MOV EBX,[ESP+0x1c]`: EBX = arg1 = drawobj (one push is still pending).
* `005659fa CALL 0x005ba150`: EAX = drawobj+0xf8+[ebbd78]*0xfc (current slot).
* `005659ff..00565a0a`: ESI = `[car+0x5ae]`, ECX=0x26, `MOVSD.REP`. **rec+0x00..0x97 = 0x98 bytes of the body block `*(car+0x5ae)`** (rec+0x58 is the 3x3 body matrix).
* `00565a0c..00565af8`: rec+0x98/9c/a0 <- car+0x1594/98/9c. rec+0xa4 <- 0x1590. rec+0xa8/ac/b0 <- 0x15a0/a4/a8. rec+0xb4/b8 <- 0x1588/158c.
  **rec+0xbc <- car+0x1554**. rec+0xc0..0xd4 <- car+0x153c..0x1550. Loop `00565ad1..00565aef` (4 iterations): rec+0xd8+4i <- car+0x1558+4i
  and rec+0xe8+4i <- car+0x1568+4i. rec+0xf8 <- car+0x15ac.
* The drawobj header is also filled here: drawobj+0x54..0x60 <- car+0x1578..0x1584 (`0056596d..00565989`), and drawobj+0x90..0xf7 <- 0x68 bytes from **car+0x1493** (`00565991`, `005659d3..005659de`, `MOVSD.REP` with 0x1a dwords).
* `00565aff LEA ECX,[EBX+4]` / `00565b07 JMP 0x005ba070`: `[drawobj+8+idx*4] = [ebbd04]` (snapshot stamp).
* Emulated (`/opt/s12/work_drawchain/emu_565880.py` and `.out`). Each car dword was filled with a sentinel that encodes its own offset. The decoded slot showed `rec+0xbc <- car+0x1554` and the full map above for idx 0 and idx 1.

`005ba150` is called only from `005659fa` (fill) and `005ba14a` (getter): index.tsv in `/opt/s12/ev11`. No 0xfc-byte or 0x3f-dword copy from the car record exists.

### 2.2 Callers of `00565880`
All three call sites are in `00599a80` (recovered). The draw object is indexed by the car index:
`0059a4e1..0059a4ee` computes `EDX = 251*car[0x5b2]` and `LEA ESI,[EDX*4+0xd95740]`, so drawobj = 0xd95740 + 0x3ec*car[0x5b2].
* `0059a4f6` / `0059a5a1`: every listed car except the focus car (`car[0x5b2] != [da13c8]`). Afterwards flags = (flags & 0xec) | 0x20 (`0059a504..0059a512`), so **bit0 and bit4 are cleared**.
* `0059a642`: the focus car. Flags: &0xfe, &0xfd, |0x10, |0x20 (`0059a669..0059a692`). Then `0059a6dc..0059a6f1`: `0056ba70(camera[+4])` is true for camera mode 1..3, and **bit0 is set**. Bit1 is set at `0059a72b` (modes 4/5/10/13 via `0056bb00`, and the focus car is the player). Bit5 is cleared at `0059a744` (modes 10/11/14/15 via `0056bb30`).
* The camera mode names come from the jump table of `0056b960` at `0056ba00` (strings 0x74eca4..): 1 = "cockpit", 2 = "LookLeft", 3 = "LookRight". **So drawobj+0x30 bit0 means "focus car, in-car camera".**

### 2.3 Getters and interpolation
* `005ba130` (ECX = drawobj): `LEA ECX,[ESI+4]; CALL 005ba080`. If true, return drawobj+0x2f0. Else `JMP 005ba150`, which returns drawobj+0xf8+[ebbd78]*0xfc.
  `005ba0f0` is the virtual twin (vtable `006f6dfc`, slot 5 of `006f6de8`). It falls back through `[vt+0x18]` to `005ba110`, which has the same body as `005ba150`.
* `005ba080` (ECX = drawobj+4) returns 1 only if `[ebbd84]` is set, `[drawobj+0xc - idx*4] == [ebbd04]-1` (the other slot's stamp) and `[drawobj+8+idx*4] == [ebbd04]` (the current slot's stamp).
* `005ba170` is slot 0 of the vtable `006f6de4`, which sits at drawobj+4. Both vtables are installed by the static constructor `00599a40`: `00599a60 MOV [esi-4],0x6f6de8 ; 00599a67 MOV [esi],0x6f6de4`, with ESI = 0xd95744 + k*0x3ec for 0x30 objects.
  Because `this` = drawobj+4: EDI = this+0xf4+idx*0xfc = current slot, ESI = this+0x1f0-idx*0xfc = previous slot, EBP = this+0x2ec = drawobj+0x2f0 (`005ba184..005ba1ac`).
  (The pseudo-C of `005ba170` looks biased by -4 because Ghidra treats `this` as drawobj.)
  The steer field is handled at `005ba37a..005ba3d6`:
  `FLD [edi+0xbc]; FSUB [esi+0xbc]; FMUL t; FADD [esi+0xbc]`, then subtract 2π (`6ee484` = 6.2831855) while > π (`6e97f8` = 3.14159265358789), add 2π while < -π (`6f4638`), and `FSTP [ebp+0xbc]`.
  So **interp+0xbc = wrap_±π(lerp(prev, cur, t))**. The next block (`005ba3dc..005ba461`) interpolates rec+0xc0..0xc8 as a 3-vector. That matches the fill (car+0x153c..0x1544).
* The caller is `0059aa50`, called by `0059aac0` at `0059aad2`. If `[ebbd84]`, it takes t = `[ebbd7c]` and calls `(obj+4)->vf0(t)` for `[scene+0x1db]` and for each of the `[scene+0x1e3]` objects in the list at scene+0x1ca4 (`0059aa5a..0059aaab`). `[ebbd7c]`/`[ebbd84]` are written by `005b9ed0` from snapshot timestamps.

### 2.4 End-to-end execution (new: `/opt/s12/work_drawchain/v2/emu_chain.py`, output `emu_chain.out`)
This runs the original `00565880` twice (prev snapshot with stamp S-1 in slot 0, current with stamp S in slot 1), then the original vtable slot `[drawobj+4]->vf0` (= `005ba170`), then the original vtable slot `[drawobj]->vf2` (= `00587a90` -> `005662d0`), with fake 3do node and variable objects.
Stubs: `00554fb0` returns a constant ratio. `005f5c10` (body-block, track-relative interpolation) is a no-op because it needs a loaded track (`005f592e -> 0051370a`). `_ftol` (`006c5018`, encrypted) uses the x87 equivalent.

| case | rec+0xbc prev / cur, t | interp+0xbc | 'steer' vf2 args | other |
|---|---|---|---|---|
| 1 cockpit (flags 0x31), ratio 15 | 0.04 / 0.08, 0.25 | 0.05 | (0.25, -0.35, **-0.75**) | steeringWheelEnable = 0 (opt8=1); lf/rf wheel h = 1.620795 |
| 2 same, stamps not consecutive | 0.04 / 0.08 | not written | (0.25, -0.35, **-1.2**) = current slot | — |
| 3 cockpit, ratio 12 | -0.3 / -0.3 | -0.3 | (0.25, -0.35, **2.79**) (clamped) | steeringWheelEnable = 1 (opt8=0) |
| 4 external (flags 0x30), ratio 15 | 0 / 0.05, 1.0 | 0.05 | not called | **timeValue = 1170** = 10*trunc(-0.75*57.2958+160.355) |

The wheels' third argument is NaN in the interpolated cases because wheel-spin extrapolation (`005ba5ee..005ba69f`) uses fake header data. This does not matter here.

## 3. The angle computation in `005662d0` (asm `/opt/s12/ev10/005662d0.asm`)

```
005662d5 MOV EBP,[ESP+0x28]     ; arg2 = drawobj        005662f9 MOV ESI,[ESP+0x2c] ; arg1 = model
005662db MOV ECX,EBP ; 005662dd CALL 0x005ba130 ; 005662e2 MOV EDI,EAX      ; rec
005664e2 CALL 0x00554fb0        ; ratio (x87)
005664e7 FMUL dword [EDI+0xbc]
005664ed FCHS
005664ef FST dword [ESP+0x14]   ; a (f32)
005664f3 FCOMP dword [0x006f5e70]   ; -2.79f   (80-bit value compared)
005664fe JP 0x0056650a
00566500 MOV dword [ESP+0x14],0xc0328f5c   ; -2.79f
0056650a FLD dword [ESP+0x14] ; 0056650e FCOMP dword [0x006f5e6c] (2.79f) ; JNZ ; 0056651d MOV [ESP+0x14],0x40328f5c (+2.79f)
```
Note on the clamp: the lower bound is tested on the 80-bit product and the upper bound on the f32-rounded value. A NaN passes through unchanged.

`00554fb0` takes no car argument. It reads only player globals: speed `00554f50` (bf6d44/4c/54 -> bf6f44), setup `c055c0` item 0x30, and the override byte `74c9a0`.
So **every** drawn car's wheel uses the **local player's** ratio at the player's speed, multiplied by that car's own rec+0xbc. This is a quirk, and it applies to AI and remote cars too.

**Ghidra pseudo-C caution**: the decompiler assigns the stack slots of `005662d0` wrongly. It shows `rec[0xd0] - fVar24` on the head node and passes `uVar15` to the steer node. The asm (and the execution in 2.4) shows the clamped angle goes to the steer node's third argument (`00566811 MOV EDX,[ESP+0x14]`). The head node receives `(0, rec[0xd0]-pitch, rec[0xd4]-roll)`, where pitch and roll come from `005f74c0(rec+0x58)`.

## 4. Which node, and the axis/sign convention

### 4.1 Node identities (binder `00429a80`, calls `[3do]->vf7(name,&slot)` = find node, `vf9` = find variable)
| model offset | name (string addr) | kind | binder address | use in `005662d0` |
|---|---|---|---|---|
| +0x13c | **steer** (0x723270) | node | `0042a3a6..0042a3b4` (no NULL check, so mandatory) | `vf2(model[0x28c], model[0x290], a)` if flags&1 |
| +0x28c,+0x290 | rest rotation of 'steer' | float | `0042a4d3..0042a4ec`: `steer->vf4(&m[0x28c], &m[0x290], &tmp)` (third component discarded) | first two vf2 args |
| +0x2e0 | timeValue (0x723180) | variable | `00429fce..00429fdc` | external-view animation value |
| +0x28 | steeringWheelEnable (0x72306c) | variable | `00429d8b..00429d96` | = opts[8] ? 0 : 1 |
| +0x2c | windshieldEnable (0x723058) | variable | `00429d4e..00429d5f` | — |
| +0x20 | cockpitView (0x723280) | variable | `0042a4c5..0042a4d0` | 1.0 in cockpit |
| +0x140 | head (0x723278) | node | `0042a4a3..0042a4b1` | vf0(rec c0,c4,c8), vf2(0, rec d0-p, rec d4-r) |
| +0x110 | shifter | node | `0042a0bb` | vf2(m[0x2a4], rec[0xb4], rec[0xb8]) if flags&1 |
| +0x114/118/11c/120 | arml/armr/elbowl/elbowr (0x72321c..34) | node | `0042a29b..0042a317`; elbow rests -> +0x294..0x2a0 (`0042a4ef..0042a531`) | **not driven** (see 4.3) |
| +0xf0/+0xf8 | lfwheel/rfwheel | node | `0042a06f`/`0042a082`; rests (h,p,r) at +0x25c/260/264 and +0x268/26c/270 (`0042a207..0042a224`) | vf2(rec[0xbc]+1.570795, m[0x264]/m[0x270], rec[0xe8]/[0xec]) |
| +0x2d8 | carMakeIdx | variable | `0042a552..0042a562` | = (float)drawobj[0x2c] (`005662fd..00566310`) |
| +0x2f4 | — | — | — | not in `005662d0`. It is the **'head'** node of the second (LOD) layout bound by `0042a720` (`0042acb4..0042acc2`, string 0x7234c8 "head"), used by `00565cc0` |

### 4.2 Argument order and axis
* vf2 takes three floats (callee cleans 0xc). vf4 reads three floats back. The binder reads the rest values with vf4 and the draw writes them back with vf2, keeping components 1 and 2. **The steering angle replaces component 3.**
* The order of the three components is established through `005f74c0`, which the draw uses for the head node. `005f74c0(&h,&p,&r,M)` computes h = atan2(M[3],M[0]) (`005f74cc..005f74d3`) and p = atan2(-M[6], sqrt(M0²+M3²)) (`005f74d5..005f74f3`), then r. This is the decomposition of a row-major **R = Rz(h)·Ry(p)·Rx(r)**. Executed with that construction (emu case E in `/opt/s12/work_drawchain/emu_5662d0.out`), the head vf2 received exactly (0, 0.3-p, 0.4-r).
  The head passes (0, Δp, Δr) to vf2, and the front wheels pass (steer+π/2, rest, spin). Both are consistent only with vf2 = (heading, pitch, roll) in that order.
  **Inference (not verified, needs the node class or 3do data): vf2 = SetRotation(h, p, r), so the steering-wheel angle is the roll of the 'steer' node about its own local x axis, after the rest heading and pitch (the column rake).**
* Sign: a = -(ratio·δ), with δ = rec+0xbc (mean front hub steer). From `STAGE12_STEERING_STATE_MAP.md` (states 15/21 = rotation about local z) and the chain bf63c0 = -bf63c8 = left - right, δ > 0 means a left turn (counter-clockwise from above). The wheels confirm this internally: front wheel heading = +δ + π/2 (`005668db..005668f5`).
  So a > 0 for a right turn, which matches the repo's "+ = clockwise (right turn)". Whether + is visually clockwise depends on the 'steer' node's local axes in the .3do: **unresolved** (no 3do data here).

### 4.3 Arms
`arml/armr/elbowl/elbowr` are bound and their rest rotations are captured, but no draw code writes them.
A full-program Ghidra operand scan (`/opt/s12/work_drawchain/v2/scan_arms2.tsv`: "+ 0x114]" .. "+ 0x2a0]", "+ 0x18c]", "+ 0x1bc]") finds model-base uses of +0x114..0x120 and +0x294..0x2a0 only in `00429a80`.
In external views the driver and wheel are animated through `timeValue` (and `animate_driver` +0xe0 = 1 only for non-focus cars, `005667e2..00566809`). Inferred: in the cockpit the arms follow the 3do hierarchy or stay static. Unresolved without the .3do.

### 4.4 Other model layouts
* `005660f0` (model[0]==0): only the wheels (`lfwheel` heading = rec[0xbc] + 1.570795). No steering wheel.
* `00565cc0` is the second layout (`004298d0`/`0042a720`), reached through `00587ae0` (vtable slot 3) when its argument != `[drawobj+0x18]`. It computes the same clamped angle (`00565ef8..00565f33`) but has **no 'steer' node**. When flags&1 is clear, the angle only drives `timeValue` at +0x334 (`00565fe1..00566025`). Its `steeringWheelEnable` (+0x318) and `windshieldEnable` (+0x31c) are always set to 1.0 (`00565e64..00565e88`).

## 5. 'Animated Steering Wheel' option

* Registration `004401b0`: `push 2; push 2; push 0x72cad8 ("Animated Steering Wheel on or off"); push 0x72cafc ("steeringwheel"); push 0x72cb0c ("Features"); push 0x14; ECX=0x894e40; call 005cfd02`. The value pointer `[894e62] = 0x72c819` (`004401d4`), and the vtable is `0x6ed680`.
  The image default byte `[72c819] = 01`. The neighbours: pitcrew = 72c818, and 72c81a/72c81b registered by `00440230`/`004402b0`.
* Accessors: `00441750(i)` = byte `[0x72c818+i]` (i<4). The gate `00441770(i)` = byte `[0x72c81c+i]`. All of 72c81c..72c81f are 01 in the image and have **no code writer** (Ghidra xref `/opt/s12/work_drawchain/v2/xref_v3.tsv`: only `0044177d` reads them).
* `00441e50` builds the renderer options struct (7 dwords, copied from `005d44c0()` at `00441ef4..00441f06`, base = X+0x24). At `00441f43..00441f60`: **opts[8] = (00441770(1) && 00441750(1)) ? 1 : 0**. The stack balance was checked: two pending pushes at `00441ecd`/`00441ed3`, and `ADD ESP,0x1c` at `00441f48`. It is installed by `00442050..00442055` with `005d44a0(&opts)` (renderer `[f5e874]` vtable +0xa8). `005d44c0` reads it back (vtable +0xac).
* The only reader of opts[8] among the direct callers of `005d44c0`/`005d44a0` (`/opt/s12/work_drawchain/calls_5d44c0.txt`) is `005662d0`:
  `0056640d CALL 005d44c0; 00566412 MOV CL,[EAX+8]; ... 0056641f JNZ` -> `steeringWheelEnable(model+0x28).set(CL ? 0.0 : 1.0)`.
* **The 'steer' rotation (`00566811..0056682c`) and the timeValue path (`0056685b..0056688f`) are not conditioned on opts[8].** The option only flips the 3do variable `steeringWheelEnable`, inverted: option ON gives 0.0. Executed: cases 1/3 in 2.4. What that variable shows or hides in the .3do is **unresolved**.

## 6. car+0x1554 writers and readers (Ghidra scan `/opt/s12/work_drawchain/scan_1554.txt`)

| address | function | role |
|---|---|---|
| `005519d9` | `00551990` | player: (bf6d7c+bf6d94)*0.5 |
| `005a2ebc` | `005a2db0` | `= 005beaf0(e0b6dc, sar(shl([pkt+0x3c],0x12),0x19))`: signed 7-bit field, bits 7..13 |
| `005a30d6` | `005a2fd0` | `= 005beaf0(e0b6dc, movsx(word [pkt+2]) >> 10)`: signed 6-bit field, bits 10..15 |
| `005ac232` | callback `005ac080`, registered by `005aaf1d push 0x5ac080 ... 005aaf36 call 005ab2c0` (message type 1; `0x5ab4e0` is a reset callback; the matching e73404 producer of bf6360 is `005ab4f0`, called from `0055b369`). It acts only when arg2 == 0x24 (`005ac08a`) | `= 005beaf0(e73404, [pkt+0xc] >> 25)` into car `005aa360(0055ab00())`. Purpose **unresolved** |
| `005a3177` | `005a3150` | reset to 0 |
| `005c123f` | (copy) | car->car copy of 0x1548..0x1554.. |
| `00565a7d` | `00565880` | read -> draw slot +0xbc |
| `005a27cc` | `005a2720` | read: quantized with e0b6dc into word +2 bits 10..15 |
| `005151c2`, `0051565f` | `005150fa`, `005155ba` | **false positives**: a stride-0x1550 table search, not the car record |

Packet producers using the same fields: `005a2040` (`005a211d..005a2145`) packs **bf6360** (`00554fa0`) into [+0x3c] bits 7..13. `005a2280` (`005a2400..005a2428`) packs bf6360 into word +2 bits 10..15. `005a2720` packs car+0x1554. `005a2980` (called from `0052d910`) packs `20*car[0x19b6] + 2.5*car[0x199e]` into word +2 bits 10..15 (AI side, inferred). `005ab4f0` (`005ab652..005ab67b`) packs bf6360 with `e73404` into [+0xc] bits 25..31.

Quantizer (asm verified):
* `005beac0(d,x)`: q = clamp(_ftol(atan(x·d0)·d4), d[0x10], d[0x14]).
* `005beaf0(d,q)`: x = tan(q·d8)·d12.
* Descriptors from `005bea40(d, a=128.0, r=π/6, bits, signed=1)`: `e0b6dc` with 6 bits (`005a1dac..005a1dbf`), `e73404` with 7 bits (`005aafb6..005aafc9`).
  The code sets d0 = tan(c)/r, d4 = (maxq+0.5)/c, d8 = c/maxq, d12 = r/tan(c), maxq = 2^(bits-1)-1, min = -maxq, with c = f(1/sqrt(a)).
* `f` is `006c72b0`, which lies in the encrypted CRT region (like `_ftol 006c5018`). It is assumed to be atan (inferred). Under that assumption: e0b6dc has range ±0.5236 rad, step ≈ 0.01685 rad (~0.97°), truncation toward 0. e73404 has step ≈ 0.00829 rad.

A remote player's wheel therefore shows the sender's **LF** command bf6360 = bf63c0 - c086b0 (LF toe included), quantized. A local player's wheel shows the mean of the hub states, where symmetric toe cancels.

## 7. Verified / inferred / unresolved

Verified (direct asm, plus execution where noted):
* `00587aa5` call; vtables `006f6de8` (+0) and `006f6de4` (+4); 48 draw objects at 0xd95740 with stride 0x3ec.
* fill `00565880`: rec+0xbc <- car+0x1554 (executed); rec layout as in 2.1; no 0xfc memcpy.
* `005ba130`/`005ba080`/`005ba150` semantics; interp `005ba170` = lerp + ±π wrap of rec+0xbc into drawobj+0x2f0 (executed: 0.05 for 0.04->0.08 at t=0.25).
* angle formula and clamp (executed); used for the 'steer' node vf2 third argument only when drawobj[0x30]&1 (focus car, camera mode 1..3: cockpit/LookLeft/LookRight); otherwise timeValue = 10·max(0, trunc(deg(a)+160.355)).
* front wheels drawn with rec+0xbc + 1.570795 as the first vf2 component (both fronts use the mean).
* player car+0x1554 = (bf6d7c+bf6d94)*0.5; packet writers and readers as in section 6.
* option chain `72c819` -> opts[8] -> `steeringWheelEnable` = opt?0:1; no gating of the rotation.
* `00554fb0` uses only player globals.

Inferred:
* vf2/vf4 = Set/GetRotation(h, p, r) with R = Rz·Ry·Rx (from `005f74c0` and consistent usage). The steering angle is the roll about the steer node's local x axis (the column).
* δ > 0 = left turn, so a > 0 = right turn (consistent with the wheel heading sign).
* `006c72b0` = atan (encrypted CRT).
* `005a2980` is the AI-side producer.
* timeValue drives a keyframed external driver/wheel animation (0..3200, centre 1600).

Unresolved:
* the visual meaning of `steeringWheelEnable` and `timeValue` inside the .3do files, the steer node's local axes, and whether the arms are parented to 'steer' (no 3do data in this environment);
* the purpose of the message-type-1 callback `005ac080` (arg 0x24) writing car+0x1554 of `005aa360(0055ab00())`;
* the writers of `[ebbd78]`/`[ebbd04]` (slot index/stamp) (not needed for the formula).

## 8. Impact on the Luau port / docs

1. `STAGE12_STEERING_STATE_MAP.md` l.74 says "draw state copy `car[0x1498..0x1594]`". This should read: "field gather by `00565880`: slot+0xbc <- car+0x1554 (`00565a7d`), slot = drawobj+0xf8+idx*0xfc (`005ba150`); interpolated copy at drawobj+0x2f0 (`005ba170`)".
2. The drawn value is `rec[0xbc]`. When render interpolation is active, it is the lerp between the two latest sim snapshots (t = render fraction), wrapped to ±π. A 36 Hz-only presentation is acceptable. For fidelity, interpolate `steeringWheelAngle` input δ (not the clamped output) between sim frames.
3. Apply the angle as the **third Euler (roll) component** of the 'steer' node: keep the model's rest heading and pitch (column rake), and do **not** add the rest roll. Only for the focus car in cockpit/LookLeft/LookRight cameras.
   Otherwise (external views, and other cars) the original only sets `timeValue = 10*max(0, trunc(deg(a)+160.355))` (0..3200). A Roblox port without keyframes can rotate the wheel directly in all views; mark that as a presentation choice.
4. The clamp is ±2.79 f32 (0x40328f5c). The ratio is the **player's** `00554fb0` even for other cars (original quirk; replicate or document).
5. The 'Animated Steering Wheel' option must not disable the rotation. If ported, it only toggles the model's static-wheel variable (inverted).
6. Front-wheel visual steer = mean hub angle δ (both wheels), heading offset 1.570795. There is no per-wheel Ackermann in the display.
7. Remote cars: δ = dequantized LF command (±π/6, 6-bit, ~0.97° steps, truncation toward 0), not the mean hub angle.
