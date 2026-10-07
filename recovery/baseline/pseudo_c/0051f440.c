/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051f440 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051f440(float param_1)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  int iVar6;
  int iVar7;
  float10 fVar8;
  float local_1c;
  float local_14;
  float local_10;
  float local_c;
  
  iVar6 = (int)param_1;
  fVar3 = *(float *)((int)param_1 + 0x1862);
  local_c = fVar3 * fVar3 * _DAT_006e9824;
  if (*(float *)((int)param_1 + 0x1972) <= local_c) {
    local_c = *(float *)((int)param_1 + 0x1972);
  }
  fVar2 = -local_c;
  fVar4 = fVar2;
  if (fVar2 <= *(float *)((int)param_1 + 0x195a)) {
    fVar4 = *(float *)((int)param_1 + 0x195a);
  }
  local_14 = local_c;
  if ((fVar4 <= local_c) && (local_14 = fVar2, fVar2 <= *(float *)((int)param_1 + 0x195a))) {
    local_14 = *(float *)((int)param_1 + 0x195a);
  }
  pfVar1 = (float *)((int)param_1 + 0x1972);
  fVar2 = _DAT_006e97d8 / *(float *)((int)param_1 + 0x1972);
  local_10 = _DAT_006e97d8 - ABS(*(float *)((int)param_1 + 0x199e)) * fVar2 * _DAT_006ea44c;
  if (local_10 < _DAT_006ea44c) {
    local_10 = 0.5;
  }
  fVar4 = _DAT_0074ac00 * *(float *)((int)param_1 + 0x1af6);
  local_1c = fVar4;
  if (_DAT_006ea470 <= fVar4) {
    local_1c = 0.4;
  }
  fVar2 = fVar2 * local_1c * *(float *)((int)param_1 + 0x197e);
  if (_DAT_006f4994 <= *(float *)((int)param_1 + 0x1872)) {
    if (*(float *)((int)param_1 + 0x1872) < _DAT_006f49e4) {
      fVar2 = (*(float *)((int)param_1 + 0x1872) - _DAT_006f4994) * fVar2 * _DAT_006f49e0;
    }
  }
  else {
    param_1 = 0.0;
    fVar2 = param_1;
  }
  param_1 = fVar2;
  if (_DAT_0074aab0 < ABS(param_1)) {
    fVar2 = ABS(param_1) - _DAT_0074aab0;
    fVar5 = (*(float *)(iVar6 + 0x176e) + *(float *)(iVar6 + 0x1702)) * _DAT_006ea50c;
    local_10 = ((fVar5 + _DAT_006e97d8) * _DAT_006ee4c4 +
               (_DAT_006f49dc - _DAT_006ee4c4 * fVar5) /
               ((_DAT_006e97d8 - fVar5 * _DAT_006ea44c) * _DAT_0074aac8 * fVar2 * fVar2 * fVar2 +
               _DAT_006e97d8)) * local_10;
  }
  fVar8 = (float10)FUN_0051f0a0(local_14 / *pfVar1);
  fVar2 = (float)(((float10)*(float *)(iVar6 + 0x1972) / (float10)fVar4) * fVar8);
  fVar5 = (_DAT_006f4164 / local_1c) * *(float *)(iVar6 + 0x1972) * _DAT_0074aab0;
  if ((((_DAT_006ea454 <= fVar2) || (param_1 = -fVar5, param_1 <= fVar2)) &&
      (param_1 = fVar2, _DAT_006ea454 < fVar2)) && (fVar5 < fVar2)) {
    param_1 = fVar5;
  }
  fVar8 = (float10)FUN_004fff80();
  if ((float10)fVar3 <= fVar8 + (float10)_DAT_006ea450) {
    if (fVar3 <= _DAT_006ea480) {
      local_c = 0.0;
      fVar3 = _DAT_006ea454;
    }
    else {
      local_c = (_DAT_006e97d8 / fVar3) * local_c;
      fVar3 = (_DAT_006e97d8 / fVar3) * local_14;
    }
  }
  else {
    local_c = (_DAT_006e97d8 / fVar3) * local_c;
    fVar3 = (_DAT_006e97d8 / fVar3) * *(float *)(iVar6 + 0x188e);
  }
  fVar3 = DAT_0074aa80 * local_10 * (param_1 - *(float *)(iVar6 + 0x197e)) +
          (fVar3 - *(float *)(iVar6 + 0x18ae)) * _DAT_0074aa98 * local_10;
  *(float *)(iVar6 + 0x18b2) = fVar3;
  if ((*(float *)(iVar6 + 0x1862) < _DAT_006f49d8) &&
     (fVar3 = fVar3 + *(float *)(iVar6 + 0x18ae), local_c < ABS(fVar3))) {
    iVar7 = 1;
    if ((int)fVar3 < 0) {
      iVar7 = -1;
    }
    *(float *)(iVar6 + 0x18b2) = (float)iVar7 * local_c - *(float *)(iVar6 + 0x18ae);
  }
  *(float *)(iVar6 + 0x195a) = local_14;
  *(float *)(iVar6 + 0x18ae) = *(float *)(iVar6 + 0x18b2) + *(float *)(iVar6 + 0x18ae);
  *(float *)(iVar6 + 0x1982) = (fVar4 / *(float *)(iVar6 + 0x1972)) * *(float *)(iVar6 + 0x197e);
  return;
}


