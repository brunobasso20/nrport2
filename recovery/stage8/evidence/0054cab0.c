/* NR2003.exe @ 0054cab0 FUN_0054cab0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_0054cab0(int param_1_00,float *param_1,float *param_2,float *param_3,float *param_4,
            float param_5,float param_6,float param_7,float param_8,float param_9,float param_10,
            uint param_11,float param_12,float param_13,float param_14)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  uint uVar5;
  uint uVar6;
  undefined4 uVar7;
  bool bVar8;
  bool bVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  float fVar15;
  float fVar16;
  float fVar17;
  float10 fVar18;
  float10 fVar19;
  float10 fVar20;
  float10 fVar21;
  float local_20;
  
  *(float *)(param_1_00 + 0x2ec) = param_8 - param_5;
  *(float *)(param_1_00 + 0x2e8) = -param_6;
  *(float *)(param_1_00 + 0x2f0) = param_5;
  DAT_00c08250 = *(undefined4 *)(param_1_00 + 0x6c);
  *(uint *)(param_1_00 + 0x2cc) = (uint)param_8 & 0x7fffffff;
  *(uint *)(param_1_00 + 700) = param_11;
  if ((_DAT_006f5904 < (float)(*(uint *)(param_1_00 + 700) & 0x7fffffff)) &&
     (*(int *)(param_1_00 + 0x2c0) < 0x11)) {
    DAT_00bf6f28 = 0x12;
    _DAT_00bf6f30 = 0xbf800000;
    if ((int)((*(uint *)(param_1_00 + 0x6c) & 1) * 2 + -1) < 1) {
      _DAT_00bf6f30 = 0x3f800000;
    }
  }
  if (param_9 < _DAT_006ea454 == (NAN(param_9) || NAN(_DAT_006ea454))) {
    bVar8 = NAN(_DAT_006ea454);
    bVar9 = param_10 < _DAT_006ea454;
    DAT_00c08284 = 2;
    *param_4 = 0.0;
    *param_3 = 0.0;
    *param_2 = 0.0;
    *param_1 = 0.0;
    DAT_00c08620 = 0.0;
    DAT_00c0828c = 0.0;
    if (bVar9 != (NAN(param_10) || bVar8)) {
      uVar7 = *(undefined4 *)(param_1_00 + 0x2c0);
      fVar18 = (float10)FUN_00579ea0(0x11,uVar7);
      fVar19 = (float10)FUN_00579e80(0x11,uVar7);
      fVar18 = ((float10)(float)fVar18 * (float10)param_7 +
               fVar19 * (float10)_DAT_00c08444 * (float10)param_10) * (float10)_DAT_00c08444;
      *param_4 = (float)fVar18;
      if ((float10)_DAT_006f58f8 < fVar18) {
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
  fVar10 = (float)(*(uint *)(param_1_00 + 0x2e8) & 0x7fffffff) +
           (float)(*(uint *)(param_1_00 + 0x2ec) & 0x7fffffff) + *(float *)(param_1_00 + 0x2cc);
  FUN_005f5890(param_1_00 + 0xe8);
  uVar5 = **(uint **)(param_1_00 + 0xdc);
  uVar6 = **(uint **)(param_1_00 + 0xe4);
  FUN_005f58a0(param_1_00 + 0xe8);
  fVar14 = (*(float *)(param_1_00 + 0x2e8) - DAT_00c08620 * *(float *)(param_1_00 + 0x2cc)) *
           (float)(uVar5 ^ uVar6) + DAT_00c08620;
  FUN_005f5890(param_1_00 + 0xe8);
  uVar5 = **(uint **)(param_1_00 + 0xdc);
  uVar6 = **(uint **)(param_1_00 + 0xe4);
  FUN_005f58a0(param_1_00 + 0xe8);
  fVar13 = (*(float *)(param_1_00 + 0x2ec) - DAT_00c0828c * *(float *)(param_1_00 + 0x2cc)) *
           (float)(uVar5 ^ uVar6) + DAT_00c0828c;
  if (DAT_00e843fc != '\0') {
    DAT_00c0828c = fVar13;
    DAT_00c08620 = fVar14;
  }
  param_9 = _DAT_00c08444 * *(float *)(param_1_00 + 0x2a8) * _DAT_00c08444 * param_9;
  *param_4 = param_9;
  fVar2 = param_9 * _DAT_006f58e0;
  fVar18 = (float10)FUN_005677d1(param_1_00 + 0x8ec,param_9 * *(float *)(param_1_00 + 0x29c));
  fVar19 = (float10)FUN_005677d1(param_1_00 + 0x7ec,*(undefined4 *)(param_1_00 + 0x2cc));
  fVar1 = (float)(((float10)_DAT_006e97d8 -
                  (float10)(float)(param_11 & 0x7fffffff) * (float10)_DAT_006ee390) *
                  fVar19 * (float10)(float)fVar18 * (float10)param_9);
  fVar15 = (_DAT_006e97d8 / (fVar2 * fVar2 + _DAT_006e97d8) + _DAT_006e97d8) * fVar1;
  fVar2 = *(float *)(*(int *)(param_1_00 + 0x70) + 0x20);
  *(undefined4 *)(param_1_00 + 0xd4) = *(undefined4 *)(param_1_00 + 0x18);
  *(undefined4 *)(param_1_00 + 0xd8) = *(undefined4 *)(param_1_00 + 0x1c);
  fVar18 = (float10)FUN_005677d1(param_1_00 + 0x96c,param_9);
  *(float *)(param_1_00 + 0xd4) =
       (float)((float10)*(float *)(param_1_00 + 0xd0) * (float10)*(float *)(param_1_00 + 0xd4) *
              fVar18);
  *(float *)(param_1_00 + 0xd8) =
       (float)((float10)*(float *)(param_1_00 + 0xd0) * fVar18 *
              (float10)*(float *)(param_1_00 + 0xd8));
  fVar18 = (float10)FUN_005677d1((&PTR_DAT_0074e080)[*(int *)(param_1_00 + 0x6c)],
                                 (_DAT_006f58fc / (_DAT_006f5900 - param_9)) *
                                 *(float *)(param_1_00 + 700));
  local_20 = 0.0;
  *(float *)(param_1_00 + 0xd4) = (float)(fVar18 * (float10)*(float *)(param_1_00 + 0xd4));
  *(float *)(param_1_00 + 0xd8) = (float)(fVar18 * (float10)*(float *)(param_1_00 + 0xd8));
  if (param_10 < _DAT_006ea454 != (NAN(param_10) || NAN(_DAT_006ea454))) {
    uVar7 = *(undefined4 *)(param_1_00 + 0x2c0);
    fVar18 = (float10)FUN_00579ea0(0x11,uVar7);
    fVar19 = (float10)FUN_00579e80(0x11,uVar7);
    fVar18 = ((float10)(float)fVar18 * (float10)param_7 +
             fVar19 * (float10)_DAT_00c08444 * (float10)param_10) * (float10)_DAT_00c08444;
    local_20 = (float)fVar18;
    *param_4 = (float)(fVar18 + (float10)*param_4);
    *(float *)(param_1_00 + 0xd4) = *(float *)(param_1_00 + 0xd4) * _DAT_006ee4c4;
    *(float *)(param_1_00 + 0xd8) = *(float *)(param_1_00 + 0xd8) * _DAT_006ee4c4;
  }
  fVar11 = param_9 * *(float *)(param_1_00 + 0xd8);
  fVar12 = param_9 * *(float *)(param_1_00 + 0xd4);
  fVar3 = fVar1 * (_DAT_006e97d8 / fVar11) * fVar14;
  fVar2 = -(fVar2 * fVar1) * *(float *)(param_1_00 + 700) * (_DAT_006e97d8 / fVar11);
  fVar4 = (fVar13 / fVar12) * fVar15;
  fVar13 = fVar3 * fVar3 + fVar4 * fVar4;
  fVar16 = (float)(0xbe7ffffdU - (int)fVar13 >> 1);
  fVar16 = (_DAT_006ea494 - fVar16 * fVar16 * _DAT_006ea44c * fVar13) * fVar16;
  fVar13 = (_DAT_006ea494 - fVar16 * fVar16 * _DAT_006ea44c * fVar13) * fVar16 * fVar13;
  fVar16 = (float)(*(uint *)(param_1_00 + 700) & 0x7fffffff);
  if (fVar16 < _DAT_006ed020 != (NAN(fVar16) || NAN(_DAT_006ed020))) {
    *(int *)(param_1_00 + 0x2b8) = *(int *)(param_1_00 + 0x2b8) + 1;
    *(float *)(param_1_00 + 0x2ac) = fVar4 + *(float *)(param_1_00 + 0x2ac);
    *(float *)(param_1_00 + 0x2b0) = fVar3 + *(float *)(param_1_00 + 0x2b0);
    *(float *)(param_1_00 + 0x2b4) = fVar13 + *(float *)(param_1_00 + 0x2b4);
  }
  fVar19 = (float10)FUN_005677d1(param_1_00 + 0x2f4,fVar2);
  fVar18 = (float10)_DAT_006e97d8;
  fVar20 = (float10)FUN_005677d1(param_1_00 + 0x2f4,fVar13);
  fVar3 = (float)fVar20;
  FUN_005f5890(param_1_00 + 0x114);
  uVar5 = **(uint **)(param_1_00 + 0x108);
  uVar6 = **(uint **)(param_1_00 + 0x110);
  FUN_005f58a0(param_1_00 + 0x114);
  fVar4 = _DAT_006e97d8 - fVar3;
  *(float *)(param_1_00 + 0x2e4) = fVar4;
  fVar16 = (((float)(uVar5 ^ uVar6) * fVar3 + fVar4) / *(float *)(param_1_00 + 0xd8)) *
           *(float *)(param_1_00 + 0xd4) * *(float *)(param_1_00 + 0x2e8);
  fVar4 = *(float *)(param_1_00 + 0x2ec) * *(float *)(param_1_00 + 0x2ec) + fVar16 * fVar16;
  fVar17 = (float)(0xbe7ffffdU - (int)fVar4 >> 1);
  fVar17 = (_DAT_006ea494 - fVar17 * fVar17 * _DAT_006ea44c * fVar4) * fVar17;
  fVar17 = (_DAT_006ea494 - fVar17 * fVar17 * _DAT_006ea44c * fVar4) * fVar17;
  fVar13 = fVar3 * fVar3 * fVar13;
  fVar20 = (float10)FUN_005677d1(param_1_00 + 0x86c,fVar17 * fVar4);
  fVar20 = fVar20 * (float10)*(float *)(param_1_00 + 0x2e4);
  fVar21 = (fVar20 + (float10)fVar13) * (float10)fVar17;
  fVar4 = *(float *)(param_1_00 + 0x2ec);
  *param_3 = (float)(((float10)(float)((fVar19 * fVar19 * (float10)fVar2 + fVar18) - fVar19) *
                      (float10)fVar3 + (float10)fVar16 * fVar21) * (float10)fVar11);
  *param_2 = (float)(fVar21 * (float10)fVar4 * (float10)fVar12);
  *param_1 = 0.0;
  fVar2 = param_9 * *(float *)(param_1_00 + 0x2c4);
  *(float *)(param_1_00 + 0x2c8) = fVar2;
  *(float *)(&DAT_00c081f4)[*(int *)(param_1_00 + 0x6c)] =
       **(float **)(param_1_00 + 0x70) * fVar2 +
       *(float *)(&DAT_00c081f4)[*(int *)(param_1_00 + 0x6c)];
  if (_DAT_006f58f8 < local_20) {
    FUN_00577260(param_5,param_6);
  }
  if (*(int *)(param_1_00 + 0x6c) < 2) {
    fVar11 = fVar17 * fVar16 * fVar11;
    fVar2 = SQRT(param_9 * *(float *)(param_1_00 + 0x2a4));
    param_14 = fVar2 * _DAT_006ea44c +
               (*param_2 / fVar15) * _DAT_006e9824 +
               *(float *)(&DAT_00c082d4 + *(int *)(param_1_00 + 0x6c) * 4) + param_14;
    _DAT_00c081ec =
         (_DAT_006e9824 / fVar1) * *param_3 * *param_2 +
         fVar13 * fVar11 * (param_14 - fVar2 * fVar3 * _DAT_006efb28) +
         (float)fVar20 * fVar11 * (param_14 - (fVar3 + _DAT_006e97d8) * _DAT_006ea44c * fVar2);
    DAT_00c085dc = fVar14;
  }
  if (fVar10 < _DAT_006f58c4 != (NAN(fVar10) || NAN(_DAT_006f58c4))) {
    fVar10 = param_13 * param_13 + param_12 * param_12;
    if (fVar10 < _DAT_006f58bc * _DAT_006f58bc) {
      DAT_00c08284 = 0;
      *param_1 = (_DAT_00c08444 * param_12 * _DAT_006f58f4 -
                 *(float *)(param_1_00 + 0x2ec) * _DAT_006f58f0) * _DAT_00c08444 * *DAT_00e84480 +
                 *param_1;
      *param_3 = (param_6 * _DAT_006f58f0 - _DAT_00c08444 * param_13 * _DAT_006f58ec) *
                 _DAT_00c08444 + *param_3;
      goto LAB_0054d3d0;
    }
    if (fVar10 < _DAT_006f58c0 * _DAT_006f58c0) {
      DAT_00c08284 = 1;
      _DAT_00c08624 = _DAT_006f58bc / SQRT(fVar10);
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

