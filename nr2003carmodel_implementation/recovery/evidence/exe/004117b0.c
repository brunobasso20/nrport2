/* NR2003.exe @ 004117b0 FUN_004117b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 * FUN_004117b0(int param_1)

{
  if ((DAT_007636f8 & 1) == 0) {
    DAT_007636f8 = DAT_007636f8 | 1;
    _DAT_00763700 = DAT_006f5f18;
    _DAT_00763704 = DAT_006f5f1c;
    _DAT_00763708 = DAT_006f5f20;
  }
  if ((DAT_007636f8 & 2) == 0) {
    DAT_007636f8 = DAT_007636f8 | 2;
    _DAT_0076371c = DAT_006f5f18;
    _DAT_00763720 = DAT_006f5f1c;
    _DAT_00763724 = DAT_006f5f20;
  }
  if ((DAT_007636f8 & 4) == 0) {
    DAT_007636f8 = DAT_007636f8 | 4;
    _DAT_00763734 = DAT_006f5f18;
    _DAT_00763738 = DAT_006f5f1c;
    _DAT_0076373c = DAT_006f5f20;
  }
  if (param_1 == 4) {
    return (undefined4 *)&DAT_00763700;
  }
  if (param_1 == 5) {
    return (undefined4 *)&DAT_0076371c;
  }
  if (param_1 != 8) {
    return &DAT_006f5f18;
  }
  return (undefined4 *)&DAT_00763734;
}

