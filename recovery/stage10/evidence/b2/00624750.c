/* NR2003.exe @ 00624750 FUN_00624750 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00624750(void)

{
  int iVar1;
  int iVar2;
  
  iVar1 = taskGetRate();
  iVar2 = getIntCount();
  DAT_00f9cd7d = 0;
  _DAT_00f99a7c = iVar2 + iVar1 * 8;
  return;
}

