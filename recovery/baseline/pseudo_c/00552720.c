/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00552720 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00552720(void)

{
  float fVar1;
  float fVar2;
  bool bVar3;
  char cVar4;
  undefined4 uVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  float10 fVar10;
  float10 fVar11;
  undefined1 *puVar12;
  float fStack_44;
  float fStack_40;
  float local_3c;
  float local_38;
  float fStack_34;
  float local_30;
  float local_2c;
  float local_28;
  undefined1 local_24 [4];
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  fVar10 = (float10)FUN_00554f50();
  if ((float10)_DAT_006ea4a4 <= fVar10) {
    local_38 = (float)fVar10;
  }
  else {
    local_38 = 0.01;
  }
  local_28 = ABS(DAT_00bf6d70);
  fVar1 = local_28;
  if (local_28 < _DAT_006ea4a4) {
    fVar1 = _DAT_006ea4a4;
  }
  local_2c = (float)((float10)local_38 * (float10)local_38);
  fVar11 = (float10)1.4426950408889634 *
           (float10)local_38 * (float10)local_38 * (float10)_DAT_006f59fc;
  fVar10 = ROUND(fVar11);
  fVar11 = (float10)f2xm1(fVar11 - fVar10);
  fVar10 = (float10)fscale((float10)1 + fVar11,fVar10);
  local_10 = (float)fVar10;
  fVar2 = _DAT_006f59f8 / local_38;
  if (fVar1 < _DAT_006f59f8 / local_38) {
    fVar2 = fVar1;
  }
  local_14 = (fVar2 / fVar1) * _DAT_006ed020 + _DAT_006ea4cc;
  fVar10 = (float10)FUN_00552410();
  local_3c = (float)(fVar10 * (float10)_DAT_006ee4c4 * (float10)local_10 +
                    ((float10)_DAT_006e97d8 - fVar10 * (float10)_DAT_006ee4c4));
  fVar10 = (float10)FUN_00552d00(8);
  local_10 = (float)fVar10;
  fVar10 = (float10)FUN_00552d00(7);
  local_28 = (float)(((float10)local_10 - fVar10) * (float10)local_3c);
  cVar4 = FUN_0055a770();
  if (cVar4 != '\0') {
    local_28 = local_28 * local_14;
  }
  fVar10 = (float10)FUN_00550230();
  if ((float10)_DAT_006ea454 < fVar10) {
    fVar11 = (float10)1.4426950408889634 * (float10)local_2c * (float10)_DAT_006f59f4;
    fVar10 = ROUND(fVar11);
    fVar11 = (float10)f2xm1(fVar11 - fVar10);
    fVar10 = (float10)fscale((float10)1 + fVar11,fVar10);
    local_30 = (float)(fVar10 * (float10)_DAT_006e981c + (float10)_DAT_006ef640);
    fVar11 = (float10)1.4426950408889634 * (float10)local_2c * (float10)_DAT_006f59f0;
    fVar10 = ROUND(fVar11);
    fVar11 = (float10)f2xm1(fVar11 - fVar10);
    fVar10 = (float10)fscale((float10)1 + fVar11,fVar10);
    local_4 = (float)fVar10;
    fVar10 = (float10)FUN_0057af30(8);
    local_10 = (float)fVar10;
    fVar10 = (float10)FUN_0057af30(7);
    local_2c = (float)((float10)local_10 - fVar10);
    cVar4 = FUN_0057af60(7);
    if ((cVar4 == '\0') && (cVar4 = FUN_0057af60(8), cVar4 == '\0')) {
      DAT_00bf63bc = local_3c * local_2c;
      local_18 = 15.0;
    }
    else {
      fVar1 = _DAT_006ed000 / (local_38 + _DAT_006ed000);
      _DAT_00bf638c =
           ((local_2c * fVar1 - DAT_00bf63bc) * fVar1 * _DAT_006ea48c -
           SQRT(fVar1) * _DAT_00bf638c * _DAT_006ee778) + _DAT_00bf638c;
      DAT_00bf63bc = _DAT_00bf638c + DAT_00bf63bc;
      if (DAT_00bf63bc <= _DAT_006e97d8) {
        if (DAT_00bf63bc < _DAT_006ea4a8) {
          DAT_00bf63bc = -1.0;
        }
      }
      else {
        DAT_00bf63bc = 1.0;
      }
      local_18 = 10.0;
    }
    local_10 = DAT_00bf63bc;
    uVar5 = FUN_0055ab00();
    iVar6 = FUN_00562f70(uVar5);
    iVar6 = *(int *)(iVar6 + 0x5ae);
    if (iVar6 == 0) {
      fVar10 = (float10)_DAT_006ea454;
      local_2c = 0.0;
    }
    else {
      local_2c = *(float *)(iVar6 + 0x40);
      local_c = *(float *)(iVar6 + 0x48);
      local_8 = *(float *)(iVar6 + 0x94);
      local_1c = *(float *)(iVar6 + 0x3c) * _DAT_00bf6df8;
      fVar1 = ROUND(local_1c);
      puVar12 = local_24;
      iVar9 = (int)fVar1 * 0x1c;
      local_20 = *(float *)(iVar9 + 0x14 + DAT_00bd7960) - local_2c;
      FUN_00538b20(puVar12);
      uVar5 = FUN_00540440();
      iVar7 = FUN_00536180(uVar5,puVar12);
      iVar8 = FUN_00536260(iVar7);
      cVar4 = *(char *)(iVar8 + 8);
      bVar3 = false;
      PTR_DAT_0074c988 = (&PTR_DAT_0074bb5c)[iVar7];
      if (*(char *)(iVar8 + 9) != '\0') {
        (**(code **)(*(int *)PTR_DAT_0074c988 + 0xc))
                  (0,&local_38,&local_3c,(int)fVar1,*(undefined4 *)(iVar6 + 0x40));
        fVar1 = local_3c;
        if (cVar4 != '\0') {
          fVar1 = local_38;
        }
        bVar3 = true;
        if (_DAT_006ea454 <= fVar1) {
          bVar3 = false;
        }
      }
      local_1c = *(float *)(*(int *)(PTR_DAT_0074c988 + 0xc) + 0x14 + iVar9) - local_2c;
      cVar4 = FUN_00535530(iVar6);
      if (((cVar4 != '\0') || (local_20 * local_20 < local_1c * local_1c)) || (bVar3)) {
        PTR_DAT_0074c988 = (undefined *)&DAT_00bd7954;
      }
      if (_DAT_00bf6f14 != PTR_DAT_0074c988) {
        _DAT_00bf6f14 = PTR_DAT_0074c988;
        _DAT_0074c98c = _DAT_006ea454;
      }
      _DAT_0074c98c = _DAT_0074c98c + _DAT_006ea4a4;
      if (_DAT_006e97d8 < _DAT_0074c98c) {
        _DAT_0074c98c = 1.0;
      }
      fStack_44 = *(float *)(*(int *)(PTR_DAT_0074c988 + 0xc) + 0x14 + iVar9);
      local_38 = 0.0;
      local_3c = 0.0;
      fVar1 = (local_2c - fStack_44) * _DAT_006f3e30;
      if (fVar1 < _DAT_006ea454) {
        local_38 = -fVar1;
        fVar1 = local_3c;
      }
      local_3c = fVar1;
      FUN_00527580(*(undefined4 *)(iVar6 + 0x3c),*(undefined4 *)(iVar6 + 0x44),local_38,local_3c,
                   &fStack_44,&fStack_34,&fStack_40);
      fStack_40 = fStack_40 * *(float *)(iVar6 + 0x44);
      fVar10 = (float10)local_2c;
      fVar1 = (local_8 - fStack_40) * _DAT_006f59e8;
      if (fStack_40 <= _DAT_006ea454) {
        if (local_30 < fVar1) {
          fVar1 = local_30;
        }
      }
      else if (fVar1 < -local_30) {
        fVar1 = -local_30;
      }
      local_2c = (fVar1 - _DAT_00bf6e84) * _DAT_006ef640 + _DAT_00bf6e84;
      fVar10 = ((((fVar10 - (float10)(fStack_44 - local_10 * local_18)) * (float10)_DAT_006ee4c4 +
                 ((float10)local_c - (float10)(fStack_34 * *(float *)(iVar6 + 0x44))) *
                 (float10)_DAT_006f59ec) -
                (float10)fStack_40 * (float10)*(float *)(iVar6 + 0x44) * (float10)_DAT_006f58e0) *
                (float10)local_14 - (float10)_DAT_00bf6388) * (float10)_DAT_0074c98c *
               (float10)_DAT_006ef640 + (float10)_DAT_00bf6388;
    }
    _DAT_00bf6388 = (float)fVar10;
    _DAT_00bf6e84 = local_2c;
    fVar10 = (float10)local_10 * (float10)local_30 +
             ((float10)_DAT_006e97d8 - (float10)local_30) * fVar10 +
             ((float10)_DAT_006e97d8 - (float10)local_4) * (float10)local_2c;
    if (fVar10 <= (float10)_DAT_006e97d8) {
      if (fVar10 < (float10)_DAT_006ea4a8) {
        fVar10 = (float10)_DAT_006ea4a8;
      }
    }
    else {
      fVar10 = (float10)_DAT_006e97d8;
    }
    return (float10)_DAT_00bf6f08 * fVar10 +
           ((float10)_DAT_006e97d8 - (float10)_DAT_00bf6f08) * (float10)local_28;
  }
  return (float10)local_28;
}


