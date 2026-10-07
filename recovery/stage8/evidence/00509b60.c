/* NR2003.exe @ 00509b60 FUN_00509b60 */

int FUN_00509b60(int param_1)

{
  int iVar1;
  byte *pbVar2;
  int *piVar3;
  int iVar4;
  undefined4 *puVar5;
  
  FUN_00544e60();
  iVar4 = param_1;
  if (((param_1 != -1) && (iVar1 = FUN_005099b0(), iVar1 == 5)) && (DAT_00bebdf1 < 5)) {
    puVar5 = &param_1;
    iVar1 = iVar4;
    FUN_00538ae0(puVar5,iVar4);
    pbVar2 = (byte *)FUN_0053d5f0(puVar5,iVar1);
    if ((*pbVar2 & 2) == 0) {
      piVar3 = (int *)FUN_00538ab0();
      (**(code **)(*piVar3 + 0x30))(iVar4);
      iVar4 = FUN_005443c0(iVar4);
      iVar1 = FUN_00509a00();
      if (iVar4 != iVar1) {
        return DAT_00bebdf1;
      }
    }
    return 5;
  }
  return DAT_00bebdf1;
}

