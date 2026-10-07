/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571920 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00571920(undefined4 param_1,undefined4 param_2)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6f6f8);
  if (cVar1 != '\0') {
    _DAT_00c70ad8 = param_1;
    FUN_006c4b00(&DAT_00c70adc,param_2,0x50);
    DAT_00c70b2b = 0;
    FUN_005f8e20(&DAT_00c6f6f8);
    return 1;
  }
  return 0;
}


