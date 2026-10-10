/* NR2003.exe @ 00570fe0 FUN_00570fe0 */

undefined4 FUN_00570fe0(undefined param_1)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6b534);
  if (cVar1 != '\0') {
    DAT_00c69115 = param_1;
    FUN_005f8e20(&DAT_00c6b534);
    return 1;
  }
  return 0;
}

