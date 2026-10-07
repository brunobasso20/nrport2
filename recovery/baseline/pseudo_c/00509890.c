/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00509890 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00509890(void)

{
  char cVar1;
  int iVar2;
  int iVar3;
  int *piVar4;
  int iStack_8;
  int iStack_4;
  
  FUN_00544e60();
  iVar2 = FUN_00544e90();
  if ((1 < iVar2) && (iVar2 = FUN_00544e90(), iVar2 < 4)) {
    FUN_005467e0();
    DAT_00b8f1f0 = 1;
  }
  FUN_0050f2e0();
  FUN_00538d20();
  iVar2 = 0;
  iStack_8 = 0;
  cVar1 = FUN_004f5f70(&iStack_8);
  while (cVar1 != '\0') {
    if (*(int *)(iStack_8 + 4) != 0) {
      FUN_004f60c0(iStack_8);
    }
    cVar1 = FUN_004f5f70(&iStack_8);
  }
  iStack_4 = taskGetRate();
  piVar4 = &DAT_00b33090;
  DAT_00b32e1c = (float)iStack_4;
  iVar3 = 0x30;
  DAT_00b32e18 = _DAT_006e97d8 / DAT_00b32e1c;
  do {
    FUN_0059fa90();
    *piVar4 = iVar2;
    piVar4[0x2e] = 5000;
    iVar2 = iVar2 + 1;
    piVar4 = piVar4 + 0xcb;
    iVar3 = iVar3 + -1;
  } while (iVar3 != 0);
  FUN_00551800();
  FUN_00578630();
  FUN_00509bd0(0);
  return;
}


