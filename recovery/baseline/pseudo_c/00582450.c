/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00582450 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void FUN_00582450(int param_1)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  float *pfVar5;
  float fVar6;
  float fVar7;
  int iVar8;
  int *piVar9;
  int iVar10;
  int *piVar11;
  float10 fVar12;
  float afStack_c [3];
  
  iVar10 = 0;
  iVar8 = 0;
  piVar9 = (int *)(param_1 + 0xb0);
  piVar11 = piVar9;
  fVar6 = _DAT_006ea454;
  do {
    iVar4 = *piVar11;
    if ((iVar4 != 0) && (-1 < *(int *)(iVar4 + 0x28))) {
      fVar2 = *(float *)(iVar4 + 0x2c) - *(float *)(param_1 + 0x2c);
      fVar3 = *(float *)(iVar4 + 0x30) - *(float *)(param_1 + 0x30);
      fVar7 = *(float *)(iVar4 + 0x34) - *(float *)(param_1 + 0x34);
      fVar2 = SQRT(fVar2 * fVar2 + fVar3 * fVar3 + fVar7 * fVar7);
      if (fVar2 < _DAT_006ea4cc) {
        fVar2 = _DAT_006ea4cc;
      }
      fVar2 = (*(float *)(param_1 + 0x14) + *(float *)(iVar4 + 0x14)) / fVar2;
      afStack_c[iVar8] = fVar2;
      if (fVar2 <= _DAT_006f6868) {
        afStack_c[iVar8] = 0.0;
      }
      else {
        afStack_c[iVar8] = *(float *)(iVar4 + 0x14) / *(float *)(param_1 + 0x14);
      }
      fVar6 = fVar6 + afStack_c[iVar8];
    }
    iVar8 = iVar8 + 1;
    piVar11 = piVar11 + 1;
  } while (iVar8 < 3);
  if (fVar6 <= _DAT_006f412c) {
    return;
  }
  fVar6 = _DAT_006e97d8 / fVar6;
  do {
    pfVar5 = (float *)*piVar9;
    if ((pfVar5 != (float *)0x0) && (-1 < (int)pfVar5[10])) {
      fVar2 = pfVar5[5] / *(float *)(param_1 + 0x14);
      fVar3 = _DAT_006e97d8;
      if (fVar2 <= _DAT_006e97d8) {
        fVar3 = fVar2 * fVar2 * fVar2;
      }
      fVar7 = afStack_c[iVar10] * *(float *)(param_1 + 8) * fVar3 * fVar6;
      pfVar5[2] = fVar7 + pfVar5[2];
      fVar12 = (float10)FUN_006c5c40();
      pfVar5[3] = (float)fVar12;
      fVar12 = (float10)FUN_006c5c40();
      pfVar1 = pfVar5 + 0xb;
      fVar12 = ((float10)_DAT_006e97d8 - fVar12) * (float10)_DAT_006f3814;
      pfVar5[4] = (float)fVar12;
      *pfVar5 = (float)((fVar12 - (float10)_DAT_006efe7c) * (float10)_DAT_006ea44c);
      fVar2 = *(float *)(param_1 + 0x30);
      fVar3 = *(float *)(param_1 + 0x34);
      fVar7 = (_DAT_006ea44c / pfVar5[2]) * fVar7;
      *pfVar1 = *pfVar1 + (*(float *)(param_1 + 0x2c) - *pfVar1) * fVar7;
      pfVar5[0xc] = pfVar5[0xc] + (fVar2 - pfVar5[0xc]) * fVar7;
      pfVar5[0xd] = pfVar5[0xd] + (fVar3 - pfVar5[0xd]) * fVar7;
    }
    iVar10 = iVar10 + 1;
    piVar9 = piVar9 + 1;
  } while (iVar10 < 3);
  return;
}


