/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f4cc0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f4cc0(uint param_1,int param_2,int param_3,float *param_4,int param_5,float *param_6)

{
  float fVar1;
  double dVar2;
  double dVar3;
  int iVar4;
  undefined4 uVar5;
  float *pfVar6;
  float *pfVar7;
  float *pfVar8;
  float *pfVar9;
  uint uVar10;
  uint uVar11;
  float10 fVar12;
  float10 fVar13;
  float10 fVar14;
  float10 fVar15;
  float10 fVar16;
  float10 fVar18;
  float10 fVar19;
  float *local_78;
  float *local_74;
  uint local_68;
  uint local_64;
  undefined4 uStack_5c;
  ulonglong local_40;
  double local_30;
  double local_10;
  float10 fVar17;
  
  uStack_5c = 0x401921fb;
  iVar4 = FUN_005f4fc0(param_1);
  if (iVar4 == 0) {
    FUN_006c74c4(&DAT_0075ccd0,s_Error_in_fft____NumSamples__u_is_00755444,param_1);
    FUN_006c7abf(1);
  }
  if (param_2 != 0) {
    uStack_5c = 0xc01921fb;
  }
  FUN_005f4f90(param_3,s_RealIn_00755478);
  FUN_005f4f90(param_5,s_RealOut_00755480);
  FUN_005f4f90(param_6,s_ImagOut_00755488);
  uVar5 = FUN_005f4fe0(param_1);
  uVar10 = 0;
  if (param_1 != 0) {
    local_78 = param_4;
    do {
      iVar4 = FUN_005f5020(uVar10,uVar5);
      *(undefined4 *)(param_5 + iVar4 * 4) =
           *(undefined4 *)((param_3 - (int)param_4) + (int)local_78);
      if (param_4 == (float *)0x0) {
        fVar1 = (float)_DAT_006ea4b0;
      }
      else {
        fVar1 = *local_78;
      }
      uVar10 = uVar10 + 1;
      param_6[iVar4] = fVar1;
      local_78 = local_78 + 1;
    } while (uVar10 < param_1);
  }
  local_68 = 1;
  local_64 = 2;
  if (1 < param_1) {
    do {
      fVar12 = (float10)(double)CONCAT44(uStack_5c,0x54442d18) / (float10)local_64;
      fVar13 = (float10)_DAT_006f8b60 * fVar12;
      fVar14 = (float10)fsin(fVar13);
      fVar12 = -fVar12;
      fVar15 = (float10)fsin(fVar12);
      fVar13 = (float10)fcos(fVar13);
      fVar12 = (float10)fcos((float10)(double)fVar12);
      uVar10 = 0;
      if (param_1 != 0) {
        local_74 = param_6 + local_68;
        local_78 = param_6;
        do {
          if (local_68 != 0) {
            iVar4 = param_5 - (int)param_6;
            pfVar6 = local_74;
            pfVar8 = local_78;
            uVar11 = local_68;
            fVar19 = fVar12;
            dVar3 = (double)fVar14;
            fVar16 = fVar13;
            fVar18 = fVar15;
            do {
              fVar17 = fVar19;
              local_30 = (double)fVar18;
              local_10 = (double)fVar16;
              pfVar7 = pfVar6 + 1;
              pfVar9 = pfVar8 + 1;
              uVar11 = uVar11 - 1;
              dVar2 = (double)(fVar17 * (fVar12 + fVar12) - (float10)local_10);
              fVar18 = (float10)local_30 * (fVar12 + fVar12) - (float10)dVar3;
              fVar19 = (float10)*(float *)(iVar4 + -4 + (int)pfVar7) * (float10)dVar2 -
                       (float10)*pfVar6 * fVar18;
              fVar1 = (float)((float10)*(float *)(iVar4 + -4 + (int)pfVar7) * fVar18 +
                             (float10)*pfVar6 * (float10)dVar2);
              *(float *)(iVar4 + -4 + (int)pfVar7) =
                   (float)((float10)*(float *)(iVar4 + -4 + (int)pfVar9) - fVar19);
              *pfVar6 = *pfVar8 - fVar1;
              *(float *)(iVar4 + -4 + (int)pfVar9) =
                   (float)((float10)*(float *)(iVar4 + -4 + (int)pfVar9) + fVar19);
              *pfVar8 = *pfVar8 + fVar1;
              pfVar6 = pfVar7;
              pfVar8 = pfVar9;
              fVar19 = (float10)dVar2;
              dVar3 = local_30;
              fVar16 = fVar17;
            } while (uVar11 != 0);
          }
          uVar10 = uVar10 + local_64;
          local_78 = local_78 + local_64;
          local_74 = local_74 + local_64;
        } while (uVar10 < param_1);
      }
      uVar10 = local_64 * 2;
      local_68 = local_64;
      local_64 = uVar10;
    } while (uVar10 <= param_1);
  }
  if (param_2 != 0) {
    local_40 = (ulonglong)param_1;
    if (param_1 != 0) {
      fVar13 = (float10)_DAT_006e9808;
      param_5 = param_5 - (int)param_6;
      do {
        *(float *)((int)param_6 + param_5) =
             (float)((float10)*(float *)((int)param_6 + param_5) * (fVar13 / (float10)local_40));
        *param_6 = (float)((float10)*param_6 * (fVar13 / (float10)local_40));
        param_6 = param_6 + 1;
        param_1 = param_1 - 1;
      } while (param_1 != 0);
    }
  }
  return;
}


