/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00547e60 */

int FUN_00547e60(void)

{
  int *piVar1;
  
  piVar1 = (int *)*DAT_00bf39d4;
  if (piVar1 != (int *)0x0) {
    *DAT_00bf39d4 = *piVar1;
    return (int)piVar1;
  }
  return 0;
}


