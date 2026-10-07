/* NR2003.exe @ 00550680 FUN_00550680 */

void FUN_00550680(void)

{
  if (DAT_00bf6ebb != '\0') {
    FUN_00501b30();
    bgRequestFGAction(FUN_00550060,(void *)0x0,(void *)0x0);
    DAT_00bf6ebb = '\0';
  }
  return;
}

