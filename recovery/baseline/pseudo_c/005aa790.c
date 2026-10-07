/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005aa790 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005aa790(int param_1)

{
  int iVar1;
  
  if (param_1 < 0) {
    iVar1 = taskGetRate();
    _DAT_00e56d08 = _DAT_00e56d08 - _DAT_006e9808 / (double)iVar1;
    if (_DAT_00e56d08 < _DAT_006ea4b0) {
      _DAT_00e56d08 = 0.0;
      return;
    }
  }
  else if (0 < param_1) {
    iVar1 = taskGetRate();
    _DAT_00e56d08 = _DAT_006e9808 / (double)iVar1 + _DAT_00e56d08;
  }
  return;
}


