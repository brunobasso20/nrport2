/* NR2003.exe @ 00562f90 FUN_00562f90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00562f90(void)

{
  bool bVar1;
  bool bVar2;
  float fVar3;
  float *pfVar4;
  float *pfVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  
  iVar8 = 0;
  do {
    pfVar4 = (float *)FUN_00557d60(0x6e);
    pfVar5 = (float *)FUN_00557d60(iVar8 + 0x66);
    fVar3 = *pfVar4 * *pfVar5 * _DAT_006f5e20;
    bVar1 = NAN(_DAT_006ea454);
    bVar2 = fVar3 == _DAT_006ea454;
    (&DAT_00c53438)[iVar8] = fVar3;
    if ((NAN(fVar3) || bVar1) == bVar2) {
      (&DAT_00c53418)[iVar8] = _DAT_006e97d8 / fVar3;
    }
    else {
      (&DAT_00c53418)[iVar8] = 0;
    }
    iVar8 = iVar8 + 1;
  } while (iVar8 < 8);
  iVar6 = FUN_0051a000();
  iVar8 = DAT_00bdbd00;
  iVar7 = 0;
  _DAT_00c08728 = *(float *)(*(int *)(iVar6 + 0x56a) + 0x2c) - _DAT_006ed00c;
  do {
    if (iVar7 < 4) {
      if (iVar7 == 3) {
        DAT_00c53404 = _DAT_00c08728 * _DAT_006ea470;
      }
      else {
        (&DAT_00c533f8)[iVar7] = 0;
      }
    }
    else {
      (&DAT_00c533f8)[iVar7] =
           ((float)(&DAT_00c53438)[iVar7] / (float)(&DAT_00c53434)[iVar7]) *
           *(float *)(&DAT_0074e928 + iVar8 * 4) * _DAT_00c08728;
    }
    iVar7 = iVar7 + 1;
  } while (iVar7 < 8);
  return;
}

