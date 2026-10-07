/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577b80 */

void __thiscall
FUN_00577b80(undefined4 *param_1_00,undefined4 param_1,undefined4 param_2,undefined4 *param_3,
            uint param_4)

{
  int iVar1;
  undefined4 *puVar2;
  
  param_1_00[2] = param_2;
  param_1_00[1] = param_1;
  puVar2 = (undefined4 *)0x0;
  param_1_00[0x10] = param_4 & 0xff;
  param_1_00[0xf] = 0;
  *param_1_00 = &PTR_FUN_006f6118;
  *(undefined1 *)(param_1_00 + 0x16) = 0;
  *(undefined1 *)((int)param_1_00 + 0x59) = 0;
  *(undefined1 *)((int)param_1_00 + 0x5a) = 0;
  param_1_00[0x14] = 0;
  param_1_00[0x15] = 0;
  param_1_00[6] = 0;
  param_1_00[7] = 0;
  param_1_00[8] = 0;
  param_1_00[9] = 0;
  param_1_00[10] = 0;
  param_1_00[0xb] = 0;
  param_1_00[0xc] = 0;
  param_1_00[0xd] = 0;
  param_1_00[0xe] = 0;
  param_1_00[4] = 0;
  if ((param_1_00[1] == 0) || (iVar1 = *(int *)(param_1_00[1] + 4), iVar1 == 0)) {
    if ((param_1_00[2] == 0) || (iVar1 = *(int *)(param_1_00[2] + 4), iVar1 == 0)) {
      param_1_00[3] = 0;
    }
    else {
      param_1_00[3] = iVar1;
    }
  }
  else {
    param_1_00[3] = iVar1;
  }
  if (param_3 != (undefined4 *)0x0) {
    puVar2 = param_1_00 + 0x11;
    *puVar2 = *param_3;
    param_1_00[0x12] = param_3[1];
    param_1_00[0x13] = param_3[2];
  }
  param_1_00[5] = puVar2;
  return;
}


