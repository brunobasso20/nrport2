/* NR2003.exe @ 0055a7d0 FUN_0055a7d0 */

void FUN_0055a7d0(void)

{
  char cVar1;
  
  cVar1 = FUN_0059b2d0();
  while (cVar1 != '\0') {
    FUN_005c2fb0(DAT_00c08194);
    bgSleep();
    cVar1 = FUN_0059b2d0();
  }
  cVar1 = FUN_0055a820();
  if (cVar1 != '\0') {
    FUN_00573cd0();
    DAT_00c081a2 = 0;
  }
  FUN_005c2fb0(DAT_00c08194);
  return;
}

