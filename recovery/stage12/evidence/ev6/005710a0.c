/* NR2003.exe @ 005710a0 FUN_005710a0 */

undefined4 FUN_005710a0(undefined param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6a3dc);
  if (cVar1 != '\0') {
    DAT_00c677dd = param_1;
    FUN_005f8e20(&DAT_00c6a3dc);
    return 1;
  }
  return 0;
}

