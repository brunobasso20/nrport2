/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056fbf0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_0056fbf0(undefined4 param_1,undefined1 param_2)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6a39c);
  if (cVar1 != '\0') {
    _DAT_00c677bc = param_1;
    DAT_00c677c0 = param_2;
    FUN_005f8e20(&DAT_00c6a39c);
    return 1;
  }
  return 0;
}


