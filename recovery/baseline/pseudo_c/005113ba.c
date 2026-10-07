/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005113ba */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005113ba(int param_1,int *param_2)

{
  float fVar1;
  double dVar2;
  double dVar3;
  int iVar4;
  float10 fVar5;
  float10 fVar6;
  float10 fVar7;
  float10 fVar8;
  
  iVar4 = **(int **)(param_1 + 0x4e);
  dVar2 = *(double *)(iVar4 + 0x15);
  fVar5 = (float10)dVar2;
  dVar3 = *(double *)(iVar4 + 0x25);
  fVar6 = (float10)fptan((float10)*(float *)(iVar4 + 0x1d));
  fVar7 = (float10)fptan((float10)*(float *)(iVar4 + 0x2d));
  if (*param_2 == 1) {
    fVar8 = (float10)(float)param_2[2];
    fVar7 = (float10)(float)fVar7 * (float10)(float)param_2[2];
  }
  else {
    fVar8 = ((float10)(float)param_2[0x11] - (float10)*(float *)(iVar4 + 0xc)) *
            (float10)(float)param_2[0x14];
    fVar7 = ((float10)(float)param_2[0x11] - (float10)*(float *)(iVar4 + 0x10)) *
            (float10)(float)param_2[0x14] * (float10)(float)fVar7;
  }
  fVar6 = fVar6 * fVar8;
  fVar8 = fVar5 - (float10)(float)dVar3;
  param_2[0x1a] = -0x18ac3de4;
  param_2[0x1b] = 0;
  param_2[0x1e] = -1;
  param_2[0x1f] = -1;
  param_2[0x26] = 0;
  param_2[0x27] = 0;
  fVar8 = fVar7 + fVar6 + fVar8 + fVar8;
  param_2[0x28] = 0;
  param_2[0x29] = 0;
  param_2[0x2a] = 0;
  param_2[0x2b] = 0;
  param_2[0x20] = (int)(float)fVar8;
  fVar5 = ((float10)(float)dVar3 - fVar5) * (float10)_DAT_006ea62c - (fVar6 + fVar6 + fVar7);
  fVar1 = (float)fVar5;
  param_2[0x21] = (int)(float)fVar5;
  param_2[0x22] = (int)(float)fVar6;
  param_2[0x23] = (int)(float)dVar2;
  param_2[0x24] = (int)((float)fVar8 * _DAT_006ea62c);
  param_2[0x25] = (int)(fVar1 + fVar1);
  return;
}


