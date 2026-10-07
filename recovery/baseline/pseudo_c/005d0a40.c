/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005d0a40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005d0a40(float param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  undefined4 uVar5;
  int iVar6;
  int iVar7;
  float10 extraout_ST0;
  float10 fVar8;
  float10 extraout_ST0_00;
  float10 fVar9;
  float10 extraout_ST1;
  
  iVar4 = (int)param_1;
  uVar5 = FUN_006c5018();
  (&DAT_00f5d250)[(int)param_1] = uVar5;
  iVar6 = FUN_006c5018();
  (&DAT_00f5d310)[(int)param_1] = iVar6;
  fVar1 = (float)(extraout_ST0 - (float10)iVar6);
  fVar2 = (float)(extraout_ST0 - extraout_ST1);
  fVar8 = (extraout_ST1 - (float10)iVar6) * (float10)fVar2 * (float10)fVar1;
  if (fVar8 < (float10)_DAT_006e97d8) {
    fVar8 = (float10)_DAT_006e97d8;
  }
  fVar8 = (float10)_DAT_006e97d8 / fVar8;
  (&DAT_00f5d354)[(int)param_1] =
       (float)((((extraout_ST0 + extraout_ST0) - extraout_ST1) - (float10)iVar6) * fVar8);
  (&DAT_00f5d394)[(int)param_1] =
       (float)(((extraout_ST1 * extraout_ST1 + (float10)iVar6 * (float10)iVar6) -
               (extraout_ST0 * extraout_ST0 + extraout_ST0 * extraout_ST0)) * fVar8);
  (&DAT_00f5d3d4)[(int)param_1] =
       (float)(((((float10)iVar6 + extraout_ST1) * extraout_ST0 - extraout_ST1 * extraout_ST1) -
               (float10)iVar6 * (float10)iVar6) * fVar8 * extraout_ST0);
  if (((float10)_DAT_006ea4b0 <=
       extraout_ST1 * (float10)(float)(&DAT_00f5d354)[(int)param_1] +
       extraout_ST1 * (float10)(float)(&DAT_00f5d354)[(int)param_1] +
       (float10)(float)(&DAT_00f5d394)[(int)param_1]) &&
     (fVar3 = (float)(&DAT_00f5d354)[(int)param_1] * (float)iVar6,
     (float)_DAT_006ea4b0 <= fVar3 + fVar3 + (float)(&DAT_00f5d394)[(int)param_1])) {
    DAT_00f5d350 = DAT_00f5d350 & ~(1 << (SUB41(param_1,0) & 0x1f));
    FUN_005d04d0(param_1);
    return;
  }
  DAT_00f5d350 = DAT_00f5d350 | 1 << (SUB41(param_1,0) & 0x1f);
  if (fVar1 * fVar1 <= fVar2 * fVar2) {
    iVar6 = FUN_006c5018();
    (&DAT_00f5d310)[(int)param_1] = iVar6;
    param_1 = (float)iVar6;
    fVar8 = extraout_ST0_00;
  }
  else {
    iVar7 = FUN_006c5018();
    (&DAT_00f5d250)[(int)param_1] = iVar7;
    fVar8 = (float10)iVar7;
    param_1 = (float)iVar6;
  }
  if ((float10)param_1 < fVar8 == ((float10)param_1 == fVar8)) {
    fVar9 = (float10)_DAT_006e97d8 / ((float10)param_1 - fVar8);
  }
  else {
    fVar9 = (float10)_DAT_006ea454;
  }
  (&DAT_00f5d354)[iVar4] = 0;
  (&DAT_00f5d394)[iVar4] = (float)fVar9;
  (&DAT_00f5d3d4)[iVar4] = (float)-(fVar9 * fVar8);
  FUN_005d04d0(iVar4);
  return;
}


