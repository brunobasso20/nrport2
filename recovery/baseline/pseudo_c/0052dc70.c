/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052dc70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052dc70(int param_1)

{
  float fVar1;
  float fVar2;
  char cVar3;
  undefined4 uVar4;
  int iVar5;
  uint uVar6;
  float local_8;
  float local_4;
  
  cVar3 = FUN_00401bc0(param_1);
  fVar2 = DAT_0074abd0;
  if (cVar3 != '\0') {
    return;
  }
  if ((0 < *(int *)(param_1 + 0x18fa)) && (*(int *)(param_1 + 0x1b26) < 1)) {
    fVar1 = *(float *)(param_1 + 0x1902) - _DAT_0074abe8;
    *(float *)(param_1 + 0x1902) = fVar1;
    if (fVar1 <= fVar2) {
      fVar1 = fVar2;
    }
    *(float *)(param_1 + 0x1902) = fVar1;
    fVar1 = *(float *)(param_1 + 0x1906) - _DAT_0074abe8;
    *(float *)(param_1 + 0x1906) = fVar1;
    if (fVar1 <= fVar2) {
      fVar1 = fVar2;
    }
    *(float *)(param_1 + 0x1906) = fVar1;
    return;
  }
  if (0 < *(int *)(param_1 + 0x1b26)) {
    *(undefined4 *)(param_1 + 0x1b4c) = 0;
    *(undefined4 *)(param_1 + 0x1b48) = 1;
    *(uint *)(param_1 + 0x139f) = *(uint *)(param_1 + 0x139f) | 1;
    *(undefined4 *)(param_1 + 0x1b40) = 0;
  }
  uVar6 = *(uint *)(param_1 + 0x139f);
  *(float *)(param_1 + 0x1906) =
       (*(float *)(param_1 + 0x19aa) * _DAT_006ea4cc + _DAT_006e97d8) *
       *(float *)(param_1 + 0x454 + *(int *)(param_1 + 0x18f6) * 4) * *(float *)(param_1 + 0x187e) *
       *(float *)(param_1 + 0x474) * _DAT_006f5208;
  if ((uVar6 & 1) != 0) {
    *(undefined4 *)(param_1 + 0x18fe) = 0x3ecccccd;
    goto LAB_0052deb5;
  }
  if ((uVar6 & 2) == 0) {
    if ((uVar6 & 4) != 0) {
      fVar2 = *(float *)(param_1 + 0x18fe) - _DAT_006f5200;
      *(float *)(param_1 + 0x18fe) = fVar2;
      if (fVar2 < _DAT_006ea508) {
        *(undefined4 *)(param_1 + 0x18fe) = 0x3d4ccccd;
        rndUniform(0);
        iVar5 = FUN_006c5018();
        *(int *)(param_1 + 0x1b4c) = *(int *)(param_1 + 0x1b4c) + iVar5;
        rndUniform(0);
        uVar4 = FUN_006c5018();
        *(undefined4 *)(param_1 + 0x1b48) = uVar4;
        *(uint *)(param_1 + 0x139f) = *(uint *)(param_1 + 0x139f) & 0xfffffffb | 2;
      }
      goto LAB_0052deb5;
    }
    if ((uVar6 & 8) == 0) goto LAB_0052deb5;
    *(undefined4 *)(param_1 + 0x18fe) = 0;
    uVar6 = uVar6 & 0xfffffff7;
  }
  else {
    iVar5 = *(int *)(param_1 + 0x1b4c) + -1;
    *(int *)(param_1 + 0x1b4c) = iVar5;
    if (-1 < iVar5) goto LAB_0052deb5;
    fVar2 = *(float *)(param_1 + 0x18fe) + _DAT_006ea508;
    *(float *)(param_1 + 0x18fe) = fVar2;
    if (_DAT_006f4658 <= fVar2) {
      *(undefined4 *)(param_1 + 0x18fe) = 0x3ee66666;
    }
    if ((*(float *)(param_1 + 0x1902) <= _DAT_006f5204) &&
       (iVar5 = *(int *)(param_1 + 0x1b48) + -1, *(int *)(param_1 + 0x1b48) = iVar5, -1 < iVar5))
    goto LAB_0052deb5;
    uVar6 = uVar6 & 0xfffffffd | 4;
  }
  *(uint *)(param_1 + 0x139f) = uVar6;
LAB_0052deb5:
  local_4 = *(float *)(param_1 + 0x1902);
  local_8 = 0.0;
  FUN_0051a870(&local_8,*(undefined4 *)(param_1 + 0x18fe),local_4);
  fVar2 = local_8 * _DAT_006f51fc + local_4;
  if ((*(byte *)(param_1 + 0x139f) & 7) == 0) {
    if (*(float *)(param_1 + 0x1b40) <= _DAT_006ea454) {
      *(undefined4 *)(param_1 + 0x1902) = *(undefined4 *)(param_1 + 0x1906);
    }
    else {
      fVar2 = fVar2 * *(float *)(param_1 + 0x1b40) +
              (_DAT_006e97d8 - *(float *)(param_1 + 0x1b40)) * *(float *)(param_1 + 0x1906);
      *(float *)(param_1 + 0x1902) = fVar2;
      if (fVar2 < _DAT_006f51f8) {
        do {
          iVar5 = FUN_006c5bf8();
          local_4 = (float)(iVar5 % 500);
          fVar2 = (float)(int)local_4 + *(float *)(param_1 + 0x1902);
          *(float *)(param_1 + 0x1902) = fVar2;
        } while (fVar2 < _DAT_006f51f8);
      }
      fVar2 = *(float *)(param_1 + 0x1b40) - *(float *)(param_1 + 0x1b44);
      *(float *)(param_1 + 0x1b40) = fVar2;
      if (fVar2 < _DAT_006ea454) {
        fVar2 = _DAT_006ea454;
      }
      *(float *)(param_1 + 0x1b40) = fVar2;
    }
  }
  else {
    *(float *)(param_1 + 0x1902) = fVar2;
  }
  fVar2 = DAT_0074abd0;
  if (DAT_0074abd0 <= *(float *)(param_1 + 0x1902)) {
    fVar2 = *(float *)(param_1 + 0x1902);
  }
  fVar1 = _DAT_006f51f4;
  if ((fVar2 <= _DAT_006f51f4) &&
     (fVar1 = DAT_0074abd0, DAT_0074abd0 <= *(float *)(param_1 + 0x1902))) {
    fVar1 = *(float *)(param_1 + 0x1902);
  }
  *(float *)(param_1 + 0x1902) = fVar1;
  if (0 < *(int *)(param_1 + 0x1b26)) {
    *(int *)(param_1 + 0x1b26) = *(int *)(param_1 + 0x1b26) + -1;
    *(uint *)(param_1 + 0x139f) = *(uint *)(param_1 + 0x139f) & 0xfffffffe;
  }
  return;
}


