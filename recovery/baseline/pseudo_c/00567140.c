/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00567140 */

void FUN_00567140(void)

{
  char cVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  int iStack_4;
  
  FUN_0057dd70();
  iVar2 = FUN_0055a5a0();
  if ((iVar2 == 4) && ((iVar2 = FUN_0055a5c0(), iVar2 == 1 || (iVar2 = FUN_0055a5c0(), iVar2 == 2)))
     ) {
    FUN_0055aa40();
  }
  FUN_00524900();
  FUN_00539230();
  cVar1 = FUN_00501480();
  if (cVar1 != '\0') {
    FUN_00501b30();
  }
  cVar1 = FUN_00502460();
  if (cVar1 != '\0') {
    FUN_00502b50(1);
  }
  cVar1 = FUN_00500800();
  if ((cVar1 != '\0') && (DAT_00c534d0 != '\0')) {
    FUN_005014a0();
  }
  iStack_4 = 0;
  cVar1 = FUN_00566a20(&iStack_4);
  while (cVar1 != '\0') {
    if (*(int *)(iStack_4 + 4) != 0) {
      FUN_00563730(iStack_4);
    }
    cVar1 = FUN_00566a20(&iStack_4);
  }
  iVar2 = FUN_005c2d20(DAT_00c08194);
  if (iVar2 != 1) {
    FUN_00578630();
  }
  iVar2 = FUN_0055a5c0();
  if (iVar2 == 3) {
    FUN_0055a5b0(0);
    FUN_00550a10();
    cVar1 = FUN_00500800();
    if (cVar1 != '\0') {
      uVar5 = 0;
      uVar4 = 0;
      uVar3 = 0;
      FUN_0055a610(0,0,0);
      FUN_00568d10(uVar3,uVar4,uVar5);
      FUN_005024a0(0x41a00000,0,1);
    }
  }
  FUN_00551800();
  FUN_0055a720(0);
  return;
}


