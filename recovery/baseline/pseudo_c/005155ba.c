/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005155ba */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_005155ba(int *param_1,int param_2,int param_3,int param_4,int param_5,int param_6,
                 int param_7,int param_8,float *param_9,float param_10,float param_11,float param_12
                 ,uint param_13)

{
  float fVar1;
  uint uVar2;
  float10 fVar3;
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
  int iVar14;
  float fVar15;
  float fVar16;
  float *pfVar17;
  int iVar18;
  undefined4 *puVar19;
  int iVar20;
  int iVar21;
  int iVar22;
  int *piVar23;
  float *pfVar24;
  uint uVar25;
  uint uVar26;
  uint uVar27;
  float *pfVar28;
  float *pfVar29;
  float10 fVar30;
  float local_58;
  int local_50;
  int local_4c;
  uint local_48;
  float local_44;
  float local_40;
  float local_2c;
  float local_18;
  uint local_10;
  uint local_c;
  
  iVar14 = param_6;
  uVar27 = param_13 >> 0x10 & 0xff;
  uVar25 = param_13 & 0x7fff;
  iVar20 = 0;
  local_4c = 0;
  local_50 = 0;
  if (uVar25 == 0xffff) {
    uVar25 = DAT_00bad920 - 1;
  }
  else if (DAT_00bad920 <= (int)uVar25) {
    uVar25 = 0;
  }
  piVar23 = (int *)(uVar25 * 0x1550 + DAT_00bcf734);
  fVar1 = (float)piVar23[1];
  for (; ((float)param_9 < fVar1 && (0 < (int)uVar25)); uVar25 = uVar25 - 1) {
    fVar1 = (float)piVar23[-0x553];
    piVar23 = piVar23 + -0x554;
  }
  for (; ((int)uVar25 < DAT_00bad920 + -1 && ((float)piVar23[0x555] <= (float)param_9));
      piVar23 = piVar23 + 0x554) {
    uVar25 = uVar25 + 1;
  }
  fVar1 = (float)param_9 - (float)piVar23[1];
  if (*piVar23 == 1) {
    local_58 = fVar1 * (float)piVar23[3];
    local_40 = (param_10 + param_11) * (float)piVar23[0x10] * _DAT_006ea44c +
               (float)piVar23[0x11] * fVar1 + (float)piVar23[0xc];
    local_44 = (param_10 + param_11) * (float)piVar23[0x11] * _DAT_006ea44c +
               -(float)piVar23[0x10] * fVar1 + (float)piVar23[0xd];
    fVar1 = _DAT_006e97d8;
  }
  else {
    local_58 = fVar1 * (float)piVar23[3];
    fVar30 = (float10)(local_58 * (float)piVar23[0x14] + (float)piVar23[0x13]);
    fVar3 = (float10)fcos(fVar30);
    fVar30 = (float10)fsin(fVar30);
    fVar4 = (float)piVar23[0x11] - (param_10 + param_11) * _DAT_006ea44c;
    local_40 = (float)fVar30 * fVar4 + (float)piVar23[0xc];
    local_44 = (float)piVar23[0xd] - (float)fVar3 * fVar4;
    fVar1 = _DAT_006ea478;
    if (_DAT_006ea4cc < ABS(fVar4) - param_12) {
      fVar1 = (float)piVar23[0x10] / (ABS(fVar4) - param_12);
    }
  }
  fVar4 = param_11;
  if (param_11 < param_10) {
    fVar4 = param_10;
    param_10 = param_11;
  }
  local_18 = param_10 - param_12;
  fVar4 = fVar4 + param_12;
  uVar2 = piVar23[0x15];
  uVar26 = uVar27;
  if ((int)uVar2 <= (int)uVar27) {
    uVar26 = uVar2;
  }
  pfVar24 = (float *)(piVar23 + uVar26 * 0x12 + 0x1a);
  fVar5 = local_58 * (float)piVar23[uVar26 * 0x12 + 0x1b] + *pfVar24;
  while (fVar5 < local_18) {
    pfVar17 = pfVar24 + 0x13;
    pfVar24 = pfVar24 + 0x12;
    uVar26 = uVar26 + 1;
    fVar5 = local_58 * *pfVar17 + *pfVar24;
  }
  pfVar17 = pfVar24 + -0x12;
  fVar5 = local_58 * pfVar24[-0x11] + *pfVar17;
  while (uVar26 = uVar26 - 1, local_18 < fVar5) {
    pfVar24 = pfVar17 + -0x11;
    pfVar17 = pfVar17 + -0x12;
    fVar5 = local_58 * *pfVar24 + *pfVar17;
  }
  if ((int)uVar2 <= (int)uVar27) {
    uVar27 = uVar2;
  }
  pfVar24 = (float *)(piVar23 + uVar27 * 0x12 + 0x1a);
  fVar5 = local_58 * (float)piVar23[uVar27 * 0x12 + 0x1b] + *pfVar24;
  while (fVar5 < fVar4) {
    pfVar17 = pfVar24 + 0x13;
    pfVar24 = pfVar24 + 0x12;
    uVar27 = uVar27 + 1;
    fVar5 = local_58 * *pfVar17 + *pfVar24;
  }
  pfVar17 = pfVar24 + -0x12;
  fVar5 = local_58 * pfVar24[-0x11] + *pfVar17;
  while (uVar27 = uVar27 - 1, fVar4 < fVar5) {
    pfVar24 = pfVar17 + -0x11;
    pfVar17 = pfVar17 + -0x12;
    fVar5 = local_58 * *pfVar24 + *pfVar17;
  }
  param_11 = -1e+24;
  if ((int)uVar26 <= (int)uVar27) {
    pfVar24 = (float *)(piVar23 + uVar26 * 0x12 + 0x1c);
    param_10 = (float)uVar26;
    do {
      iVar21 = local_4c;
      *(uint *)(param_5 + iVar20 * 4) = uVar25;
      *(float *)(param_6 + iVar20 * 4) = param_10;
      *(undefined4 *)(param_7 + iVar20 * 4) = 0;
      *(undefined4 *)(param_8 + iVar20 * 4) = 0;
      *(undefined4 *)(param_3 + iVar20 * 4) = 1;
      fVar5 = -((_DAT_006e97d8 / (local_58 * pfVar24[1] + *pfVar24)) *
               (((local_58 * pfVar24[10] + pfVar24[0xb]) * local_58 + pfVar24[0xc]) * local_58 +
               pfVar24[0xd]));
      if (fVar5 - param_11 < _DAT_006ea4cc) {
        local_4c = 1;
        *(undefined4 *)(param_7 + iVar20 * 4) = 1;
        *(undefined4 *)(param_3 + iVar20 * 4) = 0;
        *(int *)(param_2 + local_50 * 4) = iVar21 + 1;
        local_50 = local_50 + 1;
        iVar21 = iVar20 + 1;
        *(uint *)(param_5 + iVar21 * 4) = uVar25;
        *(float *)(param_6 + iVar21 * 4) = param_10;
        *(undefined4 *)(param_7 + iVar21 * 4) = 0;
        *(undefined4 *)(param_8 + iVar21 * 4) = 0;
        *(undefined4 *)(param_3 + iVar21 * 4) = 0;
        iVar20 = iVar20 + 2;
        *(uint *)(param_5 + iVar20 * 4) = uVar25;
        *(float *)(param_6 + iVar20 * 4) = param_10;
        *(undefined4 *)(param_7 + iVar20 * 4) = 0;
        *(undefined4 *)(param_8 + iVar20 * 4) = 0;
        *(undefined4 *)(param_3 + iVar20 * 4) = 1;
      }
      pfVar24 = pfVar24 + 0x12;
      local_4c = local_4c + 1;
      param_10 = (float)((int)param_10 + 1);
      iVar20 = iVar20 + 1;
      param_11 = fVar5;
    } while ((int)param_10 <= (int)uVar27);
  }
  fVar5 = (float)param_9 + fVar1 * param_12;
  *(int *)(param_2 + local_50 * 4) = local_4c;
  local_50 = local_50 + 1;
  local_c = uVar25;
  if (DAT_00bad918 <= fVar5) {
    fVar5 = fVar5 - DAT_00bad918;
    local_c = 0;
  }
  if ((int)local_c < DAT_00bad920) {
    do {
      if (fVar5 < *(float *)(local_c * 0x1550 + 4 + DAT_00bcf734)) {
        if ((int)local_c < DAT_00bad920) goto LAB_00515ae8;
        break;
      }
      local_c = local_c + 1;
    } while ((int)local_c < DAT_00bad920);
    local_c = 0;
  }
  else {
    local_c = 0;
  }
LAB_00515ae8:
  fVar1 = (float)param_9 - fVar1 * param_12;
  local_10 = uVar25;
  if (fVar1 < _DAT_006ea454) {
    fVar1 = fVar1 + DAT_00bad918;
    local_10 = DAT_00bad920 - 1;
  }
  if (0 < (int)local_10) {
    param_9 = (float *)(local_10 * 0x1550 + 4 + DAT_00bcf734);
    do {
      if (*param_9 <= fVar1) break;
      local_10 = local_10 - 1;
      param_9 = param_9 + -0x554;
    } while (0 < (int)local_10);
  }
  local_2c = 1.0;
  fVar1 = ABS(fVar4 - local_18) * (float)_DAT_006ea668;
  fVar4 = local_2c;
  uVar27 = local_10;
  do {
    do {
      uVar2 = uVar27;
      param_9 = (float *)fVar4;
      if (uVar2 == local_c) {
        *param_1 = local_50;
        return param_13 & 0xff008000 | uVar26 * 0x10000 | uVar25 | 0x8000;
      }
      local_48 = uVar2 + 1;
      if (DAT_00bad920 <= (int)local_48) {
        local_48 = 0;
      }
      iVar21 = uVar2 * 0x1550 + DAT_00bcf734;
      local_2c = (float)param_9;
      if (uVar2 == uVar25) {
        local_2c = 0.0;
        param_9 = (float *)local_58;
      }
      param_6 = 0;
      fVar4 = local_2c;
      uVar27 = local_48;
    } while (*(int *)(iVar21 + 0x5c) < 1);
    pfVar24 = (float *)(iVar21 + 0x974);
    do {
      fVar4 = (float)param_9 * pfVar24[-2] + pfVar24[-1];
      fVar5 = fVar4 * (float)param_9 + *pfVar24;
      fVar6 = fVar5 * (float)param_9 + pfVar24[1];
      fVar4 = (((float)param_9 * pfVar24[-2] + fVar4) * (float)param_9 + fVar5) * (float)param_9 +
              fVar6;
      fVar15 = (float)param_9 * pfVar24[3] + pfVar24[4];
      fVar5 = fVar15 * (float)param_9 + pfVar24[5];
      fVar7 = fVar5 * (float)param_9 + pfVar24[6];
      fVar5 = (((float)param_9 * pfVar24[3] + fVar15) * (float)param_9 + fVar5) * (float)param_9 +
              fVar7;
      fVar15 = fVar4 * fVar4 + fVar5 * fVar5;
      fVar8 = fVar15 * _DAT_006ea44c;
      fVar15 = (float)(0xbe7ffffdU - (int)fVar15 >> 1);
      fVar15 = (_DAT_006ea494 - fVar15 * fVar15 * fVar8) * fVar15;
      fVar15 = (_DAT_006ea494 - fVar15 * fVar15 * fVar8) * fVar15;
      fVar15 = (_DAT_006ea494 - fVar15 * fVar15 * fVar8) * fVar15;
      fVar9 = (float)param_9 * pfVar24[-0x11] + pfVar24[-0x10];
      fVar16 = fVar9 * (float)param_9 + pfVar24[-0xf];
      fVar10 = fVar16 * (float)param_9 + pfVar24[-0xe];
      fVar9 = (((float)param_9 * pfVar24[-0x11] + fVar9) * (float)param_9 + fVar16) * (float)param_9
              + fVar10;
      fVar11 = (float)param_9 * pfVar24[-0xc] + pfVar24[-0xb];
      fVar16 = fVar11 * (float)param_9 + pfVar24[-10];
      fVar13 = fVar16 * (float)param_9 + pfVar24[-9];
      fVar12 = (((float)param_9 * pfVar24[-0xc] + fVar11) * (float)param_9 + fVar16) *
               (float)param_9 + fVar13;
      fVar16 = fVar9 * fVar9 + fVar12 * fVar12;
      fVar11 = fVar16 * _DAT_006ea44c;
      fVar16 = (float)(0xbe7ffffdU - (int)fVar16 >> 1);
      fVar16 = (_DAT_006ea494 - fVar16 * fVar16 * fVar11) * fVar16;
      fVar16 = (_DAT_006ea494 - fVar16 * fVar16 * fVar11) * fVar16;
      fVar16 = (_DAT_006ea494 - fVar16 * fVar16 * fVar11) * fVar16;
      if (((_DAT_006ea494 - fVar16 * fVar16 * fVar11) * fVar16 *
           ((local_44 - (fVar13 * (float)param_9 + pfVar24[-8])) * fVar9 -
           (local_40 - (fVar10 * (float)param_9 + pfVar24[-0xd])) * fVar12) < fVar1) &&
         ((_DAT_006ea494 - fVar15 * fVar15 * fVar8) * fVar15 *
          (((fVar7 * (float)param_9 + pfVar24[7]) - local_44) * fVar4 -
          ((fVar6 * (float)param_9 + pfVar24[2]) - local_40) * fVar5) < fVar1)) {
        param_11 = *(float *)(iVar21 + 0x54);
        if (-1 < (int)param_11) {
          pfVar17 = (float *)(iVar21 + 0x68 + (int)param_11 * 0x48);
          do {
            fVar4 = pfVar17[1] * _DAT_006ea454 + *pfVar17;
            if (fVar4 < pfVar24[-0x13] != (fVar4 == pfVar24[-0x13])) break;
            pfVar17 = pfVar17 + -0x12;
            param_11 = (float)((int)param_11 + -1);
          } while (-1 < (int)param_11);
        }
        *(uint *)(param_5 + iVar20 * 4) =
             ((uint)(uVar2 != local_10) * 2 | (uint)(local_48 != local_c)) << 0x16 | uVar2;
        *(float *)(iVar14 + iVar20 * 4) = param_11;
        *(int *)(param_7 + iVar20 * 4) = param_6;
        *(uint *)(param_8 + iVar20 * 4) = (uint)pfVar24[-0x27] | 0x80000000;
        *(undefined4 *)(param_3 + iVar20 * 4) = 4;
        iVar22 = iVar20 + 1;
        if (uVar2 != local_10) {
          *(uint *)(param_5 + iVar22 * 4) = uVar2;
          *(float *)(iVar14 + iVar22 * 4) = param_11;
          *(int *)(param_7 + iVar22 * 4) = param_6;
          if (*(char *)(pfVar24 + -0x25) == '\0') {
            uVar27 = (uint)pfVar24[-0x27] | 0x40000000;
          }
          else {
            uVar27 = (uint)pfVar24[-0x27] | 0x80000000;
          }
          *(uint *)(param_8 + iVar22 * 4) = uVar27;
          *(undefined4 *)(param_3 + iVar22 * 4) = 5;
          pfVar17 = (float *)(iVar22 * 0x10 + param_4);
          *pfVar17 = -*(float *)(iVar21 + 0x20);
          pfVar17[1] = -*(float *)(iVar21 + 0x24);
          iVar22 = iVar20 + 2;
          pfVar17[2] = -*(float *)(iVar21 + 0x28);
          pfVar17[3] = -*(float *)(iVar21 + 0x2c);
          param_10 = 0.0;
          pfVar17 = pfVar24 + -0x22;
          piVar23 = (int *)(iVar14 + iVar22 * 4);
          pfVar28 = (float *)(iVar22 * 0x10 + 8 + param_4);
          do {
            pfVar29 = pfVar28;
            if (*(char *)((int)pfVar24 + (int)param_10 + -0x90) != '\0') {
              *(uint *)((int)piVar23 + (param_5 - iVar14)) = uVar2;
              *piVar23 = (int)param_11;
              *(int *)((int)piVar23 + (param_7 - iVar14)) = param_6;
              iVar22 = iVar22 + 1;
              *(uint *)((int)piVar23 + (param_8 - iVar14)) = (uint)pfVar24[-0x27] | 0x40000000;
              *(undefined4 *)((param_3 - iVar14) + (int)piVar23) = 5;
              piVar23 = piVar23 + 1;
              pfVar29 = pfVar28 + 4;
              pfVar28[-2] = pfVar17[-1];
              pfVar28[-1] = *pfVar17;
              *pfVar28 = pfVar17[1];
              pfVar28[1] = pfVar17[2];
            }
            param_10 = (float)((int)param_10 + 1);
            pfVar17 = pfVar17 + 4;
            pfVar28 = pfVar29;
          } while ((int)param_10 < 2);
        }
        if (local_48 != local_c) {
          param_10 = 2.8026e-45;
          pfVar17 = pfVar24 + -0x1a;
          piVar23 = (int *)(iVar14 + iVar22 * 4);
          pfVar28 = (float *)(iVar22 * 0x10 + 8 + param_4);
          do {
            pfVar29 = pfVar28;
            if (*(char *)((int)pfVar24 + (int)param_10 + -0x90) != '\0') {
              *(uint *)((int)piVar23 + (param_5 - iVar14)) = uVar2;
              *piVar23 = (int)param_11;
              *(int *)((int)piVar23 + (param_7 - iVar14)) = param_6;
              iVar22 = iVar22 + 1;
              *(uint *)((int)piVar23 + (param_8 - iVar14)) = (uint)pfVar24[-0x27] | 0x40000000;
              *(undefined4 *)((int)piVar23 + (param_3 - iVar14)) = 5;
              piVar23 = piVar23 + 1;
              pfVar29 = pfVar28 + 4;
              pfVar28[-2] = pfVar17[-1];
              pfVar28[-1] = *pfVar17;
              *pfVar28 = pfVar17[1];
              pfVar28[1] = pfVar17[2];
            }
            param_10 = (float)((int)param_10 + 1);
            pfVar17 = pfVar17 + 4;
            pfVar28 = pfVar29;
          } while ((int)param_10 < 4);
          *(uint *)(param_5 + iVar22 * 4) = uVar2;
          *(float *)(iVar14 + iVar22 * 4) = param_11;
          *(int *)(param_7 + iVar22 * 4) = param_6;
          if (*(char *)((int)pfVar24 + -0x93) == '\0') {
            uVar27 = (uint)pfVar24[-0x27] | 0x40000000;
          }
          else {
            uVar27 = (uint)pfVar24[-0x27] | 0x80000000;
          }
          *(uint *)(param_8 + iVar22 * 4) = uVar27;
          *(undefined4 *)(param_3 + iVar22 * 4) = 5;
          iVar18 = local_48 * 0x1550 + DAT_00bcf734;
          puVar19 = (undefined4 *)(iVar22 * 0x10 + param_4);
          iVar22 = iVar22 + 1;
          *puVar19 = *(undefined4 *)(iVar18 + 0x20);
          puVar19[1] = *(undefined4 *)(iVar18 + 0x24);
          puVar19[2] = *(undefined4 *)(iVar18 + 0x28);
          puVar19[3] = *(undefined4 *)(iVar18 + 0x2c);
        }
        *(uint *)(param_5 + iVar22 * 4) = uVar2;
        *(float *)(iVar14 + iVar22 * 4) = param_11;
        *(int *)(param_7 + iVar22 * 4) = param_6;
        *(uint *)(param_8 + iVar22 * 4) = (uint)pfVar24[-0x27] | 0x80000000;
        *(undefined4 *)(param_3 + iVar22 * 4) = 2;
        iVar18 = iVar22 + 1;
        *(uint *)(param_5 + iVar18 * 4) = uVar2;
        *(float *)(iVar14 + iVar18 * 4) = param_11;
        *(int *)(param_7 + iVar18 * 4) = param_6;
        *(uint *)(param_8 + iVar18 * 4) = (uint)pfVar24[-0x27] | 0x80000000;
        *(undefined4 *)(param_3 + iVar18 * 4) = 3;
        *(int *)(param_2 + local_50 * 4) = (iVar22 + 2) - iVar20;
        local_50 = local_50 + 1;
        iVar20 = iVar22 + 2;
      }
      param_6 = param_6 + 1;
      pfVar24 = pfVar24 + 0x42;
      fVar4 = local_2c;
      uVar27 = local_48;
    } while (param_6 < *(int *)(iVar21 + 0x5c));
  } while( true );
}


