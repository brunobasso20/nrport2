/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052f7d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052f7d0(int param_1)

{
  float fVar1;
  uint uVar2;
  uint *puVar3;
  uint uVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  undefined4 uVar7;
  uint *puVar8;
  uint *puVar9;
  int iVar10;
  undefined4 *puVar11;
  float *pfVar12;
  bool bVar13;
  double dVar14;
  int local_1c;
  uint local_18 [2];
  double local_10;
  
  FUN_0052b4c0();
  fVar1 = *(float *)(*(int *)(param_1 + 0x58a) + 0x24);
  dVar14 = rndUniform(0);
  local_10 = (dVar14 - (double)_DAT_006ea44c) * (double)_DAT_00bd79c4 + (double)fVar1;
  FUN_005f5890(param_1 + 0x524);
  puVar8 = *(uint **)(param_1 + 0x51c);
  puVar9 = &DAT_00f72120;
  iVar10 = 2;
  puVar3 = local_18;
  do {
    uVar4 = *puVar8;
    uVar2 = *puVar9;
    puVar8 = puVar8 + 1;
    puVar9 = puVar9 + 1;
    iVar10 = iVar10 + -1;
    *puVar3 = uVar4 ^ uVar2;
    puVar3 = puVar3 + 1;
  } while (iVar10 != 0);
  iVar10 = 2;
  bVar13 = true;
  puVar8 = local_18;
  puVar3 = *(uint **)(param_1 + 0x518);
  do {
    if (iVar10 == 0) break;
    iVar10 = iVar10 + -1;
    bVar13 = *puVar8 == *puVar3;
    puVar8 = puVar8 + 1;
    puVar3 = puVar3 + 1;
  } while (bVar13);
  if (!bVar13) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x3f) == 0) {
    puVar11 = *(undefined4 **)(param_1 + 0x520);
    iVar10 = 2;
    do {
      uVar5 = FUN_005cfcfc();
      *puVar11 = uVar5;
      puVar11 = puVar11 + 1;
      iVar10 = iVar10 + -1;
    } while (iVar10 != 0);
  }
  puVar11 = (undefined4 *)(param_1 + 0x518);
  FUN_0040e980(*(undefined4 *)(param_1 + 0x518),&local_10,*(undefined4 *)(param_1 + 0x520),8);
  FUN_0040e980(*(undefined4 *)(param_1 + 0x51c),&DAT_00f72120,*puVar11,8);
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x3ff) == 0) {
    uVar5 = FUN_0051c850(*(undefined4 *)(param_1 + 0x520));
    *(undefined4 *)(param_1 + 0x520) = uVar5;
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x1ff) == 0) {
    uVar5 = FUN_0051c850(*puVar11);
    *puVar11 = uVar5;
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x7ff) == 0) {
    uVar5 = FUN_0051c850(*(undefined4 *)(param_1 + 0x51c));
    *(undefined4 *)(param_1 + 0x51c) = uVar5;
  }
  FUN_005f58a0(param_1 + 0x524);
  *(undefined4 *)(param_1 + 0x544) = 0;
  *(undefined4 *)(param_1 + 0x548) = 0xbff00000;
  pfVar12 = (float *)(param_1 + 0x1cce);
  local_1c = 4;
  do {
    pfVar12[7] = 0.0;
    pfVar12[-8] = 0.0;
    pfVar12[-4] = 0.0;
    *pfVar12 = 0.01;
    iVar10 = FUN_005099b0();
    if (iVar10 != 5) {
      iVar10 = FUN_00544bf0();
      local_18[1] = 0;
      local_18[0] = (*(uint *)(iVar10 + 0x50) & 3) + 1;
      *pfVar12 = (float)local_18[0] * *pfVar12;
    }
    pfVar12 = pfVar12 + 1;
    local_1c = local_1c + -1;
    *(undefined4 *)(param_1 + 0x1a86) = 0x3f6147ae;
  } while (local_1c != 0);
  *(undefined4 *)(param_1 + 0x1ce6) = 0x3f800000;
  FUN_00541600();
  FUN_00541600();
  FUN_00541600();
  *(undefined1 *)(param_1 + 0x1fb5) = 0;
  *(undefined1 *)(param_1 + 0x1fb6) = 0;
  *(undefined1 *)(param_1 + 0x1fb7) = 0;
  *(undefined1 *)(param_1 + 0x1fb8) = 0;
  *(undefined1 *)(param_1 + 0x1fb9) = 0;
  *(undefined4 *)(param_1 + 0x1fba) = 0;
  iVar10 = FUN_00544bf0();
  local_18[1] = 0;
  local_18[0] = (*(uint *)(iVar10 + 0x50) & 3) + 1;
  fVar1 = ((float)local_18[0] * _DAT_006f521c + _DAT_006e97d8) - _DAT_006f5218;
  dVar14 = rndUniform(0);
  *(float *)(param_1 + 0x21e0) = (float)dVar14 * fVar1 + _DAT_006f5218;
  dVar14 = rndUniform(0);
  uVar5 = *(undefined4 *)(param_1 + 0x5b2);
  *(undefined4 *)(param_1 + 0x21d4) = 0;
  *(undefined4 *)(param_1 + 0x21d8) = 0;
  *(float *)(param_1 + 0x21e4) = (float)dVar14 * fVar1 + _DAT_006f5218;
  uVar6 = FUN_00567630(uVar5);
  FUN_0054b3c0(uVar5);
  uVar7 = FUN_00567610(uVar5,uVar6);
  FUN_0052e270(uVar7,uVar6);
  FUN_00567660(uVar5);
  return;
}


