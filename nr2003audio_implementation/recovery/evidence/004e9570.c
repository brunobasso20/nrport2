/* NR2003.exe @ 004e9570 recovered_004e9570 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall recovered_004e9570(int param_1,float *param_2,float param_3)

{
  undefined4 uVar1;
  float *pfVar2;
  float fVar3;
  float fVar4;
  float *pfVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  float10 extraout_ST0;
  float10 extraout_ST0_00;
  float10 extraout_ST0_01;
  float afStack_8 [2];
  
  pfVar5 = param_2;
  fVar3 = param_3 - *(float *)(param_1 + 4);
  *param_2 = param_3;
  afStack_8[0] = *(float *)(param_1 + 0x1c) * _DAT_006ea44c;
  fVar4 = -afStack_8[0];
  if ((fVar4 <= fVar3) && (fVar3 < afStack_8[0] != (fVar3 == afStack_8[0]))) {
LAB_004e95b6:
    pfVar5[1] = *(float *)(param_1 + 0x18);
    return 1;
  }
  if (fVar3 < fVar4 == (NAN(fVar3) || NAN(fVar4))) {
    param_2 = (float *)(fVar3 - afStack_8[0]);
  }
  else {
    param_2 = (float *)(afStack_8[0] + fVar3);
  }
  if (*(char *)(param_1 + 0x20) == '\0') {
    if (param_3 < *(float *)(param_1 + 4) - afStack_8[0]) {
      FUN_006c5c40();
      pfVar5[1] = (float)(((float10)*(float *)(param_1 + 0x18) - (float10)*(float *)(param_1 + 0xc))
                          * extraout_ST0_00 + (float10)*(float *)(param_1 + 0xc));
      return 1;
    }
    fVar3 = afStack_8[0] + *(float *)(param_1 + 4);
    if (fVar3 < param_3 != (NAN(fVar3) || NAN(param_3))) {
      FUN_006c5c40();
      pfVar5[1] = (float)(((float10)*(float *)(param_1 + 0x18) - (float10)*(float *)(param_1 + 0x10)
                          ) * extraout_ST0_01 + (float10)*(float *)(param_1 + 0x10));
      return 1;
    }
    goto LAB_004e95b6;
  }
  iVar6 = ((int)param_2 >> 0x1f) + 1;
  uVar1 = *(undefined4 *)(param_1 + 0x849 + iVar6 * 4);
  pfVar2 = *(float **)(param_1 + 0x851 + iVar6 * 4);
  FUN_006c6a24((double)(((float)param_2 - *pfVar2) * pfVar2[2] * _DAT_006f3830),afStack_8);
  iVar6 = FUN_006c5018();
  if ((iVar6 < 0) || (0x7f < iVar6)) {
    iVar9 = 1;
  }
  else {
    iVar9 = 0;
  }
  if ((iVar6 == 0) &&
     (extraout_ST0 < (float10)_DAT_006ea4b0 != (NAN(extraout_ST0) || NAN((float10)_DAT_006ea4b0))))
  {
    iVar8 = 1;
LAB_004e9678:
    if ((float10)_DAT_006ea4b0 <= extraout_ST0) {
      iVar7 = 1;
      goto LAB_004e9690;
    }
  }
  else {
    iVar8 = 0;
    if ((-1 < iVar6) && (iVar6 < 0x80)) goto LAB_004e9678;
  }
  iVar7 = 0;
LAB_004e9690:
  (**(code **)(param_1 + 0x85d + (iVar9 + iVar7 * 3 + iVar8 * 2) * 4))
            (pfVar5,iVar6,(float)extraout_ST0,uVar1,
             *(undefined4 *)(param_1 + 0x859 + (uint)(0 < iVar6) * 4));
  return 1;
}

