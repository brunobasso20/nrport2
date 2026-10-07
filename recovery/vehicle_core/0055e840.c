/* Ghidra pseudo-C; NR2003.exe @ 0055e840 */

void FUN_0055e840(void)

{
  char cVar1;
  int iVar2;
  
  iVar2 = 0;
  do {
    cVar1 = FUN_00548a00(iVar2);
    if (cVar1 == '\0') {
      (&DAT_00c086e0)[iVar2] = 0;
    }
    else {
      (&DAT_00c086e0)[iVar2] = 1;
    }
    iVar2 = iVar2 + 1;
  } while (iVar2 < 9);
  DAT_00c08704 = 1;
  return;
}

