/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c870 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0056c870(void)

{
  int iVar1;
  int iVar2;
  int iVar3;
  undefined4 *puVar4;
  
  DAT_00c5caf4 = 0;
  iVar2 = 0;
  if (0 < *DAT_00c5ca24) {
    iVar3 = 0;
    do {
      iVar1 = *(int *)(iVar3 + 1 + DAT_00c5c2e8);
      if (iVar1 != 0) {
        FUN_004fe420(0x3f);
        FUN_005cfccc(iVar1);
      }
      iVar2 = iVar2 + 1;
      iVar3 = iVar3 + 5;
    } while (iVar2 < *DAT_00c5ca24);
  }
  if (DAT_00c5c2e8 != 0) {
    FUN_005cfccc(DAT_00c5c2e8);
  }
  _DAT_00c5ca28 = 0;
  _DAT_00c5ca2c = 0;
  DAT_00c5c2e8 = 0;
  _DAT_00c5ca30 = 0;
  DAT_00c5c2e4 = 0;
  puVar4 = &DAT_00c5ca38;
  for (iVar2 = 0x20; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar4 = 0;
    puVar4 = puVar4 + 1;
  }
  _DAT_00c5ca34 = 0;
  return;
}


