/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052c120 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0052c120(void)

{
  undefined4 *puVar1;
  float *pfVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  float10 fVar6;
  int local_2c;
  uint local_28;
  undefined4 uStack_24;
  double local_20;
  undefined4 local_14;
  undefined4 local_10;
  undefined4 local_c;
  
  local_2c = 0;
  _DAT_0074bc0c = DAT_0074b0e0;
  _DAT_0074bc10 = DAT_0074b0f8;
  iVar4 = FUN_005099b0();
  if ((iVar4 == 5) || (iVar4 = FUN_005099b0(), iVar4 == 6)) {
    _DAT_0074bc0c = _DAT_0074b128 * _DAT_0074bc0c;
    _DAT_0074bc10 = _DAT_0074bc10 / _DAT_0074b128;
  }
  if ((DAT_00bebd84 & 0x2000000) != 0) {
    _DAT_0074bc0c = _DAT_0074b188 * _DAT_0074bc0c;
    _DAT_0074bc10 = _DAT_0074b1a0 * _DAT_0074bc10;
    iVar4 = FUN_005099b0();
    if ((iVar4 == 5) || (iVar4 = FUN_005099b0(), iVar4 == 6)) {
      _DAT_0074bc0c = _DAT_0074b1b8 * _DAT_0074bc0c;
      _DAT_0074bc10 = _DAT_0074bc10 / _DAT_0074b1b8;
    }
  }
  cVar3 = FUN_004f5f70(&local_2c);
  while (cVar3 != '\0') {
    *(undefined **)(local_2c + 0x13bb) = (&PTR_DAT_0074bb5c)[**(int **)(local_2c + 0x21e8)];
    if (*(char *)(local_2c + 0x59b) != '\0') {
      FUN_0052c540(local_2c);
      FUN_005f5a40(*(undefined4 *)(local_2c + 0x1a76),*(undefined4 *)(local_2c + 0x186a),
                   *(undefined4 *)(local_2c + 0x1886),*(undefined4 *)(local_2c + 0x18b6));
      local_14 = 0;
      local_10 = 0;
      local_c = 0;
      FUN_005f5ac0(*(undefined4 *)(local_2c + 0x1a76),&local_14,&local_14);
      *(uint *)(local_2c + 0x1866) = *(uint *)(*(int *)(local_2c + 0x1a76) + 0x54) & 0x7fff;
      FUN_0052d910(1);
      FUN_00401b90(local_2c);
      *(int *)(local_2c + 0x1d2e) = *(int *)(local_2c + 0x5b2) % 9;
      FUN_0051a020(_DAT_00e0bb40);
      iVar4 = local_2c;
      fVar6 = (float10)FUN_006c5c40();
      *(float *)(iVar4 + 0x185e) = (float)(fVar6 * (float10)_DAT_006ea68c);
      iVar4 = 0;
      do {
        *(undefined4 *)(iVar4 + 0x1cea + local_2c) = 0;
        *(undefined4 *)(iVar4 + 0x1cae + local_2c) = 0;
        *(undefined4 *)(iVar4 + 0x1cbe + local_2c) = 0;
        *(undefined4 *)(iVar4 + 0x1cce + local_2c) = 0x3c23d70a;
        iVar5 = FUN_005099b0();
        if (iVar5 != 5) {
          pfVar2 = (float *)(iVar4 + 0x1cce + local_2c);
          iVar5 = FUN_00544bf0();
          uStack_24 = 0;
          local_28 = (*(uint *)(iVar5 + 0x50) & 3) + 1;
          *pfVar2 = (float)local_28 * *pfVar2;
        }
        iVar4 = iVar4 + 4;
      } while (iVar4 < 0x10);
      fVar6 = (float10)FUN_00509a20();
      *(float *)(local_2c + 0x1caa) = (float)fVar6;
      *(undefined4 *)(local_2c + 0x1cde) = 0;
      *(undefined4 *)(local_2c + 0x1ce2) = 0;
      *(undefined4 *)(local_2c + 0x1ce6) = 0x3f800000;
      FUN_00541600();
      FUN_00541600();
      FUN_00541600();
      iVar5 = local_2c;
      *(undefined1 *)(local_2c + 0x1fb5) = 0;
      *(undefined1 *)(local_2c + 0x1fb6) = 0;
      *(undefined1 *)(local_2c + 0x1fb7) = 0;
      *(undefined1 *)(local_2c + 0x1fb8) = 0;
      *(undefined1 *)(local_2c + 0x1fb9) = 0;
      *(undefined4 *)(local_2c + 0x1fba) = 0;
      *(undefined4 *)(local_2c + 0x21d4) = 0;
      *(undefined4 *)(local_2c + 0x21d8) = 0;
      puVar1 = (undefined4 *)(local_2c + 0x518);
      iVar4 = local_2c + 0x524;
      FUN_005f5890(iVar4);
      FUN_0040e980(&local_20,*puVar1,*(undefined4 *)(iVar5 + 0x520),8);
      FUN_005f58a0(iVar4);
      *(float *)(local_2c + 0x190e) =
           (float)local_20 + *(float *)(*(int *)(local_2c + 0x58a) + 8) + _DAT_006f5134;
      FUN_004f6e00(local_2c);
      iVar4 = FUN_0056ed60(0);
      iVar4 = *(int *)(PTR_PTR_00734368 + iVar4 * 4);
      iVar5 = FUN_0056ed60(1);
      iVar5 = *(int *)(PTR_PTR_00734368 + iVar5 * 4);
      *(float *)(local_2c + 0x196a) =
           (*(float *)(iVar5 + 0x3c) * _DAT_006ed6c8) / (*(float *)(iVar5 + 0x40) * _DAT_006f4164) +
           (*(float *)(iVar4 + 0x3c) * _DAT_006ea50c) / (*(float *)(iVar4 + 0x40) * _DAT_006f4164);
      *(float *)(local_2c + 0x196e) =
           (*(float *)(iVar5 + 0x40) * _DAT_006ed6c8 + *(float *)(iVar4 + 0x40) * _DAT_006ea50c) *
           _DAT_006f51d0;
      *(float *)(local_2c + 0x1af6) =
           (*(float *)(iVar5 + 0x2c) / *(float *)(iVar5 + 0x28)) * _DAT_006ed020 + _DAT_006ea4cc;
    }
    cVar3 = FUN_004f5f70(&local_2c);
  }
  return;
}


