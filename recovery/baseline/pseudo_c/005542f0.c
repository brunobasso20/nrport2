/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005542f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005542f0(float param_1,float param_2)

{
  float fVar1;
  float10 fVar2;
  
  if (DAT_0074c9a8 <= param_1) {
    if (DAT_0074c9a8 < param_1) {
      fVar2 = (float10)FUN_00554ee0();
      if (((float10)_DAT_006ee370 <= fVar2) || (fVar1 = _DAT_006e9804, DAT_0074c97c != 2)) {
        fVar1 = 10.0;
      }
      DAT_0074c9a8 = _DAT_0074fd74 * fVar1 + DAT_0074c9a8;
      if (param_1 < DAT_0074c9a8) {
        DAT_0074c9a8 = param_1;
      }
    }
  }
  else {
    DAT_0074c9a8 = DAT_0074c9a8 - _DAT_0074fd74 * _DAT_006ea478;
    if (DAT_0074c9a8 < param_1) {
      DAT_0074c9a8 = param_1;
    }
  }
  if (param_2 <= DAT_0074c9a8) {
    DAT_00bf6370 = param_2;
    return;
  }
  DAT_00bf6370 = DAT_0074c9a8;
  return;
}


