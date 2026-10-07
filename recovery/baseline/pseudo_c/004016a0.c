/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004016a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

bool FUN_004016a0(void)

{
  int iVar1;
  int iVar2;
  int iVar3;
  undefined4 *puVar4;
  
  if ((DAT_00760d10 & 1) == 0) {
    _DAT_00760b70 = 0;
    _DAT_00760b74 = 0;
    DAT_00760b78 = 0;
    DAT_00760c2d = 0xffffffff;
    _DAT_00760c29 = 0;
    _DAT_00760c69 = 0;
    _DAT_00760ce9 = 0;
    _DAT_00760ced = 0;
    _DAT_00760cf1 = 0;
    _DAT_00760cf5 = 0;
    DAT_00760cf9 = 0;
    DAT_00760cfa = 1;
    puVar4 = &DAT_00760b50;
    for (iVar2 = 8; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar4 = 0;
      puVar4 = puVar4 + 1;
    }
    DAT_00760d10 = DAT_00760d10 | 1;
    FUN_004fef00();
    FUN_006c4f40();
  }
  FUN_004fe810();
  FUN_004fe850();
  FUN_004fe9b0();
  FUN_004fe990();
  iVar3 = 0;
  iVar2 = FUN_00401690();
  if (0 < iVar2) {
    do {
      iVar1 = FUN_004f8920();
      if (iVar1 == 0) break;
      FUN_004f5970();
      FUN_004f76b0();
      FUN_004f7a20();
      FUN_004f7a20();
      FUN_004f7a20();
      iVar3 = iVar3 + 1;
      DAT_00acca08 = 0;
    } while (iVar3 < iVar2);
  }
  return iVar3 == iVar2;
}


