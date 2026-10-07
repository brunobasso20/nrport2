/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004ecfc0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004ecfc0(int param_1_00,float param_1)

{
  float fVar1;
  float fVar2;
  
  fVar2 = _DAT_006ea454;
  fVar1 = _DAT_006e97d8;
  if (param_1 < _DAT_006ea454) {
    *(float *)(param_1_00 + 8) = _DAT_006ea454;
    *(float *)(param_1_00 + 0xc) = SQRT(fVar2) * _DAT_006f39ec;
    return;
  }
  if (_DAT_006e97d8 < param_1) {
    *(float *)(param_1_00 + 8) = _DAT_006e97d8;
    *(float *)(param_1_00 + 0xc) = SQRT(fVar1) * _DAT_006f39ec;
    return;
  }
  *(float *)(param_1_00 + 8) = param_1;
  *(float *)(param_1_00 + 0xc) = SQRT(param_1) * _DAT_006f39ec;
  return;
}


