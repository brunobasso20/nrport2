/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00584730 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00584730(float param_1)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  int iVar8;
  float fVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  int iVar14;
  int iVar15;
  float local_24;
  
  iVar14 = (int)param_1;
  iVar8 = DAT_00d6a5e0;
  pfVar1 = *(float **)((int)param_1 + 0x5ae);
  if (pfVar1 != (float *)0x0) {
    fVar2 = *pfVar1;
    fVar3 = pfVar1[1];
    fVar4 = pfVar1[3];
    fVar5 = pfVar1[2];
    fVar6 = pfVar1[4];
    fVar7 = pfVar1[5];
    iVar15 = taskGetRate();
    fVar12 = _DAT_006e97d8 / (float)iVar15;
    fVar4 = SQRT(fVar4 * fVar4 + fVar6 * fVar6 + fVar7 * fVar7);
    fVar4 = fVar4 * fVar4 * _DAT_006f688c;
    if ((float)_DAT_006e9808 < fVar4) {
      fVar4 = _DAT_006e97d8;
    }
    fVar7 = DAT_00bdbd04 * fVar12 * _DAT_006f6888;
    fVar6 = *(float *)((int)param_1 + 0x5a2);
    fVar13 = _DAT_006ea454;
    local_24 = fVar7;
    if (fVar6 < _DAT_006e97d8) {
      if (fVar6 < _DAT_006ed6c8) {
        fVar6 = _DAT_006ed6c8;
      }
      fVar6 = (fVar6 - _DAT_006ed6c8) * _DAT_006e9804;
      local_24 = ((_DAT_006e97d8 - fVar6 * fVar6) * _DAT_006ea620 + _DAT_006e97d8) * fVar7;
    }
    for (; iVar8 != 0; iVar8 = *(int *)(iVar8 + 0xa8)) {
      fVar9 = fVar2 - *(float *)(iVar8 + 0x2c);
      fVar11 = fVar3 - *(float *)(iVar8 + 0x30);
      fVar10 = fVar5 - *(float *)(iVar8 + 0x34);
      fVar6 = *(float *)(iVar8 + 0x14);
      param_1 = fVar9 * fVar9 + fVar11 * fVar11 + fVar10 * fVar10;
      if ((param_1 < _DAT_006f4a38) && (param_1 < fVar6 * fVar6)) {
        param_1 = SQRT(param_1);
        if (param_1 < _DAT_006ea4a4) {
          param_1 = 0.01;
        }
        switch(*(undefined4 *)(iVar8 + 0x28)) {
        case 1:
        case 2:
        case 8:
        case 0x10:
          fVar13 = _DAT_006e97d8;
        }
        if (fVar6 - param_1 < fVar6 * _DAT_006ea44c) {
          fVar13 = ((fVar6 - param_1) / (fVar6 * _DAT_006ea44c)) * fVar13;
        }
        if (fVar13 < _DAT_006ea4a4) goto LAB_0058496d;
        switch(*(undefined4 *)(iVar8 + 0x28)) {
        case 1:
          fVar6 = fVar12 * _DAT_006f21d4;
          break;
        case 2:
        case 8:
          fVar6 = fVar7 * _DAT_006f6884;
          break;
        default:
          goto switchD_00584938_caseD_3;
        case 0x10:
          fVar6 = fVar12 * _DAT_006ea4cc;
        }
        fVar13 = fVar6 * fVar13;
switchD_00584938_caseD_3:
        local_24 = local_24 + fVar13;
      }
LAB_0058496d:
    }
    fVar2 = fVar4 * local_24 + *(float *)(iVar14 + 0x15b4);
    *(float *)(iVar14 + 0x15b4) = fVar2;
    if ((float)_DAT_006e9808 < fVar2) {
      *(undefined4 *)(iVar14 + 0x15b4) = 0x3f800000;
    }
  }
  return;
}


