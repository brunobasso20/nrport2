/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054d610 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0054d610(float *param_1)

{
  float *pfVar1;
  float *pfVar2;
  float fVar3;
  uint uVar4;
  undefined4 *puVar5;
  undefined4 uVar6;
  int iVar7;
  uint uVar8;
  float fVar9;
  float10 fVar10;
  float10 fVar11;
  float local_94;
  float local_90;
  float fStack_8c;
  float local_88;
  float local_84;
  float local_80;
  float local_7c;
  float local_78;
  float fStack_74;
  float local_70;
  float local_6c;
  float local_68;
  float local_64;
  float local_60;
  float local_5c;
  float fStack_58;
  float local_54 [4];
  float local_44;
  float local_40;
  uint local_3c;
  float local_38;
  float fStack_34;
  float local_30;
  float local_2c;
  float local_28;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;

  _DAT_0074c954 = DAT_00e0b830 + _DAT_006ee350;
  local_90 = param_1[0xae];
  if (0 < (int)local_90) {
    fVar9 = _DAT_006e97d8 / (float)(int)local_90;
    param_1[0xab] = fVar9 * param_1[0xab];
    param_1[0xac] = fVar9 * param_1[0xac];
    param_1[0xad] = fVar9 * param_1[0xad];
  }
  fVar10 = (float10)FUN_00579ef0(param_1[0xb0]);
  local_90 = (float)(fVar10 * (float10)param_1[0xb3] * (float10)param_1[0xb3]);
  fVar10 = (float10)FUN_00579ee0(param_1[0xb0]);
  param_1[0xb1] = (float)(fVar10 + (float10)local_90);
  if ((float10)_DAT_006e97d8 < fVar10 + (float10)local_90) {
    param_1[0xb1] = 1.0;
  }
  if (_DAT_006ea4cc <= *param_1) {
    FUN_005f5890(param_1 + 0x7c);
    FUN_00425e80(&local_90,param_1[0x79],param_1[0x7b],4);
    FUN_005f58a0(param_1 + 0x7c);
    local_7c = local_90;
    fVar10 = (float10)FUN_0054fb50();
    local_68 = (float)fVar10;
    fVar10 = (float10)FUN_0054fb50();
    param_1[0xa8] =
         (float)(((((fVar10 + (float10)local_68 + (float10)local_7c) * (float10)_DAT_006f5938 -
                   (float10)_DAT_0074c954) * (float10)_DAT_006ea470 + (float10)_DAT_0074c954) /
                 (float10)_DAT_0074c954) * (float10)*param_1);
  }
  else {
    param_1[0xa8] = 0.0;
  }
  fVar9 = _DAT_006f5894 * _DAT_006f588c * _DAT_006f588c;
  if (param_1[0xa8] <= _DAT_006ea630) {
    fVar9 = fVar9 * _DAT_006f53c0;
  }
  else {
    fVar9 = fVar9 / param_1[0xa8];
  }
  param_1[0xa9] = fVar9;
  param_1[0xa6] = (param_1[0xa8] / param_1[1]) * _DAT_006ed020 + _DAT_006ea4cc;
  FUN_005f5890(param_1 + 0x7c);
  FUN_00425e80(&local_90,param_1[0x79],param_1[0x7b],4);
  FUN_005f58a0(param_1 + 0x7c);
  local_7c = local_90;
  local_60 = (param_1[0xa8] / param_1[2]) * _DAT_006ed020 + _DAT_006ea4cc;
  fVar10 = (float10)FUN_0054fb50();
  local_68 = (float)fVar10;
  fVar10 = (float10)FUN_0054fb50();
  local_90 = param_1[0xa6];
  param_1[0xa7] =
       (float)(((float10)_DAT_006f58e4 -
               (fVar10 + (float10)local_68 + (float10)local_7c) * (float10)_DAT_006f5934) /
              ((float10)local_60 * (float10)param_1[0xd] + (float10)local_60 * (float10)param_1[0xd]
              ));
  fVar10 = (float10)FUN_00579e80(0x13,param_1[0xb0]);
  param_1[0xaa] = (float)(fVar10 * (float10)local_90);
  param_1[0xb1] = param_1[0xb1] / param_1[0xa6];
  param_1[0xb5] = param_1[0xb2] * param_1[0xb3];
  fVar9 = param_1[0xb7] * param_1[0xba] * param_1[0xb9];
  fVar3 = param_1[0xb6] * param_1[0xbb] * param_1[0xb9];
  param_1[0xb4] = SQRT(fVar9 * fVar9 + fVar3 * fVar3);
  local_7c = ABS(param_1[0xba]);
  local_90 = param_1[0xbb];
  local_68 = ABS(local_90);
  fVar9 = local_68 + local_7c + param_1[0xb3];
  if (_DAT_006ea62c <= fVar9) {
    if (fVar9 < _DAT_006ea478) {
      fVar3 = (fVar9 - _DAT_006ea62c) * _DAT_006f5930;
      param_1[0xb4] = fVar3 * param_1[0xb4];
      param_1[0xb5] = fVar3 * param_1[0xb5];
    }
  }
  else {
    param_1[0xb4] = 0.0;
    param_1[0xb5] = 0.0;
  }
  fVar3 = param_1[0xb0];
  if ((((fVar3 == 8.40779e-45) || (fVar3 == 9.80909e-45)) || (fVar3 == 1.12104e-44)) &&
     ((_DAT_006f3e2c < fVar9 &&
      (fVar9 = (param_1[0xb4] - _DAT_006f592c) +
               *(float *)(&DAT_006f64b8 + (int)fVar3 * 4) * param_1[0xb5], _DAT_006ea454 < fVar9))))
  {
    local_80 = fVar9 * _DAT_006ea480;
    if (_DAT_006e97d8 < local_80) {
      local_80 = 1.0;
    }
    uVar6 = FUN_0055ab00();
    iVar7 = FUN_00562f70(uVar6);
    if (*(int *)(iVar7 + 0x5ae) != 0) {
      FUN_00583a20(param_1 + 0x27b,param_1 + 0x27e,*(undefined4 *)(*(int *)(iVar7 + 0x5ae) + 0x3c),
                   local_80);
    }
  }
  local_90 = (float)taskGetRate();
  local_68 = (float)(int)local_90;
  local_7c = param_1[3];
  local_64 = _DAT_006e97d8 / local_68;
  fVar10 = (float10)FUN_005100e0(param_1[0xb0]);
  local_90 = (float)fVar10;
  fVar10 = (float10)FUN_00510090();
  local_5c = (float)(fVar10 * (float10)local_90 * (float10)local_7c * (float10)param_1[0xb4] *
                    (float10)_DAT_006ea44c);
  local_7c = param_1[3];
  fVar10 = (float10)FUN_005100e0(param_1[0xb0]);
  local_90 = (float)fVar10;
  fVar10 = (float10)FUN_00510090();
  local_78 = (float)(fVar10 * (float10)local_90 * (float10)local_7c * (float10)param_1[0xb5]);
  uVar6 = FUN_0055ab00();
  iVar7 = FUN_00562f70(uVar6);
  local_88 = *(float *)(iVar7 + 0x5ae);
  if ((local_88 != 0.0) &&
     (*(float *)((int)local_88 + 0x14) * *(float *)((int)local_88 + 0x14) +
      *(float *)((int)local_88 + 0x10) * *(float *)((int)local_88 + 0x10) +
      *(float *)((int)local_88 + 0xc) * *(float *)((int)local_88 + 0xc) < _DAT_006f5928)) {
    local_5c = 0.0;
    local_78 = 0.0;
  }
  local_90 = (float)(((uint)param_1[0x1b] & 1) * 2 + -1);
  local_6c = (float)(int)local_90 * param_1[0xaf];
  local_54[0] = _DAT_006ea504;
  local_54[2] = _DAT_006f5920;
  if ((local_6c <= _DAT_006f5924) &&
     (local_54[0] = _DAT_006f5920, local_54[2] = _DAT_006ea504, _DAT_006f591c <= local_6c)) {
    fVar9 = local_6c * _DAT_006f5918 * _DAT_006ea470;
    local_54[0] = _DAT_006e97d8 - fVar9;
    local_54[2] = fVar9 + _DAT_006e97d8;
  }
  local_54[1] = SQRT((param_1[0xa8] * _DAT_006ed020) / (param_1[2] - _DAT_006e9804) + _DAT_006ea4cc)
  ;
  local_80 = _DAT_006e97d8 / local_54[1];
  local_54[0] = local_80 * local_54[0];
  local_54[2] = local_80 * local_54[2];
  FUN_005f5890(param_1 + 0x5b);
  FUN_00425e80(&local_90,param_1[0x58],param_1[0x5a],4);
  FUN_005f58a0(param_1 + 0x5b);
  fVar9 = local_90;
  local_94 = local_90;
  fVar10 = (float10)FUN_0054fb50();
  if ((float10)fVar9 < fVar10) {
    fVar10 = (float10)FUN_0054fb50();
    local_94 = (float)fVar10;
  }
  fVar10 = (float10)FUN_0054fb50();
  if ((float10)local_94 < fVar10) {
    fVar10 = (float10)FUN_0054fb50();
    local_94 = (float)fVar10;
  }
  FUN_005f5890(param_1 + 0x7c);
  FUN_00425e80(&local_7c,param_1[0x79],param_1[0x7b],4);
  FUN_005f58a0(param_1 + 0x7c);
  local_70 = param_1[0x15];
  local_80 = local_7c;
  fVar10 = (float10)FUN_0054fb50();
  local_60 = (float)fVar10;
  fVar10 = (float10)FUN_0054fb50();
  fVar10 = ((fVar10 + (float10)local_60 + (float10)local_80) * (float10)_DAT_006f5938 +
           (float10)local_94) * (float10)_DAT_006ea44c - (float10)local_70;
  fVar9 = (float)fVar10;
  fVar3 = _DAT_006f5914;
  if (((float10)_DAT_006f5914 <= fVar10) || (fVar3 = fVar9, _DAT_006ea454 <= fVar9)) {
    fVar11 = (float10)1.4426950408889634 * (float10)fVar3 * (float10)_DAT_006f5910;
    fVar10 = ROUND(fVar11);
    fVar11 = (float10)f2xm1(fVar11 - fVar10);
    fVar10 = (float10)fscale((float10)1 + fVar11,fVar10);
    fVar10 = (fVar10 - (float10)_DAT_006e97d8) * (fVar10 - (float10)_DAT_006e97d8) *
             (float10)_DAT_006e9804;
  }
  else {
    fVar11 = (float10)1.4426950408889634 * (float10)fVar9 * (float10)_DAT_006f5910;
    fVar10 = ROUND(fVar11);
    fVar11 = (float10)f2xm1(fVar11 - fVar10);
    fVar10 = (float10)fscale((float10)1 + fVar11,fVar10);
    fVar10 = (fVar10 - (float10)_DAT_006e97d8) * (fVar10 - (float10)_DAT_006e97d8) *
             (float10)_DAT_006f590c;
  }
  local_60 = local_5c;
  local_90 = (float)((float10)_DAT_006e97d8 - fVar10);
  local_7c = local_78;
  fVar10 = (float10)param_1[0xa8] - ((float10)param_1[2] - (float10)_DAT_006e9804);
  fVar11 = (float10)1.4426950408889634 * fVar10 * fVar10 * (float10)_DAT_006f5908;
  fVar10 = ROUND(fVar11);
  fVar11 = (float10)f2xm1(fVar11 - fVar10);
  fVar10 = (float10)fscale((float10)1 + fVar11,fVar10);
  local_c = (float)(fVar10 * (float10)_DAT_006ea4cc + (float10)_DAT_006ed020);
  local_70 = _DAT_006e97d8 / param_1[4];
  local_84 = _DAT_006e97d8 / param_1[5];
  local_80 = local_70 * local_5c;
  local_6c = ABS(param_1[0xbc]);
  if (local_6c < _DAT_006ea620) {
    local_60 = local_6c * local_5c * _DAT_006f4a50;
    local_7c = local_6c * local_78 * _DAT_006f4a50;
  }
  local_78 = 0.0;
  iVar7 = 0;
  local_18 = SQRT(DAT_00bf3a00 + _DAT_006ea4a0) * local_64 * _DAT_006ee5e0;
  local_20 = *(float *)((int)param_1[0x1c] + 0x14) * local_18;
  local_18 = *(float *)((int)param_1[0x1c] + 0x18) * local_18;
  do {
    pfVar1 = param_1 + iVar7 * 0xb + 0x58;
    FUN_005f5890(pfVar1 + 3);
    local_4 = (float)(*(uint *)*pfVar1 ^ *(uint *)pfVar1[2]);
    FUN_005f58a0(pfVar1 + 3);
    pfVar2 = param_1 + iVar7 * 0xb + 0x79;
    FUN_005f5890(pfVar2 + 3);
    local_2c = (float)(*(uint *)*pfVar2 ^ *(uint *)pfVar2[2]);
    FUN_005f58a0(pfVar2 + 3);
    fVar9 = (local_4 - local_2c) * param_1[0x14];
    FUN_005f5890(pfVar1 + 3);
    FUN_00425e80(&local_24,*pfVar1,pfVar1[2],4);
    FUN_005f58a0(pfVar1 + 3);
    local_1c = (local_60 * local_54[iVar7] - fVar9) * local_70 * local_64 + local_24;
    FUN_0051c3f0(&local_1c);
    FUN_005f5890(pfVar2 + 3);
    FUN_00425e80(&local_14,*pfVar2,pfVar2[2],4);
    FUN_005f58a0(pfVar2 + 3);
    local_54[3] = (fVar9 + local_7c) * local_84 * local_64 + local_14;
    FUN_0051c3f0(local_54 + 3);
    FUN_005f5890(pfVar1 + 3);
    local_40 = (float)(*(uint *)*pfVar1 ^ *(uint *)pfVar1[2]);
    FUN_005f58a0(pfVar1 + 3);
    fVar9 = (local_40 - _DAT_0074c954) * local_20 * local_70;
    FUN_005f5890(pfVar1 + 3);
    FUN_00425e80(&local_38,*pfVar1,pfVar1[2],4);
    FUN_005f58a0(pfVar1 + 3);
    local_10 = local_38 - fVar9;
    FUN_0051c3f0(&local_10);
    FUN_005f5890(pfVar2 + 3);
    local_30 = (float)(*(uint *)pfVar2[2] ^ *(uint *)*pfVar2);
    FUN_005f58a0(pfVar2 + 3);
    fVar9 = (local_30 - _DAT_0074c954) * local_18 * local_84;
    FUN_005f5890(pfVar2 + 3);
    FUN_00425e80(&local_28,*pfVar2,pfVar2[2],4);
    FUN_005f58a0(pfVar2 + 3);
    local_8 = local_28 - fVar9;
    FUN_0051c3f0(&local_8);
    FUN_005f5890(pfVar2 + 3);
    local_44 = (float)(*(uint *)*pfVar2 ^ *(uint *)pfVar2[2]);
    FUN_005f58a0(pfVar2 + 3);
    if (param_1[0x16] < local_44) {
      FUN_005f5890(pfVar2 + 3);
      local_3c = *(uint *)pfVar2[1] ^ DAT_00f72118;
      if (local_3c != *(uint *)*pfVar2) {
        do {
          DAT_00f7212c = FUN_005cfcfc();
        } while (DAT_00f7212c == 0);
      }
      uVar8 = FUN_005cfcfc();
      if ((uVar8 & 0x3f) == 0) {
        FUN_004f68c0(pfVar2[2],4);
      }
      FUN_00425e80(*pfVar2,param_1 + 0x16,pfVar2[2],4);
      FUN_00425e80(pfVar2[1],&DAT_00f72118,*pfVar2,4);
      uVar8 = FUN_005cfcfc();
      if ((uVar8 & 0x3ff) == 0) {
        fVar9 = (float)FUN_0051c5d0(pfVar2[2]);
        pfVar2[2] = fVar9;
      }
      uVar8 = FUN_005cfcfc();
      if ((uVar8 & 0x1ff) == 0) {
        fVar9 = (float)FUN_0051c5d0(*pfVar2);
        *pfVar2 = fVar9;
      }
      uVar8 = FUN_005cfcfc();
      if ((uVar8 & 0x7ff) == 0) {
        fVar9 = (float)FUN_0051c5d0(pfVar2[1]);
        pfVar2[1] = fVar9;
      }
      FUN_005f58a0(pfVar2 + 3);
    }
    FUN_005f5890(pfVar1 + 3);
    fStack_34 = (float)(*(uint *)*pfVar1 ^ *(uint *)pfVar1[2]);
    FUN_005f58a0(pfVar1 + 3);
    if (local_78 < fStack_34) {
      FUN_005f5890(pfVar1 + 3);
      fStack_58 = (float)(*(uint *)*pfVar1 ^ *(uint *)pfVar1[2]);
      FUN_005f58a0(pfVar1 + 3);
      local_78 = fStack_58;
    }
    FUN_005f5890(pfVar1 + 3);
    fStack_74 = (float)(*(uint *)*pfVar1 ^ *(uint *)pfVar1[2]);
    FUN_005f58a0(pfVar1 + 3);
    if (param_1[0x16] < fStack_74) {
      FUN_005f5890(pfVar1 + 3);
      fStack_8c = (float)(*(uint *)pfVar1[1] ^ DAT_00f72118);
      if (fStack_8c != *(float *)*pfVar1) {
        do {
          DAT_00f7212c = FUN_005cfcfc();
        } while (DAT_00f7212c == 0);
      }
      uVar8 = FUN_005cfcfc();
      if ((uVar8 & 0x3f) == 0) {
        FUN_004f68c0(pfVar1[2],4);
      }
      FUN_00425e80(*pfVar1,param_1 + 0x16,pfVar1[2],4);
      FUN_00425e80(pfVar1[1],&DAT_00f72118,*pfVar1,4);
      uVar8 = FUN_005cfcfc();
      if ((uVar8 & 0x3ff) == 0) {
        fVar9 = (float)FUN_0051c5d0(pfVar1[2]);
        pfVar1[2] = fVar9;
      }
      uVar8 = FUN_005cfcfc();
      if ((uVar8 & 0x1ff) == 0) {
        fVar9 = (float)FUN_0051c5d0(*pfVar1);
        *pfVar1 = fVar9;
      }
      uVar8 = FUN_005cfcfc();
      if ((uVar8 & 0x7ff) == 0) {
        fVar9 = (float)FUN_0051c5d0(pfVar1[1]);
        pfVar1[1] = fVar9;
      }
      FUN_005f58a0(pfVar1 + 3);
    }
    iVar7 = iVar7 + 1;
  } while (iVar7 < 3);
  pfVar1 = param_1 + 0x84;
  FUN_005f5890(param_1 + 0x87);
  fStack_8c = (float)(*(uint *)param_1[0x86] ^ *(uint *)*pfVar1);
  FUN_005f58a0(param_1 + 0x87);
  FUN_005f5890(param_1 + 0x7c);
  fStack_74 = (float)(*(uint *)param_1[0x79] ^ *(uint *)param_1[0x7b]);
  FUN_005f58a0(param_1 + 0x7c);
  fVar9 = (fStack_8c - fStack_74) * param_1[0x14] * local_84 * local_64 * _DAT_006ea48c;
  FUN_005f5890(param_1 + 0x87);
  FUN_00425e80(&fStack_8c,*pfVar1,param_1[0x86],4);
  FUN_005f58a0(param_1 + 0x87);
  fStack_74 = fStack_8c - fVar9;
  FUN_0051c3f0(&fStack_74);
  FUN_005f5890(param_1 + 0x7c);
  FUN_00425e80(&fStack_8c,param_1[0x79],param_1[0x7b],4);
  FUN_005f58a0(param_1 + 0x7c);
  fStack_74 = fStack_8c + fVar9;
  FUN_0051c3f0(&fStack_74);
  FUN_005f5890(param_1 + 0x87);
  FUN_00425e80(&fStack_8c,*pfVar1,param_1[0x86],4);
  FUN_005f58a0(param_1 + 0x87);
  fStack_74 = fStack_8c;
  FUN_005f5890(param_1 + 0x92);
  FUN_00425e80(&fStack_58,param_1[0x8f],param_1[0x91],4);
  FUN_005f58a0(param_1 + 0x92);
  fVar9 = (fStack_74 - fStack_58) * param_1[0x14] * local_84 * local_64 * _DAT_006ea48c;
  FUN_005f5890(param_1 + 0x87);
  FUN_00425e80(&fStack_8c,*pfVar1,param_1[0x86],4);
  FUN_005f58a0(param_1 + 0x87);
  fStack_74 = fStack_8c - fVar9;
  FUN_0051c3f0(&fStack_74);
  FUN_005f5890(param_1 + 0x92);
  FUN_00425e80(&fStack_8c,param_1[0x8f],param_1[0x91],4);
  FUN_005f58a0(param_1 + 0x92);
  fStack_74 = fStack_8c + fVar9;
  FUN_0051c3f0(&fStack_74);
  fVar9 = local_88;
  if (local_88 != 0.0) {
    local_84 = 0.0;
    local_94 = 0.0;
    local_88 = param_1[0xba] * param_1[0xba] + param_1[0xbc] * param_1[0xbc];
    local_70 = (float)(0xbe7ffffdU - (int)local_88 >> 1);
    fVar3 = (_DAT_006ea494 - local_70 * local_70 * _DAT_006ea44c * local_88) * local_70;
    fVar3 = local_80 /
            ((_DAT_006ea494 - fVar3 * fVar3 * _DAT_006ea44c * local_88) * fVar3 * local_88 +
            _DAT_006f58dc);
    if (_DAT_006f58d4 < fVar3) {
      local_84 = (fVar3 - _DAT_006f58d4) / (_DAT_006f58d8 - _DAT_006f58d4);
    }
    if (param_1[0x16] < local_78) {
      local_94 = (local_68 / _DAT_006f58d0) * (local_78 - param_1[0x16]);
    }
    if (_DAT_006f58c8 < local_80) {
      local_94 = (local_80 - _DAT_006f58c8) / (_DAT_006f58cc - _DAT_006f58c8) + local_94;
    }
    fVar3 = param_1[0xb0];
    if ((&DAT_006f6508)[(int)fVar3] == '\0') {
      *(undefined1 *)(param_1 + 0x28e) = 0;
    }
    if (local_84 <= _DAT_006ea4a4) {
      if (*(char *)(param_1 + 0x28e) != '\0') {
        if ((&DAT_006f6508)[(int)fVar3] != '\0') {
          fVar3 = param_1[0x1b];
          iVar7 = FUN_0055ab00();
          FUN_0054d580(fVar9,*(float *)((int)param_1[0x1c] + 0xc) - _DAT_006ea4a4,param_1 + 0x281,
                       param_1 + 0x28d,param_1 + 0x27b,param_1 + 0x27e,0,(int)fVar3 + iVar7 * 4);
        }
        *(undefined1 *)(param_1 + 0x28e) = 0;
      }
    }
    else {
      if (_DAT_006e97d8 < local_84) {
        local_84 = 1.0;
      }
      if (*(char *)(param_1 + 0x28e) == '\0') {
        if ((&DAT_006f6508)[(int)fVar3] != '\0') {
          *(undefined1 *)(param_1 + 0x28e) = 1;
          FUN_0054d400(fVar9,*(float *)((int)param_1[0x1c] + 0xc) - _DAT_006ea4a4,param_1 + 0x281,
                       param_1 + 0x28d,param_1 + 0x27b,param_1 + 0x27e,0);
        }
      }
      else {
        fVar3 = param_1[0x1b];
        iVar7 = FUN_0055ab00();
        FUN_0054d580(fVar9,*(float *)((int)param_1[0x1c] + 0xc) - _DAT_006ea4a4,param_1 + 0x281,
                     param_1 + 0x28d,param_1 + 0x27b,param_1 + 0x27e,local_84,(int)fVar3 + iVar7 * 4
                    );
      }
    }
    if (_DAT_006ea4a4 < local_94) {
      if (_DAT_006e97d8 < local_94) {
        local_94 = 1.0;
      }
      FUN_00583590(param_1 + 0x27b,param_1 + 0x27e,*(undefined4 *)((int)fVar9 + 0x3c),local_94);
    }
  }
  local_88 = param_1[0x9a] * param_1[0xb3];
  fStack_8c = ABS(local_88);
  FUN_0054f260(local_64,fStack_8c);
  pfVar1 = param_1 + 0x4d;
  FUN_005f5890(param_1 + 0x50);
  FUN_00425e80(&local_88,*pfVar1,param_1[0x4f],4);
  FUN_005f58a0(param_1 + 0x50);
  fStack_8c = local_88 + local_64;
  FUN_0051c3f0(&fStack_8c);
  FUN_005f5890(param_1 + 0x50);
  local_88 = (float)(*(uint *)param_1[0x4f] ^ *(uint *)*pfVar1);
  FUN_005f58a0(param_1 + 0x50);
  if (_DAT_006e9824 < local_88) {
    local_78 = local_54[0];
    if (local_54[0] < local_54[1]) {
      local_78 = local_54[1];
    }
    if (local_78 < local_54[2]) {
      local_78 = local_54[2];
    }
    fStack_8c = ABS(DAT_00c086ac);
    local_88 = fStack_8c * local_6c * _DAT_006ea50c + local_5c;
    FUN_005f5890(param_1 + 0x50);
    uVar8 = *(uint *)*pfVar1;
    uVar4 = *(uint *)param_1[0x4f];
    FUN_005f58a0(param_1 + 0x50);
    FUN_0054e9f0(uVar8 ^ uVar4,local_88 * local_78);
    fStack_8c = 0.0;
    FUN_005f5890(param_1 + 0x50);
    local_88 = (float)(*(uint *)param_1[0x4e] ^ DAT_00f72118);
    if (local_88 != *(float *)*pfVar1) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x3f) == 0) {
      puVar5 = (undefined4 *)param_1[0x4f];
      uVar6 = FUN_005cfcfc();
      *puVar5 = uVar6;
    }
    *(uint *)*pfVar1 = *(uint *)param_1[0x4f] ^ (uint)fStack_8c;
    FUN_00425e80(param_1[0x4e],&DAT_00f72118,*pfVar1,4);
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x3ff) == 0) {
      fVar9 = (float)FUN_0051c5d0(param_1[0x4f]);
      param_1[0x4f] = fVar9;
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x1ff) == 0) {
      fVar9 = (float)FUN_0051c5d0(*pfVar1);
      *pfVar1 = fVar9;
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x7ff) == 0) {
      fVar9 = (float)FUN_0051c5d0(param_1[0x4e]);
      param_1[0x4e] = fVar9;
    }
    FUN_005f58a0(param_1 + 0x50);
  }
  fVar10 = (float10)FUN_005100c0(param_1[0xb0]);
  param_1[0x34] = (float)(fVar10 * (float10)param_1[0x33] * (float10)local_c * (float10)local_90);
  return;
}
