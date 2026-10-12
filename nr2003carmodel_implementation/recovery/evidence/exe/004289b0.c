/* NR2003.exe @ 004289b0 FUN_004289b0 */

undefined4 FUN_004289b0(undefined4 param_1,int param_2)

{
  int iVar1;
  
  iVar1 = param_2;
  param_2 = 0;
  (**(code **)(*(int *)(&DAT_008726fc)[*(int *)(iVar1 + 8) * 0x380] + 8))(&param_2);
  return param_1;
}

