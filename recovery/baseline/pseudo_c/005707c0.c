/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005707c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005707c0(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6f720);
  if (cVar1 != '\0') {
    _DAT_00c6f970 = param_2;
    _DAT_00c6f978 = param_1;
    _DAT_00c6f974 = param_3;
    FUN_005f8e20(&DAT_00c6f720);
    return 1;
  }
  return 0;
}


