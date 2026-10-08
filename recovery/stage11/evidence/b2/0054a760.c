/* NR2003.exe @ 0054a760 FUN_0054a760 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0054a760(int *param_1,int *param_2,int *param_3,int *param_4,int **param_5,int **param_6,
                 int **param_7,int **param_8,int *param_9,int *param_10,int *param_11,int **param_12
                 )

{
  bool bVar1;
  bool bVar2;
  int **ppiVar3;
  uint uVar4;
  int **ppiVar5;
  
  ppiVar3 = DAT_00bf09c0;
  uVar4 = (int)param_1 >> 4 & 0x1f;
  for (ppiVar5 = (int **)(&DAT_00bf0940)[uVar4]; ppiVar5 != (int **)0x0;
      ppiVar5 = (int **)ppiVar5[0x16]) {
    if (*ppiVar5 == param_1) goto LAB_0054a7c4;
  }
  if (DAT_00bf09c0 != (int **)0x0) {
    ppiVar5 = DAT_00bf09c0 + 0x17;
    DAT_00bf09c0 = (int **)*DAT_00bf09c0;
    *ppiVar5 = (int *)DAT_00bf39f0;
    DAT_00bf39f0 = ppiVar3;
    ppiVar3[0x16] = (int *)(&DAT_00bf0940)[uVar4];
    (&DAT_00bf0940)[uVar4] = ppiVar3;
    ppiVar3[1] = (int *)0xbf800000;
    *ppiVar3 = param_1;
    ppiVar5 = ppiVar3;
LAB_0054a7c4:
    if ((float)ppiVar5[1] < (float)param_2) {
      ppiVar5[2] = param_3;
      ppiVar5[1] = param_2;
      ppiVar5[3] = param_4;
      ppiVar5[4] = *param_5;
      ppiVar5[5] = param_5[1];
      ppiVar5[6] = param_5[2];
      ppiVar5[7] = *param_6;
      ppiVar5[8] = param_6[1];
      ppiVar5[9] = param_6[2];
      ppiVar5[10] = *param_7;
      ppiVar5[0xb] = param_7[1];
      ppiVar5[0xc] = param_7[2];
      ppiVar5[0xd] = *param_8;
      ppiVar5[0xe] = param_8[1];
      ppiVar5[0xf] = param_8[2];
      ppiVar5[0x10] = *param_12;
      ppiVar5[0x11] = param_12[1];
      ppiVar5[0x12] = param_12[2];
      FUN_005f6a70(ppiVar5 + 0x10);
      bVar1 = NAN(_DAT_006ea454);
      bVar2 = (float)param_10 < _DAT_006ea454;
      ppiVar5[0x13] = param_9;
      if (bVar2 != (NAN((float)param_10) || bVar1)) {
        param_10 = (int *)-(float)param_10;
      }
      ppiVar5[0x14] = param_10;
      ppiVar5[0x15] = param_11;
      FUN_0054a8d0(ppiVar5,*(undefined4 *)(param_1[1] + 0x1a4),1);
      if (param_11 != (int *)0x0) {
        FUN_0054a8d0(ppiVar5,param_11[0x69],0);
      }
    }
  }
  return;
}

