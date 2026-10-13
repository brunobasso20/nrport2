/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00513eaa */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00513eaa(int param_1,undefined4 param_2,float param_3,float param_4,float param_5,
                 float *param_6)

{
  float fVar1;
  int iVar2;
  float fVar3;
  int iVar4;
  float *pfVar5;
  float *pfVar6;
  int iVar7;
  int iVar8;

  switch(param_2) {
  case 1:
  case 2:
  case 3:
  case 4:
    break;
  case 5:
  case 6:
  case 7:
  case 8:
    *param_6 = _DAT_0074c36c *
               *(float *)(&DAT_006f41d8 +
                         (((int)ROUND(param_3 * _DAT_006ea514) & 0xfU) * 0x10 +
                         ((int)ROUND(param_4 * _DAT_006ea514) & 0xfU)) * 4) + *param_6;
  default:
    return;
  }
  fVar1 = _DAT_006ea454;
  if (0 < *(int *)(param_1 + 0x1540)) {
    iVar8 = (int)ROUND(_DAT_00bba5a0 * param_3) - *(int *)(param_1 + 0x1538);
    if (iVar8 < 0) {
      iVar8 = 0;
    }
    if (*(int *)(param_1 + 0x153c) <= iVar8) {
      iVar8 = *(int *)(param_1 + 0x153c) + -1;
    }
    if (_DAT_006ea454 <= param_5) {
      if (_DAT_006e97d8 < param_5) {
        param_5 = 1.0;
      }
    }
    else {
      param_5 = 0.0;
    }
    if (*(int *)(param_1 + 0x1540) == 1) {
      fVar1 = *(float *)(*(int *)(*(int *)(param_1 + 0x1544) + 0x10) + iVar8 * 8);
    }
    else {
      iVar2 = *(int *)(param_1 + 0x1544);
      iVar7 = *(int *)(param_1 + 0x1540) + -1;
      pfVar6 = (float *)(iVar2 + iVar7 * 0x14);
      iVar4 = iVar7;
      if (iVar7 < 0) {
LAB_00513fc3:
        fVar1 = *(float *)(*(int *)(iVar2 + 0x10) + iVar8 * 8);
      }
      else {
        do {
          fVar1 = param_5 * pfVar6[2] + *pfVar6;
          if (fVar1 < param_4) {
            if (iVar4 < 0) goto LAB_00513fc3;
            if (iVar4 == iVar7) {
              fVar1 = *(float *)((int)pfVar6[4] + iVar8 * 8);
            }
            else {
              pfVar5 = (float *)((int)pfVar6[4] + iVar8 * 8);
              fVar1 = ((param_4 - fVar1) / (param_5 * pfVar6[3] + pfVar6[1])) * pfVar5[1] + *pfVar5;
            }
            goto LAB_00513ff8;
          }
          iVar4 = iVar4 + -1;
          pfVar6 = pfVar6 + -5;
        } while (-1 < iVar4);
        fVar1 = *(float *)(*(int *)(iVar2 + 0x10) + iVar8 * 8);
      }
    }
  }
LAB_00513ff8:
  iVar8 = *(int *)(param_1 + 0x1548);
  if (0 < iVar8) {
    if (iVar8 == 1) {
      param_5 = param_5 * (*(float **)(param_1 + 0x154c))[6];
      pfVar5 = *(float **)(param_1 + 0x154c);
    }
    else {
      pfVar6 = *(float **)(param_1 + 0x154c);
      iVar8 = iVar8 + -1;
      pfVar5 = pfVar6 + iVar8 * 8;
      iVar7 = iVar8;
      if (iVar8 < 0) {
LAB_00514070:
        param_5 = param_5 * pfVar6[6];
        pfVar5 = pfVar6;
      }
      else {
        do {
          fVar3 = param_5 * pfVar5[2] + *pfVar5;
          if (fVar3 < param_4) {
            if (iVar7 < 0) goto LAB_00514070;
            if (iVar7 == iVar8) {
              param_5 = param_5 * pfVar5[6];
            }
            else {
              param_5 = param_5 * pfVar5[6] +
                        (param_5 * pfVar5[7] + pfVar5[5]) *
                        ((param_4 - fVar3) / (param_5 * pfVar5[3] + pfVar5[1]));
            }
            goto LAB_005140b1;
          }
          iVar7 = iVar7 + -1;
          pfVar5 = pfVar5 + -8;
        } while (-1 < iVar7);
        param_5 = param_5 * pfVar6[6];
        pfVar5 = pfVar6;
      }
    }
LAB_005140b1:
    fVar1 = (param_5 + pfVar5[4]) * fVar1;
  }
  *param_6 = _DAT_0074c36c * fVar1 + *param_6;
  return;
}
