/* NR2003.exe @ 00565770 FUN_00565770 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00565770(int param_1)

{
  float fVar1;
  
  if (((byte)*(undefined4 *)(param_1 + 0x14fc) & 0x18) == 8) {
    fVar1 = *(float *)(param_1 + 0x1590) + _DAT_006f4614;
    *(float *)(param_1 + 0x1590) = fVar1;
    if (_DAT_006e97d8 < fVar1) {
      *(undefined4 *)(param_1 + 0x1590) = 0x3f800000;
    }
  }
  else {
    fVar1 = *(float *)(param_1 + 0x1590) - _DAT_006ee398;
    *(float *)(param_1 + 0x1590) = fVar1;
    if (fVar1 < _DAT_006ea454 != (NAN(fVar1) || NAN(_DAT_006ea454))) {
      *(undefined4 *)(param_1 + 0x1590) = 0;
      return;
    }
  }
  FUN_00565c30();
  return;
}

