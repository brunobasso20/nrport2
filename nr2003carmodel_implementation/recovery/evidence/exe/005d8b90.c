/* NR2003.exe @ 005d8b90 FUN_005d8b90 */

int * __thiscall FUN_005d8b90(int *param_1_00,int param_1,int *param_2)

{
  int iVar1;
  undefined4 uVar2;
  
  *param_1_00 = param_1;
  iVar1 = param_2[2];
  uVar2 = (**(code **)(*param_2 + 4))();
  FUN_006c75a5(s__s_s<_s>_0075493c,param_1 + 4,iVar1,uVar2);
  FUN_006c75a5(&DAT_00754948,*param_1_00 + 4);
  FUN_005ed8c0();
  return param_1_00;
}

