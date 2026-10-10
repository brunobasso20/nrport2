/* NR2003.exe @ 00570e90 FUN_00570e90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570e90(undefined4 param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6a40c);
  if (cVar1 != '\0') {
    _DAT_00c691f4 = param_1;
    FUN_005f8e20(&DAT_00c6a40c);
    return 1;
  }
  return 0;
}

