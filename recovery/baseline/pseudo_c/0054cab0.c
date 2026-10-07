/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054cab0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_0054cab0(int param_1_00,float *param_1,float *param_2,float *param_3,float *param_4,
            float param_5,float param_6,float param_7,float param_8,float param_9,float param_10,
            float param_11,float param_12,float param_13,float param_14)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  uint uVar8;
  uint uVar9;
  undefined4 uVar10;
  bool bVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  float fVar15;
  float fVar16;
  float fVar17;
  float fVar18;
  float10 fVar19;
  float10 fVar20;
  float10 fVar21;
  float10 fVar22;
  float local_20;
  
  *(float *)(param_1_00 + 0x2ec) = param_8 - param_5;
  *(float *)(param_1_00 + 0x2e8) = -param_6;
  *(float *)(param_1_00 + 0x2f0) = param_5;
  DAT_00c08250 = *(undefined4 *)(param_1_00 + 0x6c);
  *(float *)(param_1_00 + 0x2cc) = ABS(param_8);
  *(float *)(param_1_00 + 700) = param_11;
  if ((_DAT_006f5904 < ABS(*(float *)(param_1_00 + 700))) && (*(int *)(param_1_00 + 0x2c0) < 0x11))
  {
    DAT_00bf6f28 = 0x12;
    _DAT_00bf6f30 = 0xbf800000;
    if ((int)((*(uint *)(param_1_00 + 0x6c) & 1) * 2 + -1) < 1) {
      _DAT_00bf6f30 = 0x3f800000;
    }
  }
  if (_DAT_006ea454 <= param_9) {
    bVar11 = param_10 < _DAT_006ea454;
    DAT_00c08284 = 2;
    *param_4 = 0.0;
    *param_3 = 0.0;
    *param_2 = 0.0;
    *param_1 = 0.0;
    DAT_00c08620 = 0.0;
    DAT_00c0828c = 0.0;
    if (bVar11) {
      uVar10 = *(undefined4 *)(param_1_00 + 0x2c0);
      fVar19 = (float10)FUN_00579ea0(0x11,uVar10);
      fVar20 = (float10)FUN_00579e80(0x11,uVar10);
      fVar19 = ((float10)(float)fVar19 * (float10)param_7 +
               fVar20 * (float10)_DAT_00c08444 * (float10)param_10) * (float10)_DAT_00c08444;
      *param_4 = (float)fVar19;
      if ((float10)_DAT_006f58f8 < fVar19) {
        FUN_00577260(param_5,param_6);
      }
    }
    *(undefined4 *)(param_1_00 + 0x2c8) = 0;
    *(undefined4 *)(param_1_00 + 0x2e4) = 0;
    *(undefined4 *)(param_1_00 + 0x2e8) = 0;
    *(undefined4 *)(param_1_00 + 0x2ec) = 0;
    *(undefined4 *)(param_1_00 + 0x2f0) = 0;
    if (*(int *)(param_1_00 + 0x6c) < 2) {
      DAT_00c085dc = 0.0;
      _DAT_00c081ec = 0.0;
    }
    goto LAB_0054d3d0;
  }
  fVar6 = *(float *)(param_1_00 + 0x2ec);
  fVar7 = *(float *)(param_1_00 + 0x2e8);
  fVar1 = *(float *)(param_1_00 + 0x2cc);
  FUN_005f5890(param_1_00 + 0xe8);
  uVar8 = **(uint **)(param_1_00 + 0xdc);
  uVar9 = **(uint **)(param_1_00 + 0xe4);
  FUN_005f58a0(param_1_00 + 0xe8);
  fVar15 = (*(float *)(param_1_00 + 0x2e8) - DAT_00c08620 * *(float *)(param_1_00 + 0x2cc)) *
           (float)(uVar8 ^ uVar9) + DAT_00c08620;
  FUN_005f5890(param_1_00 + 0xe8);
  uVar8 = **(uint **)(param_1_00 + 0xdc);
  uVar9 = **(uint **)(param_1_00 + 0xe4);
  FUN_005f58a0(param_1_00 + 0xe8);
  fVar14 = (*(float *)(param_1_00 + 0x2ec) - DAT_00c0828c * *(float *)(param_1_00 + 0x2cc)) *
           (float)(uVar8 ^ uVar9) + DAT_00c0828c;
  if (DAT_00e843fc != '\0') {
    DAT_00c0828c = fVar14;
    DAT_00c08620 = fVar15;
  }
  param_9 = _DAT_00c08444 * *(float *)(param_1_00 + 0x2a8) * _DAT_00c08444 * param_9;
  *param_4 = param_9;
  fVar3 = param_9 * _DAT_006f58e0;
  fVar19 = (float10)FUN_005677d1(param_1_00 + 0x8ec,param_9 * *(float *)(param_1_00 + 0x29c));
  fVar20 = (float10)FUN_005677d1(param_1_00 + 0x7ec,*(undefined4 *)(param_1_00 + 0x2cc));
  fVar2 = (float)(((float10)_DAT_006e97d8 - (float10)ABS(param_11) * (float10)_DAT_006ee390) *
                  fVar20 * (float10)(float)fVar19 * (float10)param_9);
  fVar16 = (_DAT_006e97d8 / (fVar3 * fVar3 + _DAT_006e97d8) + _DAT_006e97d8) * fVar2;
  fVar3 = *(float *)(*(int *)(param_1_00 + 0x70) + 0x20);
  *(undefined4 *)(param_1_00 + 0xd4) = *(undefined4 *)(param_1_00 + 0x18);
  *(undefined4 *)(param_1_00 + 0xd8) = *(undefined4 *)(param_1_00 + 0x1c);
  fVar19 = (float10)FUN_005677d1(param_1_00 + 0x96c,param_9);
  *(float *)(param_1_00 + 0xd4) =
       (float)((float10)*(float *)(param_1_00 + 0xd0) * (float10)*(float *)(param_1_00 + 0xd4) *
              fVar19);
  *(float *)(param_1_00 + 0xd8) =
       (float)((float10)*(float *)(param_1_00 + 0xd0) * fVar19 *
              (float10)*(float *)(param_1_00 + 0xd8));
  fVar19 = (float10)FUN_005677d1((&PTR_DAT_0074e080)[*(int *)(param_1_00 + 0x6c)],
                                 (_DAT_006f58fc / (_DAT_006f5900 - param_9)) *
                                 *(float *)(param_1_00 + 700));
  local_20 = 0.0;
  *(float *)(param_1_00 + 0xd4) = (float)(fVar19 * (float10)*(float *)(param_1_00 + 0xd4));
  *(float *)(param_1_00 + 0xd8) = (float)(fVar19 * (float10)*(float *)(param_1_00 + 0xd8));
  if (param_10 < _DAT_006ea454) {
    uVar10 = *(undefined4 *)(param_1_00 + 0x2c0);
    fVar19 = (float10)FUN_00579ea0(0x11,uVar10);
    fVar20 = (float10)FUN_00579e80(0x11,uVar10);
    fVar19 = ((float10)(float)fVar19 * (float10)param_7 +
             fVar20 * (float10)_DAT_00c08444 * (float10)param_10) * (float10)_DAT_00c08444;
    local_20 = (float)fVar19;
    *param_4 = (float)(fVar19 + (float10)*param_4);
    *(float *)(param_1_00 + 0xd4) = *(float *)(param_1_00 + 0xd4) * _DAT_006ee4c4;
    *(float *)(param_1_00 + 0xd8) = *(float *)(param_1_00 + 0xd8) * _DAT_006ee4c4;
  }
  fVar12 = param_9 * *(float *)(param_1_00 + 0xd8);
  fVar13 = param_9 * *(float *)(param_1_00 + 0xd4);
  fVar4 = fVar2 * (_DAT_006e97d8 / fVar12) * fVar15;
  fVar3 = -(fVar3 * fVar2) * *(float *)(param_1_00 + 700) * (_DAT_006e97d8 / fVar12);
  fVar5 = (fVar14 / fVar13) * fVar16;
  fVar14 = fVar4 * fVar4 + fVar5 * fVar5;
  fVar17 = (float)(0xbe7ffffdU - (int)fVar14 >> 1);
  fVar17 = (_DAT_006ea494 - fVar17 * fVar17 * _DAT_006ea44c * fVar14) * fVar17;
  fVar14 = (_DAT_006ea494 - fVar17 * fVar17 * _DAT_006ea44c * fVar14) * fVar17 * fVar14;
  if (ABS(*(float *)(param_1_00 + 700)) < _DAT_006ed020) {
    *(int *)(param_1_00 + 0x2b8) = *(int *)(param_1_00 + 0x2b8) + 1;
    *(float *)(param_1_00 + 0x2ac) = fVar5 + *(float *)(param_1_00 + 0x2ac);
    *(float *)(param_1_00 + 0x2b0) = fVar4 + *(float *)(param_1_00 + 0x2b0);
    *(float *)(param_1_00 + 0x2b4) = fVar14 + *(float *)(param_1_00 + 0x2b4);
  }
  fVar20 = (float10)FUN_005677d1(param_1_00 + 0x2f4,fVar3);
  fVar19 = (float10)_DAT_006e97d8;
  fVar21 = (float10)FUN_005677d1(param_1_00 + 0x2f4,fVar14);
  fVar4 = (float)fVar21;
  FUN_005f5890(param_1_00 + 0x114);
  uVar8 = **(uint **)(param_1_00 + 0x108);
  uVar9 = **(uint **)(param_1_00 + 0x110);
  FUN_005f58a0(param_1_00 + 0x114);
  fVar5 = _DAT_006e97d8 - fVar4;
  *(float *)(param_1_00 + 0x2e4) = fVar5;
  fVar17 = (((float)(uVar8 ^ uVar9) * fVar4 + fVar5) / *(float *)(param_1_00 + 0xd8)) *
           *(float *)(param_1_00 + 0xd4) * *(float *)(param_1_00 + 0x2e8);
  fVar5 = *(float *)(param_1_00 + 0x2ec) * *(float *)(param_1_00 + 0x2ec) + fVar17 * fVar17;
  fVar18 = (float)(0xbe7ffffdU - (int)fVar5 >> 1);
  fVar18 = (_DAT_006ea494 - fVar18 * fVar18 * _DAT_006ea44c * fVar5) * fVar18;
  fVar18 = (_DAT_006ea494 - fVar18 * fVar18 * _DAT_006ea44c * fVar5) * fVar18;
  fVar14 = fVar4 * fVar4 * fVar14;
  fVar21 = (float10)FUN_005677d1(param_1_00 + 0x86c,fVar18 * fVar5);
  fVar21 = fVar21 * (float10)*(float *)(param_1_00 + 0x2e4);
  fVar22 = (fVar21 + (float10)fVar14) * (float10)fVar18;
  fVar5 = *(float *)(param_1_00 + 0x2ec);
  *param_3 = (float)(((float10)(float)((fVar20 * fVar20 * (float10)fVar3 + fVar19) - fVar20) *
                      (float10)fVar4 + (float10)fVar17 * fVar22) * (float10)fVar12);
  *param_2 = (float)(fVar22 * (float10)fVar5 * (float10)fVar13);
  *param_1 = 0.0;
  fVar3 = param_9 * *(float *)(param_1_00 + 0x2c4);
  *(float *)(param_1_00 + 0x2c8) = fVar3;
  *(float *)(&DAT_00c081f4)[*(int *)(param_1_00 + 0x6c)] =
       **(float **)(param_1_00 + 0x70) * fVar3 +
       *(float *)(&DAT_00c081f4)[*(int *)(param_1_00 + 0x6c)];
  if (_DAT_006f58f8 < local_20) {
    FUN_00577260(param_5,param_6);
  }
  if (*(int *)(param_1_00 + 0x6c) < 2) {
    fVar12 = fVar18 * fVar17 * fVar12;
    fVar3 = SQRT(param_9 * *(float *)(param_1_00 + 0x2a4));
    param_14 = fVar3 * _DAT_006ea44c +
               (*param_2 / fVar16) * _DAT_006e9824 +
               *(float *)(&DAT_00c082d4 + *(int *)(param_1_00 + 0x6c) * 4) + param_14;
    _DAT_00c081ec =
         (_DAT_006e9824 / fVar2) * *param_3 * *param_2 +
         fVar14 * fVar12 * (param_14 - fVar3 * fVar4 * _DAT_006efb28) +
         (float)fVar21 * fVar12 * (param_14 - (fVar4 + _DAT_006e97d8) * _DAT_006ea44c * fVar3);
    DAT_00c085dc = fVar15;
  }
  if (ABS(fVar7) + ABS(fVar6) + fVar1 < _DAT_006f58c4) {
    fVar1 = param_13 * param_13 + param_12 * param_12;
    if (fVar1 < _DAT_006f58bc * _DAT_006f58bc) {
      DAT_00c08284 = 0;
      *param_1 = (_DAT_00c08444 * param_12 * _DAT_006f58f4 -
                 *(float *)(param_1_00 + 0x2ec) * _DAT_006f58f0) * _DAT_00c08444 * *DAT_00e84480 +
                 *param_1;
      *param_3 = (param_6 * _DAT_006f58f0 - _DAT_00c08444 * param_13 * _DAT_006f58ec) *
                 _DAT_00c08444 + *param_3;
      goto LAB_0054d3d0;
    }
    if (fVar1 < _DAT_006f58c0 * _DAT_006f58c0) {
      DAT_00c08284 = 1;
      _DAT_00c08624 = _DAT_006f58bc / SQRT(fVar1);
      *param_1 = (_DAT_00c08624 * _DAT_00c08444 * param_12 * _DAT_006f58f4 -
                 *(float *)(param_1_00 + 0x2ec) * _DAT_006f58f0) * _DAT_00c08444 * *DAT_00e84480 +
                 *param_1;
      *param_3 = (param_6 * _DAT_006f58f0 - _DAT_00c08624 * _DAT_00c08444 * param_13 * _DAT_006f58ec
                 ) * _DAT_00c08444 + *param_3;
      goto LAB_0054d3d0;
    }
  }
  DAT_00c08284 = 2;
LAB_0054d3d0:
  *(float *)(param_1_00 + 0x2e0) = *param_4;
  *(float *)(param_1_00 + 0x2dc) = *param_3;
  *(float *)(param_1_00 + 0x2d8) = *param_2;
  return;
}


