/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005144fa */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_005144fa(float *param_1,float *param_2,float *param_3,float *param_4,float *param_5,
                 float *param_6,float *param_7,float *param_8,float *param_9,float *param_10,
                 float *param_11,float *param_12,float *param_13,float param_14,float param_15,
                 undefined4 param_16,uint param_17,float *param_18,float param_19,float param_20,
                 float param_21,uint param_22)

{
  float fVar1;
  char cVar2;
  float fVar3;
  float *pfVar4;
  float *pfVar5;
  float fVar6;
  uint uVar7;
  int *piVar8;
  int *piVar9;
  int *piVar10;
  float10 fVar11;
  float10 fVar12;
  float10 fVar13;
  float10 fVar14;
  float10 fVar15;
  float local_34;
  float local_30;
  uint local_2c;
  float local_28;
  float local_24;
  int *local_20;
  float local_1c;
  int *local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  local_2c = (int)param_18 + param_17;
  if ((int)local_2c < 0) {
    local_2c = local_2c + DAT_00bad920;
  }
  if (DAT_00bad920 <= (int)local_2c) {
    local_2c = local_2c - DAT_00bad920;
  }
  fVar6 = param_21;
  if (local_2c != param_17) {
    do {
      piVar10 = (int *)(local_2c * 0x1550 + DAT_00bcf734);
      fVar11 = (float10)param_14 - (float10)(float)piVar10[0xc];
      fVar12 = (float10)param_15 - (float10)(float)piVar10[0xd];
      if (*piVar10 == 1) {
        local_28 = (float)piVar10[0x11];
        fVar14 = fVar11 * (float10)(float)piVar10[0xe] + fVar12 * (float10)(float)piVar10[0xf];
        fVar15 = fVar11 * (float10)(float)piVar10[0x10] + fVar12 * (float10)(float)piVar10[0x11];
        fVar11 = -(float10)(float)piVar10[0x10];
      }
      else {
        fVar15 = fVar11 * fVar11 + fVar12 * fVar12;
        fVar3 = (float)(0xbe7ffffdU - (int)(float)fVar15 >> 1);
        fVar14 = (float10)_DAT_006ea44c * fVar15;
        fVar13 = ((float10)_DAT_006ea494 - (float10)fVar3 * (float10)fVar3 * fVar14) *
                 (float10)fVar3;
        fVar13 = ((float10)_DAT_006ea494 - fVar13 * fVar13 * fVar14) * fVar13;
        fVar13 = ((float10)_DAT_006ea494 - fVar13 * fVar13 * fVar14) * fVar13;
        fVar13 = ((float10)_DAT_006ea494 - fVar13 * fVar13 * fVar14) * fVar13;
        fVar14 = (float10)fpatan(fVar12 * (float10)(float)piVar10[0xe] -
                                 fVar11 * (float10)(float)piVar10[0xf],
                                 fVar11 * (float10)(float)piVar10[0xe] +
                                 fVar12 * (float10)(float)piVar10[0xf]);
        fVar14 = fVar14 * (float10)(float)piVar10[0x12];
        fVar15 = ((float10)(float)piVar10[0x10] - fVar15 * fVar13) * (float10)(float)piVar10[4];
        param_21 = (float)(fVar13 * (float10)(float)piVar10[4]);
        local_28 = (float)-(fVar12 * (float10)param_21);
        fVar11 = fVar11 * (float10)param_21;
      }
      local_30 = (float)fVar15;
      local_34 = (float)fVar14;
      local_24 = (float)fVar11;
      local_18 = piVar10;
      if ((local_34 < _DAT_006ea454) ||
         (local_34 < (float)piVar10[5] == (local_34 == (float)piVar10[5]))) {
        if (_DAT_006ea454 <= local_34) {
          local_8 = local_30;
          local_4 = ABS(local_30);
          fVar3 = (local_34 - _DAT_006e97d8) * (float)piVar10[2] + local_4;
        }
        else {
          local_10 = local_30;
          local_c = ABS(local_30);
          fVar3 = local_c - local_34 * (float)piVar10[2];
        }
        if (fVar3 < param_19) {
          param_19 = fVar3;
          param_20 = (float)local_2c;
        }
      }
      else {
        if (piVar10[0x16] <= (int)fVar6) {
          fVar6 = (float)piVar10[0x16];
        }
        piVar8 = piVar10 + (int)fVar6 * 9 + 0x15e;
        while( true ) {
          if (piVar8[2] == 0) {
            fVar3 = (local_34 * (float)piVar8[4] + (float)piVar8[3]) - local_30;
          }
          else {
            fVar3 = (param_14 - (float)piVar8[5]) * (float)piVar8[8] -
                    (param_15 - (float)piVar8[6]) * (float)piVar8[7];
          }
          if (_DAT_006ea454 <= fVar3) break;
          fVar6 = (float)((int)fVar6 + 1);
          piVar8 = piVar8 + 9;
        }
        cVar2 = FUN_005195d0(local_34,local_30,param_14,param_15);
        while( true ) {
          fVar6 = (float)((int)fVar6 + -1);
          piVar8 = piVar8 + -9;
          if (cVar2 == '\0') break;
          cVar2 = FUN_005195d0(local_34,local_30,param_14,param_15);
        }
        local_20 = piVar8;
        if ((0 < (int)fVar6) && ((int)fVar6 < piVar10[0x16])) {
          if (piVar10[0x15] <= (int)param_22) {
            param_22 = piVar10[0x15];
          }
          pfVar4 = (float *)(piVar10 + param_22 * 0x12 + 0x1a);
          fVar3 = local_34 * (float)piVar10[param_22 * 0x12 + 0x1b] + *pfVar4;
          while (fVar3 < local_30) {
            pfVar5 = pfVar4 + 0x13;
            pfVar4 = pfVar4 + 0x12;
            param_22 = param_22 + 1;
            fVar3 = local_34 * *pfVar5 + *pfVar4;
          }
          param_18 = pfVar4 + -0x12;
          fVar3 = local_34 * pfVar4[-0x11] + *param_18;
          while (param_22 = param_22 - 1, local_30 < fVar3) {
            pfVar4 = param_18 + -0x11;
            param_18 = param_18 + -0x12;
            fVar3 = local_34 * *pfVar4 + *param_18;
          }
          param_20 = _DAT_006e97d8 / (local_34 * param_18[3] + param_18[2]);
          param_19 = (local_30 - (local_34 * param_18[1] + *param_18)) * param_20;
          *param_3 = param_14;
          *param_4 = param_15;
          fVar3 = ((local_34 * param_18[6] + param_18[7]) * local_34 + param_18[8]) * local_34 +
                  param_18[9] +
                  (((local_34 * param_18[0xc] + param_18[0xd]) * local_34 + param_18[0xe]) *
                   local_34 + param_18[0xf]) * param_19;
          *param_5 = fVar3;
          *param_6 = fVar3;
          param_21 = fVar6;
          if (piVar10[7] != 0) {
            FUN_0051413a(&local_18,&local_2c,&local_34,&param_19,&param_20,&local_30,&local_28,
                         &local_24,&param_18,&param_22,&local_20,&param_21,param_5,param_6,param_14,
                         param_15,param_16);
            piVar10 = local_18;
          }
          fVar3 = param_21;
          fVar6 = -((((local_34 * param_18[0xc] + param_18[0xd]) * local_34 + param_18[0xe]) *
                     local_34 + param_18[0xf]) * param_20);
          if (*piVar10 == 1) {
            fVar1 = (float)piVar10[3];
          }
          else {
            fVar1 = _DAT_006e97d8 / (((float)piVar10[0x11] - local_30) * (float)piVar10[0x14]);
          }
          fVar1 = -(((param_19 * param_18[3] + param_18[1]) * fVar6 +
                    (local_34 * param_18[10] + param_18[0xb]) * local_34 + param_18[8] +
                    ((local_34 * param_18[0x10] + param_18[0x11]) * local_34 + param_18[0xe]) *
                    param_19) * fVar1);
          *param_7 = local_28 * fVar1 - fVar6 * local_24;
          fVar6 = fVar1 * local_24 + fVar6 * local_28;
          *param_8 = fVar6;
          fVar6 = fVar6 * fVar6 + *param_7 * *param_7 + _DAT_006e97d8;
          fVar1 = fVar6 * _DAT_006ea44c;
          param_15 = (float)(0xbe7ffffdU - (int)fVar6 >> 1);
          param_15 = (_DAT_006ea494 - param_15 * param_15 * fVar1) * param_15;
          param_15 = (_DAT_006ea494 - fVar1 * param_15 * param_15) * param_15;
          param_15 = (_DAT_006ea494 - fVar1 * param_15 * param_15) * param_15;
          param_15 = (_DAT_006ea494 - fVar1 * param_15 * param_15) * param_15;
          param_14 = local_34 * (float)piVar10[2] + (float)piVar10[1];
          FUN_00513eaa(piVar10,*local_20,param_14,local_30,local_34,param_6,&param_14);
          *param_7 = param_15 * *param_7;
          *param_8 = param_15 * *param_8;
          *param_9 = param_15;
          *param_12 = (float)*local_20;
          *param_13 = (float)local_20[1];
          *param_10 = local_28;
          *param_11 = local_24;
          fVar12 = (float10)FUN_0051700a(param_14);
          *param_1 = (float)fVar12;
          *param_2 = local_30;
          return ((int)fVar3 << 8 | param_22) << 0x10 | local_2c | 0x8000;
        }
        local_1c = ABS(local_30);
        local_14 = local_30;
        if (local_1c < param_19) {
          param_19 = local_1c;
          param_20 = (float)local_2c;
        }
      }
      local_2c = local_2c + (int)param_18;
      if ((int)local_2c < 0) {
        local_2c = local_2c + DAT_00bad920;
      }
      if (DAT_00bad920 <= (int)local_2c) {
        local_2c = local_2c - DAT_00bad920;
      }
    } while (local_2c != param_17);
  }
  piVar10 = (int *)((int)param_20 * 0x1550 + DAT_00bcf734);
  fVar11 = (float10)param_14 - (float10)(float)piVar10[0xc];
  fVar12 = (float10)param_15 - (float10)(float)piVar10[0xd];
  if (*piVar10 == 1) {
    local_28 = (float)piVar10[0x11];
    fVar14 = fVar11 * (float10)(float)piVar10[0xe] + fVar12 * (float10)(float)piVar10[0xf];
    fVar15 = fVar11 * (float10)(float)piVar10[0x10] + fVar12 * (float10)(float)piVar10[0x11];
    fVar11 = -(float10)(float)piVar10[0x10];
  }
  else {
    fVar15 = fVar11 * fVar11 + fVar12 * fVar12;
    fVar3 = (float)(0xbe7ffffdU - (int)(float)fVar15 >> 1);
    fVar14 = (float10)_DAT_006ea44c * fVar15;
    fVar13 = ((float10)_DAT_006ea494 - (float10)fVar3 * (float10)fVar3 * fVar14) * (float10)fVar3;
    fVar13 = ((float10)_DAT_006ea494 - fVar13 * fVar13 * fVar14) * fVar13;
    fVar13 = ((float10)_DAT_006ea494 - fVar13 * fVar13 * fVar14) * fVar13;
    fVar13 = ((float10)_DAT_006ea494 - fVar13 * fVar13 * fVar14) * fVar13;
    fVar14 = (float10)fpatan(fVar12 * (float10)(float)piVar10[0xe] -
                             fVar11 * (float10)(float)piVar10[0xf],
                             fVar11 * (float10)(float)piVar10[0xe] +
                             fVar12 * (float10)(float)piVar10[0xf]);
    fVar14 = fVar14 * (float10)(float)piVar10[0x12];
    fVar15 = ((float10)(float)piVar10[0x10] - fVar15 * fVar13) * (float10)(float)piVar10[4];
    fVar3 = (float)(fVar13 * (float10)(float)piVar10[4]);
    local_28 = (float)-(fVar12 * (float10)fVar3);
    fVar11 = fVar11 * (float10)fVar3;
  }
  local_30 = (float)fVar15;
  local_34 = (float)fVar14;
  local_24 = (float)fVar11;
  if (_DAT_006ea454 <= local_34) {
    if ((float)piVar10[5] < local_34) {
      local_34 = (float)piVar10[5];
    }
  }
  else {
    local_34 = 0.0;
  }
  param_21 = fVar6;
  if (piVar10[0x16] <= (int)fVar6) {
    param_21 = (float)piVar10[0x16];
  }
  piVar8 = piVar10 + (int)param_21 * 9 + 0x15e;
  while( true ) {
    if (piVar8[2] == 0) {
      fVar6 = (local_34 * (float)piVar8[4] + (float)piVar8[3]) - local_30;
    }
    else {
      fVar6 = (param_14 - (float)piVar8[5]) * (float)piVar8[8] -
              (param_15 - (float)piVar8[6]) * (float)piVar8[7];
    }
    if (_DAT_006ea454 <= fVar6) break;
    param_21 = (float)((int)param_21 + 1);
    piVar8 = piVar8 + 9;
  }
  do {
    piVar9 = piVar8;
    param_21 = (float)((int)param_21 + -1);
    piVar8 = piVar9 + -9;
    if (piVar9[-7] == 0) {
      fVar6 = (local_34 * (float)piVar9[-5] + (float)piVar9[-6]) - local_30;
    }
    else {
      fVar6 = (param_14 - (float)piVar9[-4]) * (float)piVar9[-1] -
              (param_15 - (float)piVar9[-3]) * (float)piVar9[-2];
    }
  } while (_DAT_006ea454 <= fVar6);
  uVar7 = param_22;
  if (piVar10[0x15] <= (int)param_22) {
    uVar7 = piVar10[0x15];
  }
  pfVar4 = (float *)(piVar10 + uVar7 * 0x12 + 0x1a);
  fVar6 = local_34 * (float)piVar10[uVar7 * 0x12 + 0x1b] + *pfVar4;
  while (fVar6 < local_30) {
    pfVar5 = pfVar4 + 0x13;
    pfVar4 = pfVar4 + 0x12;
    uVar7 = uVar7 + 1;
    fVar6 = local_34 * *pfVar5 + *pfVar4;
  }
  pfVar5 = pfVar4 + -0x12;
  fVar6 = local_34 * pfVar4[-0x11] + *pfVar5;
  while (uVar7 = uVar7 - 1, local_30 < fVar6) {
    pfVar4 = pfVar5 + -0x11;
    pfVar5 = pfVar5 + -0x12;
    fVar6 = local_34 * *pfVar4 + *pfVar5;
  }
  fVar3 = _DAT_006e97d8 / (local_34 * pfVar5[3] + pfVar5[2]);
  param_19 = (local_30 - (local_34 * pfVar5[1] + *pfVar5)) * fVar3;
  *param_3 = param_14;
  *param_4 = param_15;
  fVar6 = (((local_34 * pfVar5[0xc] + pfVar5[0xd]) * local_34 + pfVar5[0xe]) * local_34 +
          pfVar5[0xf]) * param_19 +
          ((local_34 * pfVar5[6] + pfVar5[7]) * local_34 + pfVar5[8]) * local_34 + pfVar5[9];
  *param_5 = fVar6;
  *param_6 = fVar6;
  fVar6 = -((((local_34 * pfVar5[0xc] + pfVar5[0xd]) * local_34 + pfVar5[0xe]) * local_34 +
            pfVar5[0xf]) * fVar3);
  if (*piVar10 == 1) {
    fVar3 = (float)piVar10[3];
  }
  else {
    fVar3 = _DAT_006e97d8 / (((float)piVar10[0x11] - local_30) * (float)piVar10[0x14]);
  }
  fVar3 = -(((param_19 * pfVar5[3] + pfVar5[1]) * fVar6 +
            (local_34 * pfVar5[10] + pfVar5[0xb]) * local_34 + pfVar5[8] +
            ((local_34 * pfVar5[0x10] + pfVar5[0x11]) * local_34 + pfVar5[0xe]) * param_19) * fVar3)
  ;
  *param_7 = local_28 * fVar3 - fVar6 * local_24;
  fVar6 = fVar3 * local_24 + fVar6 * local_28;
  *param_8 = fVar6;
  fVar6 = *param_7 * *param_7 + fVar6 * fVar6 + _DAT_006e97d8;
  fVar3 = fVar6 * _DAT_006ea44c;
  param_15 = (float)(0xbe7ffffdU - (int)fVar6 >> 1);
  param_15 = (_DAT_006ea494 - param_15 * param_15 * fVar3) * param_15;
  param_15 = (_DAT_006ea494 - fVar3 * param_15 * param_15) * param_15;
  param_15 = (_DAT_006ea494 - fVar3 * param_15 * param_15) * param_15;
  param_15 = (_DAT_006ea494 - fVar3 * param_15 * param_15) * param_15;
  param_14 = local_34 * (float)piVar10[2] + (float)piVar10[1];
  FUN_00513eaa(piVar10,*piVar8,param_14,local_30,local_34,param_6,&param_14);
  *param_7 = param_15 * *param_7;
  *param_8 = param_15 * *param_8;
  *param_9 = param_15;
  *param_12 = (float)*piVar8;
  *param_13 = (float)piVar9[-8];
  *param_10 = local_28;
  *param_11 = local_24;
  fVar12 = (float10)FUN_0051700a(param_14);
  *param_1 = (float)fVar12;
  *param_2 = local_30;
  return ((int)param_21 << 8 | uVar7) << 0x10 | (uint)param_20;
}


