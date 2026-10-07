/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005123ca */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005123ca(float param_1,float param_2,float param_3,float param_4,int *param_5)

{
  float fVar1;
  float fVar2;
  float fVar3;
  bool bVar4;
  bool bVar5;
  char cVar6;
  int iVar7;
  int iVar8;
  float *pfVar9;
  
  iVar8 = *param_5;
  bVar4 = true;
  bVar5 = true;
  iVar7 = 0;
  if (0 < iVar8) {
    pfVar9 = (float *)(param_5 + 9);
    do {
      iVar7 = iVar7 + 1;
      fVar1 = (float)param_5[iVar7 % iVar8 + 1] - pfVar9[-8];
      fVar2 = (float)param_5[iVar7 % iVar8 + 9] - *pfVar9;
      cVar6 = FUN_005124ea(param_1,param_2,param_3 - param_1,param_4 - param_2,pfVar9[-8],*pfVar9,
                           fVar1,fVar2);
      if (cVar6 != '\0') {
        return 1;
      }
      if ((bVar4) &&
         (fVar3 = (param_1 - pfVar9[-8]) * fVar2 - (param_2 - *pfVar9) * fVar1,
         fVar3 < _DAT_006ea454 == (fVar3 == _DAT_006ea454))) {
        bVar4 = false;
      }
      if ((bVar5) &&
         (fVar1 = (param_3 - pfVar9[-8]) * fVar2 - (param_4 - *pfVar9) * fVar1,
         fVar1 < _DAT_006ea454 == (fVar1 == _DAT_006ea454))) {
        bVar5 = false;
      }
      iVar8 = *param_5;
      pfVar9 = pfVar9 + 1;
    } while (iVar7 < iVar8);
    if ((!bVar4) && (!bVar5)) {
      return 0;
    }
  }
  return 1;
}


