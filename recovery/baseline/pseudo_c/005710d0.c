/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005710d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005710d0(undefined4 param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6b5a0);
  if (cVar1 != '\0') {
    _DAT_00c5f718 = param_1;
    FUN_005f8e20(&DAT_00c6b5a0);
    return 1;
  }
  return 0;
}


