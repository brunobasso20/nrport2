/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00550230 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00550230(void)

{
  bool bVar1;
  int iVar2;
  
  bVar1 = inServer();
  if (bVar1) {
    iVar2 = FUN_00544bf0();
  }
  else {
    bVar1 = inBackground();
    if (!bVar1) goto LAB_00550262;
    iVar2 = FUN_0055a680();
  }
  if ((iVar2 != 0) && ((*(uint *)(iVar2 + 0x4c) & 0x20000000) != 0)) {
    return (float10)_DAT_006ea454;
  }
LAB_00550262:
  return (float10)_DAT_00bf6f08;
}


