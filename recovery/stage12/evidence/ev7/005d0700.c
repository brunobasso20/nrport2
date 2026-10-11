/* NR2003.exe @ 005d0700 FUN_005d0700 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

bool FUN_005d0700(byte param_1)

{
  if (DAT_00f5d4f0 != '\0') {
    return (1 << (param_1 & 0x1f) & _DAT_00f5d4e8) != 0;
  }
  return false;
}

