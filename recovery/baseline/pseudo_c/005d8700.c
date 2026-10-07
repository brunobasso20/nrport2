/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005d8700 */

int FUN_005d8700(void)

{
  int iVar1;
  int local_4;
  
  iVar1 = FUN_005cfce4(&local_4,0x16);
  if ((iVar1 != 0) && (local_4 != 0)) {
    iVar1 = FUN_005deac0();
    if (iVar1 != 0) {
      *(int *)(iVar1 + 4) = *(int *)(iVar1 + 4) + 1;
    }
    return iVar1;
  }
  return 0;
}


