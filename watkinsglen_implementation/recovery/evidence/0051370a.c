/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051370a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_0051370a(float *param_1,float *param_2,float *param_3,float *param_4,float *param_5,
                 float *param_6,float *param_7,float *param_8,float *param_9,float *param_10,
                 float *param_11,float *param_12,float *param_13,float param_14,float param_15,
                 undefined4 param_16,uint param_17)

{
  float fVar1;
  float *pfVar2;
  char cVar3;
  float fVar4;
  float fVar5;
  int *piVar6;
  uint uVar7;
  float10 fVar8;
  float10 fVar9;
  float10 fVar10;
  float10 fVar11;
  float10 fVar12;
  undefined4 uVar13;
  float local_38;
  float local_34;
  uint local_30;
  float local_2c;
  float local_28;
  uint local_24;
  int *local_20;
  float local_1c;
  int *local_18;
  float *local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;

  local_30 = param_17 >> 0x18;
  local_24 = param_17 & 0x7fff;
  param_17 = param_17 >> 0x10 & 0xff;
  if (DAT_00bad920 <= (int)local_24) {
    local_24 = 0;
    param_17 = 0;
    local_30 = 0;
  }
  local_20 = (int *)(local_24 * 0x1550 + DAT_00bcf734);
  fVar8 = (float10)param_14 - (float10)(float)local_20[0xc];
  fVar9 = (float10)param_15 - (float10)(float)local_20[0xd];
  if (*local_20 == 1) {
    fVar11 = fVar8 * (float10)(float)local_20[0xe] + fVar9 * (float10)(float)local_20[0xf];
    fVar12 = fVar8 * (float10)(float)local_20[0x10] + fVar9 * (float10)(float)local_20[0x11];
    local_28 = (float)local_20[0x11];
    fVar8 = -(float10)(float)local_20[0x10];
  }
  else {
    fVar12 = fVar8 * fVar8 + fVar9 * fVar9;
    fVar5 = (float)(0xbe7ffffdU - (int)(float)fVar12 >> 1);
    fVar11 = (float10)_DAT_006ea44c * fVar12;
    fVar10 = ((float10)_DAT_006ea494 - (float10)fVar5 * (float10)fVar5 * fVar11) * (float10)fVar5;
    fVar10 = ((float10)_DAT_006ea494 - fVar10 * fVar10 * fVar11) * fVar10;
    fVar10 = ((float10)_DAT_006ea494 - fVar10 * fVar10 * fVar11) * fVar10;
    fVar10 = ((float10)_DAT_006ea494 - fVar10 * fVar10 * fVar11) * fVar10;
    fVar11 = (float10)fpatan(fVar9 * (float10)(float)local_20[0xe] -
                             fVar8 * (float10)(float)local_20[0xf],
                             fVar8 * (float10)(float)local_20[0xe] +
                             fVar9 * (float10)(float)local_20[0xf]);
    fVar11 = fVar11 * (float10)(float)local_20[0x12];
    fVar12 = ((float10)(float)local_20[0x10] - fVar12 * fVar10) * (float10)(float)local_20[4];
    local_c = (float)(fVar10 * (float10)(float)local_20[4]);
    local_28 = (float)-(fVar9 * (float10)local_c);
    fVar8 = fVar8 * (float10)local_c;
  }
  local_34 = (float)fVar12;
  local_38 = (float)fVar11;
  local_2c = (float)fVar8;
  if (local_38 < _DAT_006ea454) {
    fVar5 = ABS(local_34) - local_38 * (float)local_20[2];
    uVar13 = 0xffffffff;
  }
  else {
    if (local_38 < (float)local_20[5] != (local_38 == (float)local_20[5])) {
      local_8 = local_38;
      local_4 = local_34;
      uVar7 = local_20[0x16];
      if ((int)local_30 < local_20[0x16]) {
        uVar7 = local_30;
      }
      piVar6 = local_20 + uVar7 * 9 + 0x15e;
      local_30 = uVar7;
      while( true ) {
        if (piVar6[2] == 0) {
          fVar5 = (local_38 * (float)piVar6[4] + (float)piVar6[3]) - local_34;
        }
        else {
          fVar5 = (param_14 - (float)piVar6[5]) * (float)piVar6[8] -
                  (param_15 - (float)piVar6[6]) * (float)piVar6[7];
        }
        if (_DAT_006ea454 <= fVar5) break;
        local_30 = local_30 + 1;
        piVar6 = piVar6 + 9;
      }
      local_30 = local_30 - 1;
      cVar3 = FUN_005195d0(local_38,local_34,param_14,param_15);
      fVar1 = local_4;
      fVar5 = local_8;
      while (piVar6 = piVar6 + -9, cVar3 != '\0') {
        local_30 = local_30 - 1;
        cVar3 = FUN_005195d0(fVar5,fVar1,param_14,param_15);
      }
      local_18 = piVar6;
      if ((0 < (int)local_30) && ((int)local_30 < local_20[0x16])) {
        uVar7 = local_20[0x15];
        if ((int)param_17 < local_20[0x15]) {
          uVar7 = param_17;
        }
        fVar5 = local_38 * (float)local_20[uVar7 * 0x12 + 0x1b] +
                (float)local_20[uVar7 * 0x12 + 0x1a];
        pfVar2 = (float *)(local_20 + uVar7 * 0x12 + 0x1a);
        while (fVar5 < local_34) {
          uVar7 = uVar7 + 1;
          fVar5 = local_38 * pfVar2[0x13] + pfVar2[0x12];
          pfVar2 = pfVar2 + 0x12;
        }
        fVar5 = local_38 * pfVar2[-0x11] + pfVar2[-0x12];
        local_14 = pfVar2 + -0x12;
        param_17 = uVar7;
        while (param_17 = param_17 - 1, local_34 < fVar5) {
          fVar5 = local_38 * local_14[-0x11] + local_14[-0x12];
          local_14 = local_14 + -0x12;
        }
        local_10 = _DAT_006e97d8 / (local_38 * local_14[3] + local_14[2]);
        local_1c = (local_34 - (local_38 * local_14[1] + *local_14)) * local_10;
        *param_3 = param_14;
        *param_4 = param_15;
        fVar5 = ((local_38 * local_14[6] + local_14[7]) * local_38 + local_14[8]) * local_38 +
                local_14[9] +
                (((local_38 * local_14[0xc] + local_14[0xd]) * local_38 + local_14[0xe]) * local_38
                + local_14[0xf]) * local_1c;
        *param_5 = fVar5;
        *param_6 = fVar5;
        if (local_20[7] != 0) {
          FUN_0051413a(&local_20,&local_24,&local_38,&local_1c,&local_10,&local_34,&local_28,
                       &local_2c,&local_14,&param_17,&local_18,&local_30,param_5,param_6,param_14,
                       param_15,param_16);
        }
        fVar5 = -((((local_38 * local_14[0xc] + local_14[0xd]) * local_38 + local_14[0xe]) *
                   local_38 + local_14[0xf]) * local_10);
        if (*local_20 == 1) {
          fVar1 = (float)local_20[3];
        }
        else {
          fVar1 = _DAT_006e97d8 / (((float)local_20[0x11] - local_34) * (float)local_20[0x14]);
        }
        local_c = -(((local_1c * local_14[3] + local_14[1]) * fVar5 +
                    (local_38 * local_14[10] + local_14[0xb]) * local_38 + local_14[8] +
                    ((local_38 * local_14[0x10] + local_14[0x11]) * local_38 + local_14[0xe]) *
                    local_1c) * fVar1);
        *param_7 = local_c * local_28 - fVar5 * local_2c;
        fVar5 = local_c * local_2c + fVar5 * local_28;
        *param_8 = fVar5;
        fVar5 = fVar5 * fVar5 + *param_7 * *param_7 + _DAT_006e97d8;
        fVar1 = fVar5 * _DAT_006ea44c;
        fVar4 = (float)(0xbe7ffffdU - (int)fVar5 >> 1);
        fVar4 = (_DAT_006ea494 - fVar4 * fVar4 * fVar1) * fVar4;
        fVar4 = (_DAT_006ea494 - fVar1 * fVar4 * fVar4) * fVar4;
        fVar4 = (_DAT_006ea494 - fVar1 * fVar4 * fVar4) * fVar4;
        fVar4 = (_DAT_006ea494 - fVar1 * fVar4 * fVar4) * fVar4;
        fVar5 = local_38 * (float)local_20[2] + (float)local_20[1];
        FUN_00513eaa(local_20,*local_18,fVar5,local_34,local_38,param_6,&local_c);
        *param_7 = fVar4 * *param_7;
        *param_8 = fVar4 * *param_8;
        *param_9 = fVar4;
        *param_12 = (float)*local_18;
        *param_13 = (float)local_18[1];
        *param_10 = local_28;
        *param_11 = local_2c;
        fVar9 = (float10)FUN_0051700a(fVar5);
        *param_1 = (float)fVar9;
        *param_2 = local_34;
        return (local_30 << 8 | param_17) << 0x10 | local_24 | 0x8000;
      }
      fVar5 = ABS(local_34);
      uVar13 = 1;
      goto LAB_00513e28;
    }
    fVar5 = (local_38 - _DAT_006e97d8) * (float)local_20[2] + ABS(local_34);
    uVar13 = 1;
  }
  local_8 = ABS(local_34);
  local_4 = local_34;
LAB_00513e28:
  uVar7 = FUN_005144fa(param_1,param_2,param_3,param_4,param_5,param_6,param_7,param_8,param_9,
                       param_10,param_11,param_12,param_13,param_14,param_15,param_16,local_24,
                       uVar13,fVar5,local_24,local_30,param_17);
  return uVar7;
}
