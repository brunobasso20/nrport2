/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00587c70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00587c70(undefined4 param_1_00,float param_1)

{
  float10 fVar1;
  
  DAT_00750190 = param_1;
  fVar1 = (float10)FUN_005170aa(param_1_00);
  fVar1 = fVar1 * (float10)_DAT_006f4658;
  if (fVar1 < (float10)(_DAT_006f6970 * _DAT_006ea62c)) {
    fVar1 = (float10)(_DAT_006f6970 * _DAT_006ea62c);
  }
  if ((float10)(_DAT_006f6978 + _DAT_006f6970) < fVar1) {
    fVar1 = (float10)(_DAT_006f6978 + _DAT_006f6970);
  }
  DAT_00750188 = (float)((fVar1 - (float10)_DAT_006f6970) * (float10)param_1 +
                        (float10)_DAT_006f6970);
  return;
}


