/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00467180 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00467180(int *param_1,int param_2)

{
  int iVar1;
  int iVar2;
  uint uVar3;
  uint uVar4;
  float *pfVar5;
  float unaff_EBX;
  float unaff_EBP;
  int *unaff_ESI;
  int *piVar6;
  int unaff_EDI;
  uint uVar7;
  float10 fVar8;
  undefined4 uVar9;
  undefined4 *puStack_274;
  float fStack_26c;
  int *piStack_268;
  float *pfStack_264;
  char ****ppppcStack_260;
  int **ppiStack_25c;
  undefined4 uStack_258;
  float *pfStack_254;
  float fStack_250;
  float fStack_24c;
  int *piStack_248;
  float afStack_244 [2];
  int **ppiStack_23c;
  undefined1 ***pppuStack_238;
  char ***pppcStack_234;
  undefined4 uStack_230;
  char *pcStack_22c;
  int *piStack_228;
  float fStack_224;
  char **ppcStack_220;
  int *piStack_21c;
  undefined4 uStack_218;
  char ***pppcStack_214;
  char **ppcStack_210;
  undefined1 **ppuStack_20c;
  undefined4 *puStack_208;
  undefined1 **ppuStack_204;
  char **ppcStack_200;
  float **ppfStack_1fc;
  undefined1 **ppuStack_1f8;
  char **ppcStack_1f4;
  float **ppfStack_1f0;
  undefined1 **ppuStack_1ec;
  char **ppcStack_1e8;
  float **ppfStack_1e4;
  undefined1 **ppuStack_1e0;
  char **ppcStack_1dc;
  float **ppfStack_1d8;
  int *piStack_1d4;
  int *piStack_1d0;
  undefined1 *puStack_1cc;
  undefined1 *puStack_1c8;
  char *pcStack_1c4;
  float ***pppfStack_1c0;
  int *piStack_1bc;
  float ***pppfStack_1b8;
  char *pcStack_1b4;
  char **ppcStack_1b0;
  int *piStack_1ac;
  char **ppcStack_1a8;
  char *pcStack_1a4;
  char **ppcStack_1a0;
  char *pcStack_19c;
  float **ppfStack_198;
  char *pcStack_194;
  char **ppcStack_190;
  char *pcStack_18c;
  float **ppfStack_188;
  char *pcStack_184;
  int **ppiStack_180;
  char *pcStack_17c;
  float **ppfStack_178;
  undefined4 uStack_174;
  float **ppfStack_170;
  char *pcStack_16c;
  undefined1 *puStack_168;
  char *pcStack_164;
  float *pfStack_160;
  char *pcStack_15c;
  undefined4 *puStack_158;
  int *piStack_154;
  float *pfStack_150;
  int *piStack_14c;
  char **ppcStack_148;
  char *pcStack_144;
  float *pfStack_140;
  char *pcStack_13c;
  float *pfStack_138;
  char *pcStack_134;
  float *pfStack_130;
  char *pcStack_12c;
  undefined1 *puStack_128;
  char *pcStack_124;
  float *pfStack_120;
  char *pcStack_11c;
  float *pfStack_118;
  int *piStack_114;
  int *piStack_110;
  float fStack_fc;
  float fStack_f8;
  float fStack_f4;
  float fStack_f0;
  float fStack_ec;
  undefined1 auStack_e8 [8];
  undefined1 auStack_e0 [8];
  int aiStack_d8 [2];
  int aiStack_d0 [5];
  undefined4 uStack_bc;
  undefined1 auStack_b4 [12];
  undefined4 uStack_a8;
  float afStack_a0 [2];
  undefined4 uStack_98;
  uint local_94;
  int local_90;
  float afStack_8c [35];
  
  if (param_1 == (int *)0x0) {
    return;
  }
  if (param_2 == 0) {
    return;
  }
  uVar7 = 0;
  local_94 = 0;
  fStack_fc = (float)(uint)fStack_fc._0_2_;
  piVar6 = (int *)0x0;
  do {
    piStack_114 = (int *)param_2;
    pfStack_118 = (float *)0x4671c6;
    piStack_110 = piVar6;
    fVar8 = (float10)FUN_005486a0();
    afStack_8c[(int)piVar6] = (float)fVar8;
    if ((float10)_DAT_006ea454 < fVar8) {
      if (uVar7 == 0) {
        uVar7 = 1;
      }
      if ((fVar8 == (float10)_DAT_006ea4a0) && (uVar7 < 2)) {
        uVar7 = 2;
      }
    }
    piVar6 = (int *)((int)piVar6 + 1);
  } while ((int)piVar6 < 0xb);
  piStack_110 = &local_90;
  piStack_114 = (int *)s_chassis_damage_007355d0;
  pfStack_118 = (float *)0x467223;
  local_94 = uVar7;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    uStack_98 = 0;
  }
  pfStack_118 = afStack_a0;
  pcStack_11c = s_corners_damage_007355e0;
  pfStack_120 = (float *)0x46723e;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    uStack_a8 = 0;
  }
  pfStack_120 = &fStack_ec;
  pcStack_124 = s_grill_damage_007355f0;
  puStack_128 = (undefined1 *)0x467259;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    fStack_f4 = 0.0;
  }
  puStack_128 = auStack_b4;
  pcStack_12c = s_hood_damage_00735600;
  pfStack_130 = (float *)0x467274;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    uStack_bc = 0;
  }
  pfStack_130 = &fStack_f4;
  pcStack_134 = s_rend_damage_0073560c;
  pfStack_138 = (float *)0x46728f;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    fStack_fc = 0.0;
  }
  pfStack_138 = &fStack_f4;
  pcStack_13c = s_rf_removed_00735618;
  pfStack_140 = (float *)0x4672aa;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    fStack_fc = 0.0;
  }
  pfStack_140 = &fStack_f0;
  pcStack_144 = s_lf_removed_00735624;
  ppcStack_148 = (char **)0x4672c5;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    fStack_f8 = 0.0;
  }
  ppcStack_148 = &pcStack_11c;
  piStack_14c = (int *)s_rr_removed_00735630;
  pfStack_150 = (float *)0x4672e0;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    pcStack_124 = (char *)0x0;
  }
  pfStack_150 = &fStack_ec;
  piStack_154 = (int *)s_lr_removed_0073563c;
  puStack_158 = (undefined4 *)0x4672fb;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    fStack_f4 = 0.0;
  }
  puStack_158 = (undefined4 *)&stack0xfffffef4;
  pcStack_15c = s_grill_removed_00735648;
  pfStack_160 = (float *)0x467316;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    piStack_114 = (int *)0x0;
  }
  pfStack_160 = &fStack_f4;
  pcStack_164 = s_hood_removed_00735658;
  puStack_168 = (undefined1 *)0x467331;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    fStack_fc = 0.0;
  }
  puStack_168 = &stack0xffffff00;
  pcStack_16c = s_rend_removed_00735668;
  ppfStack_170 = (float **)0x46734c;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    unaff_ESI = (int *)0x0;
  }
  ppfStack_170 = &pfStack_140;
  uStack_174 = s_frontend_broken_00735678;
  ppfStack_178 = (float **)0x467367;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    ppcStack_148 = (char **)0x0;
  }
  ppfStack_178 = &pfStack_140;
  pcStack_17c = s_rearend_broken_00735688;
  ppiStack_180 = (int **)0x467382;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    ppcStack_148 = (char **)0x0;
  }
  ppiStack_180 = &piStack_110;
  pcStack_184 = s_damaged_00735698;
  ppfStack_188 = (float **)0x46739d;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    pfStack_118 = (float *)0x0;
  }
  if (unaff_EBX == _DAT_006ea4a0) {
    uStack_174._0_3_ = CONCAT12(1,(undefined2)uStack_174);
    if (pcStack_13c != (char *)0x0) {
      ppfStack_188 = (float **)0x3f800000;
      pcStack_18c = (char *)0x4673d0;
      (*(code *)**(undefined4 **)pcStack_13c)();
    }
    if (piStack_154 != (int *)0x0) {
      ppfStack_188 = (float **)0xff;
LAB_00467409:
      pcStack_18c = (char *)0x46740e;
      (**(code **)(*piStack_154 + 4))();
    }
  }
  else {
    ppfStack_188 = (float **)0x4673f1;
    uVar9 = FUN_006c5018();
    if (pcStack_13c != (char *)0x0) {
      ppfStack_188 = (float **)0x0;
      pcStack_18c = (char *)0x467400;
      (*(code *)**(undefined4 **)pcStack_13c)();
    }
    ppfStack_188 = (float **)uVar9;
    if (piStack_154 != (int *)0x0) goto LAB_00467409;
  }
  if (unaff_EBP == _DAT_006ea4a0) {
    uStack_174 = (char *)CONCAT13(1,(undefined3)uStack_174);
    if (pfStack_120 != (float *)0x0) {
      ppfStack_188 = (float **)0x3f800000;
      pcStack_18c = (char *)0x467438;
      (**(code **)*pfStack_120)();
    }
    if (piStack_14c != (int *)0x0) {
      ppfStack_188 = (float **)0xff;
LAB_00467471:
      pcStack_18c = (char *)0x467476;
      (**(code **)(*piStack_14c + 4))();
    }
  }
  else {
    ppfStack_188 = (float **)0x467459;
    uVar9 = FUN_006c5018();
    if (pfStack_120 != (float *)0x0) {
      ppfStack_188 = (float **)0x0;
      pcStack_18c = (char *)0x467468;
      (**(code **)*pfStack_120)();
    }
    ppfStack_188 = (float **)uVar9;
    if (piStack_14c != (int *)0x0) goto LAB_00467471;
  }
  if (fStack_fc == _DAT_006ea4a0) {
    uStack_174._0_3_ = CONCAT12(1,(undefined2)uStack_174);
    if (pfStack_138 != (float *)0x0) {
      ppfStack_188 = (float **)0x3f800000;
      pcStack_18c = (char *)0x4674a0;
      (**(code **)*pfStack_138)();
    }
    uVar7 = 0xff;
  }
  else {
    ppfStack_188 = (float **)0x4674b9;
    uVar7 = FUN_006c5018();
    if (pfStack_138 != (float *)0x0) {
      ppfStack_188 = (float **)0x0;
      pcStack_18c = (char *)0x4674c8;
      (**(code **)*pfStack_138)();
    }
  }
  if (fStack_f8 == _DAT_006ea4a0) {
    uStack_174._0_3_ = CONCAT12(1,(undefined2)uStack_174);
    if (pcStack_144 != (char *)0x0) {
      ppfStack_188 = (float **)0x3f800000;
      pcStack_18c = (char *)0x4674f4;
      (*(code *)**(undefined4 **)pcStack_144)();
    }
    uVar7 = uVar7 | 0xff00;
  }
  else {
    ppfStack_188 = (float **)0x46750e;
    iVar1 = FUN_006c5018();
    if (pcStack_144 != (char *)0x0) {
      ppfStack_188 = (float **)0x0;
      pcStack_18c = (char *)0x46751d;
      (*(code *)**(undefined4 **)pcStack_144)();
    }
    uVar7 = uVar7 | iVar1 << 8;
  }
  if (fStack_f4 == _DAT_006ea4a0) {
    uStack_174 = (char *)CONCAT13(1,(undefined3)uStack_174);
    if (pcStack_124 != (char *)0x0) {
      ppfStack_188 = (float **)0x3f800000;
      pcStack_18c = (char *)0x46754c;
      (*(code *)**(undefined4 **)pcStack_124)();
    }
    uVar7 = uVar7 | 0xff0000;
  }
  else {
    ppfStack_188 = (float **)0x467566;
    iVar1 = FUN_006c5018();
    if (pcStack_124 != (char *)0x0) {
      ppfStack_188 = (float **)0x0;
      pcStack_18c = (char *)0x467575;
      (*(code *)**(undefined4 **)pcStack_124)();
    }
    uVar7 = uVar7 | iVar1 << 0x10;
  }
  if (fStack_f0 == _DAT_006ea4a0) {
    uStack_174 = (char *)CONCAT13(1,(undefined3)uStack_174);
    if (pcStack_15c != (char *)0x0) {
      ppfStack_188 = (float **)0x3f800000;
      pcStack_18c = (char *)0x4675a4;
      (*(code *)**(undefined4 **)pcStack_15c)();
    }
    ppfStack_188 = (float **)(uVar7 | 0xff000000);
  }
  else {
    ppfStack_188 = (float **)0x4675be;
    iVar1 = FUN_006c5018();
    if (pcStack_15c != (char *)0x0) {
      ppfStack_188 = (float **)0x0;
      pcStack_18c = (char *)0x4675cd;
      (*(code *)**(undefined4 **)pcStack_15c)();
    }
    ppfStack_188 = (float **)(uVar7 | iVar1 << 0x18);
  }
  if (piStack_110 != (int *)0x0) {
    pcStack_18c = (char *)0x4675e0;
    (**(code **)(*piStack_110 + 4))();
  }
  if (fStack_ec == _DAT_006ea4a0) {
    uStack_174._0_3_ = CONCAT12(1,(undefined2)uStack_174);
    if (pcStack_11c != (char *)0x0) {
      ppfStack_188 = (float **)0x3f800000;
      pcStack_18c = (char *)0x46760a;
      (*(code *)**(undefined4 **)pcStack_11c)();
    }
    if (piStack_114 != (int *)0x0) {
      ppfStack_188 = (float **)0xff;
LAB_00467643:
      pcStack_18c = (char *)0x467648;
      (**(code **)(*piStack_114 + 4))();
    }
  }
  else {
    ppfStack_188 = (float **)0x46762b;
    uVar9 = FUN_006c5018();
    if (pcStack_11c != (char *)0x0) {
      ppfStack_188 = (float **)0x0;
      pcStack_18c = (char *)0x46763a;
      (*(code *)**(undefined4 **)pcStack_11c)();
    }
    ppfStack_188 = (float **)uVar9;
    if (piStack_114 != (int *)0x0) goto LAB_00467643;
  }
  if (unaff_ESI != (int *)0x0) {
    iVar1 = *unaff_ESI;
    ppfStack_188 = (float **)0x467664;
    iVar2 = FUN_006c5018();
    ppfStack_188 = (float **)0x46767b;
    uVar7 = FUN_006c5018();
    ppfStack_188 = (float **)0x467692;
    uVar3 = FUN_006c5018();
    ppfStack_188 = (float **)0x4676a9;
    uVar4 = FUN_006c5018();
    ppfStack_188 = (float **)(((iVar2 << 8 | uVar7) << 8 | uVar3) << 8 | uVar4);
    pcStack_18c = (char *)0x4676b1;
    (**(code **)(iVar1 + 4))();
  }
  pfVar5 = pfStack_118;
  if (unaff_EDI == 0) {
LAB_00467718:
    if (pfVar5 != (float *)0x0) {
      ppfStack_188 = (float **)0x0;
      pcStack_18c = (char *)0x467721;
      (**(code **)*pfVar5)();
    }
  }
  else {
    if (unaff_EDI != 1) {
      if (unaff_EDI != 2) goto LAB_00467721;
      if (pfStack_118 != (float *)0x0) {
        ppfStack_188 = (float **)0x40000000;
        pcStack_18c = (char *)0x4676d9;
        (**(code **)*pfStack_118)();
      }
      if (uStack_174._2_1_ == '\0') {
        if (puStack_158 != (undefined4 *)0x0) {
          ppfStack_188 = (float **)0x0;
          pcStack_18c = (char *)0x4676fd;
          (**(code **)*puStack_158)();
        }
      }
      else if (puStack_158 != (undefined4 *)0x0) {
        ppfStack_188 = (float **)0x3f800000;
        pcStack_18c = (char *)0x4676f2;
        (**(code **)*puStack_158)();
      }
      pfVar5 = pfStack_150;
      if (uStack_174._3_1_ == '\0') goto LAB_00467718;
    }
    if (pfVar5 != (float *)0x0) {
      ppfStack_188 = (float **)0x3f800000;
      pcStack_18c = (char *)0x467716;
      (**(code **)*pfVar5)();
    }
  }
