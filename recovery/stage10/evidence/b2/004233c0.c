/* NR2003.exe @ 004233c0 FUN_004233c0 */

int FUN_004233c0(void)

{
  char cVar1;
  int iVar2;
  
  iVar2 = 1;
  do {
    cVar1 = FUN_0056c150(iVar2,0xffffffff);
    if (cVar1 != '\0') {
      return iVar2;
    }
    iVar2 = iVar2 + 1;
  } while (iVar2 < 5);
  return -1;
}

