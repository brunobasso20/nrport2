/* NR2003.exe @ 00550180 FUN_00550180 */

undefined FUN_00550180(void)

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
      return DAT_00bf6f05;
    }
    iVar2 = FUN_0055a680();
  }
  if ((iVar2 != 0) && ((*(uint *)(iVar2 + 0x4c) & 0x20000000) != 0)) {
    return 0;
  }
  return DAT_00bf6f05;
}

