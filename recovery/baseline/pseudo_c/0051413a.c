/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051413a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051413a(int *param_1,int *param_2,float *param_3,float *param_4,float *param_5,
                 float *param_6,float *param_7,float *param_8,undefined4 *param_9,int *param_10,
                 undefined4 *param_11,int *param_12,float *param_13,float *param_14,float param_15,
                 float param_16,float param_17)

{
  int *piVar1;
  int iVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float *pfVar6;
  float *pfVar7;
  int *piVar8;
  int iVar9;
  int *piVar10;
  int *piVar11;
  int iVar12;
  float10 fVar13;
  float10 fVar14;
  float10 fVar15;
  float10 fVar16;
  float10 fVar17;
  float local_20;
  float local_1c;
  float local_8;
  
  piVar1 = *(int **)(*param_1 + 0x1c);
  do {
    if (piVar1 == (int *)0x0) {
      return;
    }
    iVar2 = *piVar1;
    piVar8 = (int *)(iVar2 * 0x1550 + DAT_00bcf734);
    fVar13 = (float10)param_15 - (float10)(float)piVar8[0xc];
    fVar14 = (float10)param_16 - (float10)(float)piVar8[0xd];
    if (*piVar8 == 1) {
      local_8 = (float)piVar8[0x11];
      fVar16 = fVar13 * (float10)(float)piVar8[0xe] + fVar14 * (float10)(float)piVar8[0xf];
      fVar17 = fVar13 * (float10)(float)piVar8[0x10] + fVar14 * (float10)(float)piVar8[0x11];
      fVar13 = -(float10)(float)piVar8[0x10];
    }
    else {
      fVar17 = fVar13 * fVar13 + fVar14 * fVar14;
      fVar5 = (float)(0xbe7ffffdU - (int)(float)fVar17 >> 1);
      fVar16 = (float10)_DAT_006ea44c * fVar17;
      fVar15 = ((float10)_DAT_006ea494 - (float10)fVar5 * (float10)fVar5 * fVar16) * (float10)fVar5;
      fVar15 = ((float10)_DAT_006ea494 - fVar15 * fVar15 * fVar16) * fVar15;
      fVar15 = ((float10)_DAT_006ea494 - fVar15 * fVar15 * fVar16) * fVar15;
      fVar15 = ((float10)_DAT_006ea494 - fVar15 * fVar15 * fVar16) * fVar15;
      fVar16 = (float10)fpatan(fVar14 * (float10)(float)piVar8[0xe] -
                               fVar13 * (float10)(float)piVar8[0xf],
                               fVar13 * (float10)(float)piVar8[0xe] +
                               fVar14 * (float10)(float)piVar8[0xf]);
      fVar16 = fVar16 * (float10)(float)piVar8[0x12];
      fVar17 = ((float10)(float)piVar8[0x10] - fVar17 * fVar15) * (float10)(float)piVar8[4];
      fVar5 = (float)(fVar15 * (float10)(float)piVar8[4]);
      local_8 = (float)-(fVar14 * (float10)fVar5);
      fVar13 = fVar13 * (float10)fVar5;
    }
    local_1c = (float)fVar17;
    local_20 = (float)fVar16;
    if ((_DAT_006ea454 <= local_20) &&
       (local_20 < (float)piVar8[5] != (local_20 == (float)piVar8[5]))) {
      iVar12 = piVar8[0x16];
      iVar9 = *param_12;
      if (iVar12 <= *param_12) {
        iVar9 = iVar12;
      }
      piVar10 = piVar8 + iVar9 * 9 + 0x15e;
      while( true ) {
        if (piVar10[2] == 0) {
          fVar5 = (local_20 * (float)piVar10[4] + (float)piVar10[3]) - local_1c;
        }
        else {
          fVar5 = (param_15 - (float)piVar10[5]) * (float)piVar10[8] -
                  (param_16 - (float)piVar10[6]) * (float)piVar10[7];
        }
        if (_DAT_006ea454 <= fVar5) break;
        iVar9 = iVar9 + 1;
        piVar10 = piVar10 + 9;
      }
      do {
        piVar11 = piVar10 + -9;
        iVar9 = iVar9 + -1;
        if (piVar10[-7] == 0) {
          fVar5 = (local_20 * (float)piVar10[-5] + (float)piVar10[-6]) - local_1c;
        }
        else {
          fVar5 = (param_15 - (float)piVar10[-4]) * (float)piVar10[-1] -
                  (param_16 - (float)piVar10[-3]) * (float)piVar10[-2];
        }
        piVar10 = piVar11;
      } while (_DAT_006ea454 <= fVar5);
      if ((0 < iVar9) && (iVar9 < iVar12)) {
        iVar12 = piVar8[0x15];
        if (*param_10 < piVar8[0x15]) {
          iVar12 = *param_10;
        }
        pfVar6 = (float *)(piVar8 + iVar12 * 0x12 + 0x1a);
        fVar5 = local_20 * (float)piVar8[iVar12 * 0x12 + 0x1b] + *pfVar6;
        while (fVar5 < local_1c) {
          pfVar7 = pfVar6 + 0x13;
          pfVar6 = pfVar6 + 0x12;
          iVar12 = iVar12 + 1;
          fVar5 = local_20 * *pfVar7 + *pfVar6;
        }
        pfVar7 = pfVar6 + -0x12;
        fVar5 = local_20 * pfVar6[-0x11] + *pfVar7;
        while (iVar12 = iVar12 + -1, local_1c < fVar5) {
          pfVar6 = pfVar7 + -0x11;
          pfVar7 = pfVar7 + -0x12;
          fVar5 = local_20 * *pfVar6 + *pfVar7;
        }
        fVar4 = _DAT_006e97d8 / (local_20 * pfVar7[3] + pfVar7[2]);
        fVar5 = (local_1c - (local_20 * pfVar7[1] + *pfVar7)) * fVar4;
        fVar3 = ((local_20 * pfVar7[6] + pfVar7[7]) * local_20 + pfVar7[8]) * local_20 + pfVar7[9] +
                (((local_20 * pfVar7[0xc] + pfVar7[0xd]) * local_20 + pfVar7[0xe]) * local_20 +
                pfVar7[0xf]) * fVar5;
        if (*param_13 - _DAT_006e97d8 < param_17 == (*param_13 - _DAT_006e97d8 == param_17)) {
          if (fVar3 < *param_13) goto LAB_0051446c;
        }
        else if ((fVar3 - _DAT_006e97d8 < param_17 != (fVar3 - _DAT_006e97d8 == param_17)) &&
                (*param_13 < fVar3)) {
LAB_0051446c:
          *param_1 = (int)piVar8;
          *param_2 = iVar2;
          *param_3 = local_20;
          *param_4 = fVar5;
          *param_5 = fVar4;
          *param_6 = local_1c;
          *param_7 = local_8;
          *param_8 = (float)fVar13;
          *param_9 = pfVar7;
          *param_10 = iVar12;
          *param_11 = piVar11;
          *param_12 = iVar9;
          *param_13 = fVar3;
          *param_14 = fVar3;
        }
      }
    }
    piVar1 = (int *)piVar1[1];
  } while( true );
}


