/* NR2003.exe @ 00584730 FUN_00584730 */

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
  float fVar8;
  float fVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  int iVar13;
  int iVar14;
  int iVar15;
  float local_24;
  
  iVar13 = (int)param_1;
  iVar15 = DAT_00d6a5e0;
  pfVar1 = *(float **)((int)param_1 + 0x5ae);
  if (pfVar1 != (float *)0x0) {
    fVar2 = *pfVar1;
    fVar3 = pfVar1[1];
    fVar4 = pfVar1[3];
    fVar5 = pfVar1[2];
    fVar6 = pfVar1[4];
    fVar7 = pfVar1[5];
    iVar14 = taskGetRate();
    fVar12 = _DAT_006e97d8 / (float)iVar14;
    fVar4 = SQRT(fVar4 * fVar4 + fVar6 * fVar6 + fVar7 * fVar7);
    fVar4 = fVar4 * fVar4 * _DAT_006f688c;
    if ((float)_DAT_006e9808 < fVar4) {
      fVar4 = _DAT_006e97d8;
    }
    fVar7 = DAT_00bdbd04 * fVar12 * _DAT_006f6888;
    fVar6 = *(float *)((int)param_1 + 0x5a2);
    local_24 = fVar7;
    if (fVar6 < _DAT_006e97d8 != (NAN(fVar6) || NAN(_DAT_006e97d8))) {
      if (fVar6 < _DAT_006ed6c8 != (NAN(fVar6) || NAN(_DAT_006ed6c8))) {
        fVar6 = _DAT_006ed6c8;
      }
      fVar6 = (fVar6 - _DAT_006ed6c8) * _DAT_006e9804;
      local_24 = ((_DAT_006e97d8 - fVar6 * fVar6) * _DAT_006ea620 + _DAT_006e97d8) * fVar7;
    }
    fVar6 = _DAT_006ea454;
    if (iVar15 != 0) {
      do {
        fVar9 = fVar2 - *(float *)(iVar15 + 0x2c);
        fVar11 = fVar3 - *(float *)(iVar15 + 0x30);
        fVar10 = fVar5 - *(float *)(iVar15 + 0x34);
        fVar8 = *(float *)(iVar15 + 0x14);
        param_1 = fVar9 * fVar9 + fVar11 * fVar11 + fVar10 * fVar10;
        if ((param_1 < _DAT_006f4a38 != (NAN(param_1) || NAN(_DAT_006f4a38))) &&
           (param_1 < fVar8 * fVar8)) {
          param_1 = SQRT(param_1);
          if (param_1 < _DAT_006ea4a4 != (NAN(param_1) || NAN(_DAT_006ea4a4))) {
            param_1 = 0.01;
          }
          switch(*(undefined4 *)(iVar15 + 0x28)) {
          case 1:
          case 2:
          case 8:
          case 0x10:
            fVar6 = _DAT_006e97d8;
          }
          param_1 = fVar8 - param_1;
          fVar8 = fVar8 * _DAT_006ea44c;
          if (param_1 < fVar8 != (NAN(param_1) || NAN(fVar8))) {
            fVar6 = (param_1 / fVar8) * fVar6;
          }
          if (fVar6 < _DAT_006ea4a4) goto LAB_0058496d;
          switch(*(undefined4 *)(iVar15 + 0x28)) {
          case 1:
            fVar8 = fVar12 * _DAT_006f21d4;
            break;
          case 2:
          case 8:
            fVar8 = fVar7 * _DAT_006f6884;
            break;
          default:
            goto switchD_00584938_caseD_3;
          case 0x10:
            fVar8 = fVar12 * _DAT_006ea4cc;
          }
          fVar6 = fVar8 * fVar6;
switchD_00584938_caseD_3:
          local_24 = local_24 + fVar6;
        }
LAB_0058496d:
        iVar15 = *(int *)(iVar15 + 0xa8);
      } while (iVar15 != 0);
    }
    fVar2 = fVar4 * local_24 + *(float *)(iVar13 + 0x15b4);
    *(float *)(iVar13 + 0x15b4) = fVar2;
    if ((float)_DAT_006e9808 < fVar2) {
      *(undefined4 *)(iVar13 + 0x15b4) = 0x3f800000;
    }
  }
  return;
}

