/* NR2003.exe @ 005d36d0 FUN_005d36d0 */

undefined4 FUN_005d36d0(undefined4 param_1,undefined4 *param_2)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = FUN_005cfd0e(&param_1,param_1);
  if (iVar1 != 0) {
    uVar2 = FUN_005d3720(param_1,param_2);
    FUN_005cfd08(param_1);
    return uVar2;
  }
  *param_2 = 0;
  return 0;
}

