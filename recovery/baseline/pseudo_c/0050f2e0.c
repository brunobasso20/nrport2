/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050f2e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0050f2e0(void)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  int iVar6;
  byte bVar7;
  float *pfVar8;
  int iVar9;
  int local_8;
  
  if (((DAT_00bdaa38 < 1) ||
      (iVar6 = FUN_00509b60(0xffffffff), fVar5 = DAT_0074b218, fVar4 = DAT_0074b200, iVar6 < 5)) ||
     (iVar6 = 0, DAT_00bdaa38 < 1)) {
LAB_0050f4e4:
    FUN_0050d710();
    return;
  }
  pfVar8 = (float *)&DAT_00bd7a2c;
  iVar9 = DAT_00bdaa38;
  fVar2 = _DAT_006ea454;
  do {
    if (_DAT_006ea454 < pfVar8[-3]) {
      pfVar8[-3] = pfVar8[-3] - fVar5 * pfVar8[-2];
    }
    fVar3 = _DAT_006ea454;
    if (_DAT_006ea454 < *pfVar8) {
      fVar1 = *pfVar8 - fVar5 * pfVar8[1];
      *pfVar8 = fVar1;
      if (((fVar3 < fVar1) && (_DAT_00b8fa5c * _DAT_006ed6c8 < pfVar8[-3])) &&
         (pfVar8[-3] < _DAT_00b8fa5c * _DAT_006ea494)) {
        fVar3 = (fVar1 - pfVar8[-3]) * fVar4 + pfVar8[2];
        pfVar8[-1] = fVar3;
        if (_DAT_006f41a0 < fVar3) {
          pfVar8[-1] = 1.15;
        }
        if (pfVar8[-1] < _DAT_006e981c) {
          pfVar8[-1] = 0.7;
        }
        fVar2 = fVar2 + pfVar8[-1];
        iVar6 = iVar6 + 1;
      }
    }
    pfVar8 = pfVar8 + 6;
    iVar9 = iVar9 + -1;
  } while (iVar9 != 0);
  if (iVar6 < 1) goto LAB_0050f4e4;
  iVar9 = FUN_00544bf0();
  if ((*(byte *)(iVar9 + 0x50) & 4) == 0) {
    iVar9 = FUN_00544bf0();
    bVar7 = *(byte *)(iVar9 + 0x5f);
  }
  else {
    iVar9 = FUN_00544bf0();
    bVar7 = *(byte *)(iVar9 + 100) >> 1;
  }
  fVar4 = (float)bVar7 * _DAT_006ea4a4;
  iVar9 = FUN_0045ae70();
  iVar9 = iVar9 + 1;
  if (fVar2 / (float)iVar6 <= fVar4) {
    local_8 = 3;
    if (3 < iVar9) goto LAB_0050f495;
  }
  else {
    iVar9 = 1;
  }
  local_8 = iVar9;
LAB_0050f495:
  fVar5 = _DAT_006ea62c / ((float)local_8 + _DAT_006e97d8 + (float)local_8 + _DAT_006e97d8);
  FUN_0045ae20((fVar5 * (fVar2 / (float)iVar6) + (_DAT_006e97d8 - fVar5) * fVar4) * _DAT_006ed00c +
               _DAT_006e97d8);
  FUN_0045aec0(iVar9);
  FUN_0050d710();
  return;
}


