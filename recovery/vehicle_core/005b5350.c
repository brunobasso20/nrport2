/* Ghidra pseudo-C; NR2003.exe @ 005b5350 */

int __thiscall FUN_005b5350(int param_1_00,uint *param_1)

{
  uint uVar1;
  
  if (0x400 < *(int *)(param_1_00 + 9)) {
    uVar1 = *(uint *)(param_1_00 + 9) & 0x3ff;
    *param_1 = uVar1;
    return uVar1 * 0x1f + 0xd + param_1_00;
  }
  if (0 < (int)*(uint *)(param_1_00 + 9)) {
    *param_1 = 0;
    return param_1_00 + 0xd;
  }
  return 0;
}

