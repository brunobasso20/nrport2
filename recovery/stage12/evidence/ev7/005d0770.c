/* NR2003.exe @ 005d0770 FUN_005d0770 */

bool FUN_005d0770(byte param_1)

{
  if (DAT_00f5d4f0 != '\0') {
    return (DAT_00f5d350 & 1 << (param_1 & 0x1f)) != 0;
  }
  return false;
}

