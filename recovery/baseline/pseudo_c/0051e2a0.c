/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051e2a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051e2a0(float param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  int iVar5;
  int iVar6;
  ushort uVar7;
  float10 fVar8;
  
  iVar5 = (int)param_1;
  FUN_0052dc70();
  if (0 < *(int *)((int)param_1 + 0x18fa)) {
    *(undefined4 *)((int)param_1 + 0x1ada) = 0;
    goto LAB_0051e489;
  }
  if ((*(float *)((int)param_1 + 0x1906) <= *(float *)((int)param_1 + 0x444) - _DAT_006ed00c) ||
     (*(int *)((int)param_1 + 0x450) + 1 <= *(int *)((int)param_1 + 0x18f6))) {
    iVar6 = *(int *)((int)param_1 + 0x18f6);
    if (2 < iVar6) {
      if (*(char *)((int)param_1 + 0x1b32) == '\0') {
        fVar1 = _DAT_006f499c;
        if (DAT_00bdbd00 == 5) {
          fVar1 = _DAT_006e981c;
        }
        if (iVar6 < 4) {
          fVar1 = _DAT_006ea454;
          if (iVar6 == 3) {
            fVar1 = (*(float *)((int)param_1 + 0x444) - _DAT_006ed00c) * _DAT_006ea470;
          }
        }
        else {
          fVar1 = (*(float *)((int)param_1 + 0x444) - _DAT_006ed00c) *
                  ((*(float *)((int)param_1 + 0x454 + iVar6 * 4) * *(float *)((int)param_1 + 0x474))
                  / (*(float *)((int)param_1 + 0x450 + iVar6 * 4) * *(float *)((int)param_1 + 0x474)
                    )) * fVar1;
        }
        uVar7 = (ushort)(fVar1 < *(float *)((int)param_1 + 0x1906)) << 8 |
                (ushort)(fVar1 == *(float *)((int)param_1 + 0x1906)) << 0xe;
      }
      else {
        fVar1 = (*(float *)((int)param_1 + 0x450 + iVar6 * 4) * *(float *)((int)param_1 + 0x474) *
                *(float *)((int)param_1 + 0x1906)) /
                (*(float *)((int)param_1 + 0x454 + iVar6 * 4) * *(float *)((int)param_1 + 0x474));
        fVar2 = *(float *)((int)param_1 + 0x444) * _DAT_006efb28;
        uVar7 = (ushort)(fVar2 < fVar1) << 8 | (ushort)(fVar2 == fVar1) << 0xe;
      }
      if (uVar7 == 0) {
        *(undefined4 *)((int)param_1 + 0x1b26) = 6;
        *(int *)((int)param_1 + 0x18f6) = iVar6 + -1;
        goto LAB_0051e3d2;
      }
    }
  }
  else {
    *(int *)((int)param_1 + 0x18f6) = *(int *)((int)param_1 + 0x18f6) + 1;
LAB_0051e3d2:
    iVar6 = FUN_006c5018();
    *(int *)((int)param_1 + 0x18fa) = iVar6;
    if ((char)*(uint *)((int)param_1 + 0x139f) < '\0') {
      *(int *)((int)param_1 + 0x18fa) = iVar6 * 2;
      *(uint *)((int)param_1 + 0x139f) = *(uint *)((int)param_1 + 0x139f) & 0xffffff7f;
    }
    *(undefined4 *)((int)param_1 + 0x19c2) = _DAT_0074abb8;
    *(undefined4 *)((int)param_1 + 0x1992) = 0;
  }
  fVar8 = (float10)FUN_0051e930(param_1);
  *(float *)((int)param_1 + 0x1aea) = (float)fVar8;
  fVar8 = fVar8 * (float10)*(float *)((int)param_1 + 0x1d36);
  *(float *)((int)param_1 + 0x1ada) = (float)fVar8;
  if (*(int *)((int)param_1 + 0x1d06) != 0x3f800000) {
    *(float *)((int)param_1 + 0x1ada) =
         (float)((((float10)*(float *)((int)param_1 + 0x1d06) - (float10)_DAT_006e97d8) *
                  (float10)_DAT_0074adb0 + (float10)_DAT_006e97d8) * fVar8);
  }
  if (*(int *)((int)param_1 + 0x1d26) != 0x3f800000) {
    *(float *)((int)param_1 + 0x1ada) =
         ((*(float *)((int)param_1 + 0x1d26) - _DAT_006e97d8) * _DAT_0074adc8 + _DAT_006e97d8) *
         *(float *)((int)param_1 + 0x1ada);
  }
LAB_0051e489:
  fVar1 = *(float *)((int)param_1 + 0x195a);
  if (ABS(*(float *)((int)param_1 + 0x195a)) + _DAT_006f412c < *(float *)((int)param_1 + 0x1972)) {
    fVar2 = *(float *)((int)param_1 + 0x195a) / *(float *)((int)param_1 + 0x1972);
    if (*(float *)((int)param_1 + 0x1956) <= _DAT_006ea454) {
      *(float *)((int)param_1 + 0x1976) =
           (_DAT_006e97d8 - fVar2 * fVar2) * *(float *)((int)param_1 + 0x196a) *
           *(float *)((int)param_1 + 0x1972);
    }
    else {
      *(float *)((int)param_1 + 0x1976) =
           SQRT(_DAT_006e97d8 - fVar2 * fVar2) * *(float *)((int)param_1 + 0x196a) *
           *(float *)((int)param_1 + 0x1972);
    }
  }
  else {
    *(undefined4 *)((int)param_1 + 0x1976) = 0;
  }
  fVar2 = *(float *)((int)param_1 + 0x1ada) -
          (*(float *)((int)param_1 + 0x1afa) + *(float *)((int)param_1 + 0x1ada)) * _DAT_0074ab70;
  if (_DAT_006ea454 < *(float *)((int)param_1 + 0x1b40)) {
    fVar2 = ((_DAT_006e97d8 - *(float *)((int)param_1 + 0x1b40)) * (_DAT_006e97d8 - _DAT_0074ac30) +
            _DAT_0074ac30) * fVar2;
  }
  param_1 = fVar2;
  if (0 < *(int *)(iVar5 + 0x1b22)) {
    if (*(float *)(iVar5 + 0x1956) <= _DAT_006ea454) {
      *(int *)(iVar5 + 0x1b22) = *(int *)(iVar5 + 0x1b22) + -1;
    }
    else {
      *(undefined4 *)(iVar5 + 0x1b22) = 0;
    }
  }
  iVar6 = *(int *)(*(int *)(iVar5 + 0x13b3) + 8);
  if ((iVar6 != 0) && (iVar6 != 1)) {
    if (*(float *)(iVar5 + 0x1956) <= _DAT_006ea454) {
      fVar2 = -(*(float *)(iVar5 + 0x1d3e) * *(float *)(iVar5 + 0x196a) * *(float *)(iVar5 + 0x1972)
               * _DAT_0074b0b0);
      if (0 < *(int *)(iVar5 + 0x1b22)) {
        fVar2 = fVar2 * _DAT_006ed6c8;
      }
      if (*(float *)(iVar5 + 0x1956) < fVar2) {
        *(float *)(iVar5 + 0x1956) = fVar2;
      }
    }
    else {
      fVar8 = (float10)FUN_0050a170(*(undefined4 *)(iVar5 + 0x1ae2));
      fVar8 = fVar8 * (float10)*(float *)(iVar5 + 0x196a) * (float10)*(float *)(iVar5 + 0x1972);
      if (fVar8 < (float10)param_1) {
        param_1 = (float)fVar8;
      }
      if (param_1 < *(float *)(iVar5 + 0x1956)) {
        *(float *)(iVar5 + 0x1956) = param_1;
      }
    }
  }
  fVar2 = *(float *)(iVar5 + 0x1afa) / *(float *)(iVar5 + 0x59e);
  fVar3 = _DAT_006ed6c8 * fVar2;
  fVar4 = *(float *)(iVar5 + 0x1896);
  if (param_1 <= *(float *)(iVar5 + 0x1896)) {
    fVar4 = param_1;
  }
  if (*(float *)(iVar5 + 0x1976) < fVar4) {
    fVar4 = *(float *)(iVar5 + 0x1976);
  }
  *(float *)(iVar5 + 0x195e) = fVar2 * _DAT_006f4998;
  *(float *)(iVar5 + 0x1962) = fVar3 + fVar4;
  *(float *)(iVar5 + 0x1966) = fVar4 + fVar2;
  fVar2 = *(float *)(iVar5 + 0x1976) - ABS(*(float *)(iVar5 + 0x1956));
  *(float *)(iVar5 + 0x1976) = fVar2;
  if (fVar2 < _DAT_006ea454) {
    if (_DAT_006f4994 < *(float *)(iVar5 + 0x1872)) {
      *(float *)(iVar5 + 0x1956) =
           *(float *)(iVar5 + 0x1956) -
           *(float *)(iVar5 + 0x1892) * *(float *)(iVar5 + 0x195a) * _DAT_006f4984;
    }
    fVar2 = *(float *)(iVar5 + 0x1956) / *(float *)(iVar5 + 0x196a);
    *(undefined4 *)(iVar5 + 0x1976) = 0;
    fVar1 = *(float *)(iVar5 + 0x1972) / SQRT(fVar2 * fVar2 + fVar1 * fVar1);
    *(float *)(iVar5 + 0x1956) = fVar1 * *(float *)(iVar5 + 0x1956);
    *(float *)(iVar5 + 0x195a) = fVar1 * *(float *)(iVar5 + 0x195a);
  }
  if ((*(byte *)(iVar5 + 0x139f) & 7) == 0) {
    fVar1 = _DAT_006ea454;
    if ((_DAT_006ea454 < *(float *)(iVar5 + 0x1aea)) &&
       (fVar1 = *(float *)(iVar5 + 0x1956) / *(float *)(iVar5 + 0x1aea) + _DAT_006ec744,
       _DAT_006e97d8 < fVar1)) {
      fVar1 = _DAT_006e97d8;
    }
    if (*(float *)(iVar5 + 0x1b40) <= _DAT_006ea454) {
      *(float *)(iVar5 + 0x18fe) = fVar1;
    }
    else {
      *(float *)(iVar5 + 0x18fe) =
           *(float *)(iVar5 + 0x18fe) * *(float *)(iVar5 + 0x1b40) +
           (_DAT_006e97d8 - *(float *)(iVar5 + 0x1b40)) * fVar1;
    }
    fVar1 = _DAT_006ea454;
    if (_DAT_006ea454 < *(float *)(iVar5 + 0x18fe)) {
      fVar1 = *(float *)(iVar5 + 0x18fe);
    }
    *(float *)(iVar5 + 0x18fe) = fVar1;
  }
  *(float *)(iVar5 + 0x1882) = *(float *)(iVar5 + 0x1956) - *(float *)(iVar5 + 0x1d4e);
  *(float *)(iVar5 + 0x1992) =
       (*(float *)(iVar5 + 0x1956) - *(float *)(iVar5 + 0x1992)) * *(float *)(iVar5 + 0x198e) +
       *(float *)(iVar5 + 0x1992);
  *(float *)(iVar5 + 0x199e) =
       (*(float *)(iVar5 + 0x195a) - *(float *)(iVar5 + 0x199e)) * *(float *)(iVar5 + 0x199a) +
       *(float *)(iVar5 + 0x199e);
  if (((*(byte *)(iVar5 + 0x139f) & 0x40) != 0) && (*(float *)(iVar5 + 0x1992) < _DAT_006ea454)) {
    iVar6 = FUN_006c5bf8();
    *(int *)(iVar5 + 0x1b22) = iVar6 % 0x1b + 9;
    *(uint *)(iVar5 + 0x139f) = *(uint *)(iVar5 + 0x139f) & 0xffffffbf;
  }
  fVar1 = _DAT_006ea454;
  if ((*(float *)(iVar5 + 0x1956) < _DAT_006ea454 == (*(float *)(iVar5 + 0x1956) == _DAT_006ea454))
     && (*(float *)(iVar5 + 0x1972) < _DAT_006ea454 == (*(float *)(iVar5 + 0x1972) == _DAT_006ea454)
        )) {
    fVar1 = *(float *)(iVar5 + 0x1956) / (*(float *)(iVar5 + 0x196a) * *(float *)(iVar5 + 0x1972));
  }
  *(float *)(iVar5 + 0x19aa) =
       (fVar1 - *(float *)(iVar5 + 0x19aa)) * *(float *)(iVar5 + 0x19a6) +
       *(float *)(iVar5 + 0x19aa);
  return;
}


