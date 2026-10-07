/* NR2003.exe @ 005bdc20 FUN_005bdc20 */

undefined4 FUN_005bdc20(byte *param_1)

{
  byte *pbVar1;
  int iVar2;
  
  pbVar1 = param_1;
  iVar2 = FUN_005bd610(&param_1,param_1);
  if ((iVar2 == 0) && ((*pbVar1 & 2) == 0)) {
    iVar2 = FUN_005bd200(pbVar1);
    if ((iVar2 == 0) && (*(int *)(pbVar1 + 0xc) < 2)) {
      return 0;
    }
  }
  return 1;
}

