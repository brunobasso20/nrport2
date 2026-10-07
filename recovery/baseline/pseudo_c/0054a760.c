/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054a760 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0054a760(int param_1,float param_2,int param_3,int param_4,int *param_5,int *param_6,
                 int *param_7,int *param_8,int param_9,float param_10,int param_11,int *param_12)

{
  bool bVar1;
  int *piVar2;
  uint uVar3;
  int *piVar4;
  
  piVar2 = DAT_00bf09c0;
  uVar3 = param_1 >> 4 & 0x1f;
  for (piVar4 = (int *)(&DAT_00bf0940)[uVar3]; piVar4 != (int *)0x0; piVar4 = (int *)piVar4[0x16]) {
    if (*piVar4 == param_1) goto LAB_0054a7c4;
  }
  if (DAT_00bf09c0 != (int *)0x0) {
    piVar4 = DAT_00bf09c0 + 0x17;
    DAT_00bf09c0 = (int *)*DAT_00bf09c0;
    *piVar4 = (int)DAT_00bf39f0;
    DAT_00bf39f0 = piVar2;
    piVar2[0x16] = (&DAT_00bf0940)[uVar3];
    (&DAT_00bf0940)[uVar3] = piVar2;
    piVar2[1] = -0x40800000;
    *piVar2 = param_1;
    piVar4 = piVar2;
LAB_0054a7c4:
    if ((float)piVar4[1] < param_2) {
      piVar4[2] = param_3;
      piVar4[1] = (int)param_2;
      piVar4[3] = param_4;
      piVar4[4] = *param_5;
      piVar4[5] = param_5[1];
      piVar4[6] = param_5[2];
      piVar4[7] = *param_6;
      piVar4[8] = param_6[1];
      piVar4[9] = param_6[2];
      piVar4[10] = *param_7;
      piVar4[0xb] = param_7[1];
      piVar4[0xc] = param_7[2];
      piVar4[0xd] = *param_8;
      piVar4[0xe] = param_8[1];
      piVar4[0xf] = param_8[2];
      piVar4[0x10] = *param_12;
      piVar4[0x11] = param_12[1];
      piVar4[0x12] = param_12[2];
      FUN_005f6a70(piVar4 + 0x10);
      bVar1 = param_10 < _DAT_006ea454;
      piVar4[0x13] = param_9;
      if (bVar1) {
        param_10 = -param_10;
      }
      piVar4[0x14] = (int)param_10;
      piVar4[0x15] = param_11;
      FUN_0054a8d0(piVar4,*(undefined4 *)(*(int *)(param_1 + 4) + 0x1a4),1);
      if (param_11 != 0) {
        FUN_0054a8d0(piVar4,*(undefined4 *)(param_11 + 0x1a4),0);
      }
    }
  }
  return;
}


