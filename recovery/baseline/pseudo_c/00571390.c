/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571390 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00571390(undefined4 param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6b5b4);
  if (cVar1 != '\0') {
    _DAT_00c69030 = param_1;
    FUN_005f8e20(&DAT_00c6b5b4);
    return 1;
  }
  return 0;
}


