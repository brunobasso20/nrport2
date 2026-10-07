/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050cd80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0050cd80(void)

{
  float fVar1;
  float fVar2;
  float fVar3;
  byte bVar4;
  undefined4 uVar5;
  int *piVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  float10 fVar10;
  
  uVar5 = FUN_004233c0();
  piVar6 = (int *)FUN_00432d10(uVar5);
  iVar7 = FUN_0056ed60(0);
  iVar7 = *(int *)(PTR_PTR_00734368 + iVar7 * 4);
  iVar8 = FUN_0056ed60(1);
  fVar1 = (float)piVar6[9] + (float)piVar6[2] + _DAT_006f4094;
  iVar8 = *(int *)(PTR_PTR_00734368 + iVar8 * 4);
  _DAT_0074946c =
       (*(float *)(iVar8 + 0x3c) * _DAT_006ed6c8) / (*(float *)(iVar8 + 0x40) * _DAT_006f4164) +
       (*(float *)(iVar7 + 0x3c) * _DAT_006ea50c) / (*(float *)(iVar7 + 0x40) * _DAT_006f4164);
  _DAT_00749468 =
       *(float *)(iVar8 + 0x40) * _DAT_006f415c + *(float *)(iVar7 + 0x40) * _DAT_006f4160;
  iVar9 = FUN_00544bf0();
  if ((*(byte *)(iVar9 + 0x50) & 4) == 0) {
    iVar9 = FUN_00544bf0();
    bVar4 = *(byte *)(iVar9 + 0x5f);
  }
  else {
    iVar9 = FUN_00544bf0();
    bVar4 = *(byte *)(iVar9 + 100) >> 1;
  }
  fVar2 = (float)bVar4;
  if ((float)bVar4 < _DAT_006ed000) {
    fVar2 = _DAT_006ed00c;
  }
  fVar3 = _DAT_0074b338;
  if (DAT_00bdbd00 == 4) {
    fVar3 = _DAT_006ea50c;
  }
  _DAT_00749468 =
       _DAT_0074b110 *
       ((fVar2 * _DAT_006ea4a4 - _DAT_006e97d8) * fVar3 + _DAT_006e97d8) * _DAT_00749468;
  _DAT_00749474 = *(float *)(iVar8 + 0x54);
  _DAT_00b8f368 = _DAT_00749474;
  fVar10 = (float10)FUN_006c5c40();
  _DAT_00b8fa8c = (float)(fVar10 * (float10)_DAT_00749474);
  fVar10 = (float10)FUN_006c5c40();
  _DAT_00b8f204 = (float)(fVar10 - (float10)_DAT_00b8fa8c * (float10)_DAT_006ecfe8);
  _DAT_00749470 = *(float *)(iVar7 + 0x54);
  _DAT_00b8f254 = _DAT_00749470;
  fVar10 = (float10)FUN_006c5c40();
  _DAT_00b8f920 = (float)(fVar10 * (float10)_DAT_00749470);
  fVar10 = (float10)FUN_006c5c40();
  _DAT_00b8fa58 = (float)(fVar10 - (float10)_DAT_00b8f920 * (float10)_DAT_006ecfe8);
  fVar2 = _DAT_006e97d8 / fVar1;
  fVar10 = (float10)FUN_00410ae0(piVar6,piVar6[0x3a]);
  _DAT_00749478 =
       (float)(((float10)(float)piVar6[0x2f] * (float10)_DAT_006ea470 +
                (float10)(float)piVar6[0x32] * (float10)_DAT_006ee5b0 + fVar10 +
               (float10)(float)piVar6[0x2b]) * (float10)(float)piVar6[0x28] * (float10)fVar2 *
              (float10)_DAT_006ea504);
  fVar10 = (float10)FUN_00410a90(piVar6,piVar6[0x39]);
  _DAT_0074947c =
       (float)(((((float10)(float)piVar6[0x2e] * (float10)_DAT_006ea470 +
                 (float10)(float)piVar6[0x31] * (float10)_DAT_006ee5b0) -
                (float10)(float)piVar6[0x2a]) + fVar10) * (float10)(float)piVar6[0x28] *
               (float10)fVar2 * (float10)_DAT_006ea504);
  _DAT_00749480 = 0x3f000000;
  _DAT_00749484 = (float)piVar6[0x17] / (float)piVar6[0xe];
  _DAT_00b8f808 =
       (*(float *)(*(int *)(PTR_PTR_00727280 + *piVar6 * 4) + 0x30) * _DAT_006f4158) /
       -(_DAT_006f40b0 * fVar1);
  _DAT_00749488 =
       (*(float *)(iVar8 + 0x2c) / *(float *)(iVar8 + 0x28)) * _DAT_006ed020 + _DAT_006ea4cc;
  return;
}


