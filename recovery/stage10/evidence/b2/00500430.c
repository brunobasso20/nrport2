/* NR2003.exe @ 00500430 FUN_00500430 */

void FUN_00500430(void)

{
  uint uVar1;
  uint uVar2;
  undefined4 uVar3;
  
  uVar1 = FUN_005cfeca(0xf,0);
  if (0 < DAT_00b8f160) {
    FUN_005004d0(DAT_00b8f160 << 10,0);
    return;
  }
  if (0 < DAT_00b8f164) {
    FUN_005004d0(DAT_00b8f164 << 10,0);
    return;
  }
  uVar2 = FUN_005004a0();
  if (uVar2 < uVar1) {
    FUN_005004d0(uVar1);
    return;
  }
  uVar3 = FUN_005004a0(1);
  FUN_005004d0(uVar3);
  return;
}

