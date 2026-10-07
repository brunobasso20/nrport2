/* Ghidra pseudo-C; NR2003.exe @ 005b80c0 */

void FUN_005b80c0(int param_1,undefined4 param_2,int param_3)

{
  int iVar1;
  
  iVar1 = 6;
  param_3 = param_3 - param_1;
  do {
    (**(code **)(PTR_PTR_0074fe48 + 0xc))(param_1,param_2,param_3 + param_1);
    param_1 = param_1 + 4;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}

