/* NR2003.exe @ 00410910 FUN_00410910 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00410910(float *param_1,float *param_2,float *param_3,float *param_4,float *param_5)

{
  float fVar1;
  float *pfVar2;
  float *pfVar3;
  float *pfVar4;
  float *pfVar5;
  int iVar6;
  int iVar7;
  float *pfVar8;
  int iVar9;
  float10 fVar10;
  
  pfVar5 = param_5;
  pfVar4 = param_4;
  pfVar3 = param_3;
  pfVar2 = param_2;
  *param_2 = 0.0;
  *param_4 = 0.0;
  *param_3 = 0.0;
  *param_5 = 0.0;
  fVar10 = (float10)FUN_00547ec0();
  if (fVar10 < (float10)_DAT_006ea44c != (NAN(fVar10) || NAN((float10)_DAT_006ea44c))) {
    fVar10 = (float10)_DAT_006ea44c;
  }
  iVar7 = *(int *)((int)param_1 + 0x58a);
  pfVar8 = *(float **)(iVar7 + 0x13c);
  param_4 = (float *)(*(int *)(iVar7 + 0x144) + 4);
  param_3 = (float *)(*(int *)(iVar7 + 0x140) + 4);
  param_2 = (float *)(*(int *)(iVar7 + 0x138) + 4);
  iVar9 = *(int *)(iVar7 + 0x140) - (int)pfVar8;
  param_1 = (float *)((int)param_1 + 0x14a3);
  iVar6 = *(int *)(iVar7 + 0x138) - (int)pfVar8;
  param_5 = (float *)0xb;
  iVar7 = *(int *)(iVar7 + 0x144) - (int)pfVar8;
  do {
    fVar1 = *param_1;
    if ((NAN(fVar1) || NAN(_DAT_006ea4a0)) == (fVar1 == _DAT_006ea4a0)) {
      *pfVar2 = fVar1 * *(float *)(iVar6 + (int)pfVar8) + *pfVar2;
      *pfVar3 = fVar1 * *pfVar8 + *pfVar3;
      *pfVar4 = fVar1 * *(float *)(iVar9 + (int)pfVar8) + *pfVar4;
      fVar1 = fVar1 * *(float *)(iVar7 + (int)pfVar8);
    }
    else {
      *pfVar2 = *pfVar2 + *param_2;
      *pfVar3 = pfVar8[1] + *pfVar3;
      *pfVar4 = *param_3 + *pfVar4;
      fVar1 = *param_4;
    }
    pfVar8 = pfVar8 + 2;
    param_1 = param_1 + 1;
    param_2 = param_2 + 2;
    param_3 = param_3 + 2;
    param_4 = param_4 + 2;
    *pfVar5 = fVar1 + *pfVar5;
    param_5 = (float *)((int)param_5 + -1);
  } while (param_5 != (float *)0x0);
  *pfVar2 = (float)(fVar10 * (float10)*pfVar2);
  *pfVar3 = (float)(fVar10 * (float10)*pfVar3);
  *pfVar4 = (float)(fVar10 * (float10)*pfVar4);
  *pfVar5 = (float)(fVar10 * (float10)*pfVar5);
  return;
}

