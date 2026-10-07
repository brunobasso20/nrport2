/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00554d30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00554d30(void)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float local_4;
  
  if ((DAT_0074c964 < 1) || (_DAT_00bf6ee0 + _DAT_00bf6edc <= _DAT_006ea454)) {
    local_4 = 0.0;
    fVar1 = _DAT_006ea454;
  }
  else {
    local_4 = _DAT_00bf6edc / (_DAT_00bf6ee0 + _DAT_00bf6edc);
    fVar1 = _DAT_006e97d8 / (float)DAT_0074c964;
  }
  fVar3 = _DAT_006ea454;
  if (0 < DAT_0074c968) {
    fVar3 = _DAT_006e97d8 / (float)DAT_0074c968;
  }
  _DAT_0074c960 = _DAT_00bf6edc * fVar1 + _DAT_00bf6ee0 * fVar3;
  if (_DAT_006f5878 < _DAT_0074c960) {
    _DAT_0074c960 = 1500.0;
  }
  DAT_0074c964 = 0;
  DAT_0074c968 = 0;
  _DAT_00bf6edc = 0.0;
  _DAT_00bf6ee0 = 0.0;
  DAT_00bf6ec4 = _DAT_00bf6ed4 * local_4 * fVar1 + (_DAT_006e97d8 - local_4) * _DAT_00bf6ed8 * fVar3
  ;
  fVar4 = _DAT_00bf6ee8 * fVar3;
  fVar2 = _DAT_00bf6ee4 * fVar1;
  _DAT_00bf6ee4 = 0.0;
  _DAT_00bf6ee8 = 0.0;
  _DAT_00bf6ec8 = fVar2 + fVar4;
  fVar3 = _DAT_00bf6ef0 * fVar3;
  fVar1 = _DAT_00bf6eec * fVar1;
  _DAT_00bf6eec = 0.0;
  _DAT_00bf6ef0 = 0.0;
  _DAT_00bf6ed4 = 0.0;
  _DAT_00bf6ed8 = 0.0;
  _DAT_00bf6ed0 = fVar1 + fVar3;
  return;
}


