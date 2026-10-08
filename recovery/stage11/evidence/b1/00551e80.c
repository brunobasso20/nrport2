/* NR2003.exe @ 00551e80 FUN_00551e80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00551e80(void)

{
  float fVar1;
  char cVar2;
  int iVar3;
  undefined4 uVar4;
  int iVar5;
  undefined4 *puVar6;
  uint uVar7;
  undefined4 *puVar8;
  bool bVar9;
  float10 fVar10;
  float10 fVar11;
  float10 fVar12;
  float10 fVar13;
  undefined4 local_18;
  uint local_14;
  undefined4 local_10;
  undefined4 local_c;
  undefined4 local_8;
  undefined4 local_4;
  
  DAT_00bf6f28 = DAT_00bf6f28 + -1;
  if (DAT_00bf6f28 < 0) {
    DAT_00bf6f28 = 0;
  }
  else if (0 < DAT_00bf6f28) {
    fVar10 = (float10)FUN_00554f50();
    if (((float10)_DAT_006ed67c < fVar10) && (DAT_00b8fac5 == '\0')) {
      FUN_00538b00();
      iVar3 = FUN_005398d0();
      if (iVar3 != 4) {
        fVar1 = 0.0;
        uVar4 = FUN_0055ab00();
        iVar3 = FUN_00562f70(uVar4);
        if (*(int *)(iVar3 + 0x5ae) != 0) {
          fVar10 = (float10)FUN_00516e5a(*(int *)(iVar3 + 0x5ae));
          fVar1 = (float)ABS(fVar10 * (float10)_DAT_006ed00c);
          if ((float10)_DAT_006e97d8 < ABS(fVar10 * (float10)_DAT_006ed00c)) {
            fVar1 = 1.0;
          }
        }
        fVar10 = (float10)FUN_00555050();
        fVar10 = (fVar10 * (float10)_DAT_006f59d8 + (float10)_DAT_006f59dc) * (float10)fVar1 +
                 (float10)_DAT_00bf6f2c;
        goto LAB_00551eb7;
      }
    }
  }
  fVar10 = (float10)FUN_00555050();
  fVar10 = (float10)_DAT_00bf6f2c -
           (((float10)_DAT_006e97d8 - fVar10) * (float10)_DAT_006f59e0 + (float10)_DAT_006f59dc);
LAB_00551eb7:
  _DAT_00bf6f2c = (float)fVar10;
  if (_DAT_00bf6f2c <= _DAT_006ea494) {
    if (_DAT_00bf6f2c < _DAT_006ea454 != (NAN(_DAT_00bf6f2c) || NAN(_DAT_006ea454))) {
      _DAT_00bf6f2c = 0.0;
    }
  }
  else {
    _DAT_00bf6f2c = 1.5;
  }
  iVar3 = FUN_005c2d20(DAT_00c08194);
  if (iVar3 == 1) {
    uVar4 = FUN_0055ab00();
    iVar3 = FUN_004f5970(uVar4);
    uVar4 = FUN_0055ab00();
    iVar5 = FUN_00562f70(uVar4);
    if ((iVar5 != 0) && (iVar3 != 0)) {
      puVar6 = (undefined4 *)FUN_00592db0(iVar5);
      uVar4 = FUN_0055ab00();
      uVar4 = FUN_00567610(uVar4);
      cVar2 = FUN_00547f20(puVar6,uVar4);
      if (cVar2 == '\0') {
        local_18 = FUN_00544be0();
        uVar7 = FUN_00509990();
        local_14 = local_14 ^ (uVar7 ^ local_14) & 0xfffffff;
        iVar3 = FUN_005099a0();
        local_10 = *puVar6;
        local_4 = puVar6[3];
        local_14 = local_14 & 0xfffffff ^ iVar3 << 0x1c;
        local_c = puVar6[1];
        local_8 = puVar6[2];
        puVar6 = &local_18;
        FUN_00538ad0(puVar6);
        FUN_0053eed0(puVar6);
      }
    }
  }
  cVar2 = FUN_00551880();
  if (cVar2 != '\0') {
    FUN_005524f0();
    _DAT_00bf63c0 = -_DAT_00bf63c8;
    _DAT_00bf3ccc = 0;
    _DAT_00bf3cd0 = 0;
    DAT_00bf3cd4 = 0;
    _DAT_00bf3cd8 = 0;
    DAT_00bf3cf0 = 0;
    DAT_00bf3cf4 = 0;
    DAT_00bf3cdc = 0;
    DAT_00bf3ce0 = 0;
    _DAT_00bf4705 = 0;
    _DAT_00bf4709 = 0;
    DAT_00bf470d = 0;
    _DAT_00bf4711 = 0;
    _DAT_00bf4729 = 0;
    _DAT_00bf472d = 0;
    _DAT_00bf4715 = 0;
    DAT_00bf4719 = 0;
    _DAT_00bf513e = 0;
    _DAT_00bf5142 = 0;
    DAT_00bf5146 = 0;
    _DAT_00bf514a = 0;
    _DAT_00bf5162 = 0;
    _DAT_00bf5166 = 0;
    _DAT_00bf514e = 0;
    _DAT_00bf5152 = 0;
    _DAT_00bf5b77 = 0;
    _DAT_00bf5b7b = 0;
    DAT_00bf5b7f = 0;
    _DAT_00bf5b83 = 0;
    _DAT_00bf5b9b = 0;
    _DAT_00bf5b9f = 0;
    _DAT_00bf5b87 = 0;
    _DAT_00bf5b8b = 0;
    FUN_005524b0();
    fVar10 = (float10)FUN_00552410();
    if ((NAN(fVar10) || NAN((float10)_DAT_006ea454)) == (fVar10 == (float10)_DAT_006ea454)) {
      cVar2 = FUN_0057af60(7);
      if (cVar2 == '\0') {
        cVar2 = FUN_0057af60(8);
        if (cVar2 == '\0') {
          if (_DAT_00bf63c0 <= _DAT_006ea454) {
            FUN_00552410();
            fVar10 = (float10)FUN_006c5c40();
            fVar10 = -fVar10;
          }
          else {
            FUN_00552410();
            fVar10 = (float10)FUN_006c5c40();
          }
          _DAT_00bf63c0 = (float)fVar10;
        }
      }
    }
    fVar1 = _DAT_00bf63c0 * _DAT_006f4a4c;
    fVar11 = (float10)FUN_00554fb0();
    fVar11 = (float10)fVar1 / fVar11;
    _DAT_00bf6e38 = DAT_00bf6eb0;
    _DAT_00bf63c0 = DAT_00bf6e80;
    DAT_00bf636c = DAT_00bf6e64;
    DAT_00bf6ea4 = DAT_00bf6e60;
    bVar9 = DAT_00bf6f0c != 2;
    _DAT_00bf6e14 = DAT_00bf6e68;
    _DAT_00bf63b8 = (float)fVar11;
    _DAT_00bf6e30 = _DAT_00bf6390 * _DAT_00bf6390;
    _DAT_00bf6e34 = _DAT_00bf6eac * _DAT_00bf6eac;
    fVar12 = (float10)DAT_00bf6e9c;
    _DAT_00bf6e88 = (float)((fVar11 - (float10)DAT_00bf6e80) / fVar12);
    _DAT_00bf6394 = (float)(((float10)_DAT_00bf6e30 - (float10)DAT_00bf6e60) / fVar12);
    _DAT_00bf6358 = (float)(((float10)_DAT_00bf6e34 - (float10)DAT_00bf6e64) / fVar12);
    fVar13 = (float10)DAT_00bf6eb0;
    fVar10 = (float10)DAT_00bf6e68;
    puVar6 = &DAT_00bf6e28;
    puVar8 = &DAT_00bf6e58;
    for (iVar3 = 9; iVar3 != 0; iVar3 = iVar3 + -1) {
      *puVar8 = *puVar6;
      puVar6 = puVar6 + 1;
      puVar8 = puVar8 + 1;
    }
    _DAT_00bf6e50 = (float)((fVar13 - fVar10) / fVar12);
    DAT_00bf6e80 = (float)fVar11;
    if ((bVar9) && (DAT_00bf63cc == 0)) {
      cVar2 = FUN_00552400();
      if (cVar2 != '\0') {
        FUN_005536b0();
        DAT_00bf63de = DAT_00bf63de + 1;
        return;
      }
      if (DAT_00bf6f0c == 0) {
        iVar3 = (uint)(DAT_00bf6e20 != '\0') - (uint)(DAT_00bf6e21 != '\0');
      }
      else {
        iVar3 = 0;
        if (DAT_00bf6e22 != '\0') {
          if (DAT_0074c97c < DAT_00bf6e23) {
            iVar3 = 1;
          }
          else if (DAT_00bf6e23 < DAT_0074c97c) {
            iVar3 = -1;
          }
        }
      }
      DAT_00bf6e20 = '\0';
      DAT_00bf6e21 = '\0';
      DAT_00bf6e22 = '\0';
      if (iVar3 != 0) {
        if (0 < iVar3) {
          FUN_00552450();
          DAT_00bf63de = DAT_00bf63de + 1;
          return;
        }
        FUN_00552480();
      }
    }
    DAT_00bf63de = DAT_00bf63de + 1;
  }
  return;
}

