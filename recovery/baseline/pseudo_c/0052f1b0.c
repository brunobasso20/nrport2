/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052f1b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall FUN_0052f1b0(int param_1_00,int param_1)

{
  float10 fVar1;
  
  fVar1 = (float10)FUN_004f7690(param_1 + -0x28);
  switch(param_1) {
  case 0x28:
  case 0x2d:
    return ((float10)ABS(*(float *)(param_1_00 + 0x188e) * *(float *)(param_1_00 + 0x1876) *
                         _DAT_006ef7bc) + (float10)_DAT_006e97d8) * (float10)(float)fVar1;
  default:
    return fVar1;
  case 0x2b:
  case 0x30:
    return ((float10)*(float *)(param_1_00 + 0x18fe) + (float10)_DAT_006ea44c) * fVar1;
  case 0x2c:
  case 0x31:
    break;
  }
  if (_DAT_006ea454 < *(float *)(param_1_00 + 0x1876)) {
    return fVar1 * (float10)_DAT_006ea508;
  }
  if (*(float *)(param_1_00 + 0x1972) <= _DAT_006ea454) {
    return ((float10)_DAT_006ea454 + (float10)_DAT_006e97d8) * fVar1;
  }
  return (-((float10)*(float *)(param_1_00 + 0x1876) / (float10)*(float *)(param_1_00 + 0x1972)) +
         (float10)_DAT_006e97d8) * fVar1;
}


