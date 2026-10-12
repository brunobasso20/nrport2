/* NR2003.exe @ 0042b1a0 FUN_0042b1a0 */

void FUN_0042b1a0(void)

{
  char cVar1;
  int iVar2;
  int iVar3;
  
  iVar3 = 0x2f;
  do {
    iVar2 = FUN_005748d0(iVar3);
    if (iVar2 != 0) {
      FUN_00574960(iVar3);
    }
    iVar3 = iVar3 + -1;
  } while (-1 < iVar3);
  iVar3 = 0;
  do {
    cVar1 = FUN_0056c150(iVar3,0xffffffff);
    if (cVar1 != '\0') {
      FUN_00427a30(iVar3);
      FUN_0042b0c0(iVar3,0);
    }
    iVar3 = iVar3 + 1;
  } while (iVar3 < 5);
  FUN_0042af60();
  return;
}

