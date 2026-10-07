/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005718d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005718d0(undefined4 param_1,undefined4 param_2)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6faa8);
  if (cVar1 != '\0') {
    _DAT_00c70cc0 = param_1;
    FUN_006c4b00(&DAT_00c70cc4,param_2,0x50);
    DAT_00c70d13 = 0;
    FUN_005f8e20(&DAT_00c6faa8);
    return 1;
  }
  return 0;
}


