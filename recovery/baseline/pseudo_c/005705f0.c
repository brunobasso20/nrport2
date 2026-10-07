/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005705f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005705f0(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c70ac4);
  if (cVar1 != '\0') {
    _DAT_00c6b5c8 = param_2;
    _DAT_00c6b5d0 = param_1;
    _DAT_00c6b5cc = param_3;
    FUN_005f8e20(&DAT_00c70ac4);
    return 1;
  }
  return 0;
}


