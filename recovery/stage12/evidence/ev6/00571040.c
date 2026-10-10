/* NR2003.exe @ 00571040 FUN_00571040 */

undefined4 FUN_00571040(undefined param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c70d48);
  if (cVar1 != '\0') {
    DAT_00c6a431 = param_1;
    FUN_005f8e20(&DAT_00c70d48);
    return 1;
  }
  return 0;
}

