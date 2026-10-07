/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050b530 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0050b530(int param_1,float *param_2,float *param_3,float *param_4,float *param_5,
                    float *param_6,int param_7,float *param_8,float param_9,float param_10)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  float10 fVar11;
  float10 fVar12;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  *param_8 = *param_4 - *param_2;
  param_8[1] = param_4[1] - param_2[1];
  param_8[2] = param_4[2] - param_2[2];
  FUN_005f6a70(param_8);
  fVar3 = param_8[2];
  pfVar1 = param_3 + 9;
  fVar4 = param_3[0xb];
  fVar5 = param_3[9] * param_8[1] - *param_8 * param_3[10];
  fVar6 = param_8[2] * param_3[10] - param_3[0xb] * param_8[1];
  fVar7 = *param_8 * param_3[0xb] - param_8[2] * *pfVar1;
  local_4 = param_5[2] - param_8[2];
  fVar9 = SQRT((*param_4 - *param_3) * (*param_4 - *param_3) +
               (param_4[1] - param_3[1]) * (param_4[1] - param_3[1]) +
               (param_4[2] - param_3[2]) * (param_4[2] - param_3[2]));
  fVar10 = _DAT_006e97d8 / fVar9;
  local_c = (*param_5 - *param_8) * fVar10;
  fVar2 = (param_5[1] - param_8[1]) * fVar10;
  fVar8 = local_4 * fVar10 * fVar5 + local_c * fVar6 + fVar2 * fVar7;
  *(float *)(DAT_00b8fac0 + param_7 * 4) = fVar8;
  fVar2 = local_c * *pfVar1 + fVar2 * param_3[10] + local_4 * fVar10 * param_3[0xb];
  *(float *)(DAT_00b8fabc + param_7 * 4) = fVar2;
  if (param_1 == 0xb) {
    return (float10)*param_6 * (float10)_DAT_006f410c;
  }
  if (_DAT_006ea454 < param_10) {
    fVar2 = fVar2 * param_10 * param_10;
    fVar11 = (float10)FUN_0050b4c0((fVar2 - _DAT_006f40b0 * fVar4) -
                                   _DAT_00749478 * param_10 * param_10,param_10);
    fVar12 = (float10)FUN_005100c0(param_3[0x13]);
    fVar4 = (fVar2 - _DAT_006f40b0 * fVar4) - _DAT_00749478 * param_10 * param_10;
    fVar12 = (float10)_DAT_0074b0b0 * (float10)fVar4 * fVar12 * (float10)(float)fVar11;
    fVar11 = ABS((float10)fVar8 * (float10)param_10 * (float10)param_10 -
                 (float10)fVar5 * (float10)_DAT_006f40b0);
    param_4 = (float *)(float)((float10)_DAT_006f411c * fVar11);
    if (fVar11 < fVar12) {
      param_4 = (float *)(float)((float10)(float)param_4 -
                                ((float10)_DAT_006e97d8 - (fVar11 / fVar12) * (fVar11 / fVar12)) *
                                (float10)_DAT_0074946c * fVar12);
    }
    fVar2 = _DAT_0074947c * param_10;
    fVar3 = _DAT_006f40b0 * fVar3;
    fVar10 = _DAT_006f40b0 * _DAT_006f4118;
    fVar11 = (float10)FUN_00579ef0(param_3[0x13]);
    fVar12 = (float10)FUN_00579ee0(param_3[0x13]);
    fVar11 = (float10)param_10 -
             ((float10)fVar9 / (float10)param_10) *
             (((float10)(fVar10 + fVar3 + fVar2 * param_10) -
              ((fVar12 + (float10)(float)(fVar11 * (float10)param_10 * (float10)param_10)) /
              (float10)_DAT_00749488) * (float10)fVar4) + (float10)(float)param_4);
    if (fVar11 <= (float10)param_9) {
      param_9 = (float)fVar11;
    }
  }
  fVar9 = param_9 * _DAT_006efe48;
  local_18 = param_3[0xd];
  local_14 = param_3[0xe];
  fVar3 = *param_8;
  fVar4 = param_8[1];
  fVar2 = param_8[2];
  local_4 = fVar8 * param_9 * param_9 * _DAT_006f4108;
  local_c = fVar6 * local_4;
  local_8 = fVar7 * local_4;
  local_4 = local_4 * fVar5;
  FUN_005f5ce0(&local_18,&local_24,pfVar1);
  *param_6 = fVar9 * fVar3 * local_18 + fVar9 * fVar4 * local_14 + local_10 * fVar9 * fVar2;
  param_6[1] = local_24 * fVar9 * fVar3 + local_20 * fVar9 * fVar4 + local_1c * fVar9 * fVar2;
  param_6[2] = local_24 * local_c + local_20 * local_8 + local_1c * local_4;
  return (float10)param_9;
}


