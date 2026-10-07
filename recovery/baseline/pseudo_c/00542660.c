/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00542660 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00542660(double *param_1_00,int param_1,int param_2)

{
  int iVar1;
  double dVar2;
  uint uVar3;
  double dVar4;
  double dVar5;
  double dVar6;
  double dVar7;
  double dVar8;
  double *pdVar9;
  uint *puVar10;
  int iVar11;
  uint *puVar12;
  uint uVar13;
  int iVar14;
  int iVar15;
  int iVar16;
  double local_50;
  double local_40;
  double local_38;
  double local_30;
  double local_28;
  double local_20;
  double local_10;
  
  local_40 = param_1_00[1];
  local_28 = *param_1_00;
  local_38 = param_1_00[8];
  FUN_005f5890(param_1 + 0x524);
  puVar12 = *(uint **)(param_1 + 0x520);
  puVar10 = *(uint **)(param_1 + 0x518);
  local_50._0_4_ = 2;
  pdVar9 = &local_10;
  do {
    uVar13 = *puVar10;
    uVar3 = *puVar12;
    puVar10 = puVar10 + 1;
    puVar12 = puVar12 + 1;
    *(uint *)pdVar9 = uVar13 ^ uVar3;
    local_50._0_4_ = local_50._0_4_ + -1;
    pdVar9 = (double *)((int)pdVar9 + 4);
  } while (local_50._0_4_ != 0);
  FUN_005f58a0(param_1 + 0x524);
  uVar13 = (uint)(*(char *)(param_1 + 0x1fb5) != '\0');
  iVar16 = 0;
  dVar4 = _DAT_006e9808 - local_10 / (double)*(float *)(*(int *)(param_1 + 0x58a) + 0x24);
  while( true ) {
    local_50 = local_40;
    iVar1 = param_2 + iVar16 * 0x19;
    if (*(double *)(iVar1 + 0x1c) <= _DAT_006ea4b8) {
      if ((iVar16 == 5) && (5 < *(int *)(param_2 + 0x18))) {
        local_50 = local_40 / (double)(*(int *)(param_2 + 0x18) + -4);
      }
    }
    else {
      local_50 = *(double *)(iVar1 + 0x1c) - local_28;
    }
    if (local_50 < _DAT_006ea4b0) {
      local_50 = 0.0;
    }
    dVar2 = local_50;
    if (local_38 < local_50) {
      dVar2 = local_38;
    }
    local_38 = local_38 - dVar2;
    dVar6 = dVar2 * param_1_00[7] * _DAT_006ef6d0;
    if ((int)uVar13 < iVar16) {
      local_20 = 1e+100;
      iVar11 = 5;
      iVar14 = 5;
      do {
        local_30 = dVar4 - *(double *)(&DAT_0074c7e8 + iVar11 * 8) * param_1_00[0xc];
        if (local_30 < _DAT_006ea4b0) {
          local_30 = 0.0;
        }
        dVar8 = ((double)_DAT_00b8fa5c -
                ((local_50 - dVar2) * param_1_00[7] * _DAT_006ea668 + local_30) * param_1_00[0x12])
                * local_50;
        dVar5 = ((local_50 -
                 ((_DAT_006e9808 - (local_30 + dVar6)) * (_DAT_006e9808 / param_1_00[7]) + dVar2)) +
                _DAT_006e9830) * _DAT_006ea668 * param_1_00[0x14] * param_1_00[0x10];
        dVar7 = _DAT_006ea4b0;
        if (_DAT_006ea4b0 < dVar5) {
          dVar7 = dVar5 * dVar5;
          dVar5 = param_1_00[0x14] * param_1_00[0x14];
          if (dVar5 < dVar7) {
            dVar5 = (dVar7 - dVar5) * param_1_00[0x15];
            dVar8 = dVar5 + dVar8;
            dVar7 = dVar5 + dVar7;
          }
        }
        dVar8 = dVar7 * param_1_00[0x10] + dVar8;
        iVar15 = iVar11;
        if ((dVar8 < local_20 == (dVar8 == local_20)) && (iVar11 != 5)) {
          iVar15 = iVar14;
          dVar8 = local_20;
        }
        local_20 = dVar8;
        iVar11 = iVar11 + -1;
        iVar14 = iVar15;
      } while (-1 < iVar11);
      *(int *)(iVar1 + 0x17) = iVar15;
      dVar4 = dVar4 - *(double *)(&DAT_0074c7e8 + iVar15 * 8) * param_1_00[0xc];
      if (dVar4 < _DAT_006ea4b0) {
        dVar4 = _DAT_006ea4b0;
      }
    }
    dVar4 = (local_50 - dVar2) * param_1_00[7] + dVar6 + dVar4;
    if (_DAT_006e9808 < dVar4) {
      dVar4 = _DAT_006e9808;
    }
    if (*(double *)(iVar1 + 0x1c) < _DAT_006ea4b0) break;
    if ((iVar16 < (int)uVar13) &&
       (dVar4 = dVar4 - *(double *)(&DAT_0074c7e8 + *(int *)(iVar1 + 0x30) * 8) * param_1_00[0xc],
       dVar4 < _DAT_006ea4b0)) {
      dVar4 = _DAT_006ea4b0;
    }
    local_40 = local_40 - local_50;
    iVar16 = iVar16 + 1;
    local_28 = local_50 + local_28;
    if (5 < iVar16) {
      return;
    }
  }
  return;
}


