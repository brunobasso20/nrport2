/* NR2003.exe @ 005b4060 FUN_005b4060 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005b4060(int param_1)

{
  uint uVar1;
  int iVar2;
  int iVar3;
  
  FUN_0057ca60(param_1 + 0x1b5,*(undefined4 *)(param_1 + 0x44));
  FUN_0057ca60(param_1 + 0x1b9,*(undefined4 *)(param_1 + 0x48));
  if (*(char *)(param_1 + 0x50) == '\0') {
    FUN_0057ca60(param_1 + 0x1bd,*(undefined4 *)(param_1 + 0x4c));
  }
  else {
    FUN_0057c990(param_1 + 0x1bd,*(undefined4 *)(param_1 + 0x4c));
  }
  FUN_005b8c40(param_1 + 0x1c1,*(float *)(param_1 + 0x51) * _DAT_006e97f0,
               *(float *)(param_1 + 0x55) * _DAT_006e97f0,*(float *)(param_1 + 0x59) * _DAT_006e97f0
              );
  iVar2 = 6;
  iVar3 = param_1 + 0x95;
  do {
    FUN_0057ca60(iVar3,0x3f800000);
    iVar3 = iVar3 + 0x1c;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  *(undefined4 *)(param_1 + 0x79) = 0;
  if ((*(uint *)(param_1 + 0x40) & 1) == 0) {
    if (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 1) {
      FUN_0057c990(param_1 + 0x1e5);
      FUN_0057c990(param_1 + 0x29d,0);
    }
    else {
      FUN_0057ca60(param_1 + 0x1e5,0);
      FUN_0057ca60(param_1 + 0x29d,0);
    }
  }
  else {
    FUN_0057c990(param_1 + 0x1e5);
    FUN_0057c990(param_1 + 0x29d,0);
    FUN_0057ca60(param_1 + 0x95,0);
    *(undefined4 *)(param_1 + 0x7d + *(int *)(param_1 + 0x79) * 4) = 0;
    *(int *)(param_1 + 0x79) = *(int *)(param_1 + 0x79) + 1;
  }
  if ((*(uint *)(param_1 + 0x40) & 2) == 0) {
    if (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 2) {
      FUN_0057c990(param_1 + 0x1e9);
      FUN_0057c990(param_1 + 0x2a1,0);
    }
    else {
      FUN_0057ca60(param_1 + 0x1e9,0);
      FUN_0057ca60(param_1 + 0x2a1,0);
    }
  }
  else {
    FUN_0057c990(param_1 + 0x1e9);
    FUN_0057c990(param_1 + 0x2a1,0);
    FUN_0057ca60(param_1 + 0xb1,0);
    *(undefined4 *)(param_1 + 0x7d + *(int *)(param_1 + 0x79) * 4) = 1;
    *(int *)(param_1 + 0x79) = *(int *)(param_1 + 0x79) + 1;
  }
  if ((*(uint *)(param_1 + 0x40) & 4) == 0) {
    if (((int)*(uint *)(param_1 + 0x40) >> 7 & 7U) == 3) {
      FUN_0057c990(param_1 + 0x1ed);
      FUN_0057c990(param_1 + 0x2a5,0);
    }
    else {
      FUN_0057ca60(param_1 + 0x1ed,0);
      FUN_0057ca60(param_1 + 0x2a5,0);
    }
  }
  else {
    FUN_0057c990(param_1 + 0x1ed);
    FUN_0057c990(param_1 + 0x2a5,0);
    FUN_0057ca60(param_1 + 0xcd,0);
    *(undefined4 *)(param_1 + 0x7d + *(int *)(param_1 + 0x79) * 4) = 2;
    *(int *)(param_1 + 0x79) = *(int *)(param_1 + 0x79) + 1;
  }
  iVar3 = param_1 + 0x275;
  FUN_0057ca60(iVar3,0);
  FUN_0057ca60(param_1 + 0x279,0);
  FUN_0057ca60(param_1 + 0x27d,0);
  FUN_0057ca60(param_1 + 0x281,0x3f800000);
  FUN_0057ca60(param_1 + 0x2a9,0);
  FUN_0057ca60(param_1 + 0x2ad,0);
  FUN_0057ca60(param_1 + 0x2b1,0);
  uVar1 = *(uint *)(param_1 + 0x40);
  if ((int)(((int)uVar1 >> 7 & 7U) - 1) < 3) {
    if ((uVar1 & 0x18) == 0) {
      if ((uVar1 & 0x20) == 0) goto LAB_005b4448;
      FUN_0057c990(iVar3,0);
      FUN_0057c990(param_1 + 0x279,0);
      FUN_0057c990(param_1 + 0x27d,0);
      FUN_0057c990(param_1 + 0x281,0x3f800000);
      FUN_0057c990(param_1 + 0x2a9,0);
      FUN_0057c990(param_1 + 0x2ad,0);
      FUN_0057c990(param_1 + 0x2b1,0);
      FUN_0057ca60(param_1 + 0xe9,0);
      FUN_0057ca60(param_1 + 0x105,0);
      FUN_0057ca60(param_1 + 0x121,0);
      *(undefined4 *)(param_1 + 0x7d + *(int *)(param_1 + 0x79) * 4) = 3;
      iVar3 = *(int *)(param_1 + 0x79) + 1;
      *(int *)(param_1 + 0x79) = iVar3;
      *(undefined4 *)(param_1 + 0x7d + iVar3 * 4) = 4;
      iVar3 = *(int *)(param_1 + 0x79) + 1;
      *(int *)(param_1 + 0x79) = iVar3;
      *(undefined4 *)(param_1 + 0x7d + iVar3 * 4) = 5;
    }
    else {
      uVar1 = (int)uVar1 >> 3 & 3;
      iVar2 = uVar1 - 1;
      FUN_0057c990(iVar3,0);
      FUN_0057c990(param_1 + 0x2a9 + iVar2 * 4,0);
      FUN_0057ca60(param_1 + 0xe9 + iVar2 * 0x1c,0);
      *(uint *)(param_1 + 0x7d + *(int *)(param_1 + 0x79) * 4) = uVar1 + 2;
    }
    *(int *)(param_1 + 0x79) = *(int *)(param_1 + 0x79) + 1;
  }
  else {
    FUN_0057c990(iVar3,0);
    FUN_0057c990(param_1 + 0x299 + (*(int *)(param_1 + 0x40) >> 7 & 7U) * 4,0);
  }
LAB_005b4448:
  if (*(float *)(param_1 + 0x5d) < _DAT_006ea454 ==
      (NAN(*(float *)(param_1 + 0x5d)) || NAN(_DAT_006ea454))) {
    FUN_0057ca60(param_1 + 0x125,*(undefined4 *)(param_1 + 0x5d));
    FUN_0057ca60(param_1 + 0x141,*(undefined4 *)(param_1 + 0x5d));
    FUN_0057ca60(param_1 + 0x15d,*(undefined4 *)(param_1 + 0x5d));
    FUN_0057ca60(param_1 + 0x179,*(undefined4 *)(param_1 + 0x61));
    FUN_0057ca60(param_1 + 0x195,*(undefined4 *)(param_1 + 0x65));
    FUN_0057ca60(param_1 + 0x1b1,*(undefined4 *)(param_1 + 0x69));
    FUN_005b2ef0(param_1,FUN_005b4060);
    return;
  }
  FUN_0057c990(param_1 + 0x125,-*(float *)(param_1 + 0x5d));
  FUN_0057c990(param_1 + 0x141,-*(float *)(param_1 + 0x5d));
  FUN_0057c990(param_1 + 0x15d,-*(float *)(param_1 + 0x5d));
  FUN_0057c990(param_1 + 0x179,*(undefined4 *)(param_1 + 0x61));
  FUN_0057c990(param_1 + 0x195,*(undefined4 *)(param_1 + 0x65));
  FUN_0057c990(param_1 + 0x1b1,*(undefined4 *)(param_1 + 0x69));
  FUN_005b2ef0(param_1,FUN_005b4060);
  return;
}

