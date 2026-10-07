/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00579a10 */

void __thiscall FUN_00579a10(int param_1_00,undefined4 *param_1)

{
  undefined4 uVar1;
  
  uVar1 = *(undefined4 *)(*(int *)(param_1_00 + 4) + 0x10);
  param_1[1] = *(int *)(param_1_00 + 4);
  *param_1 = uVar1;
  return;
}


