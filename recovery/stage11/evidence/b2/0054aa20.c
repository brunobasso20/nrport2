/* NR2003.exe @ 0054aa20 FUN_0054aa20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

undefined4 FUN_0054aa20(int param_1,ushort *param_2,int param_3,int param_4)

{
  int iVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float *pfVar5;
  float10 fVar6;
  float fVar7;
  double dVar8;
  byte bVar9;
  int iVar10;
  bool bVar11;
  bool bVar12;
  int iVar13;
  float *pfVar14;
  undefined4 uVar15;
  int iVar16;
  uint uVar17;
  uint uVar18;
  bool bVar19;
  float10 fVar20;
  float10 fVar21;
  undefined8 uVar22;
  double dVar23;
  uint local_60;
  uint local_58;
  float local_54;
  float local_48;
  float local_38;
  float local_34;
  float local_30;
  undefined local_2c [4];
  float local_28;
  float local_24;
  float local_20 [4];
  float local_10 [4];
  
  fVar20 = (float10)FUN_00579e50(*(undefined4 *)(param_3 + 0xc));
  fVar21 = (float10)_DAT_00bef700;
  fVar2 = *(float *)(param_3 + 4);
  bVar9 = (char)param_4 * '\x02';
  fVar6 = (float10)_DAT_006ea44c;
  local_54 = 0.0;
  uVar18 = (param_2[1] & 0xfff) >> (bVar9 & 0x1f) & 3;
  switch(uVar18) {
  case 0:
    local_54 = 0.0;
    break;
  case 1:
    local_54 = 0.25;
    break;
  case 2:
    local_54 = 0.5;
    break;
  case 3:
    local_54 = 1.0;
  }
  uVar17 = ((*param_2 & 0x3fc0) >> 6) >> (bVar9 & 0x1f) & 3;
  uVar22 = FUN_00547e00(param_4);
  local_10[0] = 65000.0;
  local_10[1] = 65000.0;
  local_10[2] = 75000.0;
  local_10[3] = 75000.0;
  fVar3 = local_10[param_4];
  local_20[0] = 95000.0;
  bVar19 = (*(uint *)((int)((ulonglong)uVar22 >> 0x20) + 0xc) >> 0x1d & 1 << ((byte)uVar22 & 0x1f) &
           3) != 0;
  local_20[1] = 95000.0;
  local_20[2] = 110000.0;
  local_20[3] = 110000.0;
  fVar4 = local_20[param_4];
  bVar11 = inBackground();
  if (bVar11) {
    iVar13 = FUN_00562f70(param_1);
  }
  else {
    iVar13 = FUN_004f5970(param_1);
  }
  pfVar5 = *(float **)(iVar13 + 0x5ae);
  if (pfVar5 == (float *)0x0) {
    return 0;
  }
  pfVar14 = pfVar5 + 0x16;
  FUN_005f6dc0(&local_38,pfVar14,param_3 + 0x40);
  local_34 = local_34 * _DAT_006ea44c;
  local_30 = local_30 * _DAT_006ea470;
  fVar7 = SQRT(local_38 * local_38 + local_34 * local_34 + local_30 * local_30);
  if (_DAT_006e97d8 < fVar7) {
    fVar7 = _DAT_006e97d8;
  }
  fVar7 = fVar7 * (float)(fVar21 * (float10)fVar2 * fVar20 * fVar6);
  local_60 = uVar17;
  local_58 = uVar18;
  if ((fVar3 < fVar7) && (uVar18 != 3)) {
    local_54 = (_DAT_006e97d8 / fVar4) * (fVar7 - fVar3) + local_54;
    if (_DAT_006e97d8 < local_54) {
      local_54 = _DAT_006e97d8;
    }
    local_58 = 0;
    if (local_54 < _DAT_006ed6c8) {
      if (local_54 < _DAT_006ea44c) {
        if (_DAT_006ea50c <= local_54) {
          local_58 = 2;
        }
      }
      else {
        local_58 = 1;
      }
    }
    else {
      local_58 = 3;
      local_60 = 3;
    }
    FUN_0054b4c0(1);
  }
  bVar11 = bVar19;
  if ((local_60 < 3) && (local_58 < 3)) {
    if (fVar3 < fVar7) {
      rndUniform(0);
      local_60 = FUN_006c5018();
      FUN_0054b4c0(1);
      if (1 < (int)local_60) {
        local_48 = 0.25;
        if (local_60 != 2) {
          local_48 = 0.75;
        }
        dVar23 = rndUniform(0);
        if (dVar23 < (double)local_48) {
          bVar11 = true;
        }
      }
    }
    iVar13 = FUN_0055ab00();
    if ((((param_1 == iVar13) && ((int)local_60 < 3)) && (local_60 == uVar17)) &&
       (_DAT_006f5870 < fVar7)) {
      fVar2 = (fVar7 - _DAT_006f5870) * (_DAT_006e97d8 / (fVar3 * _DAT_006ed070));
      if (_DAT_006e97d8 < fVar2) {
        fVar2 = _DAT_006e97d8;
      }
      fVar2 = fVar2 * fVar2 * _DAT_006f586c + _DAT_006eebb8;
      bVar12 = inServer();
      if (bVar12) {
        iVar13 = FUN_004f5970(param_1);
      }
      else {
        iVar13 = FUN_00562f70(param_1);
      }
      fVar3 = *(float *)(*(int *)(iVar13 + 0x58a) + 0x98);
      dVar23 = rndUniform(0);
      dVar23 = dVar23 * (double)fVar3;
      dVar8 = (double)fVar2 * (double)_DAT_00bef700;
      if (dVar23 < dVar8 != (NAN(dVar23) || NAN(dVar8))) {
        local_60 = local_60 + 1;
      }
    }
    if (3 < (int)local_60) {
      local_60 = 3;
    }
  }
  if (((local_58 <= uVar18) && ((int)local_60 <= (int)uVar17)) && ((bVar11 == false || (bVar19)))) {
    return 0;
  }
  bVar19 = inBackground();
  if (bVar19) {
    uVar15 = FUN_00562f70(param_1);
    FUN_00592dc0(uVar15,1);
  }
  iVar13 = DAT_00bf39e8;
  if (DAT_00bf39e8 < 0x10) {
    iVar1 = DAT_00bf39e8 * 0x34;
    iVar16 = DAT_00bf39e8 * 0xd;
    iVar10 = DAT_00bf39e8 * 0xd;
    DAT_00bf39e8 = DAT_00bf39e8 + 1;
    (&DAT_00bef3c4)[iVar10] = local_60;
    (&DAT_00bef3c0)[iVar13 * 0xd] = local_58;
    (&DAT_00bef3c8)[iVar13 * 0xd] = (uint)(bVar11 != false);
    (&DAT_00bef3e8)[iVar13 * 0xd] = param_3;
    (&DAT_00bef3bc)[iVar13 * 0xd] = param_4;
    (&DAT_00bef3b8)[iVar16] = param_1;
    if (local_58 == 3) {
      FUN_00563430(local_2c,param_4);
      FUN_005f6d20(local_20,pfVar14,local_2c);
      local_20[0] = *pfVar5 + local_20[0];
      local_20[1] = pfVar5[1] + local_20[1];
      local_20[2] = pfVar5[2] + local_20[2];
      if (local_28 <= _DAT_006ea454) {
        local_28 = local_28 + _DAT_006e9824;
      }
      else {
        local_28 = local_28 - _DAT_006e9824;
      }
      local_24 = local_24 + _DAT_006ee4c8;
      FUN_005f6d20(local_10,pfVar14,local_2c);
      local_10[0] = *pfVar5 + local_10[0];
      local_10[1] = pfVar5[1] + local_10[1];
      local_10[2] = pfVar5[2] + local_10[2];
      iVar13 = FUN_005b2180();
      iVar16 = FUN_00555140();
      *(float *)(&DAT_00bef3cc + iVar1) = local_20[0];
      *(float *)(&DAT_00bef3d0 + iVar1) = local_20[1];
      *(float *)(&DAT_00bef3d4 + iVar1) = local_20[2];
      *(float *)(&DAT_00bef3d8 + iVar1) = local_10[0];
      *(float *)(&DAT_00bef3dc + iVar1) = local_10[1];
      *(float *)(&DAT_00bef3e0 + iVar1) = local_10[2];
      *(float *)(&DAT_00bef3e4 + iVar1) = _DAT_006e97d8 - (float)iVar13 / (float)(iVar16 + -1);
    }
  }
  FUN_0054b9b0(param_4,local_60);
  FUN_0054b970(param_4,local_58);
  FUN_0054ba50((int)uVar22,bVar11);
  return 1;
}

