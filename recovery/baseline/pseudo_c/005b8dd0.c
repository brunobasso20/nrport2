/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b8dd0 */

void FUN_005b8dd0(int param_1,int param_2,int param_3)

{
  int iVar1;
  int iVar2;
  
  iVar1 = param_3 - param_2;
  param_1 = param_1 - param_2;
  param_3 = 6;
  do {
    iVar2 = 6;
    do {
      (**(code **)PTR_PTR_0074fe48)(param_2 + param_1,param_2,iVar1 + param_2);
      param_2 = param_2 + 4;
      iVar2 = iVar2 + -1;
    } while (iVar2 != 0);
    param_3 = param_3 + -1;
  } while (param_3 != 0);
  return;
}


