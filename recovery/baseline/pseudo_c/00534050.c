/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00534050 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00534050(float param_1,float param_2,float param_3,char param_4)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  char cVar5;
  bool bVar6;
  bool bVar7;
  bool bVar8;
  int iVar9;
  int iVar10;
  uint uVar11;
  int iVar12;
  int iVar13;
  int iVar14;
  int iVar15;
  int iVar16;
  int extraout_ECX;
  int extraout_ECX_00;
  undefined *puVar17;
  int iVar18;
  int iVar19;
  float10 extraout_ST0;
  float10 extraout_ST0_00;
  float10 extraout_ST0_01;
  float10 extraout_ST0_02;
  float10 extraout_ST0_03;
  int unaff_retaddr;
  float fStack_24;
  float fStack_20;
  int iStack_1c;
  int iStack_18;
  int iStack_10;
  
  iVar12 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
  iVar13 = FUN_005337e0(*(float *)((int)param_1 + 0x1886) -
                        *(float *)(*(int *)(iVar12 + 0xc) + 0x14 +
                                  *(int *)((int)param_1 + 0x186e) * 0x1c));
  iVar12 = FUN_005337e0(param_1);
  iVar14 = FUN_005337e0(param_2);
  fVar1 = _DAT_006ee5e0;
  if (iVar14 < iVar12) {
    iVar14 = (iVar14 + iVar12) / 2;
    iVar12 = iVar14;
  }
  if (iVar13 < iVar12) {
    iVar13 = iVar12;
  }
  if (iVar14 < iVar13) {
    iVar13 = iVar14;
  }
  fStack_20 = *(float *)(PTR_DAT_0074bf4c + iVar13 * 4);
  fStack_24 = 0.0;
  param_1 = fStack_20;
  param_2 = fStack_20;
  iVar18 = iVar12;
  DAT_00bdaf6c = iVar13;
  iStack_18 = iVar13;
  fVar3 = _DAT_006ea454;
  fVar4 = _DAT_006ea454;
  fVar2 = _DAT_006ee5e0;
  puVar17 = PTR_DAT_0074bf4c;
  for (iVar16 = iVar13 + -1; iVar12 <= iVar16; iVar16 = iVar16 + -1) {
    if (((iVar18 == iVar12) && (*(float *)(PTR_DAT_0074bf54 + iVar16 * 4) < fVar2)) &&
       (iVar16 < iVar13 + -1)) {
      fStack_24 = -0.0015124;
      iVar18 = iVar16;
    }
    if ((*(float *)(puVar17 + iVar16 * 4) < param_1) &&
       (param_1 = *(float *)(puVar17 + iVar16 * 4), param_1 < param_2 - _DAT_006e9818)) {
      fVar4 = (param_1 - param_2) * _DAT_006ea44c;
    }
    fVar3 = fVar3 + fStack_24;
    if (param_2 < fVar4 + *(float *)(puVar17 + iVar16 * 4) + fVar3) {
      param_2 = *(float *)(puVar17 + iVar16 * 4);
      DAT_00bdaf6c = iVar16;
      iStack_18 = iVar16;
    }
    if ((iVar18 < iVar16) && (*(int *)(PTR_DAT_0074bf50 + iVar16 * 4) == 0)) {
      *(undefined1 *)(unaff_retaddr + 0x16b7) = 0;
      puVar17 = PTR_DAT_0074bf4c;
    }
    fVar2 = _DAT_00bdb20c + fVar2;
  }
  fStack_24 = 0.0;
  param_1 = fStack_20;
  iStack_1c = iVar14;
  iStack_10 = iVar13;
  fVar2 = _DAT_006ea454;
  fVar3 = _DAT_006ea454;
  iVar15 = DAT_00bdaf6c;
  for (iVar16 = iVar13 + 1; DAT_00bdaf6c = iVar15, iVar16 <= iVar14; iVar16 = iVar16 + 1) {
    if (((iStack_1c == iVar14) && (*(float *)(PTR_DAT_0074bf54 + iVar16 * 4) < fVar1)) &&
       (iVar13 + 1 < iVar16)) {
      fStack_24 = -0.0015124;
      iStack_1c = iVar16;
    }
    if ((*(float *)(puVar17 + iVar16 * 4) < param_1) &&
       (param_1 = *(float *)(puVar17 + iVar16 * 4), param_1 < fStack_20 - _DAT_006e9818)) {
      fVar3 = (param_1 - fStack_20) * _DAT_006ea44c;
    }
    fVar2 = fVar2 + fStack_24;
    if ((fStack_20 < fVar3 + *(float *)(puVar17 + iVar16 * 4) + fVar2) &&
       (fStack_20 = *(float *)(puVar17 + iVar16 * 4), iStack_10 = iVar16,
       param_2 < fVar2 + *(float *)(puVar17 + iVar16 * 4))) {
      param_2 = *(float *)(puVar17 + iVar16 * 4);
      DAT_00bdaf6c = iVar16;
    }
    if ((iVar16 < iStack_1c) && (*(int *)(PTR_DAT_0074bf50 + iVar16 * 4) == 0)) {
      *(undefined1 *)(unaff_retaddr + 0x16b7) = 0;
      puVar17 = PTR_DAT_0074bf4c;
    }
    fVar1 = _DAT_00bdb208 + fVar1;
    iVar15 = DAT_00bdaf6c;
  }
  uVar11 = (uint)param_1 >> 8;
  param_1 = (float)((uint)param_1 & 0xffffff00);
  cVar5 = '\0';
  bVar7 = false;
  fVar1 = *(float *)(puVar17 + iStack_10 * 4);
  if (DAT_00bdb224 < *(float *)(puVar17 + iStack_10 * 4)) {
    fVar1 = DAT_00bdb224;
  }
  iVar16 = iStack_10;
  do {
    iVar9 = iVar16;
    iVar16 = iVar9 + 1;
    if (iVar14 < iVar16) goto LAB_00534387;
  } while (fVar1 - _DAT_006f52e0 <= *(float *)(puVar17 + iVar16 * 4));
  param_1 = (float)CONCAT31((int3)uVar11,1);
