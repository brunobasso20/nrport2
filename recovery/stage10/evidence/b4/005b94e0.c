/* NR2003.exe @ 005b94e0 FUN_005b94e0 */

void FUN_005b94e0(int param_1,int param_2,int param_3,int param_4,int param_5)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  
  iVar3 = param_3;
  param_4 = param_4 - param_3;
  param_5 = param_5 - param_3;
  iVar2 = param_2 - param_3;
  param_2 = param_1 + 0xc;
  param_3 = 3;
  do {
    iVar1 = 3;
    iVar4 = param_2;
    do {
      (**(code **)PTR_PTR_FUN_0074fe4c)(iVar4 + -0xc,iVar3 + iVar2);
      (**(code **)PTR_PTR_FUN_0074fe4c)(iVar4,iVar3);
      (**(code **)PTR_PTR_FUN_0074fe4c)(iVar4 + 0x3c,param_4 + iVar3);
      (**(code **)PTR_PTR_FUN_0074fe4c)(iVar4 + 0x48,param_5 + iVar3);
      iVar4 = iVar4 + 4;
      iVar3 = iVar3 + 4;
      iVar1 = iVar1 + -1;
    } while (iVar1 != 0);
    param_2 = param_2 + 0x18;
    param_3 = param_3 + -1;
  } while (param_3 != 0);
  return;
}

