/* NR2003.exe @ 004288e0 FUN_004288e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 * FUN_004288e0(undefined4 *param_1,float param_2)

{
  int iVar1;
  int iVar2;
  undefined4 *puVar3;
  float10 fVar4;
  float10 fVar5;
  
  if ((*(int *)((int)param_2 + 8) != 0) &&
     (iVar1 = (&DAT_00872688)[(int)param_1[0x27] % DAT_00876d0c], iVar1 != 0)) {
    param_1 = (undefined4 *)0x0;
    FUN_005d3e50(iVar1);
    fVar4 = (float10)FUN_005d4f70(iVar1);
    fVar5 = (float10)FUN_005d34c0();
    param_2 = (float)(fVar5 - (float10)_DAT_006ea4a0);
    if ((float10)_DAT_006ea454 < fVar5 - (float10)_DAT_006ea4a0) {
      param_2 = 0.0;
    }
    FUN_005d4f80(iVar1,param_2);
    iVar2 = FUN_005d39d0(iVar1,&param_1,1);
    if (iVar2 != 0) {
      FUN_005d4f80(iVar1,(float)fVar4);
      return param_1;
    }
    FUN_005d4f80(iVar1,(float)fVar4);
  }
  puVar3 = (undefined4 *)FUN_00525a70();
  if (puVar3 != (undefined4 *)0x0) {
    (**(code **)*puVar3)();
  }
  return puVar3;
}

