/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005115ea */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005115ea(int param_1,int *param_2,int param_3)

{
  float fVar1;
  float fVar2;
  double dVar3;
  double dVar4;
  int iVar5;
  float10 fVar6;
  float10 fVar7;
  float10 fVar8;
  float10 fVar9;
  
  iVar5 = *(int *)(*(int *)(param_1 + 0x4e) + -4 + param_3 * 4);
  dVar3 = *(double *)(iVar5 + 0x15);
  fVar6 = (float10)dVar3;
  dVar4 = *(double *)(iVar5 + 0x25);
  fVar7 = (float10)fptan((float10)*(float *)(iVar5 + 0x1d));
  fVar8 = (float10)fptan((float10)*(float *)(iVar5 + 0x2d));
  if (*param_2 == 1) {
    fVar7 = fVar7 * (float10)(float)param_2[2];
    fVar8 = (float10)(float)fVar8 * (float10)(float)param_2[2];
  }
  else {
    fVar7 = ((float10)(float)param_2[0x11] - (float10)*(float *)(iVar5 + 0xc)) * fVar7 *
            (float10)(float)param_2[0x14];
    fVar8 = ((float10)(float)param_2[0x11] - (float10)*(float *)(iVar5 + 0x10)) *
            (float10)(float)fVar8 * (float10)(float)param_2[0x14];
  }
  param_2[param_3 * 0x12 + 0x1a] = *(int *)(iVar5 + 0xc);
  param_2[param_3 * 0x12 + 0x1b] = (int)(*(float *)(iVar5 + 0x10) - *(float *)(iVar5 + 0xc));
  param_2[param_3 * 0x12 + 10] =
       (int)((float)param_2[param_3 * 0x12 + 0x1a] - (float)param_2[param_3 * 0x12 + 8]);
  param_2[param_3 * 0x12 + 0xb] =
       (int)((float)param_2[param_3 * 0x12 + 0x1b] - (float)param_2[param_3 * 0x12 + 9]);
  fVar9 = fVar6 - (float10)(float)dVar4;
  param_2[param_3 * 0x12 + 0x1e] = -1;
  param_2[param_3 * 0x12 + 0x1f] = -1;
  fVar9 = fVar8 + fVar7 + fVar9 + fVar9;
  fVar1 = (float)fVar9;
  param_2[param_3 * 0x12 + 0x20] = (int)(float)fVar9;
  fVar6 = ((float10)(float)dVar4 - fVar6) * (float10)_DAT_006ea62c - (fVar7 + fVar7 + fVar8);
  fVar2 = (float)fVar6;
  param_2[param_3 * 0x12 + 0x21] = (int)(float)fVar6;
  param_2[param_3 * 0x12 + 0x22] = (int)(float)fVar7;
  param_2[param_3 * 0x12 + 0x23] = (int)(float)dVar3;
  param_2[param_3 * 0x12 + 0x24] = (int)(fVar1 * _DAT_006ea62c);
  param_2[param_3 * 0x12 + 0x25] = (int)(fVar2 + fVar2);
  param_2[param_3 * 0x12 + 0x14] = (int)(fVar1 - (float)param_2[param_3 * 0x12 + 0xe]);
  param_2[param_3 * 0x12 + 0x15] =
       (int)((float)param_2[param_3 * 0x12 + 0x21] - (float)param_2[param_3 * 0x12 + 0xf]);
  param_2[param_3 * 0x12 + 0x16] =
       (int)((float)param_2[param_3 * 0x12 + 0x22] - (float)param_2[param_3 * 0x12 + 0x10]);
  param_2[param_3 * 0x12 + 0x17] =
       (int)((float)param_2[param_3 * 0x12 + 0x23] - (float)param_2[param_3 * 0x12 + 0x11]);
  param_2[param_3 * 0x12 + 0x18] =
       (int)((float)param_2[param_3 * 0x12 + 0x24] - (float)param_2[param_3 * 0x12 + 0x12]);
  param_2[param_3 * 0x12 + 0x19] =
       (int)((float)param_2[param_3 * 0x12 + 0x25] - (float)param_2[param_3 * 0x12 + 0x13]);
  return;
}


