/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005114aa */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005114aa(int param_1,int *param_2)

{
  float fVar1;
  double dVar2;
  double dVar3;
  int iVar4;
  int iVar5;
  float10 fVar6;
  float10 fVar7;
  float10 fVar8;
  float10 fVar9;
  
  fVar1 = _DAT_006f4648;
  iVar4 = *(int *)(*(int *)(param_1 + 0x4e) + -4 + *(int *)(param_1 + 0x42) * 4);
  dVar2 = *(double *)(iVar4 + 0x15);
  fVar6 = (float10)dVar2;
  dVar3 = *(double *)(iVar4 + 0x25);
  iVar5 = param_2[0x15];
  fVar7 = (float10)fptan((float10)*(float *)(iVar4 + 0x1d));
  fVar8 = (float10)fptan((float10)*(float *)(iVar4 + 0x2d));
  if (*param_2 == 1) {
    fVar9 = (float10)(float)param_2[2];
    fVar8 = (float10)(float)fVar8 * (float10)(float)param_2[2];
  }
  else {
    fVar9 = ((float10)(float)param_2[0x11] - (float10)*(float *)(iVar4 + 0xc)) *
            (float10)(float)param_2[0x14];
    fVar8 = ((float10)(float)param_2[0x11] - (float10)*(float *)(iVar4 + 0x10)) *
            (float10)(float)param_2[0x14] * (float10)(float)fVar8;
  }
  fVar7 = fVar7 * fVar9;
  param_2[iVar5 * 0x12 + 0x2c] = 0x6753c21c;
  param_2[iVar5 * 0x12 + 0x2d] = 0;
  param_2[iVar5 * 0x12 + 0x2e] = 0x3f800000;
  param_2[iVar5 * 0x12 + 0x2f] = 0;
  param_2[iVar5 * 0x12 + 0x1c] = (int)(fVar1 - (float)param_2[iVar5 * 0x12 + 0x1a]);
  param_2[iVar5 * 0x12 + 0x1d] =
       (int)((float)param_2[iVar5 * 0x12 + 0x2d] - (float)param_2[iVar5 * 0x12 + 0x1b]);
  fVar9 = fVar6 - (float10)(float)dVar3;
  param_2[iVar5 * 0x12 + 0x30] = -1;
  param_2[iVar5 * 0x12 + 0x31] = -1;
  fVar9 = fVar8 + fVar7 + fVar9 + fVar9;
  param_2[iVar5 * 0x12 + 0x32] = (int)(float)fVar9;
  fVar6 = ((float10)(float)dVar3 - fVar6) * (float10)_DAT_006ea62c - (fVar7 + fVar7 + fVar8);
  fVar1 = (float)fVar6;
  param_2[iVar5 * 0x12 + 0x33] = (int)(float)fVar6;
  param_2[iVar5 * 0x12 + 0x34] = (int)(float)fVar7;
  param_2[iVar5 * 0x12 + 0x35] = (int)(float)dVar2;
  param_2[iVar5 * 0x12 + 0x36] = (int)((float)fVar9 * _DAT_006ea62c);
  param_2[iVar5 * 0x12 + 0x37] = (int)(fVar1 + fVar1);
  param_2[iVar5 * 0x12 + 0x26] = 0;
  param_2[iVar5 * 0x12 + 0x27] = 0;
  param_2[iVar5 * 0x12 + 0x28] = 0;
  param_2[iVar5 * 0x12 + 0x29] = 0;
  param_2[iVar5 * 0x12 + 0x2a] = 0;
  param_2[iVar5 * 0x12 + 0x2b] = 0;
  return;
}