LAB_00534387:
  iVar16 = iStack_10;
  if (param_4 != '\0') {
    param_1 = (float)CONCAT31(param_1._1_3_,1);
  }
  do {
    iVar10 = iVar16;
    iVar16 = iVar10 + -1;
    if (iVar16 < iVar12) goto LAB_005343b7;
  } while (fVar1 - _DAT_006f52e0 <= *(float *)(puVar17 + iVar16 * 4));
  bVar7 = true;
LAB_005343b7:
  if (param_3._0_1_ != '\0') {
    bVar7 = true;
  }
  bVar8 = false;
  iVar19 = iVar10;
  iVar16 = iVar9;
  param_2._0_1_ = param_1._0_1_;
  bVar6 = bVar7;
  if (iStack_18 != iVar13) {
    fVar1 = *(float *)(puVar17 + iStack_18 * 4);
    if (DAT_00bdb224 < *(float *)(puVar17 + iStack_18 * 4)) {
      fVar1 = DAT_00bdb224;
    }
    iVar13 = iStack_18;
    do {
      iVar16 = iVar13;
      iVar13 = iVar16 + 1;
      if (iVar14 < iVar13) goto LAB_0053441b;
    } while (fVar1 - _DAT_006f52e0 <= *(float *)(puVar17 + iVar13 * 4));
    cVar5 = '\x01';
LAB_0053441b:
    param_2._0_1_ = cVar5;
    if (param_4 != '\0') {
      param_2._0_1_ = '\x01';
    }
    do {
      iVar19 = iStack_18;
      iStack_18 = iVar19 + -1;
      if (iStack_18 < iVar12) goto LAB_00534457;
    } while (fVar1 - _DAT_006f52e0 <= *(float *)(puVar17 + iStack_18 * 4));
    bVar8 = true;
LAB_00534457:
    bVar6 = bVar8;
    if (param_3._0_1_ != '\0') {
      bVar6 = true;
    }
  }
  if (iVar15 == iStack_10) {
    if (param_1._0_1_ == '\0') {
LAB_005344bb:
      _DAT_00bdaa4c = 10000.0;
      iVar12 = iStack_10;
    }
    else {
      iVar15 = FUN_00533810(iVar9);
      _DAT_00bdaa4c = (float)extraout_ST0;
      iVar12 = extraout_ECX;
    }
  }
  else {
    if (param_2._0_1_ == '\0') goto LAB_005344bb;
    iVar15 = FUN_00533810(iVar16);
    _DAT_00bdaa4c = (float)extraout_ST0_00;
    iVar12 = extraout_ECX_00;
  }
  if (iVar15 == iVar12) {
    if (bVar7) {
      iVar15 = FUN_00533810(iVar10);
      _DAT_00bdaa40 = (float)extraout_ST0_01;
      goto LAB_00534505;
    }
  }
  else if (bVar6) {
    iVar15 = FUN_00533810(iVar19);
    _DAT_00bdaa40 = (float)extraout_ST0_02;
    goto LAB_00534505;
  }
  _DAT_00bdaa40 = -10000.0;
LAB_00534505:
  iVar12 = FUN_00533810(iVar15);
  _DAT_00bdaf58 = (float)extraout_ST0_03;
  if (iVar12 < iVar18) {
    iVar12 = iVar18;
    DAT_00bdaf6c = iVar18;
  }
  if (iStack_1c < iVar12) {
    DAT_00bdaf6c = iStack_1c;
  }
  iVar12 = (**(code **)(**(int **)(unaff_retaddr + 0x13b3) + 0x4c))(unaff_retaddr);
  fVar1 = *(float *)((int)ROUND(param_3 * _DAT_00bdaf68) * 0x40 + 0x30 + *(int *)(iVar12 + 0x18));
  fVar2 = *(float *)(unaff_retaddr + 0x1b79);
  if (*(float *)(unaff_retaddr + 0x1966) <= *(float *)(unaff_retaddr + 0x1b79)) {
    fVar2 = *(float *)(unaff_retaddr + 0x1966);
  }
  if (fVar1 <= fVar2) {
    fVar2 = fVar1;
  }
  if (fVar2 - _DAT_0074b2a8 * _DAT_006e9818 < param_1) {
    *(undefined1 *)(unaff_retaddr + 0x16b7) = 0;
  }
  _DAT_00bdaf5c = *(float *)(PTR_DAT_0074bf4c + DAT_00bdaf6c * 4);
  for (iVar12 = DAT_00bdaf6c; iVar12 != iStack_10;
      iVar12 = iVar12 + (uint)(DAT_00bdaf6c < iStack_10) * 2 + -1) {
    if (*(float *)(PTR_DAT_0074bf4c + iVar12 * 4) < _DAT_00bdaf5c) {
      _DAT_00bdaf5c = *(float *)(PTR_DAT_0074bf4c + iVar12 * 4);
    }
  }
  return;
}


