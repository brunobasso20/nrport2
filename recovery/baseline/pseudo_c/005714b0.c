/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005714b0 */

undefined4 FUN_005714b0(void)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c70d14);
  if (cVar1 != '\0') {
    DAT_00c6f990 = 0;
    FUN_005f8e20(&DAT_00c70d14);
    return 1;
  }
  return 0;
}


