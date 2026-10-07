/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005117ba */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005117ba(int param_1,int *param_2,int param_3)

{
  int *piVar1;
  int iVar2;
  float fVar3;
  float fVar4;
  float10 fVar5;
  int iVar6;
  float10 fVar7;
  
  iVar2 = *(int *)(*(int *)(param_1 + 0x52) + -4 + param_3 * 4);
  fVar3 = *(float *)(iVar2 + 0xc);
  fVar4 = *(float *)(iVar2 + 0x10);
  piVar1 = param_2 + param_3 * 9 + 0x15e;
  iVar6 = FUN_00579d60(*(undefined4 *)(iVar2 + 0x15));
  fVar4 = fVar4 - fVar3;
  *piVar1 = iVar6;
  iVar6 = *(int *)(iVar2 + 0x19);
  piVar1[3] = (int)fVar3;
  piVar1[1] = iVar6;
  piVar1[4] = (int)fVar4;
  fVar3 = fVar4 * _DAT_006ea454 + fVar3;
  if (*param_2 == 1) {
    piVar1[5] = (int)(fVar3 * (float)param_2[0x10] +
                      (float)param_2[2] * (float)param_2[0x11] * _DAT_006ea454 + (float)param_2[0xc]
                     );
    piVar1[6] = (int)(fVar3 * (float)param_2[0x11] +
                     ((float)param_2[0xd] - (float)param_2[2] * (float)param_2[0x10] * _DAT_006ea454
                     ));
  }
  else {
    fVar7 = (float10)((float)param_2[0x14] * _DAT_006ea454 + (float)param_2[0x13]);
    fVar5 = (float10)fcos(fVar7);
    fVar7 = (float10)fsin(fVar7);
    fVar4 = (float)param_2[0x11];
    piVar1[5] = (int)((float)fVar7 * (fVar4 - fVar3) + (float)param_2[0xc]);
    piVar1[6] = (int)((float)param_2[0xd] - (float)fVar5 * (fVar4 - fVar3));
  }
  fVar3 = (float)piVar1[3] + (float)piVar1[4];
  if (*param_2 == 1) {
    piVar1[7] = (int)(fVar3 * (float)param_2[0x10] + (float)param_2[2] * (float)param_2[0x11] +
                     (float)param_2[0xc]);
    piVar1[8] = (int)(fVar3 * (float)param_2[0x11] +
                     ((float)param_2[0xd] - (float)param_2[2] * (float)param_2[0x10]));
  }
  else {
    fVar5 = (float10)fcos((float10)((float)param_2[0x14] + (float)param_2[0x13]));
    fVar7 = (float10)fsin((float10)((float)param_2[0x14] + (float)param_2[0x13]));
    fVar4 = (float)param_2[0x11];
    piVar1[7] = (int)((float)fVar7 * (fVar4 - fVar3) + (float)param_2[0xc]);
    piVar1[8] = (int)((float)param_2[0xd] - (float)fVar5 * (fVar4 - fVar3));
  }
  piVar1[7] = (int)((float)piVar1[7] - (float)piVar1[5]);
  piVar1[8] = (int)((float)piVar1[8] - (float)piVar1[6]);
  piVar1[2] = (uint)*(byte *)(iVar2 + 0x14);
  return;
}


