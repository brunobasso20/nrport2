/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f3530 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004f3530(int param_1_00,int *param_1)

{
  int iVar1;
  float *pfVar2;
  int iVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float *pfVar7;
  int iVar8;
  float10 fVar9;
  float local_2c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  
  iVar1 = *param_1;
  pfVar2 = *(float **)(param_1_00 + 8);
  pfVar7 = *(float **)(iVar1 + 0x14e);
  if ((pfVar7 == (float *)0x0) && (*(char *)(iVar1 + 0x152) == '\0')) {
    pfVar7 = *(float **)(iVar1 + 0x14);
  }
  iVar8 = *(int *)(iVar1 + 0x14e);
  if ((iVar8 == 0) && (*(char *)(iVar1 + 0x152) == '\0')) {
    iVar8 = *(int *)(iVar1 + 0x14);
  }
  fVar4 = _DAT_006ea454;
  if (*(int *)(iVar1 + 8) != 0) {
    fVar4 = *(float *)(*(int *)(iVar1 + 8) + 0xc);
  }
  local_18 = *pfVar7 - *pfVar2;
  local_8 = pfVar7[1] - pfVar2[1];
  local_2c = 1.0;
  local_10 = pfVar7[2] - pfVar2[2];
  fVar6 = SQRT(local_18 * local_18 + local_8 * local_8 + local_10 * local_10);
  if (fVar6 <= (float)_DAT_006f3c68) {
    local_18 = 0.0;
    local_14 = 0.0;
    local_10 = 0.0;
  }
  else {
    fVar5 = _DAT_006e97d8 / fVar6;
    local_18 = local_18 * fVar5;
    local_14 = local_8 * fVar5;
    local_10 = local_10 * fVar5;
  }
  FUN_005f6dc0(&local_c,pfVar2 + 0x16,&local_18);
  if ((_DAT_006ea454 < *(float *)(param_1_00 + 0x10)) && (_DAT_006ea4a4 < fVar6)) {
    if (ABS(local_c) <= _DAT_006ea4a4) {
      local_2c = 0.005;
    }
    else {
      fVar9 = (float10)FUN_006c5c40();
      local_2c = (float)(fVar9 * (float10)_DAT_006f3c60 + (float10)_DAT_006f3c58);
    }
  }
  fVar5 = _DAT_006e97d8;
  if ((fVar4 <= fVar6) && (_DAT_006e97d8 < fVar6)) {
    fVar5 = (fVar4 / fVar6) * (fVar4 / fVar6);
  }
  iVar3 = *param_1;
  fVar4 = _DAT_006e97d8;
  if (*(char *)(iVar3 + 0x153) != '\0') {
    fVar4 = local_2c * *(float *)(param_1_00 + 0xc);
  }
  *(float *)(iVar3 + 0x3c) = fVar4;
  *(float *)(iVar3 + 0x2c) =
       (float)(&DAT_00a57330)[*(int *)(iVar3 + 0x24)] * *(float *)(iVar3 + 0x3c) * fVar5 *
       *(float *)(iVar1 + 0x20);
  *(float *)(iVar3 + 0x40) =
       (local_18 * pfVar2[3] + local_14 * pfVar2[4] + local_10 * pfVar2[5] + _DAT_006f3c50) /
       (local_18 * *(float *)(iVar8 + 0xc) +
        local_14 * *(float *)(iVar8 + 0x10) + local_10 * *(float *)(iVar8 + 0x14) + _DAT_006f3c50);
  if (_DAT_006e9824 < fVar6) {
    fVar9 = (float10)fpatan((float10)local_8,ABS((float10)local_c));
    if (fVar9 * (float10)_DAT_006f3c48 != (float10)_DAT_006ea454) {
      *(float *)(iVar3 + 0x44) =
           (float)(((float10)fVar6 - (float10)_DAT_006e9824) *
                  ((fVar9 * (float10)_DAT_006f3c48) / (float10)fVar6));
      return;
    }
  }
  *(undefined4 *)(iVar3 + 0x44) = 0;
  return;
}


