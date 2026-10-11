/* NR2003.exe @ 0055aa60 FUN_0055aa60 */

void FUN_0055aa60(void)

{
  int iVar1;
  int *piVar2;
  int iStack_c;
  
  iStack_c = 0x55aa67;
  iStack_c = FUN_0055ab00();
  iVar1 = FUN_00562f70();
  iStack_c = iVar1 + 0x58e;
  func_0x00559950();
  func_0x00559950(iVar1 + 0x58e);
  FUN_00559360();
  iVar1 = FUN_0055a680();
  piVar2 = &iStack_c;
  if ((((*(byte *)(iVar1 + 100) & 1) != 0) && (DAT_00c0819a != '\0')) && (DAT_00c0819b != '\0')) {
    FUN_00538b20(&iStack_c);
    FUN_005402b0(piVar2);
  }
  return;
}

