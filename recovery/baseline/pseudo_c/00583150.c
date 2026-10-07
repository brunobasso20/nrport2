/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00583150 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_00583150(void)

{
  int iVar1;
  uint uVar2;
  
  iVar1 = FUN_0055a680();
  uVar2 = _DAT_00750130;
  if ((*(uint *)(iVar1 + 0x4c) & 0x80000) != 0) {
    uVar2 = _DAT_00750130 | 1;
  }
  return uVar2;
}


