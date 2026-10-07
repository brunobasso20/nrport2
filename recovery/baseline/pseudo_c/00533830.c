/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00533830 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00533830(float param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  char cVar5;
  int iVar6;
  int iVar7;
  int *piVar8;
  float unaff_EBX;
  float unaff_EDI;
  float10 fVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  float *pfVar15;
  undefined1 *local_38;
  undefined1 local_20 [8];
  float local_18;
  float fStack_14;
  float local_c;
  
  local_38 = (undefined1 *)
             (*(float *)((int)param_1 + 0x1872) * _DAT_006f410c + *(float *)((int)param_1 + 0x186a))
  ;
  fVar9 = (float10)FUN_0051700a();
  fVar1 = (float)(int)ROUND((float)((float10)_DAT_00bdaf68 * fVar9));
  local_38 = local_20;
  pfVar15 = &local_18;
  fVar13 = param_1;
  fVar14 = fVar1;
  local_c = fVar1;
  (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x48))(param_1,fVar1,pfVar15);
  fVar12 = param_1;
  fVar9 = (float10)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x40))(param_1,fVar1);
  fStack_14 = (float)fVar9;
  DAT_00bdaf64 = 0xffffffb0;
  DAT_00bdb214 = 0x4f;
  iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
  iVar6 = FUN_005337e0(*(float *)((int)param_1 + 0x1886) -
                       *(float *)(*(int *)(iVar6 + 0xc) + 0x14 +
                                 *(int *)((int)param_1 + 0x186e) * 0x1c));
  DAT_00bdaf64 = FUN_005337e0(local_18 * (float)pfVar15);
  if (iVar6 <= DAT_00bdaf64) {
    DAT_00bdaf64 = iVar6;
  }
  DAT_00bdb214 = FUN_005337e0(local_18 * unaff_EDI);
  if (DAT_00bdb214 <= iVar6) {
    DAT_00bdb214 = iVar6;
  }
  local_18 = _DAT_006f525c * *(float *)((int)param_1 + 0x1872);
  if (local_18 < DAT_006f5244) {
    local_18 = DAT_006f5244;
  }
  fVar9 = (float10)FUN_0051700a(local_18 + *(float *)((int)param_1 + 0x186a));
  fVar10 = (float)fVar9;
  (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x14))
            (param_1,fVar10,&local_38,&stack0xffffffd4,&stack0xffffffd0);
  fVar12 = (unaff_EBX / fVar12 - *(float *)((int)param_1 + 0x1872)) *
           (_DAT_006e97d8 / _DAT_006f525c) * _DAT_006e9804;
  DAT_00bdb224 = (unaff_EBX / fVar14 - *(float *)((int)param_1 + 0x1872)) *
                 (_DAT_006e97d8 / _DAT_006f525c) * _DAT_006e9804 - _DAT_006f5198;
  if (DAT_00bdb224 < fVar12) {
    fVar12 = DAT_00bdb224;
  }
  fVar9 = (float10)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x34))(param_1);
  fVar11 = (float)(fVar9 + fVar9);
  if (fVar9 + fVar9 <= (float10)_DAT_006e97d8) {
    if (fVar11 < _DAT_006ea454) {
      fVar11 = 0.0;
    }
  }
  else {
    fVar11 = 1.0;
  }
  iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
  *(float *)((int)param_1 + 0x1be6) =
       (_DAT_006e97d8 - fVar10) * _DAT_0074b290 * _DAT_006ea448 +
       *(float *)((int)ROUND(fVar14 * _DAT_00bdaf68) * 0x40 + 0x2c + *(int *)(iVar6 + 0x18)) *
       fVar10;
  fVar14 = (unaff_EDI - fVar13) / (float)-DAT_00bdaf64;
  fVar4 = (float)DAT_00bdb214;
  fVar10 = *(float *)((int)param_1 + 0x1962);
  if (*(float *)((int)param_1 + 0x1b79) < *(float *)((int)param_1 + 0x1962)) {
    fVar10 = *(float *)((int)param_1 + 0x1b79);
  }
  iVar6 = 0;
  fVar3 = fVar13;
  if (DAT_00bdaf64 < 1) {
    do {
      fVar2 = fVar10;
      if (fVar3 < fVar10) {
        fVar2 = fVar3;
      }
      iVar6 = iVar6 + -1;
      *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + 4) = fVar2;
      fVar3 = fVar3 + fVar14;
    } while (DAT_00bdaf64 <= iVar6);
  }
  iVar6 = 1;
  fVar3 = fVar13;
  if (0 < DAT_00bdb214) {
    do {
      fVar3 = fVar3 + (fVar11 - fVar13) / fVar4;
      fVar2 = fVar10;
      if (fVar3 < fVar10) {
        fVar2 = fVar3;
      }
      iVar6 = iVar6 + 1;
      *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + -4) = fVar2;
    } while (iVar6 <= DAT_00bdb214);
  }
  iVar6 = 0;
  cVar5 = FUN_00535410(param_1);
  if (cVar5 == '\0') {
    fVar9 = (float10)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x18))
                               (param_1,*(undefined4 *)((int)param_1 + 0x186e),
                                *(undefined4 *)((int)param_1 + 0x1b95),
                                *(undefined4 *)((int)param_1 + 0x1b99));
    iVar6 = *(int *)((int)param_1 + 0x186e);
    fVar13 = (float)fVar9;
    iVar7 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    fVar10 = *(float *)(*(int *)(iVar7 + 0xc) + 0x14 + iVar6 * 0x1c);
    fVar14 = (fVar14 + fVar10) * _DAT_006ea44c;
    iVar6 = FUN_005337e0(((*(float *)((int)param_1 + 0x1886) - fVar14) * _DAT_006efb28 + fVar14) -
                         fVar10);
  }
  (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
  piVar8 = (int *)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
  (**(code **)(*piVar8 + 0x1c))(param_1,fVar1);
  if (fVar12 <= _DAT_006ea454) {
    fVar9 = (float10)FUN_006c5c40();
    _DAT_00bdb208 =
         (float)((fVar9 * (float10)fVar13 * (float10)_DAT_006ea620) /
                ((float10)_DAT_006e97d8 - (float10)fVar12 * (float10)_DAT_006f49ac));
    fVar9 = (float10)FUN_006c5c40();
    fVar9 = fVar9 * (float10)fVar13 * (float10)_DAT_006ea620;
    fVar12 = fVar12 * _DAT_006f52c8;
  }
  else {
    fVar9 = (float10)FUN_006c5c40();
    _DAT_00bdb208 = (float)(fVar9 * (float10)fVar13 * (float10)_DAT_006ea620);
    fVar9 = (float10)FUN_006c5c40();
    fVar9 = (fVar9 * (float10)fVar13 * (float10)_DAT_006ea620) /
            ((float10)fVar12 * (float10)_DAT_006f49ac + (float10)_DAT_006e97d8);
    fVar12 = fVar12 * _DAT_006f52cc;
  }
  _DAT_00bdb20c = (float)fVar9;
  fVar13 = (fVar12 - _DAT_006f52c4) * fVar13;
  if (iVar6 < 0) {
    iVar7 = iVar6 + -1;
    fVar1 = fVar13;
    if (DAT_00bdaf64 <= iVar7) {
      do {
        iVar7 = iVar7 + -1;
        *(float *)(PTR_DAT_0074bf4c + iVar7 * 4 + 4) =
             fVar1 + *(float *)(PTR_DAT_0074bf4c + iVar7 * 4 + 4);
        fVar1 = fVar1 + fVar13;
      } while (DAT_00bdaf64 <= iVar7);
    }
    iVar6 = iVar6 + 1;
    fVar1 = fVar13;
    while (iVar6 < 1) {
      iVar6 = iVar6 + 1;
      *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + -4) =
           fVar1 + *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + -4);
      fVar1 = fVar1 + fVar13;
    }
    if (iVar6 <= DAT_00bdb214) {
      do {
        iVar6 = iVar6 + 1;
        *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + -4) =
             fVar1 + *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + -4);
        fVar1 = fVar1 + fVar13;
      } while (iVar6 <= DAT_00bdb214);
    }
  }
  else {
    iVar7 = iVar6 + 1;
    fVar1 = fVar13;
    if (iVar7 <= DAT_00bdb214) {
      do {
        iVar7 = iVar7 + 1;
        *(float *)(PTR_DAT_0074bf4c + iVar7 * 4 + -4) =
             fVar1 + *(float *)(PTR_DAT_0074bf4c + iVar7 * 4 + -4);
        fVar1 = fVar1 + fVar13;
      } while (iVar7 <= DAT_00bdb214);
    }
    iVar6 = iVar6 + -1;
    fVar1 = fVar13;
    while (-1 < iVar6) {
      iVar6 = iVar6 + -1;
      *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + 4) =
           fVar1 + *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + 4);
      fVar1 = fVar1 + fVar13;
    }
    if (DAT_00bdaf64 <= iVar6) {
      do {
        iVar6 = iVar6 + -1;
        *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + 4) =
             fVar1 + *(float *)(PTR_DAT_0074bf4c + iVar6 * 4 + 4);
        fVar1 = fVar1 + fVar13;
      } while (DAT_00bdaf64 <= iVar6);
    }
  }
  iVar6 = DAT_00bdaf64;
  if (DAT_00bdaf64 <= DAT_00bdb214) {
    do {
      iVar6 = iVar6 + 1;
      *(undefined4 *)(PTR_DAT_0074bf50 + iVar6 * 4 + -4) = 0;
      *(undefined4 *)(PTR_DAT_0074bf54 + iVar6 * 4 + -4) = DAT_006f5254;
    } while (iVar6 <= DAT_00bdb214);
  }
  return;
}


