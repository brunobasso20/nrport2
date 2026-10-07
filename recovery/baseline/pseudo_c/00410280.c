/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00410280 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00410280(float *param_1,float *param_2,int param_3,float param_4,float param_5,
                 undefined4 param_6,float param_7,float param_8,float param_9,float param_10)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  undefined4 uVar5;
  int *piVar6;
  float *pfVar7;
  float10 fVar8;
  float10 fVar9;
  float10 fVar10;
  float10 fVar11;
  float10 fVar12;
  float10 fVar13;
  float10 fVar14;
  float10 fVar15;
  float10 fVar16;
  float10 fVar17;
  float local_30;
  float local_2c;
  float local_28;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float fStack_10;
  float local_c;
  float local_8;
  float local_4;
  
  fVar9 = (float10)fcos((float10)param_5);
  fVar8 = (float10)fsin((float10)param_5);
  local_28 = (float)fVar9;
  local_8 = (float)fVar8;
  local_4 = ABS(local_28);
  fVar9 = (float10)fcos((float10)param_4);
  local_18 = 0.0;
  local_2c = (float)fVar9;
  local_c = local_28 * local_2c;
  local_14 = (local_28 + _DAT_006e97d8) * _DAT_006ea44c;
  uVar5 = FUN_0055ab00();
  piVar6 = (int *)FUN_00562f70(uVar5);
  FUN_00410910(piVar6,&local_30,&local_24,&local_20,&local_1c);
  uVar5 = (**(code **)(*piVar6 + 4))(1);
  fVar9 = (float10)FUN_005486a0(uVar5);
  if (fVar9 < (float10)_DAT_006e97d8 != (fVar9 == (float10)_DAT_006e97d8)) {
    pfVar7 = (float *)FUN_00557d60(0x3b);
    local_18 = *pfVar7;
  }
  pfVar7 = (float *)FUN_00557d60(0x3d);
  fStack_10 = *pfVar7;
  if (*(float *)(param_3 + 0xb4) != _DAT_006ea454) {
    pfVar7 = (float *)FUN_00557d60(0x20);
    if (_DAT_006ec6f4 + _DAT_006ec6f4 < *pfVar7) {
      local_30 = (*pfVar7 - (_DAT_006ec6f4 + _DAT_006ec6f4)) * *(float *)(param_3 + 0xb4) + local_30
      ;
    }
    pfVar7 = (float *)FUN_00557d60(0x21);
    if (_DAT_006ec6f4 + _DAT_006ec6f4 < *pfVar7) {
      local_30 = (*pfVar7 - (_DAT_006ec6f4 + _DAT_006ec6f4)) * *(float *)(param_3 + 0xb4) + local_30
      ;
    }
  }
  if (param_7 < _DAT_006ea454) {
    param_7 = 0.0;
  }
  param_7 = _DAT_006ec748 - param_7;
  if (param_7 < _DAT_006ea454) {
    param_7 = 0.0;
  }
  fVar10 = (float10)FUN_00410750(param_3,param_4);
  fVar11 = (float10)FUN_004108b0(param_3,param_7);
  fVar12 = (float10)local_18;
  fVar1 = *(float *)(param_3 + 0xb8);
  fVar8 = (float10)local_14;
  fVar13 = (float10)fStack_10;
  fVar2 = *(float *)(param_3 + 0xc4);
  fVar3 = *(float *)(param_3 + 0xa8);
  fVar9 = (float10)local_30;
  fVar17 = (float10)local_c;
  fVar14 = (float10)FUN_00410630(param_3,param_5);
  *param_1 = (float)(((float10)local_28 * (float10)(float)fVar10 +
                     fVar14 * (float10)local_2c +
                     (float10)(float)((((fVar13 * (float10)fVar2 * (float10)param_10 +
                                        fVar12 * (float10)fVar1 * fVar8) - (float10)fVar3) + fVar11
                                      + fVar9) * fVar17)) * (float10)param_8);
  fVar9 = (float10)FUN_00410670(param_3,param_5);
  param_1[1] = (float)((float10)local_8 * (float10)(float)fVar10 + fVar9 * (float10)local_2c);
  fVar10 = (float10)FUN_004108d0(param_3,param_7);
  fVar11 = (float10)_DAT_006e97d8;
  fVar1 = *(float *)(param_3 + 0xd8);
  fVar12 = (float10)local_18;
  fVar2 = *(float *)(param_3 + 0xbc);
  fVar9 = (float10)local_14;
  fVar13 = (float10)fStack_10;
  fVar3 = *(float *)(param_3 + 200);
  fVar8 = (float10)local_c;
  fVar14 = (float10)FUN_00410690(param_3,param_5);
  fVar15 = (float10)local_14;
  fVar4 = *(float *)(param_3 + 0xac);
  fVar17 = (float10)local_2c;
  fVar16 = (float10)FUN_004107b0(param_3,param_4,param_5);
  fVar9 = fVar16 * (float10)local_4 +
          (float10)(float)((fVar15 * (float10)fVar4 + fVar14 + (float10)local_24) * fVar17 +
                          (float10)(float)((fVar13 * (float10)fVar3 * (float10)param_10 +
                                           fVar12 * (float10)fVar2 * fVar9 * (float10)param_9 +
                                           (fVar11 - (float10)param_8) * (float10)fVar1 + fVar10) *
                                          fVar8));
  param_1[2] = (float)fVar9;
  if ((float10)_DAT_006ea62c < fVar9) {
    param_1[2] = 3.0;
  }
  fVar17 = (float10)FUN_00410850(param_3,param_4);
  fVar9 = (float10)FUN_004106d0(param_3,param_5);
  *param_2 = (float)(fVar9 * (float10)local_2c -
                    (float10)local_8 * (float10)(float)fVar17 * (float10)_DAT_006ec744);
  fVar10 = (float10)FUN_004108f0(param_3,param_7);
  fVar11 = (float10)_DAT_006e97d8;
  fVar1 = *(float *)(param_3 + 0xdc);
  fVar12 = (float10)_DAT_006e97d8;
  fVar2 = *(float *)(param_3 + 0xe0);
  fVar13 = (float10)local_18;
  fVar3 = *(float *)(param_3 + 0xc0);
  fVar9 = (float10)local_14;
  fVar14 = (float10)fStack_10;
  fVar4 = *(float *)(param_3 + 0xcc);
  fVar8 = (float10)local_c;
  fVar15 = (float10)FUN_004106f0(param_3,param_5,local_28);
  param_2[1] = (float)((float10)local_28 * (float10)(float)fVar17 +
                      (fVar15 + (float10)local_20) * (float10)local_2c +
                      (float10)(float)((fVar14 * (float10)fVar4 * (float10)param_10 +
                                       fVar13 * (float10)fVar3 * fVar9 * (float10)param_9 +
                                       (fVar12 - (float10)param_10) * (float10)fVar2 +
                                       (fVar11 - (float10)param_9) * (float10)fVar1 + fVar10) *
                                      fVar8));
  fVar9 = (float10)FUN_00410730(param_3,param_5);
  param_2[2] = (float)((fVar9 + (float10)local_1c) * (float10)local_2c);
  return;
}


