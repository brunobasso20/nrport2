/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00507bd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00507bd0(float param_1,float param_2,float param_3)

{
  if ((param_1 < _DAT_006ea454) || (param_2 < param_1)) {
    if (_DAT_006ea454 < param_3) {
      return (float10)_DAT_006ea454;
    }
    return (float10)_DAT_006e97d8;
  }
  if ((param_1 < param_3) && (_DAT_006ea454 < param_3)) {
    return (float10)param_1 / (float10)param_3;
  }
  if ((param_2 - param_3 < param_1) && (_DAT_006ea454 < param_3)) {
    return (float10)_DAT_006e97d8 -
           (((float10)param_1 - (float10)param_2) + (float10)param_3) / (float10)param_3;
  }
  return (float10)_DAT_006e97d8;
}


