/* NR2003.exe @ 004e98f0 recovered_004e98f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall recovered_004e98f0(int *param_1)

{
  float *pfVar1;
  float fVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  float fVar6;
  float fVar7;
  int iVar8;
  bool bVar9;
  bool bVar10;
  float fVar11;
  int iVar12;
  float10 fVar13;
  int iStack_20;
  
  fVar2 = (float)param_1[3];
  iVar3 = param_1[1];
  iVar4 = param_1[2];
  bVar9 = NAN(_DAT_006ea454);
  bVar10 = (float)param_1[6] < _DAT_006ea454;
  iVar5 = param_1[5];
  fVar6 = (float)param_1[4];
  fVar7 = (float)param_1[6];
  iVar8 = param_1[7];
  *(undefined *)(param_1 + 8) = 0;
  param_1[1] = 0;
  param_1[7] = 0;
  if (bVar10 != (NAN((float)param_1[6]) || bVar9)) {
    param_1[6] = (int)((float)param_1[6] * _DAT_006ea4a8);
    param_1[3] = (int)((float)param_1[3] * _DAT_006ea4a8);
    param_1[4] = (int)((float)param_1[4] * _DAT_006ea4a8);
  }
  param_1[4] = (int)fVar2;
  param_1[5] = param_1[2];
  fVar13 = (float10)FUN_004e9770();
  pfVar1 = (float *)((int)param_1 + 0x429);
  *(undefined4 *)((int)param_1 + 0x42d) = 0;
  *pfVar1 = (float)-fVar13;
  fVar13 = --fVar13;
  if (fVar13 < (float10)_DAT_006efdf0 == (NAN(fVar13) || NAN((float10)_DAT_006efdf0))) {
    *(float *)((int)param_1 + 0x431) = (float)((float10)_DAT_006e97d8 / fVar13);
  }
  else {
    *(undefined4 *)((int)param_1 + 0x431) = 0x497423f0;
  }
  iStack_20 = 0;
  iVar12 = (int)param_1 + 0x21;
  do {
    (**(code **)(*param_1 + 4))(iVar12,-*pfVar1 * (float)iStack_20 * _DAT_006f3834 + *pfVar1,1);
    iStack_20 = iStack_20 + 1;
    iVar12 = iVar12 + 8;
  } while (iStack_20 < 0x80);
  param_1[4] = (int)fVar6;
  param_1[5] = iVar5;
  *(undefined4 *)((int)param_1 + 0x83d) = 0;
  fVar13 = (float10)FUN_004e9770();
  *(float *)((int)param_1 + 0x841) = (float)fVar13;
  fVar13 = fVar13 - (float10)*(float *)((int)param_1 + 0x83d);
  if (fVar13 < (float10)_DAT_006efdf0 == (NAN(fVar13) || NAN((float10)_DAT_006efdf0))) {
    *(float *)((int)param_1 + 0x845) = (float)((float10)_DAT_006e97d8 / fVar13);
  }
  else {
    *(undefined4 *)((int)param_1 + 0x845) = 0x497423f0;
  }
  iVar12 = (int)param_1 + 0x435;
  iStack_20 = 0;
  do {
    (**(code **)(*param_1 + 4))
              (iVar12,(float)iStack_20 * _DAT_006f3834 * *(float *)((int)param_1 + 0x841),1);
    iStack_20 = iStack_20 + 1;
    iVar12 = iVar12 + 8;
  } while (iStack_20 < 0x80);
  *(undefined4 *)((int)param_1 + 0x421) = *(undefined4 *)((int)param_1 + 0x419);
  fVar11 = (float)iStack_20 * _DAT_006f3834;
  *(int *)((int)param_1 + 0x849) = (int)param_1 + 0x21;
  *(int *)((int)param_1 + 0x84d) = (int)param_1 + 0x435;
  *(undefined4 *)((int)param_1 + 0x425) = *(undefined4 *)((int)param_1 + 0x41d);
  *(int *)((int)param_1 + 0x855) = (int)param_1 + 0x83d;
  *(int *)((int)param_1 + 0x859) = param_1[3];
  *(float *)((int)param_1 + 0x835) = fVar11 + *(float *)((int)param_1 + 0x82d);
  bVar9 = NAN(_DAT_006ea454);
  bVar10 = fVar7 < _DAT_006ea454;
  param_1[1] = iVar3;
  *(int *)((int)param_1 + 0x839) = param_1[4];
  *(int *)((int)param_1 + 0x85d) = param_1[4];
  param_1[3] = (int)fVar2;
  param_1[7] = iVar8;
  param_1[2] = iVar4;
  *(float **)((int)param_1 + 0x851) = pfVar1;
  param_1[5] = iVar5;
  param_1[4] = (int)fVar6;
  *(undefined *)(param_1 + 8) = 1;
  if (bVar10 != (NAN(fVar7) || bVar9)) {
    param_1[6] = (int)((float)param_1[6] * _DAT_006ea4a8);
    param_1[3] = (int)(fVar2 * _DAT_006ea4a8);
    param_1[4] = (int)(fVar6 * _DAT_006ea4a8);
  }
  return;
}

