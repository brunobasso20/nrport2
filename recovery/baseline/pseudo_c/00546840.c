/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00546840 */

void FUN_00546840(void)

{
  int iVar1;
  
  iVar1 = FUN_00544e60();
  if (iVar1 == 2) {
    iVar1 = FUN_00544e90();
    if (1 < iVar1) {
      FUN_00509a60();
      return;
    }
  }
  getSVCount();
  return;
}


