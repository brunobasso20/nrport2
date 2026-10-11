/* NR2003.exe @ 0043d560 FUN_0043d560 */

void FUN_0043d560(int param_1)

{
  int iVar1;
  
  iVar1 = FUN_0043f0e0();
  if (param_1 == 0) {
    iVar1 = iVar1 + 1;
  }
  else if (param_1 == 1) {
    iVar1 = iVar1 + -1;
  }
  if ((-1 < iVar1) && (iVar1 < 0x65)) {
    FUN_0043d9c0();
    FUN_0043f0f0(iVar1);
    FUN_0043d4f0();
  }
  return;
}

