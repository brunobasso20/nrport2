/* NR2003.exe @ 00554f50 FUN_00554f50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00554f50(void)

{
  int iVar1;
  
  iVar1 = getIntCount();
  if (_DAT_0074c9ac != iVar1) {
    _DAT_00bf6f44 =
         SQRT(DAT_00bf6d44 * DAT_00bf6d44 +
              DAT_00bf6d4c * DAT_00bf6d4c + DAT_00bf6d54 * DAT_00bf6d54);
    _DAT_0074c9ac = getIntCount();
  }
  return (float10)_DAT_00bf6f44;
}

