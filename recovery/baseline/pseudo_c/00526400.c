/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00526400 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined * FUN_00526400(int param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  char cVar7;
  int iVar8;
  int iVar9;
  float10 fVar10;
  float10 fVar11;
  
  if (*(int *)(param_1 + 0x5ae) == 0) {
    return (&PTR_DAT_0074bb5c)[**(int **)(param_1 + 0x21e8)];
  }
  cVar7 = FUN_0052f2c0(*(undefined4 *)(param_1 + 0x186a),DAT_00bdbdd8,DAT_00bdbddc);
  if (cVar7 != '\0') {
    return &DAT_00bd78a0;
  }
  cVar7 = FUN_0052f2c0(*(undefined4 *)(param_1 + 0x186a),DAT_00bdbde0,DAT_00bdbde4);
  if (cVar7 != '\0') {
    return &DAT_00bd78bc;
  }
  iVar9 = *(int *)(*(int *)(param_1 + 0x5ae) + 0x50);
  if ((iVar9 == 2) || (iVar9 == 4)) {
    fVar10 = (float10)FUN_00516daa(*(undefined4 *)(param_1 + 0x186a),DAT_00bdbdd4);
    fVar11 = (float10)FUN_00516e1a();
    if ((float10)(float)fVar10 < fVar11 * (float10)_DAT_006ea44c) {
      return &DAT_00bd78bc;
    }
    return &DAT_00bd78a0;
  }
  iVar9 = *(int *)(param_1 + 0x186e);
  iVar8 = FUN_00527b10(param_1);
  iVar9 = iVar9 * 0x1c;
  fVar1 = *(float *)(*(int *)(iVar8 + 0x10) + 0x14 + iVar9);
  fVar2 = *(float *)(*(int *)(iVar8 + 0xc) + 0x14 + iVar9);
  fVar3 = *(float *)(*(int *)(iVar8 + 0x14) + 0x14 + iVar9);
  if ((fVar1 < *(float *)(param_1 + 0x1886)) &&
     (cVar7 = FUN_005164da(*(undefined4 *)(param_1 + 0x5ae),fVar1,*(undefined4 *)(param_1 + 0x1886))
     , cVar7 != '\0')) {
    return &DAT_00bd78a0;
  }
  if ((*(float *)(param_1 + 0x1886) < fVar3) &&
     (cVar7 = FUN_005164da(*(undefined4 *)(param_1 + 0x5ae),*(undefined4 *)(param_1 + 0x1886),fVar3)
     , cVar7 != '\0')) {
    return &DAT_00bd78a0;
  }
  iVar9 = *(int *)(param_1 + 0x186e);
  iVar8 = FUN_00527b10(param_1);
  iVar9 = iVar9 * 0x1c;
  fVar4 = *(float *)(*(int *)(iVar8 + 0x10) + 0x14 + iVar9);
  fVar5 = *(float *)(*(int *)(iVar8 + 0xc) + 0x14 + iVar9);
  fVar6 = *(float *)(*(int *)(iVar8 + 0x14) + 0x14 + iVar9);
  if ((fVar4 < *(float *)(param_1 + 0x1886)) &&
     (cVar7 = FUN_005164da(*(undefined4 *)(param_1 + 0x5ae),fVar4,*(undefined4 *)(param_1 + 0x1886))
     , cVar7 != '\0')) {
    return &DAT_00bd78bc;
  }
  if ((*(float *)(param_1 + 0x1886) < fVar6) &&
     (cVar7 = FUN_005164da(*(undefined4 *)(param_1 + 0x5ae),*(undefined4 *)(param_1 + 0x1886),fVar6)
     , cVar7 != '\0')) {
    return &DAT_00bd78bc;
  }
  if (*(float *)(param_1 + 0x1886) <= fVar1) {
    if (*(float *)(param_1 + 0x1886) <= fVar2) {
      if (*(float *)(param_1 + 0x1886) <= fVar3) {
        fVar1 = fVar3 - *(float *)(param_1 + 0x1886);
        goto LAB_0052666d;
      }
      fVar1 = (fVar2 - *(float *)(param_1 + 0x1886)) / (fVar2 - fVar3);
    }
    else {
      fVar1 = (*(float *)(param_1 + 0x1886) - fVar2) / (fVar1 - fVar2);
    }
  }
  else {
    fVar1 = *(float *)(param_1 + 0x1886) - fVar1;
LAB_0052666d:
    fVar1 = fVar1 + _DAT_006e97d8;
  }
  if (*(float *)(param_1 + 0x1886) <= fVar4) {
    if (fVar5 < *(float *)(param_1 + 0x1886)) {
      fVar6 = (*(float *)(param_1 + 0x1886) - fVar5) / (fVar4 - fVar5);
      goto LAB_005266e8;
    }
    if (fVar6 < *(float *)(param_1 + 0x1886)) {
      fVar6 = (fVar5 - *(float *)(param_1 + 0x1886)) / (fVar5 - fVar6);
      goto LAB_005266e8;
    }
    fVar6 = fVar6 - *(float *)(param_1 + 0x1886);
  }
  else {
    fVar6 = *(float *)(param_1 + 0x1886) - fVar4;
  }
  fVar6 = fVar6 + _DAT_006e97d8;
LAB_005266e8:
  if (fVar6 <= fVar1) {
    return &DAT_00bd78a0;
  }
  return &DAT_00bd78bc;
}


