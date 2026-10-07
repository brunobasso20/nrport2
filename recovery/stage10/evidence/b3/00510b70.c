/* NR2003.exe @ 00510b70 FUN_00510b70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00510b70(int param_1)

{
  int *piVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  int iVar5;
  float10 fVar6;
  float10 fVar7;
  float fStack_90;
  float fStack_8c;
  float fStack_88;
  float fStack_84;
  int iStack_80;
  undefined auStack_6c [108];
  
  iVar4 = FUN_005cfce4(&DAT_00bcf734,*(int *)(param_1 + 0x10) * 0x1550);
  if (iVar4 == 0) {
    return 0;
  }
  FUN_0056772e(auStack_6c,1,3);
  iVar4 = 0;
  DAT_00bad918 = 0.0;
  DAT_00bad920 = *(int *)(param_1 + 0x10);
  iVar5 = 0;
  iStack_80 = 0;
  fStack_90 = 1e+10;
  fStack_8c = -1e+10;
  fStack_84 = 1e+10;
  fStack_88 = -1e+10;
  if (0 < DAT_00bad920) {
    do {
      piVar1 = (int *)(iVar4 + DAT_00bcf734);
      fVar6 = (float10)FUN_00510f00(*(undefined4 *)(*(int *)(param_1 + 0xc) + iVar5 * 4),
                                    DAT_00bad918,iVar5);
      DAT_00bad918 = (float)fVar6;
      iStack_80 = iStack_80 + 1;
      fVar2 = (float)piVar1[0x2c];
      if (*piVar1 == 1) {
        fVar3 = fVar2 * (float)piVar1[0x10] + (float)piVar1[2] * (float)piVar1[0x11] * _DAT_006ea454
                + (float)piVar1[0xc];
        fVar2 = fVar2 * (float)piVar1[0x11] +
                ((float)piVar1[0xd] - (float)piVar1[2] * (float)piVar1[0x10] * _DAT_006ea454);
      }
      else {
        fVar7 = (float10)((float)piVar1[0x14] * _DAT_006ea454 + (float)piVar1[0x13]);
        fVar6 = (float10)fcos(fVar7);
        fVar7 = (float10)fsin(fVar7);
        fVar3 = (float)fVar7 * ((float)piVar1[0x11] - fVar2) + (float)piVar1[0xc];
        fVar2 = (float)piVar1[0xd] - (float)fVar6 * ((float)piVar1[0x11] - fVar2);
      }
      if (fStack_8c < fVar3) {
        fStack_8c = fVar3;
      }
      if (fVar3 < fStack_90 != (NAN(fVar3) || NAN(fStack_90))) {
        fStack_90 = fVar3;
      }
      if (fStack_88 < fVar2) {
        fStack_88 = fVar2;
      }
      if (fVar2 < fStack_84 != (NAN(fVar2) || NAN(fStack_84))) {
        fStack_84 = fVar2;
      }
      fVar2 = (float)piVar1[piVar1[0x15] * 0x12 + 0x1a];
      if (*piVar1 == 1) {
        fVar3 = fVar2 * (float)piVar1[0x10] + (float)piVar1[2] * (float)piVar1[0x11] * _DAT_006ea454
                + (float)piVar1[0xc];
        fVar2 = fVar2 * (float)piVar1[0x11] +
                ((float)piVar1[0xd] - (float)piVar1[2] * (float)piVar1[0x10] * _DAT_006ea454);
      }
      else {
        fVar7 = (float10)((float)piVar1[0x14] * _DAT_006ea454 + (float)piVar1[0x13]);
        fVar6 = (float10)fcos(fVar7);
        fVar7 = (float10)fsin(fVar7);
        fVar3 = (float)fVar7 * ((float)piVar1[0x11] - fVar2) + (float)piVar1[0xc];
        fVar2 = (float)piVar1[0xd] - (float)fVar6 * ((float)piVar1[0x11] - fVar2);
      }
      if (fStack_8c < fVar3) {
        fStack_8c = fVar3;
      }
      if (fVar3 < fStack_90 != (NAN(fVar3) || NAN(fStack_90))) {
        fStack_90 = fVar3;
      }
      if (fStack_88 < fVar2) {
        fStack_88 = fVar2;
      }
      if (fVar2 < fStack_84 != (NAN(fVar2) || NAN(fStack_84))) {
        fStack_84 = fVar2;
      }
      iVar5 = iVar5 + 1;
      iVar4 = iVar4 + 0x1550;
    } while (iVar5 < DAT_00bad920);
    if (0 < iStack_80) {
      _DAT_00bcf6f8 =
           (SQRT((fStack_8c - fStack_90) * (fStack_88 - fStack_84) * DAT_00bad918) *
           (float)_DAT_006f4628) / (float)iStack_80 + _DAT_006ed00c;
      goto LAB_00510e37;
    }
  }
  _DAT_00bcf6f8 = 100.0;
LAB_00510e37:
  _DAT_00bad934 = DAT_00bad918 * _DAT_006ea44c;
  _DAT_00ba7218 = -_DAT_00bad934;
  _DAT_00bad910 = _DAT_006f4620 / (DAT_00bad918 + _DAT_006ea478);
  if (_DAT_006f461c < _DAT_00bad910) {
    _DAT_00bad910 = 1024.0;
  }
  _DAT_00bcf6f0 = _DAT_006e97d8 / _DAT_00bad910;
  FUN_00516e1a();
  DAT_00b9cbb4 = FUN_006c5018();
  iVar4 = 0;
  _DAT_00b9cf58 = DAT_00b9cbb4 >> 1;
  DAT_00bb3f54 = -_DAT_00b9cf58;
  if (0 < DAT_00bad920) {
    do {
      FUN_0051208a(iVar4);
      iVar4 = iVar4 + 1;
    } while (iVar4 < DAT_00bad920);
  }
  FUN_0056775d(auStack_6c);
  return 1;
}

