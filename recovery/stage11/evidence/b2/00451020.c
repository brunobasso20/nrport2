/* NR2003.exe @ 00451020 FUN_00451020 */

void FUN_00451020(undefined4 param_1,int param_2,int param_3,int param_4,int param_5,int param_6,
                 int param_7)

{
  int iVar1;
  
  iVar1 = FUN_006c5bf8();
  iVar1 = iVar1 % (param_3 + param_5 + param_7);
  if ((iVar1 < param_3) ||
     ((iVar1 = iVar1 - param_3, param_5 <= iVar1 &&
      ((param_6 == -1 || (param_4 = param_6, param_7 <= iVar1 - param_5)))))) {
    param_4 = param_2;
  }
  FUN_00450ec0(param_1,param_4,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
  return;
}

