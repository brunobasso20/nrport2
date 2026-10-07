/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 006161c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_006161c0(int *param_1_00,uint param_1)

{
  float fVar1;
  float fVar2;
  uint uVar3;
  
  if (*(float *)((int)param_1_00 + 0x35) <= (float)param_1_00[3]) {
    if ((float)param_1_00[3] <= *(float *)((int)param_1_00 + 0x3d)) {
      param_1_00[3] = (int)((float)param_1 * (float)param_1_00[5] + (float)param_1_00[3]);
    }
    else {
      uVar3 = 0;
      if (param_1 != 0) {
        do {
          if (_DAT_006e97d8 <= (float)param_1_00[3]) break;
          uVar3 = uVar3 + 1;
          param_1_00[3] =
               (int)(((float)param_1_00[5] - *(float *)((int)param_1_00 + 0x39)) *
                     ((_DAT_006e97d8 - (float)param_1_00[3]) /
                     (_DAT_006e97d8 - *(float *)((int)param_1_00 + 0x3d))) +
                     *(float *)((int)param_1_00 + 0x39) + (float)param_1_00[3]);
        } while (uVar3 < param_1);
      }
    }
  }
  else {
    uVar3 = 0;
    if (param_1 != 0) {
      do {
        if (*(float *)((int)param_1_00 + 0x35) <= (float)param_1_00[3]) break;
        uVar3 = uVar3 + 1;
        param_1_00[3] =
             (int)(((float)param_1_00[3] / *(float *)((int)param_1_00 + 0x35)) *
                   ((float)param_1_00[5] - *(float *)((int)param_1_00 + 0x31)) +
                   *(float *)((int)param_1_00 + 0x31) + (float)param_1_00[3]);
      } while (uVar3 < param_1);
    }
  }
  if (*(float *)((int)param_1_00 + 0x25) <= (float)param_1_00[3]) {
    fVar2 = *(float *)((int)param_1_00 + 0x25);
    if (*param_1_00 == 1) {
      param_1_00[3] = (int)fVar2;
    }
    else {
      fVar1 = (float)param_1_00[3];
      if (fVar2 <= fVar1) {
        do {
          fVar1 = fVar1 - fVar2;
        } while (fVar2 <= fVar1);
        param_1_00[3] = (int)fVar1;
      }
    }
    param_1_00[1] = param_1_00[1] + 1;
    if ((*param_1_00 != 1) && (param_1_00[7] != 0)) {
      *(undefined1 *)(param_1_00 + 9) = 0;
      param_1_00[3] = *(int *)((int)param_1_00 + 0x25);
      *(undefined4 *)((int)param_1_00 + 0x29) = *(undefined4 *)((int)param_1_00 + 0x41);
      param_1_00[2] = 0;
      *(undefined4 *)((int)param_1_00 + 0x2d) = *(undefined4 *)((int)param_1_00 + 0x45);
      param_1_00[8] = param_1_00[7];
      return;
    }
    if (*(int *)((int)param_1_00 + 0x62) != 0) {
      *(undefined1 *)(*(int *)((int)param_1_00 + 0x62) + 0x29) = 1;
    }
  }
  return;
}


