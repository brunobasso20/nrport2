/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050b200 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0050b200(int param_1,float *param_2,float *param_3,float *param_4,float *param_5,
                    float *param_6,int param_7,float *param_8)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float10 fVar7;
  float10 fVar8;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  
  *param_8 = *param_4 - *param_2;
  param_8[1] = param_4[1] - param_2[1];
  param_8[2] = param_4[2] - param_2[2];
  FUN_005f6a70(param_8);
  pfVar1 = param_3 + 9;
  fVar2 = param_3[0xb];
  local_1c = param_3[9] * param_8[1] - param_3[10] * *param_8;
  fVar4 = param_8[2] * param_3[10] - param_3[0xb] * param_8[1];
  local_20 = param_3[0xb] * *param_8 - param_8[2] * *pfVar1;
  local_10 = param_5[2] - param_8[2];
  fVar3 = _DAT_006e97d8 /
          SQRT((*param_4 - *param_3) * (*param_4 - *param_3) +
               (param_4[1] - param_3[1]) * (param_4[1] - param_3[1]) +
               (param_4[2] - param_3[2]) * (param_4[2] - param_3[2]));
  local_18 = (*param_5 - *param_8) * fVar3;
  fVar6 = (param_5[1] - param_8[1]) * fVar3;
  fVar5 = local_10 * fVar3 * local_1c + local_18 * fVar4 + fVar6 * local_20;
  *(float *)(DAT_00b8fac0 + param_7 * 4) = fVar5;
  fVar6 = local_18 * *pfVar1 + fVar6 * param_3[10] + local_10 * fVar3 * param_3[0xb];
  *(float *)(DAT_00b8fabc + param_7 * 4) = fVar6;
  param_4 = (float *)(_DAT_006f40a8 * _DAT_006ea44c);
  param_2 = (float *)(_DAT_006f40a8 * _DAT_006ea50c);
  if (param_1 != 0xb) {
    fVar4 = _DAT_006f40b0 * fVar2;
    do {
      fVar3 = (float)param_4 * (float)param_4 * fVar6;
      fVar7 = (float10)FUN_0050b4c0((fVar3 - fVar4) -
                                    _DAT_00749478 * (float)param_4 * (float)param_4,param_4);
      fVar8 = (float10)FUN_005100c0(param_3[0x13]);
      fVar4 = _DAT_006f40b0 * fVar2;
      if (((fVar3 - fVar4) - _DAT_00749478 * (float)param_4 * (float)param_4) *
          (float)(fVar8 * (float10)(float)fVar7) <
          ABS((float)param_4 * (float)param_4 * fVar5 - _DAT_006f40b0 * local_1c)) {
        param_4 = (float *)((float)param_4 - (float)param_2);
      }
      else {
        param_4 = (float *)((float)param_2 + (float)param_4);
      }
      param_2 = (float *)((float)param_2 * _DAT_006ea44c);
    } while (_DAT_006f40ac < (float)param_2);
    return (float10)(float)param_4;
  }
  local_c = param_3[0xd];
  local_8 = param_3[0xe];
  fVar2 = *param_6 * _DAT_006f410c;
  local_10 = fVar2 * fVar2 * fVar5 * _DAT_006f4108;
  local_18 = local_10 * fVar4;
  local_14 = local_20 * local_10;
  local_10 = local_10 * local_1c;
  FUN_005f5ce0(&local_c,&local_24,pfVar1);
  param_6[2] = local_24 * local_18 + local_20 * local_14 + local_1c * local_10;
  return (float10)fVar2;
}


