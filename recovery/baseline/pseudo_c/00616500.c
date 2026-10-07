/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00616500 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __thiscall FUN_00616500(int *param_1_00,uint param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  uint in_EAX;
  int iVar5;
  
  if (((param_1 == 0) || (in_EAX = param_1_00[4], in_EAX == 0)) ||
     ((0 < *param_1_00 && (*param_1_00 <= param_1_00[1])))) {
    return in_EAX & 0xffffff00;
  }
  if (100 < param_1) {
    param_1 = 100;
  }
  iVar1 = *(int *)((int)param_1_00 + 0x29);
  iVar2 = *(int *)((int)param_1_00 + 0x2d);
  if ((in_EAX == 1) || (in_EAX == 3)) {
    iVar5 = 0;
    if (0 < (int)param_1) {
      do {
        if ((0 < *param_1_00) && (*param_1_00 <= param_1_00[1])) break;
        iVar3 = param_1_00[2];
        param_1_00[2] = iVar3 + 1U;
        if ((char)param_1_00[9] == '\0') {
          iVar4 = *(int *)((int)param_1_00 + 0x62);
          if (iVar4 != 0) {
            *(undefined1 *)(iVar4 + 0x29) = 0;
          }
          if ((uint)param_1_00[8] < iVar3 + 1U) {
            param_1_00[2] = 0;
            *(undefined1 *)(param_1_00 + 9) = 1;
            param_1_00[3] = 0;
            if (iVar4 != 0) {
              *(undefined1 *)(iVar4 + 0x29) = 1;
            }
          }
        }
        else {
          FUN_006161c0(1);
        }
        iVar5 = iVar5 + 1;
      } while (iVar5 < (int)param_1);
    }
  }
  else {
    iVar5 = 0;
    if (0 < (int)param_1) {
      do {
        if ((0 < *param_1_00) && (*param_1_00 <= param_1_00[1])) break;
        iVar3 = param_1_00[2];
        param_1_00[2] = iVar3 + 1U;
        if ((char)param_1_00[9] == '\0') {
          iVar4 = *(int *)((int)param_1_00 + 0x62);
          if (iVar4 != 0) {
            *(undefined1 *)(iVar4 + 0x29) = 0;
          }
          if ((uint)param_1_00[8] < iVar3 + 1U) {
            param_1_00[2] = 0;
            *(undefined1 *)(param_1_00 + 9) = 1;
            param_1_00[3] = 0;
            if (iVar4 != 0) {
              *(undefined1 *)(iVar4 + 0x29) = 1;
            }
          }
        }
        else {
          FUN_00616330(1);
        }
        iVar5 = iVar5 + 1;
      } while (iVar5 < (int)param_1);
    }
  }
  if ((char)param_1_00[9] == '\0') {
    if (*(int *)((int)param_1_00 + 0x62) != 0) {
      *(undefined1 *)(*(int *)((int)param_1_00 + 0x62) + 0x29) = 0;
    }
  }
  else if ((*param_1_00 < 1) || (param_1_00[1] < *param_1_00)) {
    if (*(char *)((int)param_1_00 + 0x61) == '\0') {
      switch(param_1_00[4]) {
      case 1:
        FUN_006160b0(param_1_00[3]);
        break;
      case 2:
        if (_DAT_006e97d8 <= (float)param_1_00[3]) {
          FUN_006160b0(*(float *)((int)param_1_00 + 0x25) - (float)param_1_00[3]);
        }
        else {
          FUN_006160b0(param_1_00[3]);
        }
        break;
      case 3:
        FUN_00616120(param_1_00[3]);
        break;
      case 4:
        if (_DAT_006e97d8 <= (float)param_1_00[3]) {
          FUN_00616120(*(float *)((int)param_1_00 + 0x25) - (float)param_1_00[3]);
        }
        else {
          FUN_00616120(param_1_00[3]);
        }
      }
    }
  }
  else {
    iVar5 = param_1_00[4];
    if ((iVar5 == 2) || (iVar5 == 4)) {
      *(undefined4 *)((int)param_1_00 + 0x29) = *(undefined4 *)((int)param_1_00 + 0x41);
      *(undefined4 *)((int)param_1_00 + 0x2d) = *(undefined4 *)((int)param_1_00 + 0x45);
      param_1_00[3] = 0;
    }
    else if ((iVar5 == 1) || (iVar5 == 3)) {
      *(undefined4 *)((int)param_1_00 + 0x29) = *(undefined4 *)((int)param_1_00 + 0x49);
      *(undefined4 *)((int)param_1_00 + 0x2d) = *(undefined4 *)((int)param_1_00 + 0x4d);
      param_1_00[3] = 0x3f800000;
    }
  }
  if ((*(int *)((int)param_1_00 + 0x29) == iVar1) && (*(int *)((int)param_1_00 + 0x2d) == iVar2)) {
    return 0;
  }
  return 1;
}


