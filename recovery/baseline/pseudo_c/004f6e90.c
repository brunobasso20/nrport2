/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f6e90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_004f6e90(int *param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float local_8;
  
  local_8 = DAT_00748520;
  fVar1 = _DAT_0074851c;
  if (*param_1 == DAT_00760b38) {
    local_8 = 1.0;
    fVar1 = _DAT_006e97d8;
  }
  fVar3 = (_DAT_006e97d8 - (float)param_1[0x66]) * _DAT_006ea494 +
          (float)param_1[0x14] * (float)param_1[0x66];
  param_1[0x46] = (int)fVar3;
  if (fVar1 <= local_8) {
    param_1[0x67] = 0x3f800000;
    fVar2 = (local_8 - fVar1) + (local_8 - fVar1) + fVar1;
  }
  else {
    param_1[0x67] = (int)(local_8 / fVar1);
    fVar2 = fVar1;
  }
  fVar4 = _DAT_0074b4a0;
  if (fVar1 < _DAT_006e97d8) {
    fVar4 = (_DAT_006e97d8 - (fVar1 - _DAT_006e97d8) * _DAT_0074b380) * _DAT_0074b4a0;
  }
  fVar5 = ((float)param_1[0x2c] - _DAT_006e97d8) - _DAT_006ea44c;
  param_1[0x4e] =
       (int)((fVar5 * fVar4 + _DAT_006e97d8) * (float)param_1[0x4a] * (float)param_1[0x49]);
  fVar4 = _DAT_0074b4a0;
  if (fVar2 < _DAT_006e97d8) {
    fVar4 = (_DAT_006e97d8 - (fVar2 - _DAT_006e97d8) * _DAT_0074b380) * _DAT_0074b4a0;
  }
  fVar6 = _DAT_0074b338;
  if (DAT_00bdbd00 == 4) {
    fVar6 = _DAT_006ea50c;
  }
  param_1[0x4d] =
       (int)(((fVar2 - _DAT_006e97d8) * fVar6 + _DAT_006e97d8) *
            (fVar4 * fVar5 + _DAT_006e97d8) * (float)param_1[0x4a] * (float)param_1[0x49]);
  fVar2 = _DAT_0074b470;
  if (local_8 < _DAT_006e97d8) {
    fVar2 = (_DAT_006e97d8 - (local_8 - _DAT_006e97d8) * _DAT_0074b3b0) * _DAT_0074b470;
  }
  fVar4 = local_8 - _DAT_006e97d8;
  param_1[0x4b] =
       (int)((_DAT_006e97d8 - fVar4 * _DAT_0074b350) *
            (_DAT_006e97d8 - (((float)param_1[0x26] - _DAT_006e97d8) - _DAT_006ea44c) * fVar2));
  fVar2 = _DAT_0074b488;
  if (local_8 < _DAT_006e97d8) {
    fVar2 = (_DAT_006e97d8 - fVar4 * _DAT_0074b398) * _DAT_0074b488;
  }
  fVar2 = (fVar4 * _DAT_0074b368 + _DAT_006e97d8) *
          ((((float)param_1[0x29] - _DAT_006e97d8) - _DAT_006ea44c) * fVar2 + _DAT_006e97d8);
  param_1[0x4c] = (int)fVar2;
  if (DAT_00bdbd00 == 4) {
    param_1[0x4c] = (int)((fVar4 * _DAT_006e9824 + _DAT_006e97d8) * fVar2);
  }
  fVar1 = (_DAT_006e97d8 - (fVar1 - _DAT_006e97d8) * _DAT_0074b4b8) *
          (_DAT_006e97d8 - ((fVar3 - _DAT_006e97d8) - _DAT_006ea44c) * _DAT_0074b578) *
          (_DAT_006e97d8 - ((float)param_1[0x11] - _DAT_006e97d8) * _DAT_0074b4d0);
  if (fVar1 < _DAT_006ea454) {
    fVar1 = _DAT_006ea454;
  }
  param_1[0x52] = (int)(_DAT_0074b4e8 * fVar1);
  param_1[0x5b] = (int)(_DAT_0074b500 * fVar1);
  param_1[0x5c] = (int)(_DAT_0074b518 * fVar1);
  param_1[0x5d] = (int)(_DAT_0074b530 * fVar1);
  param_1[0x50] =
       (int)(_DAT_006e97d8 -
            (((float)param_1[0x35] - _DAT_006e97d8) - _DAT_006e981c) * _DAT_0074b548);
  param_1[0x51] = (int)(_DAT_006e97d8 - ((float)param_1[0x32] - _DAT_006e97d8) * _DAT_0074b560);
  return;
}


