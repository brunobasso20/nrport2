/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570250 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570250(undefined4 param_1,undefined4 param_2)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6931c);
  if (cVar1 != '\0') {
    _DAT_00c691e8 = param_1;
    _DAT_00c691ec = param_2;
    FUN_005f8e20(&DAT_00c6931c);
    return 1;
  }
  return 0;
}


