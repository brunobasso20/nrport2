/* NR2003.exe @ 00553920 FUN_00553920 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00553920(float param_1,undefined4 param_2,int param_3)

{
  float fVar1;
  float fVar2;
  int iVar3;
  float *pfVar4;
  
  iVar3 = FUN_0056ed60(2);
  fVar2 = **(float **)(PTR_PTR_DAT_00734368 + iVar3 * 4);
  iVar3 = FUN_0056ed60(3);
  fVar1 = **(float **)(PTR_PTR_DAT_00734368 + iVar3 * 4);
  if ((&DAT_00c086e0)[param_3] == 0) {
    pfVar4 = (float *)FUN_00557d60(param_3 + 0x66);
    param_2 = *pfVar4;
  }
  else {
    pfVar4 = (float *)FUN_00557d60(0x67);
    param_2 = *pfVar4;
  }
  pfVar4 = (float *)FUN_00557d60(0x6e);
  return ((float10)param_2 * (float10)*pfVar4 * (float10)param_1 * (float10)_DAT_006f4754) /
         ((float10)(fVar1 + fVar2) * (float10)_DAT_006f5a34);
}

