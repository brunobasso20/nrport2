/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b51f0 */

int __thiscall FUN_005b51f0(int param_1_00,uint *param_1)

{
  uint uVar1;
  
  uVar1 = *param_1 + 1 & 0x3ff;
  *param_1 = uVar1;
  param_1_00 = param_1_00 + uVar1 * 0x1c;
  if (*(int *)(param_1_00 + 0x27 + uVar1 * 7) != -0x80000000) {
    return param_1_00 + uVar1 * 7 + 8;
  }
  return 0;
}


