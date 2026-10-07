/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055aee0 */

void FUN_0055aee0(void)

{
  char cVar1;
  int iVar2;
  undefined4 uVar3;
  
  iVar2 = FUN_005c2d40(DAT_00c08194);
  if (iVar2 == 0) {
    cVar1 = FUN_0055a820();
    if (cVar1 != '\0') {
      FUN_0055a910();
    }
    iVar2 = FUN_005c2d20(DAT_00c08194);
    if (iVar2 != 1) {
      FUN_004346f0();
    }
    FUN_0055ab30(0xffffffff);
    FUN_0055a4f0(0);
    uVar3 = FUN_005c2e30(DAT_00c08194);
    FUN_005c3550(uVar3);
    FUN_005c28c0(DAT_00c08194);
    DAT_00c08194 = 0;
  }
  else if ((0 < iVar2) && (iVar2 < 5)) {
    FUN_005b5cb0(DAT_00c08194);
    FUN_005c2910(DAT_00c08194);
    return;
  }
  return;
}


