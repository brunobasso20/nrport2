/* NR2003.exe @ 005bc950 FUN_005bc950 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005bc950(int param_1,int param_2,int param_3)

{
  float fVar1;
  int *piVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  double *pdVar6;
  uint uVar7;
  int iVar8;
  double *pdVar9;
  int iVar10;
  float10 fVar11;
  float10 fVar12;
  float fVar13;
  float fVar14;
  int iStack_7c;
  float *pfStack_78;
  float fStack_70;
  double *pdStack_6c;
  float fStack_68;
  int iStack_64;
  undefined4 uStack_60;
  double dStack_5c;
  undefined8 local_54;
  float afStack_4c [7];
  float afStack_30 [11];
  
  piVar2 = (int *)FUN_005d8700();
  local_54 = (double)CONCAT44(local_54._4_4_,piVar2);
  if (piVar2 != (int *)0x0) {
    (**(code **)(*piVar2 + 0x1c))(s_raceline_mip_00752ef8);
    iVar3 = (**(code **)(*piVar2 + 0x18))(1,1);
    if ((iVar3 != 0) && (iVar3 = FUN_005e4e50(), iVar3 != 0)) {
      iVar4 = FUN_005cfce4(&pdStack_6c,DAT_00b8faa0 << 3);
      pdVar9 = (double *)(-(uint)(iVar4 != 0) & (uint)pdStack_6c);
      iVar4 = FUN_005cfce4(&fStack_68,DAT_00b8faa0 * 8);
      uVar7 = -(uint)(iVar4 != 0) & (uint)fStack_68;
      if (pdVar9 != (double *)0x0) {
        if (uVar7 != 0) {
          iVar4 = 0;
          iVar10 = 0;
          fVar14 = 0.0;
          fVar13 = 0.0;
          if (7 < DAT_00b8faa0) {
            iVar5 = 0;
            iVar8 = DAT_00b8faa0 + -3;
            do {
              fVar13 = fVar13 + *(float *)(param_2 + iVar8 * 4);
              *(undefined4 *)((int)afStack_4c + iVar5) = *(undefined4 *)(param_2 + iVar8 * 4);
              iVar10 = iVar8 + 1;
              *(undefined4 *)((int)afStack_4c + iVar5 + 0x1c) =
                   *(undefined4 *)(param_1 + 0x14 + iVar8 * 0x1c);
              fVar14 = *(float *)(param_1 + 0x14 + iVar8 * 0x1c) + fVar14;
              if (DAT_00b8faa0 <= iVar10) {
                iVar10 = 0;
              }
              iVar5 = iVar5 + 4;
              iVar8 = iVar10;
            } while (iVar5 < 0x1c);
          }
          iStack_7c = 0;
          if (0 < DAT_00b8faa0) {
            pfStack_78 = (float *)(param_1 + 0x14);
            iStack_64 = uVar7 - (int)pdVar9;
            pdStack_6c = pdVar9;
            do {
              if (DAT_00b8faa0 < 8) {
                fVar11 = (float10)*(float *)(param_2 + iStack_7c * 4);
                fStack_70 = *pfStack_78;
              }
              else {
                fVar11 = (float10)fVar13 * (float10)_DAT_006f5930;
                fStack_70 = fVar14 * _DAT_006f5930;
                iVar8 = iVar4 + 1;
                fVar1 = *(float *)(param_2 + iVar10 * 4);
                fVar13 = (fVar1 - afStack_4c[iVar4]) + fVar13;
                afStack_4c[iVar4] = fVar1;
                fVar1 = *(float *)(param_1 + 0x14 + iVar10 * 0x1c);
                fVar14 = (fVar1 - afStack_4c[iVar4 + 7]) + fVar14;
                afStack_4c[iVar4 + 7] = fVar1;
                if (6 < iVar8) {
                  iVar8 = 0;
                }
                iVar10 = iVar10 + 1;
                iVar4 = iVar8;
                if (DAT_00b8faa0 <= iVar10) {
                  iVar10 = 0;
                }
              }
              fVar11 = fVar11 * (float10)_DAT_006f75f8;
              dStack_5c = (double)fVar11;
              if (fVar11 <= (float10)_DAT_006ea4b0) {
                fVar12 = (float10)1.442695040888963 * fVar11 * fVar11 * (float10)_DAT_006ea4b8;
                fVar11 = ROUND(fVar12);
                fVar12 = (float10)f2xm1(fVar12 - fVar11);
                fVar11 = (float10)fscale((float10)1 + fVar12,fVar11);
                fVar11 = fVar11 * (float10)_DAT_006ea668;
              }
              else {
                local_54 = (double)(*(float *)(param_1 + 0x18 + iVar10 * 0x1c) *
                                   (float)_DAT_006f75f0);
                fVar11 = (float10)FUN_0050a160();
                fStack_68 = (float)fVar11;
                fVar11 = (float10)FUN_0050a160();
                fVar12 = (float10)1.442695040888963 *
                         -(((float10)local_54 / (fVar11 * (float10)fStack_68)) * (float10)dStack_5c
                          * (float10)dStack_5c);
                fVar11 = ROUND(fVar12);
                fVar12 = (float10)f2xm1(fVar12 - fVar11);
                fVar11 = (float10)fscale((float10)1 + fVar12,fVar11);
                fVar11 = (float10)_DAT_006e9808 - fVar11 * (float10)_DAT_006ea668;
              }
              if (fVar11 < (float10)_DAT_006ea4b0 == (NAN(fVar11) || NAN((float10)_DAT_006ea4b0))) {
                if ((float10)_DAT_006e9808 < fVar11) {
                  fVar11 = (float10)_DAT_006e9808;
                }
              }
              else {
                fVar11 = (float10)_DAT_006ea4b0;
              }
              *(double *)(iStack_64 + (int)pdStack_6c) = (double)fVar11;
              pdVar6 = pdStack_6c + 1;
              iStack_7c = iStack_7c + 1;
              *pdStack_6c = (double)fStack_70;
              pfStack_78 = pfStack_78 + 7;
              pdStack_6c = pdVar6;
            } while (iStack_7c < DAT_00b8faa0);
          }
          *(double **)(iVar3 + 0x1c) = pdVar9;
          *(uint *)(iVar3 + 0x20) = uVar7;
          *(undefined4 *)(iVar3 + 0x24) = 0x40000000;
          *(undefined4 *)(iVar3 + 0x28) = 0x3fd33333;
          *(undefined4 *)(iVar3 + 0x2c) = 0x40000000;
          *(undefined4 *)(iVar3 + 0x30) = 0x3fd33333;
          *(double *)(iVar3 + 0x14) = (double)_DAT_006f75d0;
          iVar4 = DAT_00b8faa0;
          *(undefined4 *)(iVar3 + 0x10) = uStack_60;
          *(int *)(iVar3 + 0xc) = iVar4;
          if (*(int *)(param_3 + 0x28) != 0) {
            FUN_005cff12(*(int *)(param_3 + 0x28));
          }
          *(int *)(param_3 + 0x28) = iVar3;
          return 1;
        }
        FUN_005cfccc(pdVar9);
      }
      if (param_2 != 0) {
        FUN_005cfccc(param_2);
      }
      FUN_005cff12(piVar2);
    }
    FUN_005cff12(piVar2);
  }
  return 0;
}

