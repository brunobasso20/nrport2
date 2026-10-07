/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00616330 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00616330(int *param_1_00,float param_1)

{
  float fVar1;
  float fVar2;
  int iVar3;
  int iVar4;
  
  if (param_1 != 0.0) {
    iVar3 = *param_1_00;
    iVar4 = (int)param_1;
    do {
      if ((0 < iVar3) && (iVar3 <= param_1_00[1])) {
        return;
      }
      if (_DAT_006e97d8 <= (float)param_1_00[3]) {
        fVar1 = *(float *)((int)param_1_00 + 0x25) - (float)param_1_00[3];
        param_1 = -1.0;
      }
      else {
        fVar1 = (float)param_1_00[3];
        param_1 = 1.0;
      }
      if (*(float *)((int)param_1_00 + 0x35) <= fVar1) {
        if ((*(float *)((int)param_1_00 + 0x3d) <= (float)_DAT_006efdf0) ||
           (fVar1 <= *(float *)((int)param_1_00 + 0x3d))) {
          iVar4 = iVar4 + -1;
          fVar1 = param_1 * (float)param_1_00[5] + fVar1;
        }
        else {
          for (; ((iVar4 != 0 && (fVar1 < _DAT_006e97d8 != (fVar1 == _DAT_006e97d8))) &&
                 (*(float *)((int)param_1_00 + 0x3d) < fVar1));
              fVar1 = (((float)param_1_00[5] - *(float *)((int)param_1_00 + 0x39)) *
                       ((_DAT_006e97d8 - fVar1) /
                       (_DAT_006e97d8 - *(float *)((int)param_1_00 + 0x3d))) +
                      *(float *)((int)param_1_00 + 0x39)) * param_1 + fVar1) {
            iVar4 = iVar4 + -1;
          }
        }
      }
      else {
        for (; ((iVar4 != 0 && (_DAT_006ea454 <= fVar1)) &&
               (fVar1 < *(float *)((int)param_1_00 + 0x35)));
            fVar1 = ((fVar1 / *(float *)((int)param_1_00 + 0x35)) *
                     ((float)param_1_00[5] - *(float *)((int)param_1_00 + 0x31)) +
                    *(float *)((int)param_1_00 + 0x31)) * param_1 + fVar1) {
          iVar4 = iVar4 + -1;
        }
      }
      if (_DAT_006e97d8 <= (float)param_1_00[3]) {
        param_1_00[3] = (int)(*(float *)((int)param_1_00 + 0x25) - fVar1);
      }
      else {
        param_1_00[3] = (int)fVar1;
      }
      if (*(float *)((int)param_1_00 + 0x25) <= (float)param_1_00[3]) {
        fVar1 = *(float *)((int)param_1_00 + 0x25);
        if (iVar3 == 1) {
          param_1_00[3] = (int)fVar1;
        }
        else {
          fVar2 = (float)param_1_00[3];
          if (fVar1 <= fVar2) {
            do {
              fVar2 = fVar2 - fVar1;
            } while (fVar1 <= fVar2);
            param_1_00[3] = (int)fVar2;
          }
        }
        param_1_00[1] = param_1_00[1] + 1;
        if ((iVar3 == 1) || (param_1_00[7] == 0)) {
          if (*(int *)((int)param_1_00 + 0x62) != 0) {
            *(undefined1 *)(*(int *)((int)param_1_00 + 0x62) + 0x29) = 1;
          }
        }
        else {
          *(undefined1 *)(param_1_00 + 9) = 0;
          param_1_00[3] = *(int *)((int)param_1_00 + 0x25);
          *(undefined4 *)((int)param_1_00 + 0x29) = *(undefined4 *)((int)param_1_00 + 0x41);
          param_1_00[2] = 0;
          *(undefined4 *)((int)param_1_00 + 0x2d) = *(undefined4 *)((int)param_1_00 + 0x45);
          param_1_00[8] = param_1_00[7];
        }
      }
    } while (iVar4 != 0);
  }
  return;
}


