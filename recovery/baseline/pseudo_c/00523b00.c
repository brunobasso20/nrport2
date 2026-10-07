/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00523b00 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00523b00(float *param_1_00,uint *param_1,uint param_2,char param_3)

{
  float fVar1;
  uint uVar2;
  float fVar3;
  float fVar4;
  char cVar5;
  
  if (param_1 != (uint *)0x0) {
    *param_1 = 0;
    cVar5 = FUN_0040ee50(param_2);
    if (((((cVar5 != '\0') &&
          (((*(int *)(*(int *)((int)param_1_00 + 0x89) + 4) != 0 && (param_3 == '\0')) ||
           (*(char *)((int)param_1_00 + param_2 * 0xcb + 0x34c) != '\0')))) &&
         (((*(int *)((int)param_1_00 + param_2 * 0xcb + 0x344) != 0 &&
           (*(char *)(param_1_00 + 0x19) != '\0')) &&
          (*(char *)((int)param_1_00 + param_2 * 0xcb + 0x282) != '\0')))) &&
        ((*(char *)(param_1_00 + 0x22) == '\0' &&
         ((cVar5 = FUN_0040edc0(), cVar5 != '\0' ||
          (0 < *(int *)((int)param_1_00 + param_2 * 0xcb + 0x348))))))) &&
       ((*(char *)((int)param_1_00 + param_2 * 0xcb + 0x34c) != '\0' ||
        ((cVar5 = FUN_00535410(*(undefined4 *)((int)param_1_00 + 0x89)), cVar5 != '\0' ||
         (cVar5 = FUN_00535440(*(undefined4 *)((int)param_1_00 + 0x89)), cVar5 != '\0')))))) {
      uVar2 = *param_1;
      *param_1 = uVar2 | 1;
      if (0 < *(int *)((int)param_1_00 + param_2 * 0xcb + 0x348)) {
        *param_1 = uVar2 | 3;
      }
      param_1[1] = (uint)((*(float *)((int)param_1_00 + param_2 * 0xcb + 0x283) * param_1_00[0x16] +
                          *param_1_00) -
                         *(float *)((int)param_1_00 + param_2 * 0xcb + 0x287) * param_1_00[0x17]);
      param_1[2] = (uint)(param_1_00[0x17] * *(float *)((int)param_1_00 + param_2 * 0xcb + 0x283) +
                          *(float *)((int)param_1_00 + param_2 * 0xcb + 0x287) * param_1_00[0x16] +
                         param_1_00[1]);
      param_1[4] = (uint)(param_1_00[0x18] + *(float *)((int)param_1_00 + param_2 * 0xcb + 0x28b));
      fVar1 = *(float *)((int)param_1_00 + 0x82) *
              *(float *)((int)param_1_00 + param_2 * 0xcb + 0x293);
      if (((*(int *)(*(int *)((int)param_1_00 + 0x89) + 4) == 0) ||
          (*(char *)((int)param_1_00 + 0x81) == '\0')) || (fVar1 <= _DAT_006ea454)) {
        param_1[8] = 0;
      }
      else {
        fVar3 = _DAT_006e97d8 - fVar1;
        param_1[8] = (uint)fVar1;
        param_1[1] = (uint)(fVar3 * (float)param_1[1] +
                           ((*(float *)((int)param_1_00 + 0x71) *
                             *(float *)((int)param_1_00 + param_2 * 0xcb + 0x283) +
                            *(float *)((int)param_1_00 + 0x79)) -
                           *(float *)((int)param_1_00 + param_2 * 0xcb + 0x287) *
                           *(float *)((int)param_1_00 + 0x75)) * fVar1);
        param_1[2] = (uint)(fVar3 * (float)param_1[2] +
                           (*(float *)((int)param_1_00 + param_2 * 0xcb + 0x287) *
                            *(float *)((int)param_1_00 + 0x71) +
                            *(float *)((int)param_1_00 + 0x75) *
                            *(float *)((int)param_1_00 + param_2 * 0xcb + 0x283) +
                           *(float *)((int)param_1_00 + 0x7d)) * fVar1);
        for (fVar4 = *(float *)((int)param_1_00 + 0x6d) +
                     *(float *)((int)param_1_00 + param_2 * 0xcb + 0x28b);
            fVar4 < (float)param_1[4] - _DAT_006f4a4c; fVar4 = fVar4 + _DAT_006ee484) {
        }
        for (; (float)param_1[4] + _DAT_006f4a4c < fVar4; fVar4 = fVar4 - _DAT_006ee484) {
        }
        param_1[4] = (uint)(fVar3 * (float)param_1[4] + fVar4 * fVar1);
      }
      fVar1 = (float)param_1[4];
      if (fVar1 < _DAT_006ea454) {
        do {
          fVar1 = fVar1 + _DAT_006ee484;
        } while (fVar1 < _DAT_006ea454);
        param_1[4] = (uint)fVar1;
      }
      fVar1 = (float)param_1[4];
      if (_DAT_006ee484 <= fVar1) {
        do {
          fVar1 = fVar1 - _DAT_006ee484;
        } while (_DAT_006ee484 <= fVar1);
        param_1[4] = (uint)fVar1;
      }
      param_1[5] = (uint)param_1_00[9];
      param_1[6] = (uint)param_1_00[10];
      param_1[7] = (uint)param_1_00[0xb];
      param_1[3] = (uint)param_1_00[2];
      param_1[9] = *(uint *)((int)param_1_00 + param_2 * 0xcb + 0x28f);
      param_1[10] = *(uint *)((int)param_1_00 + param_2 * 0xcb + 0x297);
      uVar2 = *(uint *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2);
      param_1[0xc] = param_2;
      param_1[0xb] = uVar2;
      if (*(char *)((int)param_1_00 + 0xfe) != '\0') {
        *param_1 = *param_1 | 4;
      }
    }
  }
  return;
}


