/* NR2003.exe @ 00554fb0 FUN_00554fb0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall FUN_00554fb0(undefined4 param_1)

{
  float *pfVar1;
  float10 fVar2;
  float fVar3;
  
  fVar2 = (float10)FUN_00554f50(param_1);
  fVar3 = (float)fVar2;
  pfVar1 = (float *)FUN_00557d60(0x30);
  fVar2 = (float10)*pfVar1;
  if (((DAT_0074c9a0 != '\0') &&
      (fVar2 < (float10)_DAT_006f5a64 == (NAN(fVar2) || NAN((float10)_DAT_006f5a64)))) &&
     (fVar3 <= _DAT_006f5a60)) {
    if (fVar3 <= _DAT_006f5a5c) {
      if ((float10)_DAT_006f5a64 < fVar2) {
        fVar2 = (float10)_DAT_006f5a64;
      }
    }
    else if ((float10)_DAT_006f5a64 < fVar2) {
      return fVar2 - ((float10)_DAT_006f5a60 - (float10)fVar3) * (fVar2 - (float10)_DAT_006f5a64) *
                     (float10)_DAT_006f5a58;
    }
  }
  return fVar2;
}

