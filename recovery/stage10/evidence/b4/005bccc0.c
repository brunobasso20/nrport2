/* NR2003.exe @ 005bccc0 FUN_005bccc0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005bccc0(undefined4 param_1,int param_2,int param_3)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  
  iVar4 = 0;
  if (0 < DAT_00b8faa0) {
    do {
      fVar2 = *(float *)(DAT_00b8faa8 + iVar4 * 4);
      fVar3 = *(float *)(DAT_00b8faac + iVar4 * 4);
      pfVar1 = (float *)(param_3 + iVar4 * 4);
      fVar2 = SQRT(fVar2 * fVar2 + fVar3 * fVar3);
      *(float *)((param_2 - param_3) + (int)pfVar1) = fVar2;
      if (fVar2 < _DAT_006f412c == (NAN(fVar2) || NAN(_DAT_006f412c))) {
        *pfVar1 = *(float *)(DAT_00b8faa8 + iVar4 * 4) / fVar2;
      }
      else {
        *pfVar1 = 0.0;
      }
      iVar4 = iVar4 + 1;
    } while (iVar4 < DAT_00b8faa0);
  }
  return 1;
}

