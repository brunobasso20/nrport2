/* NR2003.exe @ 00501b00 FUN_00501b00 */

void FUN_00501b00(void)

{
  if (DAT_00b8e58a != 0) {
    if (DAT_00b8e58a == 3) {
      FUN_00501a40();
    }
    DAT_00b8e58a = 1;
    DAT_00b8e586 = DAT_00b8e586 + 1;
    FUN_005ab3c0();
    return;
  }
  return;
}

