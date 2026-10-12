/* NR2003.exe @ 00587c70 FUN_00587c70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00587c70(undefined4 param_1_00,float param_1)

{
  float10 fVar1;
  float10 fVar2;
  
  DAT_00750190 = param_1;
  fVar2 = (float10)FUN_005170aa(param_1_00);
  fVar2 = fVar2 * (float10)_DAT_006f4658;
  fVar1 = (float10)(_DAT_006f6970 * _DAT_006ea62c);
  if (fVar2 < fVar1 != (NAN(fVar2) || NAN(fVar1))) {
    fVar2 = (float10)(_DAT_006f6970 * _DAT_006ea62c);
  }
  if ((float10)(_DAT_006f6978 + _DAT_006f6970) < fVar2) {
    fVar2 = (float10)(_DAT_006f6978 + _DAT_006f6970);
  }
  DAT_00750188 = (float)((fVar2 - (float10)_DAT_006f6970) * (float10)param_1 +
                        (float10)_DAT_006f6970);
  return;
}

