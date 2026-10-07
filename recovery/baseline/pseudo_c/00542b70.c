/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00542b70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00542b70(double *param_1_00,int param_1,double *param_2)

{
  float fVar1;
  double dVar2;
  double dVar3;
  double dVar4;
  uint uVar5;
  uint uVar6;
  double dVar7;
  double dVar8;
  double dVar9;
  double dVar10;
  double dVar11;
  int iVar12;
  uint *puVar13;
  double *pdVar14;
  float *pfVar15;
  uint *puVar16;
  uint *puVar17;
  int local_ac;
  double local_a0;
  double local_98;
  double local_88;
  double local_80;
  double local_78;
  double local_70;
  uint local_68 [2];
  double local_60;
  undefined4 local_58;
  undefined4 uStack_54;
  double local_50 [4];
  double local_30;
  double local_28 [4];
  
  local_60 = _DAT_006ea4b0;
  *(undefined4 *)(param_2 + 1) = 0;
  *(undefined4 *)((int)param_2 + 0xc) = 0;
  *(undefined4 *)(param_2 + 2) = 0;
  *(undefined4 *)((int)param_2 + 0x14) = 0;
  local_88 = param_1_00[1];
  local_78 = *param_1_00;
  local_80 = param_1_00[8];
  pfVar15 = (float *)(param_1 + 0x1cae);
  iVar12 = 0;
  pdVar14 = param_1_00 + 3;
  local_30 = local_60;
  do {
    fVar1 = *pfVar15;
    pfVar15 = pfVar15 + 1;
    *(double *)((int)local_50 + iVar12) = (double)fVar1;
    local_60 = (double)fVar1 + local_60;
    dVar2 = *pdVar14;
    *(double *)((int)local_28 + iVar12) = dVar2;
    iVar12 = iVar12 + 8;
    local_30 = dVar2 + local_30;
    pdVar14 = pdVar14 + 1;
  } while (iVar12 < 0x20);
  local_60 = local_60 * _DAT_006ef6d0;
  FUN_005f5890(param_1 + 0x524);
  puVar17 = *(uint **)(param_1 + 0x520);
  puVar16 = *(uint **)(param_1 + 0x518);
  local_ac = 2;
  puVar13 = local_68;
  do {
    uVar5 = *puVar16;
    uVar6 = *puVar17;
    puVar16 = puVar16 + 1;
    puVar17 = puVar17 + 1;
    *puVar13 = uVar5 ^ uVar6;
    local_ac = local_ac + -1;
    puVar13 = puVar13 + 1;
  } while (local_ac != 0);
  FUN_005f58a0(param_1 + 0x524);
  local_a0 = _DAT_006e9808 -
             (double)CONCAT44(local_68[1],local_68[0]) /
             (double)*(float *)(*(int *)(param_1 + 0x58a) + 0x24);
  fVar1 = *(float *)(param_1 + 0x1cd2);
  if (*(float *)(param_1 + 0x1cd2) < *(float *)(param_1 + 0x1cce)) {
    fVar1 = *(float *)(param_1 + 0x1cce);
  }
  if (fVar1 <= *(float *)(param_1 + 0x1cd6)) {
    fVar1 = *(float *)(param_1 + 0x1cd6);
  }
  if (fVar1 <= *(float *)(param_1 + 0x1cda)) {
    fVar1 = *(float *)(param_1 + 0x1cda);
  }
  local_98 = (double)fVar1;
  local_58 = *(undefined4 *)(param_1_00 + 0xb);
  uStack_54 = *(undefined4 *)((int)param_1_00 + 0x5c);
  local_68[0] = *(uint *)(param_1_00 + 9);
  local_68[1] = *(undefined4 *)((int)param_1_00 + 0x4c);
  local_ac = 0;
  while( true ) {
    local_70 = 1.0;
    if (*(double *)((int)param_2 + local_ac * 0x19 + 0x1c) <= _DAT_006ea4b8) {
      dVar2 = local_88;
      if ((local_ac == 5) && (5 < *(int *)(param_2 + 3))) {
        local_70 = (double)(*(int *)(param_2 + 3) + -4);
        dVar2 = local_88 / local_70;
      }
    }
    else {
      dVar2 = *(double *)((int)param_2 + local_ac * 0x19 + 0x1c) - local_78;
    }
    if (dVar2 < _DAT_006ea4b0) {
      dVar2 = _DAT_006ea4b0;
    }
    dVar7 = local_70 * (_DAT_006ecfd0 / ((double)local_ac + _DAT_006ecfd0));
    dVar3 = dVar2;
    if (local_80 < dVar2) {
      dVar3 = local_80;
    }
    local_80 = local_80 - dVar3;
    dVar4 = dVar2 - dVar3;
    param_2[1] = (dVar4 * (double)CONCAT44(local_68[1],local_68[0]) +
                 (((dVar4 * param_1_00[2] * _DAT_006ea668 + local_60) * param_1_00[0x11] +
                   (double)_DAT_00b8fa5c + local_30) -
                 (dVar4 * param_1_00[7] * _DAT_006ea668 + local_a0) * param_1_00[0x12]) * dVar2) *
                 local_70 + param_2[1];
    dVar11 = dVar3 * param_1_00[7] * _DAT_006ef6d0;
    dVar8 = ((dVar2 - ((_DAT_006e9808 - (local_a0 + dVar11)) / param_1_00[7] + dVar3)) +
            _DAT_006e9830) * _DAT_006ea668 * param_1_00[0x14] * param_1_00[0x10];
    if (_DAT_006ea4b0 < dVar8) {
      dVar8 = dVar8 * dVar8;
      dVar10 = dVar7 * dVar8 + param_2[2];
      param_2[2] = dVar10;
      dVar9 = param_1_00[0x14] * param_1_00[0x14];
      if (dVar9 < dVar8) {
        dVar8 = (dVar8 - dVar9) * param_1_00[0x15] * dVar7;
        param_2[1] = dVar8 + param_2[1];
        param_2[2] = dVar10 + dVar8;
      }
    }
    local_a0 = dVar4 * param_1_00[7] + dVar11 + local_a0;
    if (_DAT_006e9808 < local_a0) {
      local_a0 = 1.0;
    }
    iVar12 = 0;
    dVar3 = dVar3 * _DAT_006ef6d0;
    pfVar15 = (float *)(param_1 + 0x1cce);
    do {
      dVar8 = (double)*pfVar15 * (dVar3 + dVar4) + local_50[iVar12];
      local_50[iVar12] = dVar8;
      dVar8 = (dVar8 - _DAT_006ef4c0) * param_1_00[0x16] * param_1_00[0x10] * _DAT_006f5480;
      if (_DAT_006ea4b0 < dVar8) {
        dVar8 = dVar8 * dVar8;
        dVar9 = dVar7 * dVar8 + param_2[2];
        param_2[2] = dVar9;
        dVar11 = param_1_00[0x16] * param_1_00[0x16];
        if (dVar11 < dVar8) {
          dVar8 = (dVar8 - dVar11) * param_1_00[0x17] * dVar7;
          param_2[1] = dVar8 + param_2[1];
          param_2[2] = dVar9 + dVar8;
        }
      }
      iVar12 = iVar12 + 1;
      pfVar15 = pfVar15 + 1;
    } while (iVar12 < 4);
    if (*(double *)((int)param_2 + local_ac * 0x19 + 0x1c) < _DAT_006ea4b0) break;
    if (local_80 <= _DAT_006ef6c8) {
      param_2[1] = param_1_00[0x13] + param_2[1];
    }
    else {
      dVar3 = param_1_00[0x1a];
      dVar4 = param_2[1];
      param_2[1] = dVar3 + dVar4;
      if (0 < *(int *)(param_1 + 0x21d8)) {
        dVar8 = param_1_00[7];
        if (param_1_00[7] < local_98) {
          dVar8 = local_98;
        }
        dVar8 = (local_88 - dVar2) * dVar8;
        if (dVar8 < _DAT_006e9808) {
          dVar8 = _DAT_006e9808;
        }
        dVar3 = (double)*(int *)(param_1 + 0x21d8) * param_1_00[0x1b] * dVar8 + dVar3 + dVar4;
        param_2[1] = dVar3;
        if (0 < *(int *)(param_1 + 0x21d4)) {
          param_2[1] = (double)*(int *)(param_1 + 0x21d4) * param_1_00[0x1c] * dVar8 + dVar3;
        }
      }
    }
    dVar3 = *(double *)(&DAT_0074c7b8 + *(int *)((int)param_2 + local_ac * 0x19 + 0x30) * 8);
    if (*(double *)(&DAT_0074c7b8 + *(int *)((int)param_2 + local_ac * 0x19 + 0x30) * 8) <
        *(double *)(&DAT_0074c798 + *(int *)((int)param_2 + local_ac * 0x19 + 0x2c) * 8)) {
      dVar3 = *(double *)(&DAT_0074c798 + *(int *)((int)param_2 + local_ac * 0x19 + 0x2c) * 8);
    }
    if (*(char *)((int)param_2 + local_ac * 0x19 + 0x34) != '\0') {
      dVar4 = _DAT_006ed050;
      if (_DAT_006ea4b0 < (double)CONCAT44(uStack_54,local_58)) {
        dVar4 = (double)CONCAT44(uStack_54,local_58);
      }
      dVar3 = dVar3 + dVar4;
      local_68[0] = *(uint *)(param_1_00 + 10);
      local_68[1] = *(undefined4 *)((int)param_1_00 + 0x54);
      local_58 = 0;
      uStack_54 = 0;
    }
    dVar4 = param_2[1];
    param_2[1] = dVar3 + dVar4;
    if ((*(char *)(param_1_00 + 0x1d) != '\0') && (local_80 < _DAT_006ef6c8)) {
      dVar8 = param_1_00[7];
      if (param_1_00[7] < local_98) {
        dVar8 = local_98;
      }
      dVar7 = (local_88 - dVar2) * dVar8 * param_1_00[0x19] * param_1_00[0x18] * dVar7 *
              _DAT_006ea668;
      param_2[1] = dVar3 + dVar4 + dVar7;
      param_2[2] = dVar7 + param_2[2];
    }
    local_a0 = local_a0 -
               *(double *)(&DAT_0074c7e8 + *(int *)((int)param_2 + local_ac * 0x19 + 0x30) * 8) *
               param_1_00[0xc];
    if (local_a0 < _DAT_006ea4b0) {
      local_a0 = 0.0;
    }
    iVar12 = *(int *)((int)param_2 + local_ac * 0x19 + 0x2c) * 0x10;
    pdVar14 = (double *)(&DAT_0074c820 + iVar12);
    local_50[0] = local_50[0] * *(double *)(&DAT_0074c818 + iVar12);
    local_28[0] = local_28[0] * *(double *)(&DAT_0074c818 + iVar12);
    local_50[2] = local_50[2] * *(double *)(&DAT_0074c818 + iVar12);
    local_28[2] = local_28[2] * *(double *)(&DAT_0074c818 + iVar12);
    local_50[1] = local_50[1] * *pdVar14;
    local_28[1] = local_28[1] * *pdVar14;
    local_50[3] = local_50[3] * *pdVar14;
    iVar12 = 0;
    local_28[3] = local_28[3] * *pdVar14;
    local_60 = _DAT_006ea4b0;
    local_30 = _DAT_006ea4b0;
    do {
      local_60 = local_60 + *(double *)((int)local_50 + iVar12);
      local_30 = local_30 + *(double *)((int)local_28 + iVar12);
      iVar12 = iVar12 + 8;
    } while (iVar12 < 0x20);
    local_60 = local_60 * _DAT_006ef6d0;
    local_ac = local_ac + 1;
    local_88 = local_88 - dVar2;
    local_78 = dVar2 + local_78;
    if (5 < local_ac) {
LAB_005432e0:
      *param_2 = param_2[2] * param_1_00[0x10] + param_2[1];
      return;
    }
  }
  if (_DAT_006f5470 < local_70) {
    dVar3 = (local_70 - _DAT_006e9808) * (param_1_00[0x13] + _DAT_006f5420) + param_2[1];
    param_2[1] = dVar3;
    if ((*(char *)(param_1_00 + 0x1d) != '\0') && (local_80 < _DAT_006ef6c8)) {
      dVar4 = param_1_00[7];
      if (param_1_00[7] < local_98) {
        dVar4 = local_98;
      }
      dVar2 = (local_88 - (local_70 + _DAT_006e9808) * dVar2 * _DAT_006ea668) * dVar4 * dVar7 *
              param_1_00[0x19] * param_1_00[0x18] * _DAT_006ea668;
      param_2[1] = dVar3 + dVar2;
      param_2[2] = dVar2 + param_2[2];
    }
  }
  goto LAB_005432e0;
}


