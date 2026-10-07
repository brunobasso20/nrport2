/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b7df0 */

void FUN_005b7df0(int param_1,undefined4 param_2,int param_3)

{
  int iVar1;
  
  iVar1 = 3;
  param_3 = param_3 - param_1;
  do {
    (**(code **)(PTR_PTR_0074fe48 + 0xc))(param_1,param_2,param_3 + param_1);
    param_1 = param_1 + 4;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}


