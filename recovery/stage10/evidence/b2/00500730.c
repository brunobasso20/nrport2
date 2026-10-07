/* NR2003.exe @ 00500730 FUN_00500730 */

void FUN_00500730(void)

{
  bool bVar1;
  
  FUN_00568c30();
  bVar1 = inBackground();
  if (bVar1) {
    DAT_00b71de8 = 0;
    while (DAT_00b71de9 != '\0') {
      bgSleep();
    }
  }
  FUN_00504f30();
  FUN_00505700();
  FUN_00507ae0(DAT_00b70db0,DAT_00b70db8);
  FUN_005084f0(DAT_00b70db0,DAT_00b70db8);
  FUN_00508750();
  DAT_00b71de6 = 1;
  DAT_00b71de5 = 0;
  FUN_005cfccc(DAT_00b70da8);
  DAT_00b8f15c = 0;
  bVar1 = inBackground();
  if (bVar1) {
    DAT_00b71de8 = 1;
  }
  return;
}

