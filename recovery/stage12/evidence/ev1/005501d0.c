/* NR2003.exe @ 005501d0 FUN_005501d0 */

undefined FUN_005501d0(void)

{
  bool bVar1;
  int iVar2;
  
  bVar1 = inServer();
  if (bVar1) {
    iVar2 = FUN_00544bf0();
  }
  else {
    bVar1 = inBackground();
    if (!bVar1) {
      return DAT_00bf6f06;
    }
    iVar2 = FUN_0055a680();
  }
  if ((iVar2 != 0) && ((*(uint *)(iVar2 + 0x4c) & 0x20000000) != 0)) {
    return 0;
  }
  return DAT_00bf6f06;
}

