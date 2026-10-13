/* rend_dxg.dll @ 10047350 FUN_10047350 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_10047350(int param_1_00,void *param_1)

{
  float fVar1;
  double dVar2;
  void **ppvVar3;
  int iVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  void *pvVar8;
  success sVar9;
  int iVar10;
  float *pfVar11;
  float *pfVar12;
  void *pvVar13;
  float *pfVar14;
  void *pvVar15;
  float *pfVar16;
  int iVar17;
  void *pvVar18;
  void *local_14;
  undefined8 local_10;
  undefined8 local_8;

  pvVar8 = param_1;
  if ((*(int *)((int)param_1 + 0x4d) != 0) && (0 < *(int *)(*(int *)((int)param_1 + 0x4d) + 4))) {
    if (*(void **)(param_1_00 + 0x80) != (void *)0x0) {
      _memFree(*(void **)(param_1_00 + 0x80));
    }
    sVar9 = _memAlloc(&local_14,*(int *)(*(int *)((int)pvVar8 + 0x4d) + 4) * 0xc);
    *(uint *)(param_1_00 + 0x80) = -(uint)(sVar9 != 0) & (uint)local_14;
    if (*(void **)(param_1_00 + 0x84) != (void *)0x0) {
      _memFree(*(void **)(param_1_00 + 0x84));
    }
    sVar9 = _memAlloc(&param_1,*(int *)(*(int *)((int)pvVar8 + 0x4d) + 4) << 2);
    *(uint *)(param_1_00 + 0x84) = -(uint)(sVar9 != 0) & (uint)param_1;
    if (*(void **)(param_1_00 + 0x88) != (void *)0x0) {
      _memFree(*(void **)(param_1_00 + 0x88));
    }
    sVar9 = _memAlloc(&param_1,*(int *)(*(int *)((int)pvVar8 + 0x4d) + 4) << 2);
    pvVar18 = param_1;
    param_1 = _DAT_10096f34;
    pfVar16 = (float *)(-(uint)(sVar9 != 0) & (uint)pvVar18);
    pfVar12 = *(float **)(param_1_00 + 0x80);
    *(float **)(param_1_00 + 0x88) = pfVar16;
    if (pfVar12 != (float *)0x0) {
      ppvVar3 = *(void ***)((int)pvVar8 + 0x4d);
      iVar10 = 0;
      pvVar18 = ppvVar3[1];
      if (0 < (int)pvVar18) {
        local_10 = (double)CONCAT44(local_10._4_4_,(float)(int)pvVar18);
        do {
          iVar10 = iVar10 + 1;
          fVar5 = (float)iVar10 / (float)(int)pvVar18;
          if (((pfVar12 != (float *)0x0) && (pfVar12 != (float *)0xfffffffc)) &&
             (ppvVar3 != (void **)0x0)) {
            fVar1 = _DAT_10095230 - fVar5;
            fVar6 = fVar1 * fVar1 * fVar1;
            fVar7 = fVar1 * fVar1 * fVar5 * _DAT_10097490;
            fVar1 = fVar1 * fVar5 * fVar5 * _DAT_10097490;
            fVar5 = fVar5 * fVar5 * fVar5;
            *pfVar12 = -(fVar6 * (float)ppvVar3[2] +
                        fVar7 * (float)ppvVar3[3] +
                        fVar1 * (float)ppvVar3[4] + fVar5 * (float)ppvVar3[5]);
            pfVar12[1] = fVar6 * (float)ppvVar3[6] +
                         fVar7 * (float)ppvVar3[7] +
                         fVar1 * (float)ppvVar3[8] + fVar5 * (float)ppvVar3[9];
          }
          if ((float)param_1 < pfVar12[1] != (NAN((float)param_1) || NAN(pfVar12[1]))) {
            param_1 = (void *)pfVar12[1];
          }
          pfVar12 = pfVar12 + 3;
        } while (iVar10 < (int)pvVar18);
      }
      pvVar15 = param_1;
      if (((float)_DAT_10096f34 < (float)*ppvVar3) &&
         (pvVar15 = *ppvVar3, (float)_DAT_10096f34 < (float)param_1)) {
        pfVar12 = *(float **)(param_1_00 + 0x80);
        pvVar13 = pvVar18;
        if (0 < (int)pvVar18) {
          do {
            pvVar13 = (void *)((int)pvVar13 + -1);
            *pfVar12 = ((float)pvVar15 / (float)param_1) * *pfVar12;
            pfVar12[1] = ((float)pvVar15 / (float)param_1) * pfVar12[1];
            pfVar12 = pfVar12 + 3;
          } while (pvVar13 != (void *)0x0);
        }
      }
      fVar5 = (float)*(double *)((int)pvVar8 + 0x15) - (float)pvVar15;
      *(double *)((int)pvVar8 + 0x15) = (double)fVar5;
      if (fVar5 < (float)_DAT_10097460 != (NAN(fVar5) || NAN((float)_DAT_10097460))) {
        *(undefined4 *)((int)pvVar8 + 0x15) = 0;
        *(undefined4 *)((int)pvVar8 + 0x19) = 0;
      }
      fVar5 = (float)*(double *)((int)pvVar8 + 0x1d) - (float)pvVar15;
      *(double *)((int)pvVar8 + 0x1d) = (double)fVar5;
      if (fVar5 < (float)_DAT_10097460 != (NAN(fVar5) || NAN((float)_DAT_10097460))) {
        *(undefined4 *)((int)pvVar8 + 0x1d) = 0;
        *(undefined4 *)((int)pvVar8 + 0x21) = 0;
      }
      pfVar11 = *(float **)(param_1_00 + 0x80);
      pfVar12 = pfVar11 + 2;
      local_8 = (double)CONCAT44(local_8._4_4_,pfVar12);
      *pfVar12 = SQRT(pfVar11[1] * pfVar11[1] + *pfVar11 * *pfVar11);
      if (1 < (int)pvVar18) {
        iVar10 = (int)pvVar18 + -1;
        do {
          fVar5 = pfVar11[3] - *pfVar11;
          iVar10 = iVar10 + -1;
          pfVar11[5] = SQRT(fVar5 * fVar5 + (pfVar11[4] - pfVar11[1]) * (pfVar11[4] - pfVar11[1])) +
                       pfVar11[2];
          pfVar11 = pfVar11 + 3;
        } while (iVar10 != 0);
      }
      param_1 = *(void **)(*(int *)(param_1_00 + 0x80) + -4 + (int)pvVar18 * 0xc);
      if ((*(float **)(param_1_00 + 0x84) != (float *)0x0) && (0 < (int)pvVar18)) {
        dVar2 = *(double *)((int)pvVar8 + 0x15);
        fVar5 = (float)param_1 + (float)dVar2;
        local_10 = (double)fVar5;
        pfVar11 = pfVar12;
        pfVar14 = *(float **)(param_1_00 + 0x84);
        pvVar15 = pvVar18;
        do {
          fVar1 = *pfVar11;
          pfVar11 = pfVar11 + 3;
          pvVar15 = (void *)((int)pvVar15 + -1);
          *pfVar14 = _DAT_10095230 - (fVar1 + (float)dVar2) / fVar5;
          pfVar14 = pfVar14 + 1;
        } while (pvVar15 != (void *)0x0);
      }
      if (pfVar16 != (float *)0x0) {
        if (0 < (int)pvVar18) {
          dVar2 = *(double *)((int)pvVar8 + 0x1d);
          fVar5 = (float)param_1 + (float)dVar2;
          local_8 = (double)fVar5;
          pfVar11 = pfVar16;
          do {
            fVar1 = *pfVar12;
            pfVar12 = pfVar12 + 3;
            pvVar18 = (void *)((int)pvVar18 + -1);
            *pfVar11 = _DAT_10095230 - (fVar1 + (float)dVar2) / fVar5;
            pfVar11 = pfVar11 + 1;
          } while (pvVar18 != (void *)0x0);
        }
        if ((pfVar16 != (float *)0x0) && (*(int *)(param_1_00 + 0x84) != 0)) {
          iVar10 = *(int *)((int)pvVar8 + 0x59);
          iVar17 = 0;
          *(float *)(param_1_00 + 0x90) =
               _DAT_10095230 -
               (float)*(double *)((int)pvVar8 + 0x15) /
               ((float)param_1 + (float)*(double *)((int)pvVar8 + 0x15));
          *(float *)(param_1_00 + 0x94) =
               _DAT_10095230 -
               (float)*(double *)((int)pvVar8 + 0x1d) /
               ((float)param_1 + (float)*(double *)((int)pvVar8 + 0x1d));
          if (0 < iVar10) {
            iVar10 = 0;
            do {
              iVar4 = *(int *)(*(int *)((int)pvVar8 + 0x5d) + 0x14 + iVar10);
              if (iVar4 != 0) {
                FUN_10047230(iVar4 + 0xc,0,*(undefined4 *)(param_1_00 + 0x90),
                             *(undefined4 *)(param_1_00 + 0x94),0x3f800000,0x3f800000);
              }
              iVar4 = *(int *)(*(int *)((int)pvVar8 + 0x5d) + 0x1c + iVar10);
              if (iVar4 != 0) {
                FUN_10047230(iVar4 + 0xc,2,*(undefined4 *)(param_1_00 + 0x90),
                             *(undefined4 *)(param_1_00 + 0x94),0x3f800000,0x3f800000);
              }
              iVar17 = iVar17 + 1;
              iVar10 = iVar10 + 0x53a;
            } while (iVar17 < *(int *)((int)pvVar8 + 0x59));
            return;
          }
        }
      }
    }
  }
  return;
}
