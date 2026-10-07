/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570760 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570760(undefined4 param_1,undefined1 param_2,undefined4 param_3)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c5f71c);
  if (cVar1 != '\0') {
    DAT_00c70d44 = (undefined1)((uint)param_1 >> 0x18);
    _DAT_00c70d3c = CONCAT31((int3)param_3,param_2);
    DAT_00c70d40 = (undefined1)((uint)param_3 >> 0x18);
    _DAT_00c70d40 = CONCAT31((int3)param_1,DAT_00c70d40);
    FUN_005f8e20(&DAT_00c5f71c);
    return 1;
  }
  return 0;
}


