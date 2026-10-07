/* Ghidra pseudo-C; NR2003.exe @ 005b5390 */

int __thiscall FUN_005b5390(int param_1_00,uint *param_1)

{
  uint uVar1;
  
  uVar1 = *param_1 + 1;
  *param_1 = uVar1;
  if (*(int *)(param_1_00 + 9) < 0x400) {
    if ((int)uVar1 < *(int *)(param_1_00 + 9)) {
      return uVar1 * 0x1f + 0xd + param_1_00;
    }
  }
  else {
    uVar1 = uVar1 & 0x3ff;
    *param_1 = uVar1;
    if (uVar1 != (*(uint *)(param_1_00 + 9) & 0x3ff)) {
      return uVar1 * 0x1f + 0xd + param_1_00;
    }
  }
  return 0;
}

