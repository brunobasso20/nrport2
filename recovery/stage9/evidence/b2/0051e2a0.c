/* NR2003.exe @ 0051e2a0 FUN_0051e2a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051e2a0(float param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  int iVar6;
  int iVar7;
  ushort uVar8;
  float10 fVar9;
  
  iVar6 = (int)param_1;
  FUN_0052dc70();
  if (0 < *(int *)((int)param_1 + 0x18fa)) {
    *(undefined4 *)((int)param_1 + 0x1ada) = 0;
    goto LAB_0051e489;
  }
  fVar1 = *(float *)((int)param_1 + 0x444) - _DAT_006ed00c;
  if ((fVar1 < *(float *)((int)param_1 + 0x1906) ==
       (NAN(fVar1) || NAN(*(float *)((int)param_1 + 0x1906)))) ||
     (*(int *)((int)param_1 + 0x450) + 1 <= *(int *)((int)param_1 + 0x18f6))) {
    iVar7 = *(int *)((int)param_1 + 0x18f6);
    if (2 < iVar7) {
      if (*(char *)((int)param_1 + 0x1b32) == '\0') {
        fVar1 = _DAT_006f499c;
        if (DAT_00bdbd00 == 5) {
          fVar1 = _DAT_006e981c;
        }
        if (iVar7 < 4) {
          fVar1 = _DAT_006ea454;
          if (iVar7 == 3) {
            fVar1 = (*(float *)((int)param_1 + 0x444) - _DAT_006ed00c) * _DAT_006ea470;
          }
        }
        else {
          fVar1 = (*(float *)((int)param_1 + 0x444) - _DAT_006ed00c) *
                  ((*(float *)((int)param_1 + 0x454 + iVar7 * 4) * *(float *)((int)param_1 + 0x474))
                  / (*(float *)((int)param_1 + 0x450 + iVar7 * 4) * *(float *)((int)param_1 + 0x474)
                    )) * fVar1;
        }
        uVar8 = (ushort)(fVar1 < *(float *)((int)param_1 + 0x1906)) << 8 |
                (ushort)(fVar1 == *(float *)((int)param_1 + 0x1906)) << 0xe;
      }
      else {
        fVar1 = (*(float *)((int)param_1 + 0x450 + iVar7 * 4) * *(float *)((int)param_1 + 0x474) *
                *(float *)((int)param_1 + 0x1906)) /
                (*(float *)((int)param_1 + 0x454 + iVar7 * 4) * *(float *)((int)param_1 + 0x474));
        fVar2 = *(float *)((int)param_1 + 0x444) * _DAT_006efb28;
        uVar8 = (ushort)(fVar2 < fVar1) << 8 | (ushort)(fVar2 == fVar1) << 0xe;
      }
      if (uVar8 == 0) {
        *(undefined4 *)((int)param_1 + 0x1b26) = 6;
        *(int *)((int)param_1 + 0x18f6) = iVar7 + -1;
        goto LAB_0051e3d2;
      }
    }
  }
  else {
    *(int *)((int)param_1 + 0x18f6) = *(int *)((int)param_1 + 0x18f6) + 1;
LAB_0051e3d2:
    iVar7 = FUN_006c5018();
    *(int *)((int)param_1 + 0x18fa) = iVar7;
    if ((char)*(uint *)((int)param_1 + 0x139f) < '\0') {
      *(int *)((int)param_1 + 0x18fa) = iVar7 * 2;
      *(uint *)((int)param_1 + 0x139f) = *(uint *)((int)param_1 + 0x139f) & 0xffffff7f;
    }
    *(undefined4 *)((int)param_1 + 0x19c2) = _DAT_0074abb8;
    *(undefined4 *)((int)param_1 + 0x1992) = 0;
  }
  fVar9 = (float10)FUN_0051e930(param_1);
  *(float *)((int)param_1 + 0x1aea) = (float)fVar9;
  fVar9 = fVar9 * (float10)*(float *)((int)param_1 + 0x1d36);
  *(float *)((int)param_1 + 0x1ada) = (float)fVar9;
  if (*(int *)((int)param_1 + 0x1d06) != 0x3f800000) {
    *(float *)((int)param_1 + 0x1ada) =
         (float)((((float10)*(float *)((int)param_1 + 0x1d06) - (float10)_DAT_006e97d8) *
                  (float10)_DAT_0074adb0 + (float10)_DAT_006e97d8) * fVar9);
  }
  if (*(int *)((int)param_1 + 0x1d26) != 0x3f800000) {
    *(float *)((int)param_1 + 0x1ada) =
         ((*(float *)((int)param_1 + 0x1d26) - _DAT_006e97d8) * _DAT_0074adc8 + _DAT_006e97d8) *
         *(float *)((int)param_1 + 0x1ada);
  }
LAB_0051e489:
  fVar1 = *(float *)((int)param_1 + 0x195a);
  if ((float)(*(uint *)((int)param_1 + 0x195a) & 0x7fffffff) + _DAT_006f412c <
      *(float *)((int)param_1 + 0x1972)) {
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
  if (0 < *(int *)(iVar6 + 0x1b22)) {
    if (*(float *)(iVar6 + 0x1956) <= _DAT_006ea454) {
      *(int *)(iVar6 + 0x1b22) = *(int *)(iVar6 + 0x1b22) + -1;
    }
    else {
      *(undefined4 *)(iVar6 + 0x1b22) = 0;
    }
  }
  iVar7 = *(int *)(*(int *)(iVar6 + 0x13b3) + 8);
  if ((iVar7 != 0) && (iVar7 != 1)) {
    if (*(float *)(iVar6 + 0x1956) <= _DAT_006ea454) {
      fVar2 = -(*(float *)(iVar6 + 0x1d3e) * *(float *)(iVar6 + 0x196a) * *(float *)(iVar6 + 0x1972)
               * _DAT_0074b0b0);
      if (0 < *(int *)(iVar6 + 0x1b22)) {
        fVar2 = fVar2 * _DAT_006ed6c8;
      }
      if (*(float *)(iVar6 + 0x1956) < fVar2) {
        *(float *)(iVar6 + 0x1956) = fVar2;
      }
    }
    else {
      fVar9 = (float10)FUN_0050a170(*(undefined4 *)(iVar6 + 0x1ae2));
      fVar9 = fVar9 * (float10)*(float *)(iVar6 + 0x196a) * (float10)*(float *)(iVar6 + 0x1972);
      if (fVar9 < (float10)param_1) {
        param_1 = (float)fVar9;
      }
      if (param_1 < *(float *)(iVar6 + 0x1956)) {
        *(float *)(iVar6 + 0x1956) = param_1;
      }
    }
  }
  fVar4 = *(float *)(iVar6 + 0x1afa) / *(float *)(iVar6 + 0x59e);
  fVar5 = _DAT_006ed6c8 * fVar4;
  fVar2 = *(float *)(iVar6 + 0x1896);
  if (fVar2 < param_1 == (NAN(fVar2) || NAN(param_1))) {
    fVar2 = param_1;
  }
  fVar3 = *(float *)(iVar6 + 0x1976);
  if (fVar3 < fVar2 != (NAN(fVar3) || NAN(fVar2))) {
    fVar2 = fVar3;
  }
  *(float *)(iVar6 + 0x195e) = fVar4 * _DAT_006f4998;
  *(float *)(iVar6 + 0x1962) = fVar5 + fVar2;
  *(float *)(iVar6 + 0x1966) = fVar2 + fVar4;
  fVar2 = *(float *)(iVar6 + 0x1976) - (float)(*(uint *)(iVar6 + 0x1956) & 0x7fffffff);
  *(float *)(iVar6 + 0x1976) = fVar2;
  if (fVar2 < _DAT_006ea454 != (NAN(fVar2) || NAN(_DAT_006ea454))) {
    if (_DAT_006f4994 < *(float *)(iVar6 + 0x1872)) {
      *(float *)(iVar6 + 0x1956) =
           *(float *)(iVar6 + 0x1956) -
           *(float *)(iVar6 + 0x1892) * *(float *)(iVar6 + 0x195a) * _DAT_006f4984;
    }
    fVar2 = *(float *)(iVar6 + 0x1956) / *(float *)(iVar6 + 0x196a);
    *(undefined4 *)(iVar6 + 0x1976) = 0;
    fVar1 = *(float *)(iVar6 + 0x1972) / SQRT(fVar2 * fVar2 + fVar1 * fVar1);
    *(float *)(iVar6 + 0x1956) = fVar1 * *(float *)(iVar6 + 0x1956);
    *(float *)(iVar6 + 0x195a) = fVar1 * *(float *)(iVar6 + 0x195a);
  }
  if ((*(byte *)(iVar6 + 0x139f) & 7) == 0) {
    fVar1 = _DAT_006ea454;
    if ((_DAT_006ea454 < *(float *)(iVar6 + 0x1aea)) &&
       (fVar1 = *(float *)(iVar6 + 0x1956) / *(float *)(iVar6 + 0x1aea) + _DAT_006ec744,
       _DAT_006e97d8 < fVar1)) {
      fVar1 = _DAT_006e97d8;
    }
    if (*(float *)(iVar6 + 0x1b40) <= _DAT_006ea454) {
      *(float *)(iVar6 + 0x18fe) = fVar1;
    }
    else {
      *(float *)(iVar6 + 0x18fe) =
           *(float *)(iVar6 + 0x18fe) * *(float *)(iVar6 + 0x1b40) +
           (_DAT_006e97d8 - *(float *)(iVar6 + 0x1b40)) * fVar1;
    }
    fVar1 = _DAT_006ea454;
    if (_DAT_006ea454 < *(float *)(iVar6 + 0x18fe)) {
      fVar1 = *(float *)(iVar6 + 0x18fe);
    }
    *(float *)(iVar6 + 0x18fe) = fVar1;
  }
  *(float *)(iVar6 + 0x1882) = *(float *)(iVar6 + 0x1956) - *(float *)(iVar6 + 0x1d4e);
  *(float *)(iVar6 + 0x1992) =
       (*(float *)(iVar6 + 0x1956) - *(float *)(iVar6 + 0x1992)) * *(float *)(iVar6 + 0x198e) +
       *(float *)(iVar6 + 0x1992);
  *(float *)(iVar6 + 0x199e) =
       (*(float *)(iVar6 + 0x195a) - *(float *)(iVar6 + 0x199e)) * *(float *)(iVar6 + 0x199a) +
       *(float *)(iVar6 + 0x199e);
  if (((*(byte *)(iVar6 + 0x139f) & 0x40) != 0) &&
     (*(float *)(iVar6 + 0x1992) < _DAT_006ea454 !=
      (NAN(*(float *)(iVar6 + 0x1992)) || NAN(_DAT_006ea454)))) {
    iVar7 = FUN_006c5bf8();
    *(int *)(iVar6 + 0x1b22) = iVar7 % 0x1b + 9;
    *(uint *)(iVar6 + 0x139f) = *(uint *)(iVar6 + 0x139f) & 0xffffffbf;
  }
  fVar1 = _DAT_006ea454;
  if ((*(float *)(iVar6 + 0x1956) < _DAT_006ea454 == (*(float *)(iVar6 + 0x1956) == _DAT_006ea454))
     && (*(float *)(iVar6 + 0x1972) < _DAT_006ea454 == (*(float *)(iVar6 + 0x1972) == _DAT_006ea454)
        )) {
    fVar1 = *(float *)(iVar6 + 0x1956) / (*(float *)(iVar6 + 0x196a) * *(float *)(iVar6 + 0x1972));
  }
  *(float *)(iVar6 + 0x19aa) =
       (fVar1 - *(float *)(iVar6 + 0x19aa)) * *(float *)(iVar6 + 0x19a6) +
       *(float *)(iVar6 + 0x19aa);
  return;
}

