/* NR2003.exe @ 004e9250 recovered_004e9250 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall
recovered_004e9250(int param_1,float *param_2,float param_3,undefined4 param_4)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  
  if (*(char *)(param_1 + 0x34) != '\0') {
    fVar2 = (param_3 - *(float *)(param_1 + 0x24)) * *(float *)(param_1 + 0x2c);
    (**(code **)(param_1 + 0x851 +
                ((uint)(_DAT_006ea454 <= fVar2) -
                (uint)(fVar2 < _DAT_006e97d8 != (fVar2 == _DAT_006e97d8))) * 4))
              (param_2,fVar2,param_4);
    return 1;
  }
  if (param_3 < _DAT_006ea454 == (NAN(param_3) || NAN(_DAT_006ea454))) {
    if (_DAT_006e97d8 < param_3) {
      param_3 = 1.0;
    }
  }
  else {
    param_3 = 0.0;
  }
  fVar2 = _DAT_006e97d8;
  if ((param_3 <= _DAT_006e97d8) &&
     (fVar2 = param_3, param_3 < _DAT_006ea454 != (NAN(param_3) || NAN(_DAT_006ea454)))) {
    fVar2 = _DAT_006ea454;
  }
  fVar3 = fVar2 * fVar2;
  fVar4 = _DAT_006e97d8 - fVar2;
  fVar6 = fVar4 * fVar4;
  fVar5 = (fVar3 * fVar2 * *(float *)(param_1 + 0x20) +
          fVar6 * fVar4 * *(float *)(param_1 + 8) +
          (fVar6 * *(float *)(param_1 + 0x10) * fVar2 + fVar4 * *(float *)(param_1 + 0x18) * fVar3)
          * _DAT_006ea62c) * *(float *)(param_1 + 0x30);
  fVar1 = *(float *)(param_1 + 0x14);
  param_2[1] = fVar5;
  *param_2 = (*(float *)(param_1 + 0x28) - *(float *)(param_1 + 0x24)) *
             (fVar3 * fVar2 * *(float *)(param_1 + 0x1c) +
             fVar6 * fVar4 * *(float *)(param_1 + 4) +
             (fVar6 * *(float *)(param_1 + 0xc) * fVar2 + fVar4 * fVar1 * fVar3) * _DAT_006ea62c) +
             *(float *)(param_1 + 0x24);
  if (fVar5 < _DAT_006ea454 != (NAN(fVar5) || NAN(_DAT_006ea454))) {
    param_2[1] = 0.0;
  }
  return 1;
}

