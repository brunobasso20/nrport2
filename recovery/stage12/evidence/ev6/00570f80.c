/* NR2003.exe @ 00570f80 FUN_00570f80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570f80(undefined4 param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c677c4);
  if (cVar1 != '\0') {
    _DAT_00c7037c = param_1;
    FUN_005f8e20(&DAT_00c677c4);
    return 1;
  }
  return 0;
}

