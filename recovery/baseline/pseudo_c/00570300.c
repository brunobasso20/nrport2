/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570300 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570300(undefined4 param_1,undefined1 param_2,undefined4 param_3)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c6a388);
  if (cVar1 != '\0') {
    _DAT_00c6fb20 = param_1;
    _DAT_00c6fb24 = CONCAT31((int3)param_3,param_2);
    DAT_00c6fb28 = (undefined1)((uint)param_3 >> 0x18);
    FUN_005f8e20(&DAT_00c6a388);
    return 1;
  }
  return 0;
}


