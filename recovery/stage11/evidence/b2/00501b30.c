/* NR2003.exe @ 00501b30 FUN_00501b30 */

void FUN_00501b30(void)

{
  if ((DAT_00b8f15c != '\0') && (DAT_00b8e58a != 0)) {
    if (DAT_00b8e58a == 3) {
      FUN_00501a40();
    }
    if (DAT_00b8e58a == 2) {
      FUN_00501b00();
    }
    if (DAT_00b8e58e != 0) {
      *(byte *)(DAT_00b8e58e + 6) = *(byte *)(DAT_00b8e58e + 6) | 1;
    }
    DAT_00b8e58a = 0;
    FUN_005ab3f0();
    return;
  }
  return;
}

