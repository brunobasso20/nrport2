/* NR2003.exe @ 0052e270 FUN_0052e270 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0052e270(int param_1_00,undefined4 param_1,ushort *param_2)

{
  float fVar1;
  bool bVar2;
  bool bVar3;
  byte bVar4;
  undefined4 uVar5;
  uint uVar6;
  uint uVar7;
  float *pfVar8;
  int iVar9;
  undefined4 *puVar10;
  
  fVar1 = *(float *)(param_2 + 0x2c);
  bVar2 = NAN(_DAT_006ea454);
  bVar3 = fVar1 == _DAT_006ea454;
  *(float *)(param_1_00 + 0x1d82) = fVar1;
  if ((NAN(fVar1) || bVar2) == bVar3) {
    uVar5 = 2;
    if (fVar1 < _DAT_006ea44c == (NAN(fVar1) || NAN(_DAT_006ea44c))) {
      uVar5 = 4;
    }
  }
  else {
    uVar5 = 0;
  }
  *(undefined4 *)(param_1_00 + 0x1d32) = uVar5;
  iVar9 = 0;
  puVar10 = (undefined4 *)(param_1_00 + 0x1d62);
  do {
    uVar6 = (param_2[1] & 0xfff) >> ((char)iVar9 * '\x02' & 0x1fU) & 3;
    iVar9 = iVar9 + 1;
    puVar10[-0x1e] = *(undefined4 *)(&DAT_0074bc2c + uVar6 * 4);
    *puVar10 = *(undefined4 *)(&DAT_0074bc1c + uVar6 * 4);
    puVar10 = puVar10 + 1;
  } while (iVar9 < 4);
  iVar9 = 0;
  puVar10 = (undefined4 *)(param_1_00 + 0x1d72);
  do {
    uVar6 = ((*param_2 & 0x3fc0) >> 6) >> ((char)iVar9 * '\x02' & 0x1fU) & 3;
    iVar9 = iVar9 + 1;
    puVar10[-0x1a] = *(undefined4 *)(&DAT_0074bc4c + uVar6 * 4);
    *puVar10 = *(undefined4 *)(&DAT_0074bc3c + uVar6 * 4);
    puVar10 = puVar10 + 1;
  } while (iVar9 < 4);
  fVar1 = *(float *)(param_2 + 0x2e);
  bVar2 = NAN(_DAT_006ea454);
  bVar3 = fVar1 == _DAT_006ea454;
  *(float *)(param_1_00 + 0x1d86) = fVar1;
  if ((NAN(fVar1) || bVar2) == bVar3) {
    uVar6 = 2;
    if (fVar1 < _DAT_006ea44c == (NAN(fVar1) || NAN(_DAT_006ea44c))) {
      uVar6 = 4;
    }
  }
  else {
    uVar6 = 0;
  }
  *(uint *)(param_1_00 + 0x1d2a) = uVar6;
  fVar1 = *(float *)(param_2 + 0x2a);
  bVar2 = NAN(_DAT_006ea454);
  bVar3 = fVar1 == _DAT_006ea454;
  *(float *)(param_1_00 + 0x1d8a) = fVar1;
  if ((NAN(fVar1) || bVar2) == bVar3) {
    uVar7 = 8;
    if (fVar1 < _DAT_006ea44c == (NAN(fVar1) || NAN(_DAT_006ea44c))) {
      uVar7 = 0xc;
    }
  }
  else {
    uVar7 = 0;
  }
  *(uint *)(param_1_00 + 0x1d2a) = uVar6 | uVar7;
  bVar4 = (byte)((uint)*(undefined4 *)(param_2 + 6) >> 0x1c) & 1;
  *(byte *)(param_1_00 + 0x1d9a) = bVar4;
  if (bVar4 != 0) {
    *(uint *)(param_1_00 + 0x1d2a) = uVar6 | uVar7 | 4;
  }
  if (((*(byte *)((int)param_2 + 0xf) & 1) != 0) && (_DAT_006ea454 < *(float *)(param_2 + 0x2a))) {
    *(uint *)(param_1_00 + 0x1d2a) = *(uint *)(param_1_00 + 0x1d2a) | 0x10;
  }
  if ((*(uint *)(param_1_00 + 0x1d2a) & 4) != 0) {
    *(uint *)(param_1_00 + 0x1d2a) = *(uint *)(param_1_00 + 0x1d2a) & 0xfffffffd;
  }
  fVar1 = *(float *)(param_2 + 0x26);
  bVar2 = NAN(_DAT_006ea454);
  bVar3 = fVar1 == _DAT_006ea454;
  *(float *)(param_1_00 + 0x1d8e) = fVar1;
  if ((NAN(fVar1) || bVar2) == bVar3) {
    uVar5 = 8;
    if (fVar1 < _DAT_006ea44c == (NAN(fVar1) || NAN(_DAT_006ea44c))) {
      uVar5 = 0xc;
    }
  }
  else {
    uVar5 = 0;
  }
  *(undefined4 *)(param_1_00 + 0x1d42) = uVar5;
  fVar1 = *(float *)(param_2 + 0x28);
  bVar2 = NAN(_DAT_006ea454);
  bVar3 = fVar1 == _DAT_006ea454;
  *(float *)(param_1_00 + 0x1d92) = fVar1;
  if ((NAN(fVar1) || bVar2) == bVar3) {
    uVar5 = 8;
    if (fVar1 < _DAT_006ea44c == (NAN(fVar1) || NAN(_DAT_006ea44c))) {
      uVar5 = 0xc;
    }
  }
  else {
    uVar5 = 0;
  }
  *(undefined4 *)(param_1_00 + 0x1d46) = uVar5;
  pfVar8 = (float *)(param_2 + 0x1e);
  *(undefined4 *)(param_1_00 + 0x1d96) = 0;
  iVar9 = 4;
  do {
    fVar1 = *pfVar8;
    pfVar8 = pfVar8 + 1;
    iVar9 = iVar9 + -1;
    *(float *)(param_1_00 + 0x1d96) = fVar1 + *(float *)(param_1_00 + 0x1d96);
  } while (iVar9 != 0);
  fVar1 = *(float *)(param_1_00 + 0x1d96) * _DAT_006ea50c;
  bVar2 = NAN(_DAT_006ea454);
  bVar3 = fVar1 == _DAT_006ea454;
  *(float *)(param_1_00 + 0x1d96) = fVar1;
  if ((NAN(fVar1) || bVar2) != bVar3) {
    *(undefined4 *)(param_1_00 + 0x1d3a) = 0;
    FUN_0052eea0();
    return;
  }
  uVar5 = 2;
  if (fVar1 < _DAT_006ea44c == (NAN(fVar1) || NAN(_DAT_006ea44c))) {
    uVar5 = 4;
  }
  *(undefined4 *)(param_1_00 + 0x1d3a) = uVar5;
  FUN_0052eea0();
  return;
}

