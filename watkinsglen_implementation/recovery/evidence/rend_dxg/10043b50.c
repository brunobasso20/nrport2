/* rend_dxg.dll @ 10043b50 FUN_10043b50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 * __thiscall
FUN_10043b50(undefined4 *param_1_00,undefined4 param_1,undefined4 param_3_00,undefined4 param_2,
            undefined4 param_5_00,undefined4 param_3,undefined4 param_7_00,int *param_4,
            undefined4 param_5,undefined4 param_6,int param_7,int param_8,undefined4 param_9,
            undefined4 param_10,undefined4 param_11,undefined4 param_12,undefined4 param_13,
            undefined4 param_14,undefined4 param_15)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  float fVar5;
  float fVar6;

  FUN_10041640(param_1,param_3_00,param_2,param_5_00,param_3,param_7_00,param_5,param_6,param_7,
               param_8,param_11,param_12,param_13,param_14,1,param_15);
  fVar3 = *(float *)(param_8 + 0x10) - *(float *)(param_7 + 0x10);
  *param_1_00 = &PTR_LAB_1009aa10;
  *(undefined4 *)((int)param_1_00 + 0x1dd) = 0;
  *(float *)((int)param_1_00 + 0x1d9) = fVar3;
  iVar4 = *param_4;
  if (iVar4 == 1) {
    fVar1 = (float)param_4[3];
  }
  else {
    fVar1 = _DAT_10095230 /
            (((float)param_4[0xf] - (float)(double)CONCAT44(param_2,param_3_00)) *
            (float)param_4[0x12]);
  }
  fVar1 = _DAT_10095230 / fVar1;
  param_1_00[0x70] = fVar1;
  if (iVar4 == 1) {
    fVar2 = (float)param_4[3];
  }
  else {
    fVar2 = _DAT_10095230 /
            (((float)param_4[0xf] - (float)(double)CONCAT44(param_3,param_5_00)) *
            (float)param_4[0x12]);
  }
  fVar2 = _DAT_10095230 / fVar2;
  *(bool *)(param_1_00 + 0x76) = iVar4 == 2;
  param_1_00[0x71] = fVar2 - fVar1;
  fVar1 = ((float)(double)CONCAT44(param_2,param_3_00) - *(float *)(param_7 + 0xc)) / fVar3;
  *(float *)((int)param_1_00 + 0x1e5) = fVar1;
  *(float *)((int)param_1_00 + 0x1e9) =
       ((float)(double)CONCAT44(param_3,param_5_00) - *(float *)(param_7 + 0x10)) / fVar3 - fVar1;
  *(float *)((int)param_1_00 + 0x1e1) = *(float *)(param_7 + 0x10) - *(float *)(param_7 + 0xc);
  if (iVar4 == 2) {
    iVar4 = param_4[0x12];
    param_1_00[0x74] = param_4[0x11];
    param_1_00[0x75] = iVar4;
  }
  else {
    iVar4 = param_4[0xf];
    param_1_00[0x73] = -(float)param_4[0xe];
    param_1_00[0x72] = iVar4;
  }
  fVar3 = *(float *)(param_8 + 0x31);
  fVar1 = *(float *)(param_8 + 0x21);
  fVar2 = (float)*(double *)(param_8 + 0x15) - (float)*(double *)(param_8 + 0x25);
  *(undefined4 *)((int)param_1_00 + 0x215) = param_10;
  *(undefined4 *)((int)param_1_00 + 0x211) = param_9;
  fVar1 = fVar2 + fVar2 + fVar3 + fVar1;
  fVar5 = ((float)*(double *)(param_8 + 0x25) - (float)*(double *)(param_8 + 0x15)) *
          (float)_DAT_10097990 -
          (*(float *)(param_8 + 0x21) + *(float *)(param_8 + 0x21) + *(float *)(param_8 + 0x31));
  fVar3 = (float)*(double *)(param_7 + 0x15) - (float)*(double *)(param_7 + 0x25);
  fVar2 = *(float *)(param_7 + 0x21) + *(float *)(param_7 + 0x31) + fVar3 + fVar3;
  fVar6 = ((float)*(double *)(param_7 + 0x25) - (float)*(double *)(param_7 + 0x15)) *
          (float)_DAT_10097990 -
          (*(float *)(param_7 + 0x21) + *(float *)(param_7 + 0x21) + *(float *)(param_7 + 0x31));
  *(float *)((int)param_1_00 + 0x1ed) = fVar1 - fVar2;
  *(float *)((int)param_1_00 + 0x1f1) = fVar5 - fVar6;
  fVar3 = *(float *)(param_7 + 0x21);
  *(float *)((int)param_1_00 + 0x1f5) = fVar3;
  *(float *)((int)param_1_00 + 0x1f9) = *(float *)(param_8 + 0x21) - fVar3;
  *(float *)((int)param_1_00 + 0x1fd) =
       (float)*(double *)(param_8 + 0x15) - (float)*(double *)(param_7 + 0x15);
  fVar2 = fVar2 * _DAT_10097490;
  *(float *)((int)param_1_00 + 0x201) = fVar2;
  *(float *)((int)param_1_00 + 0x205) = fVar1 * _DAT_10097490 - fVar2;
  *(float *)((int)param_1_00 + 0x209) = fVar6 + fVar6;
  *(float *)((int)param_1_00 + 0x20d) = (fVar5 + fVar5) - (fVar6 + fVar6);
  return param_1_00;
}
