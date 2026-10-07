/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051a4a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051a4a0(float *param_1,float *param_2)

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
  
  fVar1 = *param_2;
  fVar2 = param_2[2];
  fVar3 = param_2[3];
  fVar4 = param_2[4];
  fVar5 = param_2[5];
  fVar6 = fVar1 * fVar1;
  fVar10 = fVar2 * fVar2;
  fVar7 = fVar4 * fVar4;
  fVar8 = fVar7 * fVar4;
  fVar13 = fVar10 * fVar2 * fVar5;
  fVar12 = fVar8 * fVar3;
  fVar14 = (fVar10 - (fVar4 * fVar2 + fVar4 * fVar2)) + fVar7;
  fVar9 = fVar4 + fVar4;
  fVar11 = fVar4 * fVar3 * fVar2;
  fVar1 = (((fVar12 + fVar12 + (fVar13 - fVar7 * fVar3 * fVar2 * _DAT_006ea62c)) * fVar2 * fVar1 +
           (((fVar10 * fVar5 - (fVar11 + fVar11)) + fVar7 * fVar3) * fVar6 * fVar1 -
           (((fVar13 + fVar13) - fVar10 * fVar4 * fVar3 * _DAT_006ea62c) + fVar12) * fVar6)) -
          param_2[1] * fVar14 * fVar10 * fVar4) /
          ((((fVar9 + fVar2) * fVar2 * fVar1 + (fVar6 * fVar1 - (fVar2 + fVar2 + fVar4) * fVar6)) -
           fVar10 * fVar4) * fVar14);
  fVar6 = fVar2 * _DAT_006ea62c;
  param_1[3] = fVar1;
  fVar1 = -(((fVar6 - fVar9) * fVar7 * fVar3 +
            ((fVar8 + fVar8 + (fVar10 * fVar2 - fVar7 * fVar2 * _DAT_006ea62c)) * fVar1 - fVar13)) /
           (fVar14 * fVar4 * fVar2));
  fVar3 = fVar10 * _DAT_006ea62c;
  param_1[2] = fVar1;
  fVar1 = ((param_1[3] - fVar5) * fVar10 * _DAT_006ea62c + (fVar3 - fVar7) * fVar1 * fVar4) /
          ((fVar9 - fVar6) * fVar7 * fVar2);
  param_1[1] = fVar1;
  fVar1 = fVar1 * fVar2;
  *param_1 = -((fVar1 + fVar1 + param_1[2]) / fVar3);
  return;
}


