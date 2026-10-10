/* NR2003.exe @ 0043d8b0 FUN_0043d8b0 */

void FUN_0043d8b0(int param_1)

{
  undefined4 uVar1;
  int iVar2;
  
  uVar1 = FUN_0043f090();
  iVar2 = FUN_0043d9b0(uVar1);
  if (param_1 == 0) {
    iVar2 = iVar2 + 1;
  }
  else if (param_1 == 1) {
    iVar2 = iVar2 + -1;
  }
  if ((-1 < iVar2) && (iVar2 < 0x65)) {
    FUN_0043d9c0();
    uVar1 = FUN_0043d9b0(iVar2);
    FUN_0043f0c0(uVar1);
    FUN_0043d830();
  }
  return;
}

