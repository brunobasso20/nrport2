/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055b350 */

void FUN_0055b350(void)

{
  char cVar1;
  int iVar2;
  undefined1 local_14 [4];
  undefined1 local_10 [16];
  
  FUN_00501870(1);
  iVar2 = FUN_00501a20(0x24);
  if (iVar2 != 0) {
    FUN_005ab4f0(iVar2);
  }
  FUN_00501a40();
  cVar1 = FUN_005abbe0(local_14);
  if (cVar1 != '\0') {
    FUN_00501870(0x11);
    FUN_005019e0(4,local_14);
    FUN_00501a40();
  }
  cVar1 = FUN_005abc20(local_10);
  if (cVar1 != '\0') {
    FUN_00501870(0x20);
    FUN_005019e0(0x10,local_10);
    FUN_00501a40();
  }
  DAT_00c081d8 = DAT_00c081d8 + 1;
  if ((DAT_00c081d8 & 0x1f) == 0) {
    FUN_00501870(2);
    iVar2 = FUN_00501a20(4);
    if (iVar2 != 0) {
      FUN_005abe80(iVar2);
    }
    FUN_00501a40();
    return;
  }
  return;
}


