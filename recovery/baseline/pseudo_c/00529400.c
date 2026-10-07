/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00529400 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00529400(undefined4 param_1,float param_2,float *param_3)

{
  if (*param_3 < _DAT_006ea454) {
    *param_3 = 0.0;
  }
  param_2 = _DAT_0074b080 * _DAT_006e9810 + param_2;
  if ((_DAT_006ea454 < param_2) && (param_2 < *param_3)) {
    *param_3 = param_2;
    return;
  }
  return;
}


