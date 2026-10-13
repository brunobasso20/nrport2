/* NR2003.exe @ 005105c0 FUN_005105c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005105c0(int param_1)

{
  undefined4 *puVar1;
  int *piVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  float fVar6;
  int iVar7;
  undefined4 *puVar8;
  int iVar9;
  undefined *puVar10;
  int iVar11;
  int iVar12;
  int iVar13;
  int iVar14;
  float *pfVar15;
  int local_20;
  int local_1c;
  int local_10;

  iVar7 = rndInt(0);
  local_20 = 0;
  if (0 < DAT_00bad920) {
    local_10 = 0;
    do {
      iVar9 = 0;
      iVar13 = local_10 + DAT_00bcf734;
      iVar14 = *(int *)(*(int *)(param_1 + 0xc) + local_20 * 4);
      fVar6 = *(float *)(iVar13 + 4) - (float)*(int *)(iVar13 + 0x1538) * _DAT_006f45d8;
      puVar10 = &DAT_006f45e0;
      if ((0 < *(int *)(param_1 + 0x49)) &&
         (_DAT_006ea454 < *(float *)(*(undefined **)(param_1 + 0x4d) + 0x20))) {
        puVar10 = *(undefined **)(param_1 + 0x4d);
      }
      iVar12 = *(int *)(iVar14 + 0x5a);
      *(int *)(iVar13 + 0x1540) = iVar12;
      if (iVar12 < 1) {
        puVar1 = *(undefined4 **)(iVar13 + 0x1544);
        *(undefined4 *)(iVar13 + 0x1540) = 1;
        puVar1[4] = puVar1 + 5;
        *puVar1 = 0;
        puVar1[2] = 0;
        rndSeed(local_20 << 4,0);
        FUN_00510100(puVar1[4],puVar10,fVar6,*(undefined4 *)(iVar13 + 8),
                     *(undefined4 *)(iVar13 + 0x153c));
      }
      else {
        iVar11 = 0;
        if (0 < iVar12) {
          local_1c = 0;
          do {
            iVar4 = *(int *)(iVar13 + 0x1544);
            piVar2 = (int *)(iVar9 + 0x10 + iVar4);
            *piVar2 = iVar4 + iVar12 * 0x14 + *(int *)(iVar13 + 0x153c) * iVar11 * 8;
            pfVar15 = (float *)(*(int *)(iVar14 + 0x62) + local_1c);
            *(float *)(iVar9 + iVar4) = *pfVar15;
            *(float *)(iVar9 + 8 + iVar4) = pfVar15[1] - *pfVar15;
            rndSeed(local_20 * 0x10 + iVar11,0);
            FUN_00510100(*piVar2,(int)pfVar15[2] * 0x30 + *(int *)(param_1 + 0x4d),fVar6,
                         *(undefined4 *)(iVar13 + 8),*(undefined4 *)(iVar13 + 0x153c));
            local_1c = local_1c + 0xc;
            iVar11 = iVar11 + 1;
            iVar12 = *(int *)(iVar13 + 0x1540);
            iVar9 = iVar9 + 0x14;
          } while (iVar11 < iVar12);
        }
      }
      iVar9 = *(int *)(iVar14 + 0x5e);
      *(int *)(iVar13 + 0x1548) = iVar9;
      if ((0 < iVar9) && (iVar12 = 0, 0 < iVar9)) {
        iVar11 = 0;
        iVar9 = 0;
        do {
          puVar1 = (undefined4 *)(*(int *)(iVar14 + 0x66) + iVar11);
          pfVar15 = (float *)(*(int *)(iVar14 + 0x66) + iVar11);
          puVar8 = (undefined4 *)(*(int *)(iVar13 + 0x154c) + iVar9);
          iVar12 = iVar12 + 1;
          iVar9 = iVar9 + 0x20;
          iVar11 = iVar11 + 0x10;
          *puVar8 = *puVar1;
          puVar8[2] = pfVar15[1] - *pfVar15;
          puVar8[4] = pfVar15[2];
          puVar8[6] = pfVar15[3] - pfVar15[2];
        } while (iVar12 < *(int *)(iVar13 + 0x1548));
      }
      local_20 = local_20 + 1;
      local_10 = local_10 + 0x1550;
    } while (local_20 < DAT_00bad920);
  }
  local_20 = 0;
  if (0 < DAT_00bad920) {
    local_10 = 0;
    do {
      param_1 = 0;
      iVar14 = local_10 + DAT_00bcf734;
      if (*(int *)(iVar14 + 0x1540) != 1 && -1 < *(int *)(iVar14 + 0x1540) + -1) {
        iVar9 = 0;
        do {
          iVar13 = *(int *)(iVar14 + 0x1544);
          iVar12 = 0;
          *(float *)(iVar9 + 4 + iVar13) =
               *(float *)(iVar9 + 0x14 + iVar13) - *(float *)(iVar9 + iVar13);
          *(float *)(iVar9 + 0xc + iVar13) =
               *(float *)(iVar9 + 0x1c + iVar13) - *(float *)(iVar9 + 8 + iVar13);
          if (0 < *(int *)(iVar14 + 0x153c)) {
            do {
              iVar5 = *(int *)(iVar9 + 0x10 + iVar13);
              iVar3 = iVar12 * 8;
              iVar11 = iVar12 * 8;
              iVar4 = iVar12 * 8;
              iVar12 = iVar12 + 1;
              *(float *)(iVar5 + iVar4 + 4) =
                   *(float *)(*(int *)(iVar9 + 0x24 + iVar13) + iVar3) - *(float *)(iVar5 + iVar11);
            } while (iVar12 < *(int *)(iVar14 + 0x153c));
          }
          param_1 = param_1 + 1;
          iVar9 = iVar9 + 0x14;
        } while (param_1 < *(int *)(iVar14 + 0x1540) + -1);
      }
      iVar9 = 0;
      if (*(int *)(iVar14 + 0x1548) != 1 && -1 < *(int *)(iVar14 + 0x1548) + -1) {
        iVar13 = 0;
        do {
          iVar12 = *(int *)(iVar14 + 0x154c);
          iVar9 = iVar9 + 1;
          *(float *)(iVar13 + 4 + iVar12) =
               *(float *)(iVar13 + 0x20 + iVar12) - *(float *)(iVar13 + iVar12);
          *(float *)(iVar13 + 0xc + iVar12) =
               *(float *)(iVar13 + 0x28 + iVar12) - *(float *)(iVar13 + 8 + iVar12);
          *(float *)(iVar13 + 0x14 + iVar12) =
               *(float *)(iVar13 + 0x30 + iVar12) - *(float *)(iVar13 + 0x10 + iVar12);
          *(float *)(iVar13 + 0x1c + iVar12) =
               *(float *)(iVar13 + 0x38 + iVar12) - *(float *)(iVar13 + 0x18 + iVar12);
          iVar13 = iVar13 + 0x20;
        } while (iVar9 < *(int *)(iVar14 + 0x1548) + -1);
      }
      local_20 = local_20 + 1;
      local_10 = local_10 + 0x1550;
    } while (local_20 < DAT_00bad920);
  }
  rndSeed(iVar7,0);
  return;
}
