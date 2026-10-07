/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578530 */

int FUN_00578530(void)

{
  int *piVar1;
  
  piVar1 = (int *)*DAT_00c7e794;
  if (piVar1 != (int *)0x0) {
    *DAT_00c7e794 = *piVar1;
    return (int)piVar1;
  }
  return 0;
}


