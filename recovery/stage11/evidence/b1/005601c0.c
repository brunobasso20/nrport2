/* NR2003.exe @ 005601c0 FUN_005601c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005601c0(void)

{
  float fVar1;
  undefined4 uVar2;
  int iVar3;
  float *pfVar4;
  float *pfVar5;
  undefined4 *puVar6;
  float *pfVar7;
  float *pfVar8;
  
  FUN_00558770();
  uVar2 = FUN_0055ab00();
  iVar3 = FUN_00562f70(uVar2);
  iVar3 = *(int *)(iVar3 + 0x58a);
  fVar1 = *DAT_00bf4f02;
  pfVar4 = (float *)FUN_00557d60(0x2e);
  pfVar5 = (float *)FUN_00557d60(0x2d);
  fVar1 = (fVar1 - (*pfVar4 + *pfVar5) * _DAT_006ea44c) - *(float *)(iVar3 + 0x6c);
  **(float **)(DAT_00c08254 + 0x1bd) = (_DAT_00c085ac + *(float *)(DAT_00c08254 + 0x4c)) - fVar1;
  **(float **)(DAT_00c084b4 + 0x1bd) = fVar1;
  **(float **)(DAT_00c084b8 + 0x1bd) = fVar1;
  puVar6 = (undefined4 *)FUN_00557d60(0x9c);
  *DAT_00c08490 = *puVar6;
  puVar6 = (undefined4 *)FUN_00557d60(0x9b);
  *DAT_00c081f0 = *puVar6;
  puVar6 = (undefined4 *)FUN_00557d60(0x9d);
  *DAT_00c08534 = *puVar6;
  pfVar4 = (float *)FUN_00557d60(0x93);
  pfVar5 = (float *)FUN_00557d60(0x91);
  pfVar7 = (float *)FUN_00557d60(0x94);
  pfVar8 = (float *)FUN_00557d60(0x92);
  *DAT_00c08664 = ((*pfVar8 + *pfVar4) - (*pfVar7 + *pfVar5)) - _DAT_00c083a8;
  return;
}

