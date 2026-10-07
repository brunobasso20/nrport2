/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004c0e30 */

void __fastcall FUN_004c0e30(undefined4 *param_1)

{
  int iVar1;
  
  iVar1 = param_1[1];
  param_1[1] = iVar1 + -1;
  if (iVar1 + -1 == 0) {
    (**(code **)*param_1)(1);
  }
  return;
}


