/* NR2003.exe @ 0051658a FUN_0051658a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0051658a(float param_1,code *param_2)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  uint uVar5;
  int iVar6;
  float *pfVar7;
  int iVar8;
  float10 fVar9;
  
  iVar4 = (int)param_1;
  uVar5 = *(uint *)((int)param_1 + 0x54) & 0x7fff;
  if ((int)uVar5 < DAT_00bad920) {
    iVar8 = uVar5 * 0x1550 + DAT_00bcf734;
    fVar3 = *(float *)((int)param_1 + 0x3c) - *(float *)(iVar8 + 4);
    if (fVar3 < _DAT_006ea4a8 != (NAN(fVar3) || NAN(_DAT_006ea4a8))) {
      fVar3 = fVar3 + DAT_00bad918;
    }
    fVar3 = fVar3 * *(float *)(iVar8 + 0xc);
    iVar6 = *(int *)(iVar8 + 0x60);
    param_1 = 0.0;
    fVar1 = *(float *)(iVar4 + 8);
    fVar2 = *(float *)(iVar4 + 0x20);
    if (iVar6 <= *(int *)(iVar8 + 100)) {
      pfVar7 = (float *)(iVar8 + 0x9d8 + iVar6 * 0x108);
      do {
        fVar9 = (float10)(*param_2)(fVar1 - fVar2,
                                    ABS(((pfVar7[-0x2b] - pfVar7[-0x2c]) * fVar3 + pfVar7[-0x2c]) -
                                        *(float *)(iVar4 + 0x40)),fVar3 * pfVar7[1] + *pfVar7,
                                    pfVar7[-0x40]);
        if ((float10)param_1 < fVar9) {
          param_1 = (float)fVar9;
        }
        iVar6 = iVar6 + 1;
        pfVar7 = pfVar7 + 0x42;
      } while (iVar6 <= *(int *)(iVar8 + 100));
    }
    return (float10)param_1;
  }
  return (float10)_DAT_006ea454;
}

