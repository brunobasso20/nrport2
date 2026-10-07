/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051669a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float FUN_0051669a(float *param_1,int param_2,float param_3,float *param_4,int param_5,int param_6,
                  int param_7)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  float fVar15;
  float fVar16;
  float fVar17;
  float fVar18;
  float fVar19;
  float fVar20;
  float fVar21;
  float fVar22;
  float fVar23;
  float fVar24;
  float fVar25;
  float fVar26;
  float fVar27;
  byte bVar28;
  byte bVar29;
  float fVar30;
  float fVar31;
  float fVar32;
  int iVar33;
  int *piVar34;
  float *pfVar35;
  uint uVar36;
  int iVar37;
  int iVar38;
  int iVar39;
  int *piVar40;
  int *piVar41;
  float *pfVar42;
  float *pfVar43;
  float fVar44;
  float *local_58;
  int local_54;
  float *local_50;
  
  piVar40 = DAT_00bcf734 + ((uint)param_1[0x15] & 0x7fff) * 0x554;
  fVar30 = param_1[0xf] - (float)piVar40[1];
  if (fVar30 < _DAT_006ea4a8) {
    fVar30 = fVar30 + DAT_00bad918;
  }
  fVar1 = (float)piVar40[3];
  fVar31 = _DAT_006e97d8;
  if ((*piVar40 == 2) &&
     (fVar31 = _DAT_006ea478, _DAT_006ea4cc < ABS((float)piVar40[0x11] - param_1[0x10]))) {
    fVar31 = (float)piVar40[0x10] / ABS((float)piVar40[0x11] - param_1[0x10]);
  }
  fVar2 = param_1[0x19];
  fVar3 = param_1[0xe];
  fVar4 = param_1[0xd];
  fVar5 = param_1[0x16];
  bVar28 = *(byte *)((int)param_1 + 0x56);
  bVar29 = *(byte *)((int)param_1 + 0x57);
  fVar6 = param_1[0xd];
  fVar7 = param_1[0x17];
  fVar8 = param_1[0x1a];
  fVar9 = param_1[0xe];
  local_54 = 0;
  fVar10 = param_1[0x1b];
  fVar11 = param_1[0xe];
  fVar12 = param_1[0x18];
  fVar13 = param_1[0xd];
  fVar14 = param_1[0x19];
  fVar15 = param_1[0xd];
  fVar16 = param_1[0x16];
  fVar17 = param_1[0xe];
  fVar18 = param_1[0xd];
  fVar19 = param_1[0x1a];
  fVar20 = param_1[0x17];
  fVar21 = param_1[0xe];
  fVar22 = param_1[0x1b];
  fVar23 = param_1[0xd];
  fVar24 = param_1[0x18];
  fVar25 = param_1[0xe];
  fVar31 = fVar31 * (float)piVar40[3];
  if (0 < param_2) {
    local_50 = (float *)(param_5 + 8);
    iVar37 = (int)param_4 - (int)param_3;
    local_58 = param_4;
    iVar38 = param_5 - (int)param_3;
    pfVar42 = (float *)((int)param_3 + 4);
    iVar39 = param_6 - (int)param_3;
    param_5 = param_6 - param_5;
    iVar33 = param_6 - (int)param_4;
    do {
      pfVar35 = pfVar42 + -1;
      FUN_005f6d20(local_58,param_1 + 0x16,pfVar35);
      param_4 = (float *)((fVar8 * fVar9 + fVar6 * fVar7) * fVar31 * *pfVar42 +
                          (fVar4 * fVar5 + fVar2 * fVar3) * fVar31 * *pfVar35 +
                          fVar31 * (fVar12 * fVar13 + fVar10 * fVar11) * pfVar42[1] + fVar30 * fVar1
                         );
      fVar44 = (fVar18 * fVar19 - fVar20 * fVar21) * *pfVar42 +
               (fVar14 * fVar15 - fVar16 * fVar17) * *pfVar35 +
               (fVar22 * fVar23 - fVar24 * fVar25) * pfVar42[1] + param_1[0x10];
      param_3 = (float)param_4 * (float)piVar40[2] + (float)piVar40[1];
      piVar41 = piVar40;
      if (_DAT_006e97d8 < (float)param_4) {
        if ((float)piVar40[1] + (float)piVar40[2] < param_3) {
          do {
            piVar41 = piVar41 + 0x554;
            if (DAT_00bcf734 + DAT_00bad920 * 0x554 <= piVar41) {
              param_3 = param_3 - DAT_00bad918;
              piVar41 = DAT_00bcf734;
            }
          } while ((float)piVar41[2] + (float)piVar41[1] < param_3);
        }
        param_4 = (float *)((param_3 - (float)piVar41[1]) * (float)piVar41[3]);
      }
      if ((float)param_4 < _DAT_006ea454) {
        param_3 = (float)param_4 * (float)piVar41[2] + (float)piVar41[1];
        if (param_3 < (float)piVar41[1]) {
          do {
            piVar41 = piVar41 + -0x554;
            if (piVar41 < DAT_00bcf734) {
              param_3 = param_3 + DAT_00bad918;
              piVar41 = DAT_00bcf734 + DAT_00bad920 * 0x554 + -0x554;
            }
          } while (param_3 < (float)piVar41[1]);
        }
        param_4 = (float *)((param_3 - (float)piVar41[1]) * (float)piVar41[3]);
      }
      fVar26 = param_1[1];
      fVar27 = param_1[2];
      *local_58 = *param_1 + *local_58;
      local_58[1] = fVar26 + local_58[1];
      local_58[2] = fVar27 + local_58[2];
      fVar26 = *(float *)((int)pfVar42 + iVar37);
      uVar36 = (uint)bVar29;
      if (piVar41[0x16] <= (int)(uint)bVar29) {
        uVar36 = piVar41[0x16];
      }
      piVar34 = piVar41 + uVar36 * 9 + 0x15e;
      while( true ) {
        if (piVar34[2] == 0) {
          fVar27 = ((float)param_4 * (float)piVar34[4] + (float)piVar34[3]) - fVar44;
        }
        else {
          fVar27 = (*local_58 - (float)piVar34[5]) * (float)piVar34[8] -
                   (fVar26 - (float)piVar34[6]) * (float)piVar34[7];
        }
        if (_DAT_006ea454 <= fVar27) break;
        uVar36 = uVar36 + 1;
        piVar34 = piVar34 + 9;
      }
      pfVar35 = (float *)(piVar34 + -4);
      while( true ) {
        uVar36 = uVar36 - 1;
        if (pfVar35[-3] == 0.0) {
          fVar27 = ((float)param_4 * pfVar35[-1] + pfVar35[-2]) - fVar44;
        }
        else {
          fVar27 = (*local_58 - *pfVar35) * pfVar35[3] - (fVar26 - pfVar35[1]) * pfVar35[2];
        }
        if (fVar27 < _DAT_006ea454) break;
        pfVar35 = pfVar35 + -9;
      }
      *(int *)(param_7 + local_54 * 4) = piVar41[uVar36 * 9 + 0x15e];
      uVar36 = piVar41[0x15];
      if ((int)(uint)bVar28 < piVar41[0x15]) {
        uVar36 = (uint)bVar28;
      }
      pfVar35 = (float *)(piVar41 + uVar36 * 0x12 + 0x1a);
      fVar26 = (float)param_4 * (float)piVar41[uVar36 * 0x12 + 0x1b] + *pfVar35;
      while (fVar26 < fVar44) {
        pfVar43 = pfVar35 + 0x13;
        pfVar35 = pfVar35 + 0x12;
        fVar26 = (float)param_4 * *pfVar43 + *pfVar35;
      }
      pfVar43 = pfVar35 + -0x12;
      fVar26 = (float)param_4 * pfVar35[-0x11] + *pfVar43;
      while (fVar44 < fVar26) {
        pfVar35 = pfVar43 + -0x11;
        pfVar43 = pfVar43 + -0x12;
        fVar26 = (float)param_4 * *pfVar35 + *pfVar43;
      }
      fVar32 = _DAT_006e97d8 / ((float)param_4 * pfVar43[3] + pfVar43[2]);
      fVar26 = pfVar43[1];
      fVar27 = *pfVar43;
      local_50[-2] = *local_58;
      *(undefined4 *)((int)pfVar42 + iVar38) = *(undefined4 *)((int)pfVar42 + iVar37);
      fVar26 = (fVar44 - ((float)param_4 * fVar26 + fVar27)) * fVar32;
      *local_50 = ((((float)param_4 * pfVar43[0xc] + pfVar43[0xd]) * (float)param_4 + pfVar43[0xe])
                   * (float)param_4 + pfVar43[0xf]) * fVar26 +
                  (((float)param_4 * pfVar43[6] + pfVar43[7]) * (float)param_4 + pfVar43[8]) *
                  (float)param_4 + pfVar43[9];
      FUN_00513eaa(piVar41,*(undefined4 *)(param_7 + local_54 * 4),param_3,fVar44,param_4,local_50,
                   &param_6);
      if (param_6 != 0) {
        fVar27 = -(((((float)param_4 * pfVar43[0xc] + pfVar43[0xd]) * (float)param_4 + pfVar43[0xe])
                    * (float)param_4 + pfVar43[0xf]) * fVar32);
        if (*piVar41 == 1) {
          fVar44 = (float)piVar41[3];
        }
        else {
          fVar44 = _DAT_006e97d8 / (((float)piVar41[0x11] - fVar44) * (float)piVar41[0x14]);
        }
        fVar44 = -(((fVar26 * pfVar43[3] + pfVar43[1]) * fVar27 +
                   ((float)param_4 * pfVar43[10] + pfVar43[0xb]) * (float)param_4 + pfVar43[8] +
                   (((float)param_4 * pfVar43[0x10] + pfVar43[0x11]) * (float)param_4 + pfVar43[0xe]
                   ) * fVar26) * fVar44);
        *(float *)((int)local_58 + iVar33) = fVar44 * param_1[0xd] - fVar27 * param_1[0xe];
        fVar44 = fVar27 * param_1[0xd] + fVar44 * param_1[0xe];
        *(float *)((int)pfVar42 + iVar39) = fVar44;
        fVar44 = *(float *)((int)local_58 + iVar33) * *(float *)((int)local_58 + iVar33) +
                 fVar44 * fVar44 + _DAT_006e97d8;
        fVar26 = fVar44 * _DAT_006ea44c;
        fVar44 = (float)(0xbe7ffffdU - (int)fVar44 >> 1);
        fVar44 = (_DAT_006ea494 - fVar44 * fVar44 * fVar26) * fVar44;
        fVar44 = (_DAT_006ea494 - fVar26 * fVar44 * fVar44) * fVar44;
        fVar44 = (_DAT_006ea494 - fVar26 * fVar44 * fVar44) * fVar44;
        fVar44 = (_DAT_006ea494 - fVar26 * fVar44 * fVar44) * fVar44;
        *(float *)((int)local_58 + iVar33) = fVar44 * *(float *)((int)local_58 + iVar33);
        *(float *)((int)pfVar42 + iVar39) = fVar44 * *(float *)((int)pfVar42 + iVar39);
        *(float *)((int)local_50 + param_5) = fVar44;
      }
      local_58 = local_58 + 3;
      local_54 = local_54 + 1;
      pfVar42 = pfVar42 + 3;
      local_50 = local_50 + 3;
    } while (local_54 < param_2);
  }
  return param_1[0x15];
}


