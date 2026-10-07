/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050bfe0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0050bfe0(int param_1_00,int param_1)

{
  int iVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  bool bVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  int iVar11;
  int iVar12;
  int iVar13;
  undefined4 *puVar14;
  int iVar15;
  int iVar16;
  int iVar17;
  float *pfVar18;
  float *pfVar19;
  float10 fVar20;
  float10 fVar21;
  int local_f4;
  float *local_f0;
  int local_ec;
  undefined4 local_c8;
  undefined4 local_c4;
  float local_c0;
  undefined1 local_bc [12];
  float local_b0 [9];
  undefined1 local_8c [8];
  float local_84;
  undefined4 local_7c;
  undefined4 local_78;
  undefined4 local_64;
  float local_58 [22];
  
  iVar12 = 0;
  puVar14 = (undefined4 *)(param_1_00 + 0xc);
  do {
    *(undefined4 *)(param_1_00 + 8 + (DAT_00b8faa0 + iVar12) * 0x1c) = puVar14[-1];
    *(undefined4 *)(param_1_00 + 0xc + (DAT_00b8faa0 + iVar12) * 0x1c) = *puVar14;
    iVar15 = DAT_00b8faa0 + iVar12;
    iVar12 = iVar12 + 1;
    *(undefined4 *)(param_1_00 + 0x14 + iVar15 * 0x1c) = puVar14[2];
    puVar14 = puVar14 + 7;
  } while (iVar12 < 2);
  FUN_0050a230(param_1);
  FUN_0050be30(param_1);
  iVar15 = 0;
  iVar12 = DAT_00b8faa0;
  if (0 < DAT_00b8faa0) {
    pfVar18 = (float *)(param_1_00 + 0x10);
    iVar13 = (DAT_00b8faa0 + -1) * 0x1c;
    do {
      fVar2 = *(float *)(iVar13 + 0x10 + param_1_00);
      if ((float)_DAT_006f4150 < ABS(fVar2 - *pfVar18)) {
        *pfVar18 = (*(float *)(param_1_00 + 0x10 + ((iVar15 + 1) % iVar12) * 0x1c) + fVar2) *
                   _DAT_006ea44c;
        iVar12 = DAT_00b8faa0;
      }
      if (param_1 == 0xb) {
        *(float *)(DAT_00b8faa8 + iVar15 * 4) = *pfVar18;
        iVar12 = DAT_00b8faa0;
      }
      iVar13 = (int)pfVar18 + (-0x10 - param_1_00);
      iVar15 = iVar15 + 1;
      pfVar18 = pfVar18 + 7;
    } while (iVar15 < iVar12);
  }
  if (param_1 == 0xb) {
    FUN_005f5960(local_b0,0,
                 *(undefined4 *)
                  (param_1_00 + 0x14 + (int)ROUND(_DAT_00b8f814 * _DAT_006ea454) * 0x1c),0);
    if (0 < DAT_00b8faa0) {
      local_f0 = (float *)(param_1_00 + 0x18);
      iVar12 = 0;
      do {
        iVar15 = iVar12 + 1;
        local_f4 = iVar15 % DAT_00b8faa0;
        if (local_f4 == 0) {
          local_f4 = 1;
        }
        FUN_005f5960(local_58,(float)local_f4 * _DAT_006f4098,
                     *(undefined4 *)
                      (param_1_00 + 0x14 +
                      (int)ROUND(_DAT_00b8f814 * (float)local_f4 * _DAT_006f4098) * 0x1c),0);
        local_c8 = local_7c;
        local_c4 = local_78;
        FUN_005f5ce0(&local_c8,local_bc,local_8c);
        fVar10 = local_c0;
        fVar3 = local_58[0] - local_b0[0];
        fVar4 = *local_f0;
        fVar6 = local_58[1] - local_b0[1];
        fVar7 = local_58[2] - local_b0[2];
        fVar2 = *(float *)(param_1_00 + 0x18 + local_f4 * 0x1c);
        fVar8 = fVar4 * _DAT_006f410c;
        fVar9 = ((*(float *)(DAT_00b8fabc + iVar12 * 4) * fVar8 * fVar8 - local_84 * _DAT_006f40b0)
                - fVar8 * fVar8 * _DAT_00749478) * _DAT_006f4108;
        fVar20 = (float10)FUN_00579ef0(local_64);
        fVar21 = (float10)FUN_00579ee0(local_64);
        *(float *)(DAT_00b8faac + iVar12 * 4) =
             (float)((((((float10)fVar2 - (float10)fVar4) *
                        ((float10)fVar4 /
                        SQRT((float10)fVar3 * (float10)fVar3 +
                             (float10)fVar6 * (float10)fVar6 + (float10)fVar7 * (float10)fVar7)) -
                       (float10)_DAT_0074947c * (float10)fVar4 * (float10)fVar4) -
                      (float10)fVar10 * (float10)_DAT_006e9814) - (float10)_DAT_006f4148) +
                    ((fVar21 + (float10)(float)(fVar20 * (float10)fVar8 * (float10)fVar8)) /
                    (float10)_DAT_00749488) * (float10)fVar9);
        pfVar18 = local_58;
        pfVar19 = local_b0;
        for (iVar12 = 0x16; iVar12 != 0; iVar12 = iVar12 + -1) {
          *pfVar19 = *pfVar18;
          pfVar18 = pfVar18 + 1;
          pfVar19 = pfVar19 + 1;
        }
        local_f0 = local_f0 + 7;
        iVar12 = iVar15;
      } while (iVar15 < DAT_00b8faa0);
    }
    iVar13 = 0;
    iVar12 = DAT_00b8faa0;
    iVar15 = DAT_00b8faac;
    if (0 < DAT_00b8faa0) {
      do {
        fVar4 = *(float *)(iVar15 + ((iVar13 + 1) % iVar12) * 4) - *(float *)(iVar15 + iVar13 * 4);
        fVar2 = *(float *)(iVar15 + ((iVar13 + 2) % iVar12) * 4) - *(float *)(iVar15 + iVar13 * 4);
        if (((float)_DAT_006f4140 < ABS(fVar4)) && (ABS(fVar4) < ABS(fVar2))) {
          fVar4 = fVar2;
        }
        if ((float)_DAT_006f4138 < ABS(fVar4)) {
          iVar17 = 2;
          local_ec = -1;
          local_f4 = -1;
          fVar2 = _DAT_006f4134;
          do {
            iVar16 = (iVar13 + iVar17) % iVar12;
            fVar4 = ABS(*(float *)(iVar15 + iVar16 * 4) - *(float *)(iVar15 + iVar13 * 4));
            iVar1 = local_f4;
            iVar11 = local_ec;
            if ((fVar4 < _DAT_006f4130) &&
               (bVar5 = fVar2 <= fVar4, iVar1 = iVar16, iVar11 = iVar17, fVar2 = fVar4, bVar5))
            break;
            local_ec = iVar11;
            local_f4 = iVar1;
            iVar17 = iVar17 + 1;
          } while (iVar17 < 8);
          if (-1 < local_f4) {
            fVar2 = *(float *)(iVar15 + local_f4 * 4);
            fVar4 = *(float *)(iVar15 + iVar13 * 4);
            iVar17 = 1;
            fVar3 = *(float *)(iVar15 + iVar13 * 4);
            if (1 < local_ec) {
              do {
                iVar1 = iVar13 + iVar17;
                fVar3 = fVar3 + (fVar2 - fVar4) / (float)local_ec;
                iVar17 = iVar17 + 1;
                *(float *)(iVar15 + (iVar1 % iVar12) * 4) = fVar3;
                iVar12 = DAT_00b8faa0;
                iVar15 = DAT_00b8faac;
              } while (iVar17 < local_ec);
            }
          }
        }
        iVar13 = iVar13 + 1;
      } while (iVar13 < iVar12);
    }
  }
  pfVar18 = (float *)(param_1_00 + 0x10);
  *(undefined4 *)(param_1_00 + 8 + iVar12 * 0x1c) = *(undefined4 *)(param_1_00 + 8);
  local_f0 = (float *)0x0;
  *(undefined4 *)(param_1_00 + 0xc + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0xc);
  *(float *)(param_1_00 + 0x10 + DAT_00b8faa0 * 0x1c) = *pfVar18;
  *(undefined4 *)(param_1_00 + 0x18 + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0x18);
  *(undefined4 *)(param_1_00 + 0x24 + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0x24);
  *(undefined4 *)(param_1_00 + 0x28 + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0x28);
  *(undefined4 *)(param_1_00 + 0x2c + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0x2c);
  *(undefined4 *)(param_1_00 + 0x34 + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0x34);
  pfVar19 = pfVar18;
  if (0 < DAT_00b8faa0) {
    do {
      pfVar19[-1] = pfVar19[-1] / pfVar19[-2];
      *pfVar19 = *pfVar19 / (pfVar19[-2] * pfVar19[-2]);
      fVar20 = (float10)FUN_0051700a((float)(int)local_f0 * _DAT_006f4098 -
                                     pfVar19[2] * _DAT_006ea514);
      fVar2 = *(float *)(param_1_00 + 0x18 +
                        (int)ROUND((float)(fVar20 * (float10)_DAT_00b8f814)) * 0x1c);
      *pfVar19 = ((pfVar19[2] * pfVar19[2]) / (fVar2 * fVar2)) * *pfVar19;
      if (*pfVar19 <= _DAT_006ea454) {
        if (_DAT_006f4128 < *pfVar19) {
          *pfVar19 = -1e-09;
        }
      }
      else if (*pfVar19 < _DAT_006f412c) {
        *pfVar19 = 1e-09;
      }
      local_f0 = (float *)((int)local_f0 + 1);
      pfVar19 = pfVar19 + 7;
    } while ((int)local_f0 < DAT_00b8faa0);
  }
  *(undefined4 *)(param_1_00 + 0xc + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0xc);
  *(float *)(param_1_00 + 0x10 + DAT_00b8faa0 * 0x1c) = *pfVar18;
  *(undefined4 *)(param_1_00 + 0x28 + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0x28);
  *(undefined4 *)(param_1_00 + 0x2c + DAT_00b8faa0 * 0x1c) = *(undefined4 *)(param_1_00 + 0x2c);
  return;
}


