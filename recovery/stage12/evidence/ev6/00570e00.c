/* NR2003.exe @ 00570e00 FUN_00570e00 */

undefined4 FUN_00570e00(undefined param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6f70c);
  if (cVar1 != '\0') {
    DAT_00c5f714 = param_1;
    FUN_005f8e20(&DAT_00c6f70c);
    return 1;
  }
  return 0;
}

