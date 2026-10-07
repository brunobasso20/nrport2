/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005103a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005103a0(float param_1)

{
  float fVar1;
  double dVar2;
  
  if (param_1 < _DAT_006ea67c) {
    param_1 = 0.001;
  }
  if (_DAT_00ba71c4 < _DAT_006ea67c) {
    dVar2 = rndNormal(0);
    return (float10)dVar2 * (float10)0.0;
  }
  if (param_1 < _DAT_00ba71c4 != (param_1 == _DAT_00ba71c4)) {
    fVar1 = (param_1 / _DAT_00ba71c4) * _DAT_00bad900;
    dVar2 = rndNormal(0);
    return (float10)dVar2 * (float10)fVar1;
  }
  fVar1 = _DAT_00ba71c8 - _DAT_00ba71c4;
  if (fVar1 < _DAT_006f4618 != (fVar1 == _DAT_006f4618)) {
    fVar1 = (param_1 / _DAT_00ba71c4) * _DAT_00bad900;
    dVar2 = rndNormal(0);
    return (float10)dVar2 * (float10)fVar1;
  }
  if (param_1 < _DAT_00ba71c8) {
    fVar1 = (_DAT_00bad904 - _DAT_00bad900) * ((param_1 - _DAT_00ba71c4) / fVar1) + _DAT_00bad900;
    dVar2 = rndNormal(0);
    return (float10)dVar2 * (float10)fVar1;
  }
  fVar1 = _DAT_00ba71cc - _DAT_00ba71c8;
  if (fVar1 < _DAT_006f4618 != (fVar1 == _DAT_006f4618)) {
    fVar1 = (param_1 / _DAT_00ba71c8) * _DAT_00bad904;
    dVar2 = rndNormal(0);
    return (float10)dVar2 * (float10)fVar1;
  }
  if (param_1 < _DAT_00ba71cc) {
    fVar1 = (_DAT_00bad908 - _DAT_00bad904) * ((param_1 - _DAT_00ba71c8) / fVar1) + _DAT_00bad904;
    dVar2 = rndNormal(0);
    return (float10)dVar2 * (float10)fVar1;
  }
  fVar1 = _DAT_00ba71d0 - _DAT_00ba71cc;
  if (fVar1 < _DAT_006f4618 != (fVar1 == _DAT_006f4618)) {
    fVar1 = (param_1 / _DAT_00ba71cc) * _DAT_00bad908;
    dVar2 = rndNormal(0);
    return (float10)dVar2 * (float10)fVar1;
  }
  if (param_1 < _DAT_00ba71d0) {
    fVar1 = (_DAT_00bad90c - _DAT_00bad908) * ((param_1 - _DAT_00ba71cc) / fVar1) + _DAT_00bad908;
    dVar2 = rndNormal(0);
    return (float10)dVar2 * (float10)fVar1;
  }
  fVar1 = (param_1 / _DAT_00ba71d0) * _DAT_00bad90c;
  dVar2 = rndNormal(0);
  return (float10)dVar2 * (float10)fVar1;
}


