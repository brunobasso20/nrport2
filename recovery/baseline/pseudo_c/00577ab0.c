/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577ab0 */

int FUN_00577ab0(void)

{
  int *piVar1;
  
  piVar1 = (int *)*DAT_00c7e7a0;
  if (piVar1 != (int *)0x0) {
    *DAT_00c7e7a0 = *piVar1;
    return (int)piVar1;
  }
  return 0;
}


