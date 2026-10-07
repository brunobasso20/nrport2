/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005799d0 */

void __thiscall FUN_005799d0(int *param_1_00,undefined4 *param_1)

{
  undefined4 uVar1;
  
  uVar1 = *(undefined4 *)(*param_1_00 + 0x10);
  param_1[1] = *param_1_00;
  *param_1 = uVar1;
  return;
}


