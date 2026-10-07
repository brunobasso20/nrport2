/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005706f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005706f0(undefined4 param_1,undefined4 param_2,undefined1 param_3,undefined4 param_4)

{
  char cVar1;
  
  cVar1 = FUN_005f8da0(&DAT_00c69064);
  if (cVar1 != '\0') {
    _DAT_00c70de8 = param_2;
    DAT_00c70df4 = (undefined1)((uint)param_1 >> 0x18);
    _DAT_00c70dec = CONCAT31((int3)param_4,param_3);
    DAT_00c70df0 = (undefined1)((uint)param_4 >> 0x18);
    _DAT_00c70df0 = CONCAT31((int3)param_1,DAT_00c70df0);
    FUN_005f8e20(&DAT_00c69064);
    return 1;
  }
  return 0;
}


