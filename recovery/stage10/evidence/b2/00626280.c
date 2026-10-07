/* NR2003.exe @ 00626280 FUN_00626280 */

uint FUN_00626280(void)

{
  if (DAT_00f78170 < DAT_00f7816c) {
    return CONCAT31((int3)((uint)DAT_00f7816c >> 8),1);
  }
  return (uint)(*(int *)(DAT_00f78168 + 0x217c) != 0);
}

