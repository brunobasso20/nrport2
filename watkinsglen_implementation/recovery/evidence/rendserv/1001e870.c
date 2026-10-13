/* FUN_1001e870 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_1001e870(void *this,int param_1)

{
  void *this_00;
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  success sVar5;
  uint uVar6;
  int *piVar7;
  int **ppiVar8;
  float *pfVar9;
  int iVar10;
  int iVar11;
  float10 fVar12;
  float10 extraout_ST0;
  float10 fVar13;
  longlong lVar14;
  int *local_114;
  undefined4 *local_110;
  int local_10c;
  int local_108;
  float local_104;
  int local_100;
  int local_fc;
  float local_f8;
  int local_f4;
  int local_f0;
  int local_ec;
  int local_e8;
  float local_e4;
  int local_e0;
  int local_dc;
  int local_d8;
  int local_d4;
  int local_d0;
  int local_cc;
  int local_c8;
  undefined local_c4 [4];
  int local_c0;
  int *local_bc;
  int local_b8;
  int local_b0;
  int *local_ac;
  int local_a8;
  undefined4 local_a0 [3];
  ProfileValue *local_94;
  undefined local_80 [4];
  int local_7c;
  int *local_78;
  int local_74;
  int local_6c;
  int *local_68;
  int local_64;
  int local_5c;
  int *local_58;
  int local_54;
  int local_4c;
  int *local_48;
  int local_44;
  int local_3c;
  int *local_38;
  int local_34;
  int local_24 [3];
  void *local_18;

  local_d8 = *(int *)(param_1 + 0x56);
  iVar4 = *(int *)(param_1 + 0x52);
  iVar11 = 0;
  if (0 < *(int *)(param_1 + 0x46)) {
    do {
      FUN_1001e7b0(*(int *)(*(int *)(iVar4 + iVar11 * 4) + 0x21));
      iVar11 = iVar11 + 1;
    } while (iVar11 < *(int *)(param_1 + 0x46));
  }
  local_110 = (undefined4 *)0x0;
  if (0 < *(int *)(param_1 + 0x4a)) {
    do {
      local_ec = 0;
      iVar4 = *(int *)(local_d8 + (int)local_110 * 4);
      if (0 < *(int *)(iVar4 + 0x59)) {
        local_108 = 0x14;
        do {
          iVar10 = 5;
          iVar11 = local_108;
          do {
            FUN_1001e7b0(*(int *)(*(int *)(iVar4 + 0x5d) + iVar11));
            iVar11 = iVar11 + 4;
            iVar10 = iVar10 + -1;
          } while (iVar10 != 0);
          local_ec = local_ec + 1;
          local_108 = local_108 + 0x53a;
        } while (local_ec < *(int *)(iVar4 + 0x59));
      }
      local_110 = (undefined4 *)((int)local_110 + 1);
    } while ((int)local_110 < *(int *)(param_1 + 0x4a));
  }
  FUN_1001fc90(local_c4,param_1,*(int *)(param_1 + 0x4e),*(int *)(param_1 + 0x42),
               *(int *)(param_1 + 0x52),*(int *)(param_1 + 0x46));
  iVar4 = FUN_1001fe40(local_c4);
  if (iVar4 != 0) {
    FUN_10020950(local_80,param_1,*(int *)(param_1 + 0x4e),*(int *)(param_1 + 0x42),
                 *(int *)(param_1 + 0x56),*(int *)(param_1 + 0x4a));
    iVar4 = FUN_10020bf0(local_80);
    iVar11 = 0;
    if (iVar4 != 0) {
      *(undefined4 *)((int)this + 0x10) = 0;
      iVar4 = FUN_10021db0((int)local_80);
      iVar10 = FUN_100208f0((int)local_c4);
      sVar5 = _memAlloc(&local_114,(iVar4 + iVar10) * 4);
      uVar6 = -(uint)(sVar5 != 0) & (uint)local_114;
      *(uint *)((int)this + 0x14) = uVar6;
      if (uVar6 != 0) {
        FUN_10020900(local_c4,&local_fc);
        FUN_10020910(local_c4,&local_dc);
        for (; local_fc != local_dc; local_fc = *(int *)(local_fc + 4)) {
          *(undefined4 *)(*(int *)((int)this + 0x14) + *(int *)((int)this + 0x10) * 4) =
               *(undefined4 *)(local_fc + 8);
          *(int *)((int)this + 0x10) = *(int *)((int)this + 0x10) + 1;
        }
        piVar7 = (int *)FUN_10021dc0(local_80,&local_114);
        local_fc = *piVar7;
        piVar7 = (int *)FUN_10021dd0(local_80,(int *)&local_114);
        local_dc = *piVar7;
        for (; local_fc != local_dc; local_fc = *(int *)(local_fc + 4)) {
          *(undefined4 *)(*(int *)((int)this + 0x14) + *(int *)((int)this + 0x10) * 4) =
               *(undefined4 *)(local_fc + 8);
          *(int *)((int)this + 0x10) = *(int *)((int)this + 0x10) + 1;
        }
        *(undefined4 *)((int)this + 0x18) = 0;
        *(undefined4 *)((int)this + 0x20) = 0;
        *(undefined4 *)((int)this + 0x28) = 0;
        *(undefined4 *)((int)this + 0x30) = 0;
        *(undefined4 *)((int)this + 0x38) = 0;
        iVar4 = FUN_10020920((int)local_c4);
        sVar5 = _memAlloc(&local_114,iVar4 << 2);
        uVar6 = -(uint)(sVar5 != 0) & (uint)local_114;
        *(uint *)((int)this + 0x1c) = uVar6;
        if (uVar6 != 0) {
          FUN_10020930(local_c4,&local_10c);
          FUN_10020940(local_c4,&local_f0);
          for (; local_10c != local_f0; local_10c = *(int *)(local_10c + 4)) {
            *(undefined4 *)(*(int *)((int)this + 0x1c) + *(int *)((int)this + 0x18) * 4) =
                 *(undefined4 *)(local_10c + 8);
            *(int *)((int)this + 0x18) = *(int *)((int)this + 0x18) + 1;
          }
          iVar4 = FUN_10021de0((int)local_80);
          sVar5 = _memAlloc(&local_114,iVar4 << 2);
          *(uint *)((int)this + 0x24) = -(uint)(sVar5 != 0) & (uint)local_114;
          iVar4 = FUN_10021e10((int)local_80);
          sVar5 = _memAlloc(&local_114,iVar4 << 2);
          *(uint *)((int)this + 0x2c) = -(uint)(sVar5 != 0) & (uint)local_114;
          iVar4 = FUN_10021e40((int)local_80);
          sVar5 = _memAlloc(&local_114,iVar4 << 2);
          *(uint *)((int)this + 0x34) = -(uint)(sVar5 != 0) & (uint)local_114;
          iVar4 = FUN_10021e70((int)local_80);
          sVar5 = _memAlloc(&local_114,iVar4 << 2);
          uVar6 = -(uint)(sVar5 != 0) & (uint)local_114;
          *(uint *)((int)this + 0x3c) = uVar6;
          if ((((*(int *)((int)this + 0x24) != 0) && (*(int *)((int)this + 0x2c) != 0)) &&
              (*(int *)((int)this + 0x34) != 0)) && (uVar6 != 0)) {
            piVar7 = (int *)FUN_10021df0(local_80,&local_114);
            local_10c = *piVar7;
            piVar7 = (int *)FUN_10021e00(local_80,(int *)&local_114);
            local_f0 = *piVar7;
            for (; local_10c != local_f0; local_10c = *(int *)(local_10c + 4)) {
              *(undefined4 *)(*(int *)((int)this + 0x24) + *(int *)((int)this + 0x20) * 4) =
                   *(undefined4 *)(local_10c + 8);
              *(int *)((int)this + 0x20) = *(int *)((int)this + 0x20) + 1;
            }
            piVar7 = (int *)FUN_10021e20(local_80,&local_114);
            local_10c = *piVar7;
            piVar7 = (int *)FUN_10021e30(local_80,(int *)&local_114);
            local_f0 = *piVar7;
            for (; local_10c != local_f0; local_10c = *(int *)(local_10c + 4)) {
              *(undefined4 *)(*(int *)((int)this + 0x2c) + *(int *)((int)this + 0x28) * 4) =
                   *(undefined4 *)(local_10c + 8);
              *(int *)((int)this + 0x28) = *(int *)((int)this + 0x28) + 1;
            }
            FUN_10021e50(local_80,&local_100);
            FUN_10021e60(local_80,&local_e0);
            for (; local_100 != local_e0; local_100 = *(int *)(local_100 + 4)) {
              *(undefined4 *)(*(int *)((int)this + 0x34) + *(int *)((int)this + 0x30) * 4) =
                   *(undefined4 *)(local_100 + 8);
              *(int *)((int)this + 0x30) = *(int *)((int)this + 0x30) + 1;
            }
            piVar7 = (int *)FUN_10021e80(local_80,&local_114);
            local_100 = *piVar7;
            piVar7 = (int *)FUN_10021e90(local_80,(int *)&local_114);
            local_e0 = *piVar7;
            for (; local_100 != local_e0; local_100 = *(int *)(local_100 + 4)) {
              *(undefined4 *)(*(int *)((int)this + 0x3c) + *(int *)((int)this + 0x38) * 4) =
                   *(undefined4 *)(local_100 + 8);
              *(int *)((int)this + 0x38) = *(int *)((int)this + 0x38) + 1;
            }
            if (0 < *(int *)((int)this + 0x10)) {
              this_00 = (void *)((int)this + 0x40);
              do {
                iVar4 = *(int *)(*(int *)((int)this + 0x14) + iVar11 * 4);
                fVar1 = _DAT_100341f0 / *(float *)(iVar4 + 0x164);
                FUN_10013510(this_00,*(float *)(iVar4 + 0x158) * fVar1,
                             *(float *)(iVar4 + 0x15c) * fVar1,*(float *)(iVar4 + 0x160) * fVar1);
                fVar1 = _DAT_100341f0 / *(float *)(iVar4 + 0x174);
                FUN_10013510(this_00,*(float *)(iVar4 + 0x168) * fVar1,
                             *(float *)(iVar4 + 0x16c) * fVar1,*(float *)(iVar4 + 0x170) * fVar1);
                fVar1 = _DAT_100341f0 / *(float *)(iVar4 + 0x184);
                FUN_10013510(this_00,*(float *)(iVar4 + 0x178) * fVar1,
                             *(float *)(iVar4 + 0x17c) * fVar1,*(float *)(iVar4 + 0x180) * fVar1);
                fVar1 = _DAT_100341f0 / *(float *)(iVar4 + 0x194);
                FUN_10013510(this_00,*(float *)(iVar4 + 0x188) * fVar1,
                             *(float *)(iVar4 + 0x18c) * fVar1,*(float *)(iVar4 + 400) * fVar1);
                iVar11 = iVar11 + 1;
              } while (iVar11 < *(int *)((int)this + 0x10));
            }
            iVar11 = 0;
            fVar1 = (*(float *)((int)this + 0x4c) + *(float *)((int)this + 0x40)) * _DAT_10034378;
            iVar4 = *(int *)(param_1 + 0x42);
            local_104 = 0.0;
            *(float *)((int)this + 0x84) = fVar1;
            fVar2 = (*(float *)((int)this + 0x50) + *(float *)((int)this + 0x44)) * _DAT_10034378;
            *(float *)((int)this + 0x88) = fVar2;
            fVar3 = (*(float *)((int)this + 0x54) + *(float *)((int)this + 0x48)) * _DAT_10034378;
            *(float *)((int)this + 0x8c) = fVar3;
            local_110 = (undefined4 *)(fVar1 - *(float *)((int)this + 0x40));
            fVar2 = fVar2 - *(float *)((int)this + 0x44);
            fVar3 = fVar3 - *(float *)((int)this + 0x48);
            local_114 = (int *)0x40000000;
            *(float *)((int)this + 0x6c) =
                 SQRT((float)local_110 * (float)local_110 + fVar2 * fVar2 + fVar3 * fVar3);
            fVar2 = (float)*(double *)(param_1 + 0x10) - (float)*(double *)(param_1 + 0x28);
            fVar1 = (float)*(double *)(param_1 + 0x18) - (float)*(double *)(param_1 + 0x30);
            local_e4 = SQRT(fVar2 * fVar2 + fVar1 * fVar1);
            if (0 < iVar4) {
              piVar7 = *(int **)(param_1 + 0x4e);
              do {
                iVar10 = *piVar7;
                fVar13 = (float10)fpatan((float10)*(double *)(iVar10 + 0x25) -
                                         (float10)*(double *)(iVar10 + 0x15),(float10)local_e4);
                fVar13 = ABS(((float10)*(float *)(iVar10 + 0x1d) - fVar13) -
                             ((float10)*(float *)(iVar10 + 0x2d) - fVar13));
                if ((float10)_DAT_100349c0 < fVar13) {
                  fVar13 = (float10)_DAT_100353b8 - fVar13;
                }
                fVar12 = (float10)fsin((float10)_DAT_10034380 * fVar13);
                fVar12 = ABS(fVar12);
                if ((float10)_DAT_100353d0 < fVar12) {
                  fVar12 = (float10)local_e4 / (fVar12 + fVar12);
                  fVar13 = (float10)fcos(fVar13 * (float10)_DAT_10034378);
                  fVar12 = fVar12 - fVar13 * fVar12;
                  if (fVar12 < (float10)local_104) {
                    fVar12 = (float10)local_104;
                  }
                  local_104 = (float)fVar12;
                }
                piVar7 = piVar7 + 1;
                iVar4 = iVar4 + -1;
              } while (iVar4 != 0);
            }
            iVar4 = 0;
            if (0 < *(int *)((int)this + 0x10)) {
              do {
                iVar10 = FUN_1001fb40(*(void **)(*(int *)((int)this + 0x14) + iVar4 * 4),
                                      DAT_10035334,DAT_1003533c,&local_104);
                if (iVar11 <= iVar10) {
                  iVar11 = iVar10;
                }
                iVar4 = iVar4 + 1;
              } while (iVar4 < *(int *)((int)this + 0x10));
            }
            local_104 = local_104 * _DAT_10035340;
            local_e8 = iVar11 + -1;
            lVar14 = __ftol();
            iVar4 = (int)lVar14 + 1;
            local_f8 = ABS((float)*(double *)(param_1 + 0x20) - (float)*(double *)(param_1 + 0x38));
            if ((float)_DAT_100349c0 < local_f8) {
              local_f8 = (float)_DAT_100353b8 - local_f8;
            }
            iVar11 = 1;
            fVar13 = (float10)fsin((float10)local_f8 * (float10)_DAT_10034380);
            local_110 = (undefined4 *)(float)ABS(fVar13);
            if ((float)_DAT_100353d0 < (float)local_110) {
              local_e8 = 2;
              local_110 = (undefined4 *)(local_e4 / ((float)local_110 + (float)local_110));
              local_e4 = (float)local_110 * local_f8;
              fVar13 = (float10)fcos((float10)local_f8 * (float10)_DAT_10034378);
              fVar13 = (float10)(float)local_110 - fVar13 * (float10)(float)local_110;
              do {
                if (fVar13 <= (float10)DAT_10035334) break;
                fVar13 = (float10)local_e8;
                local_e8 = local_e8 + 2;
                iVar11 = iVar11 + 1;
                fVar13 = (float10)fcos((float10)local_f8 / fVar13);
                fVar13 = (float10)(float)local_110 - fVar13 * (float10)(float)local_110;
              } while (local_e8 < 0x80);
            }
            if (iVar4 <= iVar11) {
              iVar4 = iVar11;
            }
            lVar14 = __ftol();
            iVar11 = (int)lVar14;
            if (iVar4 < (int)lVar14) {
              iVar11 = iVar4;
            }
            *(int *)((int)this + 0x78) = iVar11;
            if (iVar11 < 1) {
              iVar11 = 1;
            }
            *(int *)((int)this + 0x78) = iVar11;
            if (0x3e < iVar11) {
              iVar11 = 0x3e;
            }
            *(int *)((int)this + 0x78) = iVar11;
            fVar13 = extraout_ST0;
            if (extraout_ST0 <= (float10)local_104) {
              fVar13 = (float10)local_104;
            }
            if ((float10)_DAT_100353c8 <= fVar13 / (float10)_DAT_10035344) {
              local_114 = (int *)(float)(fVar13 / (float10)_DAT_10035344);
            }
            *(undefined4 *)((int)this + 0x74) = 0;
            *(float *)((int)this + 0x70) = _DAT_100341f0 / SQRT((float)local_114);
            if (local_18 != (void *)0x0) {
              FUN_100234e0(local_24);
            }
            local_18 = (void *)0x0;
            local_24[0] = 0;
            FUN_10023d70(&local_3c);
            FUN_10023d70(&local_4c);
            FUN_10023d70(&local_5c);
            FUN_10023d70(&local_6c);
            FUN_10023620(&local_7c,(int *)&local_114);
            if (local_114 != &local_7c) {
              do {
                ppiVar8 = (int **)FUN_100233d0(&local_7c,&local_e8,local_114);
                local_114 = *ppiVar8;
              } while (local_114 != &local_7c);
            }
            if (local_94 != (ProfileValue *)0x0) {
              FUN_10023c40(local_a0,local_94);
            }
            local_94 = (ProfileValue *)0x0;
            local_a0[0] = 0;
            FUN_10023d70(&local_b0);
            FUN_10023620(&local_c0,(int *)&local_110);
            pfVar9 = (float *)FUN_100233b0(&local_c0,&local_114);
            if (local_110 != (undefined4 *)*pfVar9) {
              do {
                piVar7 = FUN_100233d0(&local_c0,&local_e8,local_110);
                local_110 = (undefined4 *)*piVar7;
                piVar7 = FUN_100233b0(&local_c0,&local_114);
              } while (local_110 != (undefined4 *)*piVar7);
            }
            return 1;
          }
        }
        if (*(void **)((int)this + 0x14) != (void *)0x0) {
          _memFree(*(void **)((int)this + 0x14));
        }
        *(undefined4 *)((int)this + 0x14) = 0;
        *(undefined4 *)((int)this + 0x10) = 0;
      }
      FUN_10021df0(local_80,&local_f4);
      FUN_10021e00(local_80,&local_108);
      if (local_f4 != local_108) {
        do {
          ppiVar8 = *(int ***)(local_f4 + 8);
          if (ppiVar8 != (int **)0x0) {
            FUN_1001fbf0(ppiVar8);
            _memFree(ppiVar8);
          }
          local_f4 = *(int *)(local_f4 + 4);
        } while (local_f4 != local_108);
      }
      piVar7 = (int *)FUN_10021e20(local_80,&local_114);
      local_f4 = *piVar7;
      piVar7 = (int *)FUN_10021e30(local_80,(int *)&local_114);
      iVar4 = *piVar7;
      local_108 = iVar4;
      if (local_f4 != iVar4) {
        do {
          ppiVar8 = *(int ***)(local_f4 + 8);
          if (ppiVar8 != (int **)0x0) {
            FUN_1001fbf0(ppiVar8);
            _memFree(ppiVar8);
            iVar4 = local_108;
          }
          local_f4 = *(int *)(local_f4 + 4);
        } while (local_f4 != iVar4);
      }
      FUN_10021dc0(local_80,&local_d4);
      FUN_10021dd0(local_80,&local_cc);
      if (local_d4 != local_cc) {
        do {
          if (*(void **)(local_d4 + 8) != (void *)0x0) {
            _memFree(*(void **)(local_d4 + 8));
          }
          local_d4 = *(int *)(local_d4 + 4);
        } while (local_d4 != local_cc);
      }
    }
    FUN_10020930(local_c4,&local_d0);
    FUN_10020940(local_c4,&local_c8);
    if (local_d0 != local_c8) {
      do {
        ppiVar8 = *(int ***)(local_d0 + 8);
        if (ppiVar8 != (int **)0x0) {
          FUN_1001fbf0(ppiVar8);
          _memFree(ppiVar8);
        }
        local_d0 = *(int *)(local_d0 + 4);
      } while (local_d0 != local_c8);
    }
    FUN_10020900(local_c4,&local_ec);
    FUN_10020910(local_c4,&local_d8);
    if (local_ec != local_d8) {
      do {
        if (*(void **)(local_ec + 8) != (void *)0x0) {
          _memFree(*(void **)(local_ec + 8));
        }
        local_ec = *(int *)(local_ec + 4);
      } while (local_ec != local_d8);
    }
    if (local_18 != (void *)0x0) {
      if (*(ProfileValue **)((int)local_18 + 8) != (ProfileValue *)0x0) {
        FUN_10023c40(local_24,*(ProfileValue **)((int)local_18 + 8));
      }
      *(undefined4 *)((int)local_18 + 8) = 0;
      if (*(ProfileValue **)((int)local_18 + 0xc) != (ProfileValue *)0x0) {
        FUN_10023c40(local_24,*(ProfileValue **)((int)local_18 + 0xc));
      }
      *(undefined4 *)((int)local_18 + 0xc) = 0;
      FUN_10023eb0();
      FUN_10023eb0();
      _memFree(local_18);
    }
    local_18 = (void *)0x0;
    local_24[0] = 0;
    if (local_38 != &local_3c) {
      do {
        if ((local_38 != &local_3c) && (local_34 != 0)) {
          piVar7 = (int *)local_38[1];
          *(int **)(*local_38 + 4) = piVar7;
          *(int *)local_38[1] = *local_38;
          local_38[1] = 0;
          *local_38 = 0;
          _memFree(local_38);
          local_34 = local_34 + -1;
          local_38 = piVar7;
        }
      } while (local_38 != &local_3c);
    }
    if (local_48 != &local_4c) {
      do {
        if ((local_48 != &local_4c) && (local_44 != 0)) {
          piVar7 = (int *)local_48[1];
          *(int **)(*local_48 + 4) = piVar7;
          *(int *)local_48[1] = *local_48;
          local_48[1] = 0;
          *local_48 = 0;
          _memFree(local_48);
          local_44 = local_44 + -1;
          local_48 = piVar7;
        }
      } while (local_48 != &local_4c);
    }
    if (local_58 != &local_5c) {
      do {
        if ((local_58 != &local_5c) && (local_54 != 0)) {
          piVar7 = (int *)local_58[1];
          *(int **)(*local_58 + 4) = piVar7;
          *(int *)local_58[1] = *local_58;
          local_58[1] = 0;
          *local_58 = 0;
          _memFree(local_58);
          local_54 = local_54 + -1;
          local_58 = piVar7;
        }
      } while (local_58 != &local_5c);
    }
    if (local_68 != &local_6c) {
      do {
        if ((local_68 != &local_6c) && (local_64 != 0)) {
          piVar7 = (int *)local_68[1];
          *(int **)(*local_68 + 4) = piVar7;
          *(int *)local_68[1] = *local_68;
          local_68[1] = 0;
          *local_68 = 0;
          _memFree(local_68);
          local_64 = local_64 + -1;
          local_68 = piVar7;
        }
      } while (local_68 != &local_6c);
    }
    if (local_78 != &local_7c) {
      do {
        if ((local_78 != &local_7c) && (local_74 != 0)) {
          piVar7 = (int *)local_78[1];
          *(int **)(*local_78 + 4) = piVar7;
          *(int *)local_78[1] = *local_78;
          local_78[1] = 0;
          *local_78 = 0;
          _memFree(local_78);
          local_74 = local_74 + -1;
          local_78 = piVar7;
        }
      } while (local_78 != &local_7c);
    }
  }
  if (local_94 != (ProfileValue *)0x0) {
    if (*(ProfileValue **)(local_94 + 8) != (ProfileValue *)0x0) {
      FUN_10023c40(local_a0,*(ProfileValue **)(local_94 + 8));
    }
    *(undefined4 *)(local_94 + 8) = 0;
    if (*(ProfileValue **)(local_94 + 0xc) != (ProfileValue *)0x0) {
      FUN_10023c40(local_a0,*(ProfileValue **)(local_94 + 0xc));
    }
    *(undefined4 *)(local_94 + 0xc) = 0;
    FUN_10023eb0();
    if ((DAT_1005726d & 1) == 0) {
      DAT_1005726d = DAT_1005726d | 1;
      FUN_10023140(&DAT_1005729c);
      FUN_100291e7((int *)FUN_10023f00);
    }
    _memFree(local_94);
  }
  local_94 = (ProfileValue *)0x0;
  local_a0[0] = 0;
  if (local_ac != &local_b0) {
    do {
      if ((local_ac != &local_b0) && (local_a8 != 0)) {
        piVar7 = (int *)local_ac[1];
        *(int **)(*local_ac + 4) = piVar7;
        *(int *)local_ac[1] = *local_ac;
        local_ac[1] = 0;
        *local_ac = 0;
        _memFree(local_ac);
        local_a8 = local_a8 + -1;
        local_ac = piVar7;
      }
    } while (local_ac != &local_b0);
  }
  if (local_bc != &local_c0) {
    do {
      if ((local_bc != &local_c0) && (local_b8 != 0)) {
        piVar7 = (int *)local_bc[1];
        *(int **)(*local_bc + 4) = piVar7;
        *(int *)local_bc[1] = *local_bc;
        local_bc[1] = 0;
        *local_bc = 0;
        _memFree(local_bc);
        local_b8 = local_b8 + -1;
        local_bc = piVar7;
      }
    } while (local_bc != &local_c0);
  }
  return 0;
}
