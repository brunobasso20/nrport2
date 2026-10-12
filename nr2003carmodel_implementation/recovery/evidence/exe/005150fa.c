/* NR2003.exe @ 005150fa FUN_005150fa */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_005150fa(float *param_1,float *param_2,float *param_3,float *param_4,float *param_5,
                 float *param_6,float *param_7,float *param_8,float *param_9,float *param_10,
                 float *param_11,float param_12,float param_13,float param_14)

{
  float fVar1;
  float10 fVar2;
  float fVar3;
  char cVar4;
  uint uVar5;
  float *pfVar6;
  float *pfVar7;
  float fVar8;
  int *piVar9;
  int *piVar10;
  float10 fVar11;
  uint local_14;
  float local_10;
  uint local_c;
  
  local_c = (uint)param_14 >> 0x10 & 0xff;
  uVar5 = (uint)param_14 >> 0x18;
  local_14 = (uint)param_14 & 0x7fff;
  if (DAT_00bad918 < param_12) {
    do {
      param_12 = param_12 - DAT_00bad918;
    } while (DAT_00bad918 < param_12);
  }
  if (param_12 < _DAT_006ea454 != (NAN(param_12) || NAN(_DAT_006ea454))) {
    do {
      param_12 = param_12 + DAT_00bad918;
    } while (param_12 < _DAT_006ea454 != (NAN(param_12) || NAN(_DAT_006ea454)));
  }
  if (DAT_00bad920 <= (int)local_14) {
    local_14 = 0;
    local_c = 0;
    uVar5 = 0;
  }
  piVar9 = (int *)(local_14 * 0x1550 + DAT_00bcf734);
  if (param_12 < (float)piVar9[1] != (NAN(param_12) || NAN((float)piVar9[1]))) {
    do {
      if ((int)local_14 < 1) break;
      pfVar6 = (float *)(piVar9 + -0x553);
      piVar9 = piVar9 + -0x554;
      local_14 = local_14 - 1;
    } while (param_12 < *pfVar6 != (NAN(param_12) || NAN(*pfVar6)));
  }
  for (; ((int)local_14 < DAT_00bad920 + -1 && ((float)piVar9[0x555] <= param_12));
      piVar9 = piVar9 + 0x554) {
    local_14 = local_14 + 1;
  }
  param_14 = param_12 - (float)piVar9[1];
  if (*piVar9 == 1) {
    param_12 = (float)piVar9[0x11];
    local_10 = -(float)piVar9[0x10];
    *param_1 = param_12 * param_14 + param_13 * (float)piVar9[0x10] + (float)piVar9[0xc];
    *param_2 = local_10 * param_14 + param_13 * (float)piVar9[0x11] + (float)piVar9[0xd];
    param_14 = param_14 * (float)piVar9[3];
  }
  else {
    param_14 = param_14 * (float)piVar9[3];
    fVar11 = (float10)(param_14 * (float)piVar9[0x14] + (float)piVar9[0x13]);
    fVar2 = (float10)fcos(fVar11);
    fVar11 = (float10)fsin(fVar11);
    param_12 = (float)fVar2;
    local_10 = (float)fVar11;
    fVar8 = (float)piVar9[0x11];
    *param_1 = local_10 * (fVar8 - param_13) + (float)piVar9[0xc];
    *param_2 = (float)piVar9[0xd] - param_12 * (fVar8 - param_13);
  }
  fVar8 = *param_1;
  fVar1 = *param_2;
  if (piVar9[0x16] <= (int)uVar5) {
    uVar5 = piVar9[0x16];
  }
  piVar10 = piVar9 + uVar5 * 9 + 0x15e;
  while( true ) {
    if (piVar10[2] == 0) {
      fVar3 = (param_14 * (float)piVar10[4] + (float)piVar10[3]) - param_13;
    }
    else {
      fVar3 = (fVar8 - (float)piVar10[5]) * (float)piVar10[8] -
              (fVar1 - (float)piVar10[6]) * (float)piVar10[7];
    }
    if (_DAT_006ea454 <= fVar3) break;
    uVar5 = uVar5 + 1;
    piVar10 = piVar10 + 9;
  }
  cVar4 = FUN_005195d0(param_14,param_13,fVar8,fVar1);
  while( true ) {
    uVar5 = uVar5 - 1;
    piVar10 = piVar10 + -9;
    if (cVar4 == '\0') break;
    cVar4 = FUN_005195d0(param_14,param_13,fVar8,fVar1);
  }
  if (piVar9[0x15] <= (int)local_c) {
    local_c = piVar9[0x15];
  }
  pfVar6 = (float *)(piVar9 + local_c * 0x12 + 0x1a);
  fVar8 = param_14 * (float)piVar9[local_c * 0x12 + 0x1b] + *pfVar6;
  if (fVar8 < param_13 != (NAN(fVar8) || NAN(param_13))) {
    do {
      pfVar7 = pfVar6 + 0x13;
      pfVar6 = pfVar6 + 0x12;
      local_c = local_c + 1;
      fVar8 = param_14 * *pfVar7 + *pfVar6;
    } while (fVar8 < param_13 != (NAN(fVar8) || NAN(param_13)));
  }
  pfVar7 = pfVar6 + -0x12;
  fVar8 = param_14 * pfVar6[-0x11] + *pfVar7;
  while (local_c = local_c - 1, param_13 < fVar8) {
    pfVar6 = pfVar7 + -0x11;
    pfVar7 = pfVar7 + -0x12;
    fVar8 = param_14 * *pfVar6 + *pfVar7;
  }
  fVar1 = _DAT_006e97d8 / (param_14 * pfVar7[3] + pfVar7[2]);
  fVar3 = (param_13 - (param_14 * pfVar7[1] + *pfVar7)) * fVar1;
  fVar8 = (((param_14 * pfVar7[0xc] + pfVar7[0xd]) * param_14 + pfVar7[0xe]) * param_14 +
          pfVar7[0xf]) * fVar3 +
          ((param_14 * pfVar7[6] + pfVar7[7]) * param_14 + pfVar7[8]) * param_14 + pfVar7[9];
  *param_3 = fVar8;
  *param_4 = fVar8;
  fVar8 = -((((param_14 * pfVar7[0xc] + pfVar7[0xd]) * param_14 + pfVar7[0xe]) * param_14 +
            pfVar7[0xf]) * fVar1);
  if (*piVar9 == 1) {
    fVar1 = (float)piVar9[3];
  }
  else {
    fVar1 = _DAT_006e97d8 / (((float)piVar9[0x11] - param_13) * (float)piVar9[0x14]);
  }
  fVar1 = -(((fVar3 * pfVar7[3] + pfVar7[1]) * fVar8 +
            (param_14 * pfVar7[10] + pfVar7[0xb]) * param_14 + pfVar7[8] +
            ((param_14 * pfVar7[0x10] + pfVar7[0x11]) * param_14 + pfVar7[0xe]) * fVar3) * fVar1);
  *param_5 = param_12 * fVar1 - fVar8 * local_10;
  fVar8 = fVar8 * param_12 + fVar1 * local_10;
  *param_6 = fVar8;
  fVar8 = fVar8 * fVar8 + *param_5 * *param_5 + _DAT_006e97d8;
  fVar1 = fVar8 * _DAT_006ea44c;
  fVar8 = (float)(0xbe7ffffdU - (int)fVar8 >> 1);
  fVar8 = (_DAT_006ea494 - fVar8 * fVar8 * fVar1) * fVar8;
  fVar8 = (_DAT_006ea494 - fVar1 * fVar8 * fVar8) * fVar8;
  fVar8 = (_DAT_006ea494 - fVar1 * fVar8 * fVar8) * fVar8;
  fVar8 = (_DAT_006ea494 - fVar1 * fVar8 * fVar8) * fVar8;
  FUN_00513eaa(piVar9,*piVar10,param_14 * (float)piVar9[2] + (float)piVar9[1],param_13,param_14,
               param_4,&param_13);
  *param_5 = fVar8 * *param_5;
  *param_6 = fVar8 * *param_6;
  *param_7 = fVar8;
  *param_10 = (float)*piVar10;
  *param_11 = (float)piVar10[1];
  *param_8 = param_12;
  *param_9 = local_10;
  return (uVar5 * 0x100 | local_c) << 0x10 | local_14 | 0x8000;
}

