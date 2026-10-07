/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b7d10 */

void FUN_005b7d10(int param_1,int param_2)

{
  int iVar1;
  
  iVar1 = 3;
  param_2 = param_2 - param_1;
  do {
    (**(code **)PTR_PTR_0074fe4c)(param_1,param_2 + param_1);
    param_1 = param_1 + 4;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}


