/* NR2003.exe @ 00570ef0 FUN_00570ef0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570ef0(undefined4 param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6f6b8);
  if (cVar1 != '\0') {
    _DAT_00c6912c = param_1;
    FUN_005f8e20(&DAT_00c6f6b8);
    return 1;
  }
  return 0;
}

