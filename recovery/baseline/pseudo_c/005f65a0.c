/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f65a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f65a0(int param_1,double param_2,double param_3,char param_4_00,float *param_4,
                 float *param_5)

{
  float fVar1;
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
  float fVar13;
  float fVar14;
  float fVar15;
  float fVar16;
  float fVar17;
  float10 fVar18;
  float10 fVar19;
  float10 fVar20;
  float10 fVar21;
  float10 fVar22;
  float10 fVar23;
  float10 fVar24;
  
  fVar19 = (float10)fcos((float10)(float)*(double *)(param_1 + 0x20));
  fVar18 = (float10)fsin((float10)(float)*(double *)(param_1 + 0x20));
  fVar1 = (float)fVar19;
  fVar2 = (float)fVar18;
  fVar19 = (float10)fcos((float10)(float)*(double *)(param_1 + 0x38));
  fVar18 = (float10)fsin((float10)(float)*(double *)(param_1 + 0x38));
  fVar3 = (float)fVar19;
  fVar4 = (float)fVar18;
  fVar11 = (float)param_2;
  fVar19 = (float10)(float)*(double *)(param_1 + 0x10) + (float10)(-fVar2 * fVar11);
  fVar12 = (float)*(double *)(param_1 + 0x18) + fVar1 * fVar11;
  fVar14 = (float)param_3;
  fVar13 = (float)*(double *)(param_1 + 0x10) + -fVar2 * fVar14;
  fVar15 = fVar1 * fVar14 + (float)*(double *)(param_1 + 0x18);
  fVar6 = (float)*(double *)(param_1 + 0x28) + -fVar4 * fVar11;
  fVar9 = (float)*(double *)(param_1 + 0x30) + fVar3 * fVar11;
  fVar11 = (float)*(double *)(param_1 + 0x28) + -fVar4 * fVar14;
  fVar14 = fVar3 * fVar14 + (float)*(double *)(param_1 + 0x30);
  if ((*(int *)(param_1 + 0xc) != 0) && (param_4_00 == '\0')) {
    fVar18 = ABS((float10)*(double *)(param_1 + 0x38) - (float10)*(double *)(param_1 + 0x20));
    if ((float10)_DAT_006e97f8 < fVar18) {
      fVar18 = (float10)_DAT_006efb78 - fVar18;
    }
    fVar20 = (float10)fsin(fVar18 * (float10)_DAT_006ea668);
    fVar18 = (float10)fcos(fVar18 * (float10)_DAT_006ea668);
    fVar20 = ABS(fVar20) * ABS(fVar20) * (float10)_DAT_006e9838;
    fVar21 = SQRT((float10)(double)((float10)fVar6 - fVar19) *
                  (float10)(double)((float10)fVar6 - fVar19) +
                  (float10)(fVar9 - fVar12) * (float10)(fVar9 - fVar12)) *
             (float10)(double)((float10)_DAT_006e9808 - ABS(fVar18));
    fVar21 = (fVar21 + fVar21) / fVar20;
    fVar5 = (float)(fVar19 + (float10)fVar1 * fVar21);
    fVar22 = (float10)fVar2 * fVar21 + (float10)fVar12;
    fVar23 = (float10)fVar5 * (float10)_DAT_006ea62c;
    fVar24 = (float10)(float)((float10)fVar6 - (float10)fVar3 * fVar21) * (float10)_DAT_006ea62c;
    fVar6 = (float)(((fVar23 - fVar19) - fVar24) + (float10)fVar6);
    fVar5 = (float)(((float10)(float)(fVar19 * (float10)_DAT_006ea62c) -
                    (float10)fVar5 * (float10)_DAT_006f3e2c) + fVar24);
    fVar7 = (float)(fVar23 - (float10)(float)(fVar19 * (float10)_DAT_006ea62c));
    fVar8 = (float)(fVar22 * (float10)_DAT_006ea62c);
    fVar21 = (float10)(float)((float10)fVar9 - (float10)fVar4 * fVar21) * (float10)_DAT_006ea62c;
    fVar9 = (float)((((float10)fVar8 - (float10)fVar12) - fVar21) + (float10)fVar9);
    fVar10 = (float)(((float10)(fVar12 * _DAT_006ea62c) - fVar22 * (float10)_DAT_006f3e2c) + fVar21)
    ;
    fVar8 = fVar8 - fVar12 * _DAT_006ea62c;
    fVar18 = SQRT((float10)(fVar11 - fVar13) * (float10)(fVar11 - fVar13) +
                  (float10)(fVar14 - fVar15) * (float10)(fVar14 - fVar15)) *
             (float10)(double)((float10)_DAT_006e9808 - ABS(fVar18));
    fVar20 = (fVar18 + fVar18) / fVar20;
    fVar1 = (float)((float10)fVar13 + (float10)fVar1 * fVar20);
    fVar21 = (float10)fVar2 * fVar20 + (float10)fVar15;
    fVar16 = fVar1 * _DAT_006ea62c;
    fVar3 = (float)((float10)fVar11 - (float10)fVar3 * fVar20) * _DAT_006ea62c;
    fVar17 = fVar13 * _DAT_006ea62c;
    fVar1 = fVar1 * _DAT_006f3e2c;
    fVar2 = (float)(fVar21 * (float10)_DAT_006ea62c);
    fVar20 = ((float10)fVar14 - (float10)fVar4 * fVar20) * (float10)_DAT_006ea62c;
    fVar4 = fVar15 * _DAT_006ea62c;
    fVar18 = (float10)_DAT_006f3e2c;
    *param_4 = (((fVar16 - fVar13) - fVar3) + fVar11) - fVar6;
    param_4[1] = ((fVar17 - fVar1) + fVar3 + fVar6) - fVar5;
    param_4[2] = ((fVar16 - fVar17) + fVar5) - fVar7;
    param_4[3] = (float)(((float10)fVar13 + (float10)fVar7) - fVar19);
    param_4[4] = (float)fVar19;
    *param_5 = (float)((((float10)fVar2 - (float10)fVar15) - fVar20) + (float10)fVar14) - fVar9;
    param_5[4] = fVar12;
    param_5[1] = ((float)(((float10)fVar4 - fVar21 * fVar18) + fVar20) + fVar9) - fVar10;
    param_5[2] = ((fVar2 - fVar4) + fVar10) - fVar8;
    param_5[3] = (fVar15 + fVar8) - fVar12;
    return;
  }
  param_4[2] = 0.0;
  param_4[1] = 0.0;
  *param_4 = 0.0;
  param_4[3] = (float)((float10)fVar11 - fVar19);
  param_4[4] = (float)fVar19;
  param_5[2] = 0.0;
  param_5[1] = 0.0;
  *param_5 = 0.0;
  param_5[3] = fVar14 - fVar12;
  param_5[4] = fVar12;
  return;
}


