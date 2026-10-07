/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00562f90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00562f90(void)

{
  bool bVar1;
  float fVar2;
  float *pfVar3;
  float *pfVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  
  iVar7 = 0;
  do {
    pfVar3 = (float *)FUN_00557d60(0x6e);
    pfVar4 = (float *)FUN_00557d60(iVar7 + 0x66);
    fVar2 = *pfVar3 * *pfVar4 * _DAT_006f5e20;
    bVar1 = fVar2 == _DAT_006ea454;
    (&DAT_00c53438)[iVar7] = fVar2;
    if (bVar1) {
      (&DAT_00c53418)[iVar7] = 0;
    }
    else {
      (&DAT_00c53418)[iVar7] = _DAT_006e97d8 / fVar2;
    }
    iVar7 = iVar7 + 1;
  } while (iVar7 < 8);
  iVar5 = FUN_0051a000();
  iVar7 = DAT_00bdbd00;
  iVar6 = 0;
  _DAT_00c08728 = *(float *)(*(int *)(iVar5 + 0x56a) + 0x2c) - _DAT_006ed00c;
  do {
    if (iVar6 < 4) {
      if (iVar6 == 3) {
        DAT_00c53404 = _DAT_00c08728 * _DAT_006ea470;
      }
      else {
        (&DAT_00c533f8)[iVar6] = 0;
      }
    }
    else {
      (&DAT_00c533f8)[iVar6] =
           ((float)(&DAT_00c53438)[iVar6] / (float)(&DAT_00c53434)[iVar6]) *
           *(float *)(&DAT_0074e928 + iVar7 * 4) * _DAT_00c08728;
    }
    iVar6 = iVar6 + 1;
  } while (iVar6 < 8);
  return;
}