LAB_00467721:
  ppfStack_188 = &pfStack_130;
  pcStack_18c = s_wheel_speed_0_007356a0;
  ppcStack_190 = (char **)0x467733;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    pfStack_138 = (float *)0x0;
  }
  ppcStack_190 = &pcStack_13c;
  pcStack_194 = s_wheel_speed_1_007356b0;
  ppfStack_198 = (float **)0x46774e;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    pcStack_144 = (char *)0x0;
  }
  ppfStack_198 = &pfStack_138;
  pcStack_19c = s_wheel_speed_2_007356c0;
  ppcStack_1a0 = (char **)0x467769;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    pfStack_140 = (float *)0x0;
  }
  ppcStack_1a0 = &pcStack_144;
  pcStack_1a4 = s_wheel_speed_3_007356d0;
  ppcStack_1a8 = (char **)0x467784;
  iVar1 = (**(code **)(*param_1 + 0x24))();
  if (iVar1 != 1) {
    piStack_14c = (int *)0x0;
  }
  ppcStack_1a8 = &pcStack_18c;
  piStack_1ac = (int *)s_lfwheel_007356e0;
  ppcStack_1b0 = (char **)0x46779f;
  iVar1 = (**(code **)(*param_1 + 0x1c))();
  if (iVar1 != 1) {
    pcStack_194 = (char *)0x0;
  }
  ppcStack_1b0 = &pcStack_18c;
  pcStack_1b4 = s_rfwheel_007356e8;
  pppfStack_1b8 = (float ***)0x4677ba;
  iVar1 = (**(code **)(*param_1 + 0x1c))();
  if (iVar1 != 1) {
    pcStack_194 = (char *)0x0;
  }
  pppfStack_1b8 = &ppfStack_198;
  piStack_1bc = (int *)s_lrwheel_007356f0;
  pppfStack_1c0 = (float ***)0x4677d5;
  iVar1 = (**(code **)(*param_1 + 0x1c))();
  if (iVar1 != 1) {
    ppcStack_1a0 = (char **)0x0;
  }
  pppfStack_1c0 = &ppfStack_198;
  pcStack_1c4 = s_rrwheel_007356f8;
  puStack_1c8 = (undefined1 *)0x4677f0;
  iVar1 = (**(code **)(*param_1 + 0x1c))();
  if (iVar1 != 1) {
    ppcStack_1a0 = (char **)0x0;
  }
  puStack_1c8 = auStack_e8;
  puStack_1cc = (undefined1 *)0x46780a;
  (**(code **)(*piStack_1ac + 0x14))();
  puStack_1cc = auStack_e0;
  piStack_1d0 = (int *)0x46781b;
  (**(code **)(*ppcStack_1a8 + 0x14))();
  piStack_1d0 = aiStack_d8;
  piStack_1d4 = (int *)0x46782c;
  (**(code **)(*ppcStack_1b0 + 0x14))();
  piStack_1d4 = aiStack_d0;
  ppfStack_1d8 = (float **)0x46783d;
  (**(code **)(*piStack_1ac + 0x14))();
  ppfStack_1d8 = &pfStack_120;
  ppcStack_1dc = &pcStack_124;
  ppuStack_1e0 = &puStack_128;
  ppfStack_1e4 = (float **)0x46785e;
  (**(code **)(*piStack_1bc + 0x10))();
  ppfStack_1e4 = &pfStack_120;
  ppcStack_1e8 = &pcStack_124;
  ppuStack_1ec = &puStack_128;
  ppfStack_1f0 = (float **)0x46787f;
  (*(code *)(*pppfStack_1c0)[4])();
  ppfStack_1f0 = &pfStack_120;
  ppcStack_1f4 = &pcStack_124;
  ppuStack_1f8 = &puStack_128;
  ppfStack_1fc = (float **)0x4678a0;
  (**(code **)(*piStack_1d0 + 0x10))();
  ppfStack_1fc = &pfStack_120;
  ppcStack_200 = &pcStack_124;
  ppuStack_204 = &puStack_128;
  puStack_208 = (undefined4 *)0x4678c1;
  (**(code **)(*piStack_1d4 + 0x10))();
  puStack_208 = (undefined4 *)0x0;
  ppuStack_20c = (undefined1 **)afStack_8c[7];
  ppcStack_210 = (char **)0x4678c8;
  iVar1 = FUN_00548b90();
  puStack_208 = (undefined4 *)0x0;
  if (iVar1 == 3) {
    ppuStack_20c = (undefined1 **)0x4678d9;
    (*(code *)**(undefined4 **)pcStack_1b4)();
    ppuStack_20c = &puStack_1cc;
    ppcStack_210 = &pcStack_1c4;
    pppcStack_214 = &ppcStack_1f4;
    uStack_218 = 0x4678f1;
    (*(code *)(*ppfStack_1f0)[4])();
    piStack_21c = (int *)((float)pfStack_160 - _DAT_006ee4cc);
    uStack_218 = 0;
    ppcStack_220 = ppcStack_200;
    fStack_224 = 6.471915e-39;
    (*(code *)(*ppfStack_1fc)[2])();
    fStack_224 = (float)pcStack_13c + _DAT_006ea4d4;
    piStack_228 = (int *)((float)pfStack_140 - _DAT_006ee4c8);
    pcStack_22c = pcStack_144;
    uStack_230 = 0x467945;
    (**(code **)*puStack_208)();
  }
  else {
    ppuStack_20c = (undefined1 **)0x46794b;
    (*(code *)**(undefined4 **)pcStack_1b4)();
  }
  uStack_230 = 1;
  pppcStack_234 = (char ***)afStack_8c[7];
  pppuStack_238 = (undefined1 ***)0x467953;
  iVar1 = FUN_00548b90();
  uStack_230 = 0;
  if (iVar1 == 3) {
    pppcStack_234 = (char ***)0x467964;
    (*(code *)**ppfStack_1d8)();
    pppcStack_234 = &ppcStack_1f4;
    pppuStack_238 = &ppuStack_1ec;
    ppiStack_23c = &piStack_21c;
    afStack_244[1] = 6.472065e-39;
    (**(code **)(*ppcStack_210 + 0x10))();
    afStack_244[0] = (float)pcStack_17c + _DAT_006ee4cc;
    afStack_244[1] = 0.0;
    piStack_248 = piStack_228;
    fStack_24c = 6.47211e-39;
    (**(code **)(*piStack_21c + 8))();
    fStack_24c = (float)puStack_158 + _DAT_006ea4d4;
    fStack_250 = (float)pcStack_15c + _DAT_006ee4c4;
    pfStack_254 = pfStack_160;
    uStack_258 = 0x4679d0;
    (**(code **)*piStack_228)();
  }
  else {
    pppcStack_234 = (char ***)0x4679d6;
    (*(code *)**ppfStack_1d8)();
  }
  uStack_258 = 2;
  ppiStack_25c = (int **)afStack_8c[7];
  ppppcStack_260 = (char ****)0x4679de;
  iVar1 = FUN_00548b90();
  uStack_258 = 0;
  if (iVar1 == 3) {
    ppiStack_25c = (int **)0x4679ef;
    (*(code *)**ppfStack_1fc)();
    ppiStack_25c = &piStack_21c;
    ppppcStack_260 = &pppcStack_214;
    pfStack_264 = afStack_244;
    piStack_268 = (int *)0x467a07;
    (*(code *)(*ppiStack_23c)[4])();
    fStack_26c = (float)ppfStack_198 - _DAT_006ee4cc;
    piStack_268 = (int *)0x0;
    (**(code **)(*piStack_248 + 8))(fStack_250);
    puStack_274 = (undefined4 *)((float)uStack_174 + _DAT_006ea4d4);
    (**(code **)*pfStack_254)(pcStack_17c,(float)ppfStack_178 - _DAT_006ee4c4);
  }
  else {
    ppiStack_25c = (int **)0x467a61;
    (*(code *)**ppfStack_1fc)();
  }
  iVar1 = FUN_00548b90(afStack_8c[7],3);
  uVar9 = 0;
  if (iVar1 != 3) {
    (**(code **)*ppcStack_220)(0);
    return;
  }
  (**(code **)*ppcStack_220)();
  (*(code *)(*ppiStack_25c)[4])(&fStack_26c,&ppiStack_23c,afStack_244);
  (**(code **)(*piStack_268 + 8))(uVar9,(float)pcStack_1b4 + _DAT_006ee4cc,0);
  (**(code **)*puStack_274)
            (ppfStack_198,(float)pcStack_194 + _DAT_006ee4c4,(float)ppcStack_190 + _DAT_006ea4d4);
  return;
}


