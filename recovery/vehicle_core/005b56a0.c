/* Ghidra pseudo-C; NR2003.exe @ 005b56a0 */

int FUN_005b56a0(void)

{
  undefined4 *puVar1;
  int iVar2;
  
  iVar2 = DAT_00eab1bc;
  if (DAT_00eab1bc != 0) {
    puVar1 = (undefined4 *)(DAT_00eab1bc + 0x3c);
    DAT_00eab1bc = *(undefined4 *)(DAT_00eab1bc + 0x3c);
    *puVar1 = 0;
    return iVar2;
  }
  return 0;
}

