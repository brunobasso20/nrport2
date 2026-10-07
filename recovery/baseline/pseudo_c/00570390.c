/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570390 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570390(undefined1 param_1,undefined4 param_2)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c5f498);
  if (cVar1 != '\0') {
    _DAT_00c677d8 = CONCAT31((int3)param_2,param_1);
    DAT_00c677dc = (undefined1)((uint)param_2 >> 0x18);
    FUN_005f8e20(&DAT_00c5f498);
    return 1;
  }
  return 0;
}


