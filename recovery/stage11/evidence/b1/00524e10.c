/* NR2003.exe @ 00524e10 FUN_00524e10 */

void FUN_00524e10(void)

{
  int iVar1;
  int iVar2;
  
  FUN_00523f80();
  iVar2 = 0;
  do {
    iVar1 = FUN_00562f70(iVar2);
    if (*(char *)(iVar1 + 0x59a) != '\0') {
      FUN_00524420(iVar2);
    }
    iVar2 = iVar2 + 1;
  } while (iVar2 < 0x30);
  return;
}

