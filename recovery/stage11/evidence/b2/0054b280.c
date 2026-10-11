/* NR2003.exe @ 0054b280 FUN_0054b280 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_0054b280(undefined4 param_1,undefined4 param_2)

{
  char cVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  float10 fVar5;
  float10 fVar6;
  float10 extraout_ST1;
  undefined8 uVar7;
  undefined8 uVar8;
  
  cVar1 = FUN_00547f20(param_1,param_2);
  if (cVar1 == '\0') {
    iVar4 = 0;
    do {
      iVar2 = FUN_005484e0(param_1,iVar4);
      iVar3 = FUN_005484e0(param_2,iVar4);
      if (iVar2 != iVar3 && -1 < iVar2 - iVar3) {
        return 1;
      }
      iVar4 = iVar4 + 1;
    } while (iVar4 < 0xb);
    FUN_00548360(param_1);
    fVar5 = (float10)FUN_00548360(param_2);
    if ((float10)_DAT_006ea44c < extraout_ST1 - fVar5) {
      return 1;
    }
    fVar5 = (float10)FUN_00548790(param_1);
    fVar6 = (float10)FUN_00548790(param_2);
    if ((float10)_DAT_006ea44c < (float10)(float)fVar5 - fVar6) {
      return 1;
    }
    iVar4 = 0;
    do {
      uVar7 = FUN_00548b90(param_1,iVar4);
      uVar8 = FUN_00548b90(param_2,(int)((ulonglong)uVar7 >> 0x20));
      if ((int)uVar7 != (int)uVar8 && -1 < (int)uVar7 - (int)uVar8) {
        return 1;
      }
      iVar4 = (int)((ulonglong)uVar8 >> 0x20) + 1;
    } while (iVar4 < 4);
  }
  return 0;
}

