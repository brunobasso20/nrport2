/* NR2003.exe @ 005b0980 FUN_005b0980 */

undefined4 FUN_005b0980(byte param_1,int param_2,int param_3,undefined4 param_4)

{
  int iVar1;
  undefined4 local_4;
  
  local_4 = CONCAT22((short)param_2,(ushort)param_1);
  iVar1 = FUN_005b7c40();
  if (iVar1 < param_2 + 4) {
    FUN_005b0580();
    return 0;
  }
  if ((0 < param_2) && (param_3 != 0)) {
    FUN_005b79e0(4,&local_4,0);
    FUN_005b79e0(param_2,param_3,param_4);
    return 1;
  }
  FUN_005b79e0(4,&local_4,param_4);
  return 1;
}

