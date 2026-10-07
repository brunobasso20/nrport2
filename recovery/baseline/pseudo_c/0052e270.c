/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052e270 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0052e270(int param_1,undefined4 param_2,ushort *param_3)

{
  float fVar1;
  bool bVar2;
  byte bVar3;
  undefined4 uVar4;
  uint uVar5;
  uint uVar6;
  float *pfVar7;
  int iVar8;
  undefined4 *puVar9;
  
  fVar1 = *(float *)(param_3 + 0x2c);
  bVar2 = fVar1 == _DAT_006ea454;
  *(float *)(param_1 + 0x1d82) = fVar1;
  if (bVar2) {
    uVar4 = 0;
  }
  else {
    uVar4 = 2;
    if (_DAT_006ea44c <= fVar1) {
      uVar4 = 4;
    }
  }
  *(undefined4 *)(param_1 + 0x1d32) = uVar4;
  iVar8 = 0;
  puVar9 = (undefined4 *)(param_1 + 0x1d62);
  do {
    uVar5 = (param_3[1] & 0xfff) >> ((char)iVar8 * '\x02' & 0x1fU) & 3;
    iVar8 = iVar8 + 1;
    puVar9[-0x1e] = *(undefined4 *)(&DAT_0074bc2c + uVar5 * 4);
    *puVar9 = *(undefined4 *)(&DAT_0074bc1c + uVar5 * 4);
    puVar9 = puVar9 + 1;
  } while (iVar8 < 4);
  iVar8 = 0;
  puVar9 = (undefined4 *)(param_1 + 0x1d72);
  do {
    uVar5 = ((*param_3 & 0x3fc0) >> 6) >> ((char)iVar8 * '\x02' & 0x1fU) & 3;
    iVar8 = iVar8 + 1;
    puVar9[-0x1a] = *(undefined4 *)(&DAT_0074bc4c + uVar5 * 4);
    *puVar9 = *(undefined4 *)(&DAT_0074bc3c + uVar5 * 4);
    puVar9 = puVar9 + 1;
  } while (iVar8 < 4);
  fVar1 = *(float *)(param_3 + 0x2e);
  bVar2 = fVar1 == _DAT_006ea454;
  *(float *)(param_1 + 0x1d86) = fVar1;
  if (bVar2) {
    uVar5 = 0;
  }
  else {
    uVar5 = 2;
    if (_DAT_006ea44c <= fVar1) {
      uVar5 = 4;
    }
  }
  *(uint *)(param_1 + 0x1d2a) = uVar5;
  fVar1 = *(float *)(param_3 + 0x2a);
  bVar2 = fVar1 == _DAT_006ea454;
  *(float *)(param_1 + 0x1d8a) = fVar1;
  if (bVar2) {
    uVar6 = 0;
  }
  else {
    uVar6 = 8;
    if (_DAT_006ea44c <= fVar1) {
      uVar6 = 0xc;
    }
  }
  *(uint *)(param_1 + 0x1d2a) = uVar5 | uVar6;
  bVar3 = (byte)((uint)*(undefined4 *)(param_3 + 6) >> 0x1c) & 1;
  *(byte *)(param_1 + 0x1d9a) = bVar3;
  if (bVar3 != 0) {
    *(uint *)(param_1 + 0x1d2a) = uVar5 | uVar6 | 4;
  }
  if (((*(byte *)((int)param_3 + 0xf) & 1) != 0) && (_DAT_006ea454 < *(float *)(param_3 + 0x2a))) {
    *(uint *)(param_1 + 0x1d2a) = *(uint *)(param_1 + 0x1d2a) | 0x10;
  }
  if ((*(uint *)(param_1 + 0x1d2a) & 4) != 0) {
    *(uint *)(param_1 + 0x1d2a) = *(uint *)(param_1 + 0x1d2a) & 0xfffffffd;
  }
  fVar1 = *(float *)(param_3 + 0x26);
  bVar2 = fVar1 == _DAT_006ea454;
  *(float *)(param_1 + 0x1d8e) = fVar1;
  if (bVar2) {
    uVar4 = 0;
  }
  else {
    uVar4 = 8;
    if (_DAT_006ea44c <= fVar1) {
      uVar4 = 0xc;
    }
  }
  *(undefined4 *)(param_1 + 0x1d42) = uVar4;
  fVar1 = *(float *)(param_3 + 0x28);
  bVar2 = fVar1 == _DAT_006ea454;
  *(float *)(param_1 + 0x1d92) = fVar1;
  if (bVar2) {
    uVar4 = 0;
  }
  else {
    uVar4 = 8;
    if (_DAT_006ea44c <= fVar1) {
      uVar4 = 0xc;
    }
  }
  *(undefined4 *)(param_1 + 0x1d46) = uVar4;
  pfVar7 = (float *)(param_3 + 0x1e);
  *(undefined4 *)(param_1 + 0x1d96) = 0;
  iVar8 = 4;
  do {
    fVar1 = *pfVar7;
    pfVar7 = pfVar7 + 1;
    iVar8 = iVar8 + -1;
    *(float *)(param_1 + 0x1d96) = fVar1 + *(float *)(param_1 + 0x1d96);
  } while (iVar8 != 0);
  fVar1 = *(float *)(param_1 + 0x1d96) * _DAT_006ea50c;
  bVar2 = fVar1 == _DAT_006ea454;
  *(float *)(param_1 + 0x1d96) = fVar1;
  if (bVar2) {
    *(undefined4 *)(param_1 + 0x1d3a) = 0;
    FUN_0052eea0();
    return;
  }
  uVar4 = 2;
  if (_DAT_006ea44c <= fVar1) {
    uVar4 = 4;
  }
  *(undefined4 *)(param_1 + 0x1d3a) = uVar4;
  FUN_0052eea0();
  return;
}


