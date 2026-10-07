/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00568a20 */

void __thiscall
FUN_00568a20(undefined4 *param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  int *piVar1;
  int iVar2;
  undefined4 *puVar3;
  
  puVar3 = (undefined4 *)&DAT_00c5c1c8;
  for (iVar2 = 0x2c; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar3 = 0;
    puVar3 = puVar3 + 1;
  }
  *(undefined2 *)puVar3 = 0;
  DAT_00c5c279 = 0;
  DAT_00c5c275 = 0xffffffff;
  DAT_00c5c271 = 0;
  *param_1 = 0x3f800000;
  piVar1 = (int *)FUN_006c4980();
  if (param_1[2] != *piVar1) {
    if (param_1[2] != 0) {
      FUN_004c0e30();
    }
    param_1[2] = *piVar1;
    FUN_004f0120();
  }
  FUN_006c4a00();
  param_1[1] = 0;
  param_1[3] = 0;
  *(undefined1 *)((int)param_1 + 0x162) = 0;
  piVar1 = (int *)FUN_004ed0c0();
  if (*(int *)((int)param_1 + 0x192) != *piVar1) {
    if (*(int *)((int)param_1 + 0x192) != 0) {
      FUN_004c0e30();
    }
    iVar2 = *piVar1;
    *(int *)((int)param_1 + 0x192) = iVar2;
    if (iVar2 != 0) {
      *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
    }
  }
  FUN_004ed160();
  *(undefined4 *)((int)param_1 + 0x165) = 0xffffffff;
  *(undefined4 *)((int)param_1 + 0x169) = 0xffffffff;
  *(undefined4 *)((int)param_1 + 0x16d) = 0xffffffff;
  *(undefined4 *)((int)param_1 + 0x171) = 0;
  *(undefined4 *)((int)param_1 + 0x175) = 0;
  *(undefined4 *)((int)param_1 + 0x179) = 0;
  *(undefined4 *)((int)param_1 + 0x17d) = 0;
  *(undefined4 *)((int)param_1 + 0x181) = 0;
  *(undefined4 *)((int)param_1 + 0x185) = 0;
  piVar1 = (int *)FUN_006c4980();
  puVar3 = *(undefined4 **)((int)param_1 + 0x19a);
  if (puVar3 != (undefined4 *)*piVar1) {
    if ((puVar3 != (undefined4 *)0x0) &&
       (iVar2 = puVar3[1], puVar3[1] = iVar2 + -1, iVar2 + -1 == 0)) {
      (**(code **)*puVar3)(1);
    }
    iVar2 = *piVar1;
    *(int *)((int)param_1 + 0x19a) = iVar2;
    if (iVar2 != 0) {
      *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
    }
  }
  FUN_006c4a00();
  *(undefined4 *)((int)param_1 + 0x196) = 0;
  *(undefined4 *)((int)param_1 + 0x19e) = 0;
  *(undefined1 *)(param_1 + 0xbd) = 0;
  piVar1 = (int *)FUN_004ed0c0();
  puVar3 = (undefined4 *)param_1[0xc9];
  if (puVar3 != (undefined4 *)*piVar1) {
    if ((puVar3 != (undefined4 *)0x0) &&
       (iVar2 = puVar3[1], puVar3[1] = iVar2 + -1, iVar2 + -1 == 0)) {
      (**(code **)*puVar3)(1);
    }
    iVar2 = *piVar1;
    param_1[0xc9] = iVar2;
    if (iVar2 != 0) {
      *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
    }
  }
  FUN_004ed160();
  *(undefined4 *)((int)param_1 + 0x2f7) = 0xffffffff;
  *(undefined4 *)((int)param_1 + 0x2fb) = 0xffffffff;
  *(undefined4 *)((int)param_1 + 0x2ff) = 0xffffffff;
  *(undefined4 *)((int)param_1 + 0x303) = 0;
  *(undefined4 *)((int)param_1 + 0x307) = 0;
  *(undefined4 *)((int)param_1 + 0x30b) = 0;
  *(undefined4 *)((int)param_1 + 0x30f) = 0;
  *(undefined4 *)((int)param_1 + 0x313) = 0;
  *(undefined4 *)((int)param_1 + 0x317) = 0;
  param_1[0xcb] = param_3;
  param_1[0xca] = param_2;
  param_1[0xcc] = param_4;
  param_1[0xcd] = 0;
  param_1[0xce] = 0x3f800000;
  param_1[0xcf] = 0;
  param_1[0xd0] = 0;
  param_1[0xd1] = 0;
  param_1[0xd2] = 0;
  param_1[0xd3] = 0;
  param_1[0xd4] = 0x3f800000;
  param_1[0xd5] = 0;
  return;
}


