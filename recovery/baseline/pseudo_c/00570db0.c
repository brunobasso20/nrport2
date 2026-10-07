/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570db0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570db0(int param_1,undefined4 *param_2)

{
  char cVar1;
  undefined4 *puVar2;
  
  cVar1 = FUN_005f8da0(&DAT_00c6b44c);
  if ((cVar1 != '\0') && (0 < param_1)) {
    _DAT_00c703a8 = param_1;
    puVar2 = &DAT_00c703ac;
    for (param_1 = param_1 * 2; param_1 != 0; param_1 = param_1 + -1) {
      *puVar2 = *param_2;
      param_2 = param_2 + 1;
      puVar2 = puVar2 + 1;
    }
    FUN_005f8e20(&DAT_00c6b44c);
    return 1;
  }
  return 0;
}


