/* NR2003.exe @ 00571010 FUN_00571010 */

undefined4 FUN_00571010(undefined param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6f734);
  if (cVar1 != '\0') {
    DAT_00c70d81 = param_1;
    FUN_005f8e20(&DAT_00c6f734);
    return 1;
  }
  return 0;
}

