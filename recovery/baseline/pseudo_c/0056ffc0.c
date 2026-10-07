/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056ffc0 */

undefined4 FUN_0056ffc0(undefined1 param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c70d70);
  if (cVar1 != '\0') {
    DAT_00c69130 = param_1;
    FUN_005f8e20(&DAT_00c70d70);
    return 1;
  }
  return 0;
}


