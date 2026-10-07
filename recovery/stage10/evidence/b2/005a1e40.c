/* NR2003.exe @ 005a1e40 FUN_005a1e40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_005a1e40(void)

{
  float fVar1;
  float fVar2;
  float10 fVar3;
  uint uVar4;
  float *pfVar5;
  float *pfVar6;
  float fVar7;
  ushort uVar8;
  float10 fVar9;
  float10 fVar10;
  float10 fVar11;
  
  uVar4 = FUN_00555060();
  if (1 < (int)uVar4) {
    pfVar5 = (float *)FUN_00557d60(uVar4 + 0x66);
    pfVar6 = (float *)FUN_00557d60(0x6e);
    fVar9 = (float10)FUN_00554f10();
    fVar1 = *pfVar5;
    fVar2 = *pfVar6;
    fVar3 = (float10)_DAT_006f6f10;
    fVar10 = (float10)FUN_00551950(1);
    fVar11 = (float10)FUN_00551950(0);
    fVar7 = (float)((uint)(float)((fVar11 + (float10)(float)fVar10) * (float10)_DAT_006ea44c) &
                   0x7fffffff);
    uVar4 = (uint)(ushort)((ushort)(fVar7 < _DAT_006ea4a4) << 8 |
                          (ushort)(fVar7 == _DAT_006ea4a4) << 0xe);
    if (fVar7 >= _DAT_006ea4a4 && fVar7 != _DAT_006ea4a4) {
      fVar7 = (float)((fVar9 / ((float10)fVar1 * (float10)fVar2)) * fVar3) / fVar7;
      uVar4 = (uint)(ushort)((ushort)(fVar7 < _DAT_006f49dc) << 8 |
                            (ushort)(fVar7 == _DAT_006f49dc) << 0xe);
      if (_DAT_006f49dc < fVar7) {
        uVar8 = (ushort)(fVar7 < _DAT_006f6f0c) << 8 |
                (ushort)(NAN(fVar7) || NAN(_DAT_006f6f0c)) << 10 |
                (ushort)(fVar7 == _DAT_006f6f0c) << 0xe;
        uVar4 = (uint)uVar8;
        if (fVar7 < _DAT_006f6f0c != (NAN(fVar7) || NAN(_DAT_006f6f0c))) {
          return CONCAT31((uint3)(byte)(uVar8 >> 8),1);
        }
      }
    }
  }
  return uVar4 & 0xffffff00;
}

