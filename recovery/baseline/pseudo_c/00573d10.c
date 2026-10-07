/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573d10 */

void thunk_FUN_00412020(void)

{
  int iVar1;
  
  if (DAT_007668d8 != '\0') {
    iVar1 = 0;
    do {
      FUN_00412240(iVar1,1);
      FUN_00412240(iVar1,0);
      iVar1 = iVar1 + 1;
    } while (iVar1 < 0x10);
    DAT_007668d8 = '\0';
  }
  return;
}


