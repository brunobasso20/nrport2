/* NR2003.exe @ 00571070 FUN_00571070 */

undefined4 FUN_00571070(undefined param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c67748);
  if (cVar1 != '\0') {
    DAT_00c6b468 = param_1;
    FUN_005f8e20(&DAT_00c67748);
    return 1;
  }
  return 0;
}

