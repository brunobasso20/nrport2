/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00407f20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00407f20(int param_1,float param_2,float *param_3,float *param_4)

{
  float fVar1;
  int iVar2;
  int iVar3;
  float fVar4;
  char cVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  bool bVar9;
  float10 fVar10;
  
  iVar8 = (int)param_2;
  DAT_00760fac = 0;
  fVar1 = *(float *)(*(int *)(param_1 + 0x186e) * 0x40 + DAT_00bd796c);
  iVar6 = FUN_00413e20();
  if (*(int *)(iVar6 + 0x3f4) == 2) {
    fVar4 = fVar1 * _DAT_006ea4cc;
    param_2 = fVar1 * _DAT_006ea504;
    if (param_2 < fVar4 + _DAT_006e9804) {
      param_2 = fVar4 + _DAT_006e9804;
    }
    iVar8 = *(int *)(param_1 + 0x1afe);
    FUN_00413e20();
    FUN_00415210();
    iVar6 = FUN_0041aad0();
    if (0 < iVar6) {
      iVar8 = 1 - iVar8;
    }
    iVar6 = FUN_00544bf0();
    if ((*(uint *)(iVar6 + 0x4c) & 0xf000) == 0x2000) {
      if (iVar8 == 0) {
LAB_00408165:
        *param_3 = param_2;
        *param_4 = fVar4;
        return;
      }
    }
    else if (iVar8 != 0) goto LAB_00408165;
    *param_3 = fVar4;
    *param_4 = param_2;
    return;
  }
  FUN_00415210();
  iVar6 = FUN_00417fc0();
  if (iVar6 == 1) {
    *param_4 = 0.5;
    *param_3 = 0.5;
    if (param_2 == 0.0) {
      return;
    }
    fVar10 = (float10)FUN_0052b070(param_1,param_2);
    if (fVar10 <= (float10)_DAT_006ea478) {
      return;
    }
    cVar5 = FUN_00408180(param_1,param_2);
    if (cVar5 == '\0') {
      return;
    }
    DAT_00760fac = 1;
    return;
  }
  fVar4 = fVar1 * _DAT_006ea50c;
  *param_4 = fVar4;
  *param_3 = fVar4;
  if (param_2 == 0.0) {
    return;
  }
  bVar9 = param_2 != (float)DAT_00760b38;
  param_2 = 10.0;
  if (bVar9) {
    iVar6 = *(int *)(param_1 + 0x1b02);
    if (iVar6 < 1) goto LAB_0040803a;
    iVar2 = *(int *)(iVar8 + 0x5b2);
    iVar7 = FUN_00413e20();
    iVar3 = *(int *)(param_1 + 0x1afe);
    if ((iVar3 < 0) || (*(int *)(iVar7 + 0x3f4) <= iVar3)) {
      iVar6 = -1;
    }
    else {
      iVar6 = *(int *)(iVar7 + -4 + (iVar3 + iVar6 * 2) * 4);
    }
    if (iVar2 == iVar6) goto LAB_0040803a;
  }
  param_2 = 20.0;
LAB_0040803a:
  fVar10 = (float10)FUN_0052b070(param_1,iVar8);
  if (((float10)param_2 <= fVar10) && (cVar5 = FUN_00408180(param_1,iVar8), cVar5 != '\0')) {
    *param_3 = 0.0;
    *param_4 = 0.0;
    DAT_00760fac = 1;
    return;
  }
  fVar4 = fVar1 * _DAT_006ea470;
  *param_3 = fVar4;
  fVar1 = fVar1 * _DAT_006ea508;
  *param_4 = fVar1;
  if (fVar4 < _DAT_006ea454) {
    *param_3 = 0.0;
  }
  if (_DAT_006ea454 <= fVar1) {
    return;
  }
  *param_4 = 0.0;
  return;
}


