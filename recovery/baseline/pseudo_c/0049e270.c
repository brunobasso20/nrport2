/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0049e270 */

undefined4 __fastcall FUN_0049e270(int param_1)

{
  undefined4 *puVar1;
  char cVar2;
  int iVar3;
  undefined4 uVar4;
  uint uVar5;
  int iVar6;
  char *pcVar7;
  int *piVar8;
  int extraout_EDX;
  undefined1 uVar9;
  undefined4 *puVar10;
  undefined4 unaff_ESI;
  undefined4 uVar11;
  undefined4 uVar12;
  undefined4 uVar13;
  undefined4 uVar14;
  undefined4 uVar15;
  char *pcStack_b0;
  char *pcStack_ac;
  undefined4 uStack_a8;
  undefined4 *puStack_a4;
  char **ppcStack_a0;
  int *piStack_9c;
  int **ppiStack_98;
  char *pcStack_94;
  undefined4 uStack_80;
  undefined4 *puStack_7c;
  undefined4 uStack_78;
  undefined4 *puStack_74;
  int *local_70;
  char *pcStack_6c;
  char *apcStack_68 [6];
  char acStack_50 [80];
  
  pcStack_94 = s_txt3DAccelerator_0073fe14;
  piVar8 = (int *)(param_1 + 0x15d);
  piStack_9c = (int *)0x49e290;
  ppiStack_98 = (int **)piVar8;
  cVar2 = FUN_005fbf80();
  if (cVar2 == '\0') {
    return 0;
  }
  ppiStack_98 = &local_70;
  pcStack_94 = (char *)0x0;
  piStack_9c = (int *)0x49e2a4;
  iVar3 = FUN_005d35a0();
  if (iVar3 == 1) {
    pcStack_94 = (char *)0x0;
    ppiStack_98 = (int **)0x49e2b7;
    ppiStack_98 = (int **)(**(code **)(*local_70 + 0x1c))();
    ppcStack_a0 = apcStack_68 + 5;
    piStack_9c = (int *)&DAT_0073fe28;
    puStack_a4 = (undefined4 *)0x49e2c7;
    FUN_006c4f81();
    piVar8 = (int *)**(int **)(*piVar8 + 0x1ae);
    if (piVar8 != (int *)0x0) {
      pcStack_94 = acStack_50;
LAB_0049e2f2:
      ppiStack_98 = (int **)0x49e2f7;
      (**(code **)(*piVar8 + 0x6c))();
    }
  }
  else {
    piVar8 = (int *)**(int **)(*piVar8 + 0x1ae);
    if (piVar8 != (int *)0x0) {
      pcStack_94 = s_Unknown_0073fe2c;
      goto LAB_0049e2f2;
    }
  }
  pcStack_94 = s_txtDrivingRes_0073fe34;
  piStack_9c = (int *)0x49e30b;
  ppiStack_98 = (int **)(param_1 + 0x161);
  cVar2 = FUN_005fbf80();
  if (cVar2 == '\0') {
    return 0;
  }
  pcStack_94 = (char *)&uStack_80;
  ppiStack_98 = &puStack_7c;
  piStack_9c = &uStack_78;
  uStack_78 = 800;
  puStack_7c = (undefined4 *)0x258;
  uStack_80 = 0x10;
  ppcStack_a0 = (char **)0x49e33f;
  FUN_0043e980();
  ppcStack_a0 = (char **)uStack_80;
  puStack_a4 = puStack_7c;
  uStack_a8 = uStack_78;
  pcStack_b0 = acStack_50;
  pcStack_ac = s__d_x__d_x__d_0073fe44;
  FUN_006c4f81();
  piVar8 = (int *)**(int **)(*(int *)(param_1 + 0x161) + 0x1ae);
  if (piVar8 != (int *)0x0) {
    pcStack_94 = acStack_50;
    ppiStack_98 = (int **)0x49e378;
    (**(code **)(*piVar8 + 0x6c))();
  }
  ppiStack_98 = (int **)(param_1 + 0x165);
  pcStack_94 = s_btnChangeConfiguration_0073fe54;
  piStack_9c = (int *)0x49e38c;
  cVar2 = FUN_005fbd80();
  if (cVar2 == '\0') {
    return 0;
  }
  puVar10 = (undefined4 *)(param_1 + 0x169);
  apcStack_68[0] = s_chkShadows_0073fe6c;
  apcStack_68[1] = s_chkReflectionsOnCars_0073fe78;
  apcStack_68[2] = s_chkReflectionsOnStructures_0073fe90;
  apcStack_68[3] = s_chkLightMaps_0073feac;
  apcStack_68[4] = s_chkFog_0073febc;
  iVar3 = 0;
  do {
    pcStack_94 = apcStack_68[iVar3];
    piStack_9c = (int *)0x49e3d6;
    ppiStack_98 = (int **)puVar10;
    puStack_74 = puVar10;
    cVar2 = FUN_005fbe20();
    if (cVar2 == '\0') {
      return 0;
    }
    piVar8 = (int *)*puVar10;
    pcStack_94 = (char *)(uint)*(byte *)(iVar3 + 0x30d + param_1);
    ppiStack_98 = (int **)0x49e3f1;
    (**(code **)(*piVar8 + 0x2c))();
    piStack_9c = (int *)0x49e3f7;
    ppiStack_98 = (int **)iVar3;
    cVar2 = FUN_00441690();
    if (cVar2 == '\0') {
      ppiStack_98 = (int **)0x49e40c;
      (**(code **)(*piVar8 + 0x48))();
    }
    else {
      ppiStack_98 = (int **)0x49e405;
      (**(code **)(*piVar8 + 0x44))();
    }
    iVar3 = iVar3 + 1;
    puVar10 = puStack_74 + 1;
  } while (iVar3 < 4);
  puVar10 = (undefined4 *)(param_1 + 0x17d);
  apcStack_68[0] = s_chkSmoke_0073fec4;
  apcStack_68[1] = s_chkDirt_0073fed0;
  apcStack_68[2] = s_chkDust_0073fed8;
  apcStack_68[3] = s_chkSparks_0073fee0;
  apcStack_68[4] = s_chkSkidMarks_0073feec;
  apcStack_68[5] = s_chkDebris_0073fefc;
  iVar3 = 0;
  do {
    ppiStack_98 = (int **)0x49e461;
    pcStack_94 = (char *)iVar3;
    puStack_74 = puVar10;
    cVar2 = FUN_0049e240();
    if (cVar2 == '\0') {
      pcStack_94 = apcStack_68[iVar3];
      piStack_9c = (int *)0x49e473;
      ppiStack_98 = (int **)puVar10;
      cVar2 = FUN_005fbe20();
      if (cVar2 == '\0') {
        return 0;
      }
      piVar8 = (int *)*puVar10;
      pcStack_94 = (char *)(uint)*(byte *)(iVar3 + 0x312 + param_1);
      ppiStack_98 = (int **)0x49e48e;
      (**(code **)(*piVar8 + 0x2c))();
      piStack_9c = (int *)0x49e494;
      ppiStack_98 = (int **)iVar3;
      cVar2 = FUN_00441710();
      if (cVar2 == '\0') {
        ppiStack_98 = (int **)0x49e4a9;
        (**(code **)(*piVar8 + 0x48))();
      }
      else {
        ppiStack_98 = (int **)0x49e4a2;
        (**(code **)(*piVar8 + 0x44))();
      }
    }
    iVar3 = iVar3 + 1;
    puVar10 = puStack_74 + 1;
  } while (iVar3 < 6);
  puVar1 = (undefined4 *)(param_1 + 0x195);
  pcStack_94 = s_chkEffects_0073ff08;
  piStack_9c = (int *)0x49e4ce;
  ppiStack_98 = (int **)puVar1;
  puStack_74 = puVar10;
  cVar2 = FUN_005fbe20();
  if (cVar2 == '\0') {
    return 0;
  }
  iVar3 = 0;
  do {
    ppiStack_98 = (int **)0x49e4e0;
    pcStack_94 = (char *)iVar3;
    cVar2 = FUN_0049e240();
    if (cVar2 != '\0') {
      ppiStack_98 = (int **)0x49e4ea;
      pcStack_94 = (char *)iVar3;
      cVar2 = FUN_00441710();
      if (cVar2 != '\0') {
        piVar8 = (int *)*puVar1;
        pcStack_94 = (char *)0x49e530;
        (**(code **)(*piVar8 + 0x44))();
        goto LAB_0049e500;
      }
    }
    iVar3 = iVar3 + 1;
  } while (iVar3 < 6);
  piVar8 = (int *)*puVar1;
  pcStack_94 = (char *)0x49e500;
  (**(code **)(*piVar8 + 0x48))();
LAB_0049e500:
  uVar9 = 1;
  pcStack_94 = (char *)0x0;
  puStack_74._0_1_ = 1;
  do {
    ppiStack_98 = (int **)0x49e510;
    cVar2 = FUN_0049e240();
    if ((cVar2 != '\0') && (*(char *)(extraout_EDX + 0x312 + param_1) == '\0')) {
      uVar9 = 0;
      puStack_74._0_1_ = 0;
      break;
    }
    pcStack_94 = (char *)(extraout_EDX + 1);
  } while ((int)pcStack_94 < 6);
  pcStack_94._0_1_ = puStack_74._0_1_;
  pcStack_94._1_3_ = 0;
  ppiStack_98 = (int **)0x49e549;
  (**(code **)(*piVar8 + 0x2c))();
  ppiStack_98 = (int **)s_chkLenseFlare_0073ff14;
  *(undefined1 *)(param_1 + 0x31c) = uVar9;
  ppcStack_a0 = (char **)0x49e563;
  piStack_9c = (undefined4 *)(param_1 + 0x2f1);
  cVar2 = FUN_005fbe20();
  if (cVar2 == '\0') {
    return 0;
  }
  ppiStack_98 = (int **)(uint)*(byte *)(param_1 + 0x35f);
  piStack_9c = (int *)0x49e57b;
  (**(code **)(**(int **)(param_1 + 0x2f1) + 0x2c))();
  piVar8 = (int *)(param_1 + 0x2f5);
  piStack_9c = (int *)s_chkTrackLighting_0073ff24;
  *piVar8 = 0;
  puStack_a4 = (undefined4 *)0x49e595;
  ppcStack_a0 = (char **)piVar8;
  FUN_005fbe20();
  if ((int *)*piVar8 != (int *)0x0) {
    piStack_9c = (int *)(uint)*(byte *)(param_1 + 0x360);
    ppcStack_a0 = (char **)0x49e5a9;
    (**(code **)(*(int *)*piVar8 + 0x2c))();
  }
  piVar8 = (int *)(param_1 + 0x2f9);
  piStack_9c = (int *)s_chkSpecularHighlights_0073ff38;
  *piVar8 = 0;
  puStack_a4 = (undefined4 *)0x49e5c3;
  ppcStack_a0 = (char **)piVar8;
  FUN_005fbe20();
  piVar8 = (int *)*piVar8;
  if (piVar8 != (int *)0x0) {
    piStack_9c = (int *)(uint)*(byte *)(param_1 + 0x361);
    ppcStack_a0 = (char **)0x49e5d9;
    (**(code **)(*piVar8 + 0x2c))();
    if (piVar8 != (int *)0x0) {
      piStack_9c = (int *)0x49e5e2;
      cVar2 = FUN_005d5090();
      if ((cVar2 == '\0') || (*(char *)(param_1 + 0x360) == '\0')) {
        piStack_9c = (int *)0x49e600;
        (**(code **)(*piVar8 + 0x48))();
      }
      else {
        piStack_9c = (int *)0x49e5f7;
        (**(code **)(*piVar8 + 0x44))();
      }
    }
  }
  puVar10 = (undefined4 *)(param_1 + 0x199);
  local_70 = (int *)s_chkAnimatedPitCrew_0073ff50;
  pcStack_6c = s_chkSteeringWheel_0073ff64;
  apcStack_68[0] = s_chkAnimatedObjects_0073ff78;
  apcStack_68[1] = s_chkWindshieldBuildup_0073ff8c;
  iVar3 = 0;
  do {
    piStack_9c = (&local_70)[iVar3];
    puStack_a4 = (undefined4 *)0x49e63a;
    ppcStack_a0 = (char **)puVar10;
    puStack_7c = puVar10;
    cVar2 = FUN_005fbe20();
    if (cVar2 == '\0') {
      return 0;
    }
    piVar8 = (int *)*puVar10;
    piStack_9c = (int *)(uint)*(byte *)(iVar3 + 0x318 + param_1);
    ppcStack_a0 = (char **)0x49e656;
    (**(code **)(*piVar8 + 0x2c))();
    puStack_a4 = (undefined4 *)0x49e65c;
    ppcStack_a0 = (char **)iVar3;
    cVar2 = FUN_00441770();
    if (cVar2 == '\0') {
      ppcStack_a0 = (char **)0x49e673;
      (**(code **)(*piVar8 + 0x48))();
    }
    else {
      ppcStack_a0 = (char **)0x49e66b;
      (**(code **)(*piVar8 + 0x44))();
    }
    iVar3 = iVar3 + 1;
    puVar10 = puStack_7c + 1;
  } while (iVar3 < 4);
  ppcStack_a0 = (char **)(param_1 + 0x1fd);
  piStack_9c = (int *)s_sliDrawingDistance_0073ffa4;
  puStack_a4 = (undefined4 *)0x49e698;
  puStack_7c = puVar10;
  cVar2 = FUN_005fc1c0();
  if (cVar2 == '\0') {
    return 0;
  }
  ppcStack_a0 = (char **)(param_1 + 0x201);
  piStack_9c = (int *)s_txtDrawingDistance_0073ffb8;
  puStack_a4 = (undefined4 *)0x49e6b4;
  cVar2 = FUN_005fbf80();
  if (cVar2 == '\0') {
    return 0;
  }
  ppcStack_a0 = (char **)(param_1 + 0x205);
  piStack_9c = (int *)s_btnUpDrawingDistance_0073ffcc;
  puStack_a4 = (undefined4 *)0x49e6d0;
  cVar2 = FUN_005fbd80();
  if (cVar2 == '\0') {
    return 0;
  }
  ppcStack_a0 = (char **)(param_1 + 0x209);
  piStack_9c = (int *)s_btnDnDrawingDistance_0073ffe4;
  puStack_a4 = (undefined4 *)0x49e6ec;
  cVar2 = FUN_005fbd80();
  if (cVar2 == '\0') {
    return 0;
  }
  piStack_9c = (int *)s_sliFieldOfView_0073fffc;
  puStack_a4 = (undefined4 *)0x49e708;
  ppcStack_a0 = (char **)(param_1 + 0x20d);
  cVar2 = FUN_005fc1c0();
  if (cVar2 == '\0') {
    return 0;
  }
  ppcStack_a0 = (char **)(param_1 + 0x211);
  piStack_9c = (int *)s_txtFieldOfView_0074000c;
  puStack_a4 = (undefined4 *)0x49e724;
  cVar2 = FUN_005fbf80();
  if (cVar2 == '\0') {
    return 0;
  }
  ppcStack_a0 = (char **)(param_1 + 0x215);
  piStack_9c = (int *)s_btnUpFieldOfView_0074001c;
  puStack_a4 = (undefined4 *)0x49e740;
  cVar2 = FUN_005fbd80();
  if (cVar2 == '\0') {
    return 0;
  }
  ppcStack_a0 = (char **)(param_1 + 0x219);
  piStack_9c = (int *)s_btnDnFieldOfView_00740030;
  puStack_a4 = (undefined4 *)0x49e75c;
  cVar2 = FUN_005fbd80();
  if (cVar2 == '\0') {
    return 0;
  }
  piStack_9c = (int *)0x49e775;
  uVar4 = FUN_006c5018();
  piStack_9c = (int *)0x49e788;
  piStack_9c = (int *)FUN_006c5018();
  piVar8 = *(int **)(param_1 + 0x20d);
  puStack_a4 = (undefined4 *)0x0;
  uStack_a8 = 0x49e798;
  ppcStack_a0 = (char **)uVar4;
  (**(code **)(*piVar8 + 0x90))();
  iVar3 = *piVar8;
  uStack_a8 = 0x49e7ab;
  uStack_a8 = FUN_006c5018();
  pcStack_ac = (char *)0x49e7b1;
  (**(code **)(iVar3 + 0x2c))();
  pcStack_ac = (char *)0x49e7b8;
  FUN_004a0580();
  pcStack_b0 = (char *)(param_1 + 0x261);
  pcStack_ac = s_ddnCarDetailLvl_00740044;
  cVar2 = FUN_005fc2b0();
  if (cVar2 == '\0') {
    return 0;
  }
  if (*(int *)(param_1 + 0x20) == 0) {
LAB_0049e7f7:
    if (*(int *)(param_1 + 0x25d) != 0) {
      pcStack_ac = (char *)0x49e803;
      FUN_006063b0();
    }
    iVar3 = *(int *)(param_1 + 0x249);
    while (0 < iVar3) {
      if (*(int *)(param_1 + 0x255) == 0) {
        pcStack_ac = &stack0xffffff74;
        pcStack_b0 = (char *)0x49e826;
        FUN_004a6a50();
      }
      else {
        pcStack_ac = (char *)0x49e814;
        unaff_ESI = FUN_0045b2b0();
      }
      pcStack_b0 = &stack0xffffff7c;
      pcStack_ac = (char *)unaff_ESI;
      FUN_004a6ab0();
      iVar3 = *(int *)(param_1 + 0x249);
    }
    if (*(int *)(param_1 + 0x25d) != 0) {
      pcStack_ac = (char *)0x49e84a;
      FUN_006063b0();
    }
    pcStack_ac = (char *)0x49e851;
    FUN_004a0a20();
    pcStack_b0 = (char *)(param_1 + 0x299);
    pcStack_ac = s_ddnDynLightDist_00740064;
    pcStack_b0[0] = '\0';
    pcStack_b0[1] = '\0';
    pcStack_b0[2] = '\0';
    pcStack_b0[3] = '\0';
    cVar2 = FUN_005fc2b0();
    if (cVar2 != '\0') {
      if (*(int *)(param_1 + 0x20) != 0) {
        pcVar7 = (char *)(param_1 + 0x295);
        pcStack_ac = s_lstDynLightDist_00740074;
        pcStack_b0 = pcVar7;
        cVar2 = FUN_005fc300();
        if (cVar2 != '\x01') goto LAB_0049f0ba;
      }
      if (*(int *)(param_1 + 0x295) != 0) {
        pcStack_ac = (char *)0x49e8a2;
        FUN_006063b0();
      }
      iVar3 = *(int *)(param_1 + 0x281);
      while (0 < iVar3) {
        if (*(int *)(param_1 + 0x28d) == 0) {
          pcStack_ac = &stack0xffffff74;
          pcStack_b0 = (char *)0x49e8c5;
          FUN_004a6d70();
        }
        else {
          pcStack_ac = (char *)0x49e8b3;
          unaff_ESI = FUN_0045b2b0();
        }
        pcStack_b0 = &stack0xffffff7c;
        pcStack_ac = (char *)unaff_ESI;
        FUN_004a6dd0();
        iVar3 = *(int *)(param_1 + 0x281);
      }
      if (*(int *)(param_1 + 0x295) != 0) {
        pcStack_ac = (char *)0x49e8e9;
        FUN_006063b0();
      }
      pcStack_ac = *(char **)(param_1 + 0x362);
      pcStack_b0 = (char *)0x49e8f7;
      FUN_004a0b30();
    }
    pcStack_b0 = (char *)(param_1 + 0x29d);
    pcStack_ac = s_lblDynLightDist_00740084;
    pcStack_b0[0] = '\0';
    pcStack_b0[1] = '\0';
    pcStack_b0[2] = '\0';
    pcStack_b0[3] = '\0';
    cVar2 = FUN_005fbf80();
    if (cVar2 == '\0') {
      return 0;
    }
    pcStack_b0 = (char *)(param_1 + 0x2b9);
    pcStack_ac = s_ddnDynLightQuality_00740094;
    pcStack_b0[0] = '\0';
    pcStack_b0[1] = '\0';
    pcStack_b0[2] = '\0';
    pcStack_b0[3] = '\0';
    cVar2 = FUN_005fc2b0();
    if (cVar2 != '\0') {
      if (*(int *)(param_1 + 0x20) != 0) {
        pcVar7 = (char *)(param_1 + 0x2b5);
        pcStack_ac = s_lstDynLightQuality_007400a8;
        pcStack_b0 = pcVar7;
        cVar2 = FUN_005fc300();
        if (cVar2 != '\x01') goto LAB_0049f0ba;
      }
      if (*(int *)(param_1 + 0x2b5) != 0) {
        pcStack_ac = (char *)0x49e96a;
        FUN_006063b0();
      }
      iVar3 = *(int *)(param_1 + 0x2a1);
      while (0 < iVar3) {
        if (*(int *)(param_1 + 0x2ad) == 0) {
          pcStack_ac = &stack0xffffff74;
          pcStack_b0 = (char *)0x49e98d;
          FUN_004a6f50();
        }
        else {
          pcStack_ac = (char *)0x49e97b;
          unaff_ESI = FUN_0045b2b0();
        }
        pcStack_b0 = &stack0xffffff7c;
        pcStack_ac = (char *)unaff_ESI;
        FUN_004a6fb0();
        iVar3 = *(int *)(param_1 + 0x2a1);
      }
      if (*(int *)(param_1 + 0x2b5) != 0) {
        pcStack_ac = (char *)0x49e9b1;
        FUN_006063b0();
      }
      pcStack_ac = *(char **)(param_1 + 0x366);
      pcStack_b0 = (char *)0x49e9bf;
      FUN_004a0cb0();
    }
    pcStack_b0 = (char *)(param_1 + 0x2bd);
    pcStack_ac = s_lblDynLightQuality_007400bc;
    pcStack_b0[0] = '\0';
    pcStack_b0[1] = '\0';
    pcStack_b0[2] = '\0';
    pcStack_b0[3] = '\0';
    cVar2 = FUN_005fbf80();
    if (cVar2 == '\0') {
      return 0;
    }
    pcVar7 = (char *)(param_1 + 0x2fd);
    pcStack_ac = s_chkDynLight_007400d0;
    pcVar7[0] = '\0';
    pcVar7[1] = '\0';
    pcVar7[2] = '\0';
    pcVar7[3] = '\0';
    pcStack_b0 = pcVar7;
    cVar2 = FUN_005fbe20();
    if (cVar2 != '\0') {
      pcStack_ac = (char *)(uint)*(byte *)(param_1 + 0x36a);
      pcStack_b0 = (char *)0x49ea11;
      (**(code **)(**(int **)pcVar7 + 0x2c))();
    }
    pcVar7 = (char *)(param_1 + 0x301);
    pcStack_ac = s_chkDynLightRenderCars_007400dc;
    pcVar7[0] = '\0';
    pcVar7[1] = '\0';
    pcVar7[2] = '\0';
    pcVar7[3] = '\0';
    pcStack_b0 = pcVar7;
    cVar2 = FUN_005fbe20();
    if (cVar2 != '\0') {
      pcStack_ac = (char *)(uint)*(byte *)(param_1 + 0x36b);
      pcStack_b0 = (char *)0x49ea41;
      (**(code **)(**(int **)pcVar7 + 0x2c))();
    }
    pcVar7 = (char *)(param_1 + 0x305);
    pcStack_ac = s_chkDynLightRenderIntoCockpit_007400f4;
    pcVar7[0] = '\0';
    pcVar7[1] = '\0';
    pcVar7[2] = '\0';
    pcVar7[3] = '\0';
    pcStack_b0 = pcVar7;
    cVar2 = FUN_005fbe20();
    if (cVar2 != '\0') {
      pcStack_ac = (char *)(uint)*(byte *)(param_1 + 0x36c);
      pcStack_b0 = (char *)0x49ea71;
      (**(code **)(**(int **)pcVar7 + 0x2c))();
    }
    pcStack_ac = (char *)0x49ea78;
    FUN_004a34b0();
    pcStack_ac = s_sliGamma_00740114;
    pcStack_b0 = (char *)(param_1 + 0x225);
    cVar2 = FUN_005fc1c0();
    if (cVar2 == '\0') {
      return 0;
    }
    pcStack_b0 = (char *)(param_1 + 0x229);
    pcStack_ac = s_txtGamma_00740120;
    cVar2 = FUN_005fbf80();
    if (cVar2 == '\0') {
      return 0;
    }
    pcStack_b0 = (char *)(param_1 + 0x22d);
    pcStack_ac = s_btnUpGamma_0074012c;
    cVar2 = FUN_005fbd80();
    if (cVar2 == '\0') {
      return 0;
    }
    pcStack_b0 = (char *)(param_1 + 0x231);
    pcStack_ac = s_btnDnGamma_00740138;
    cVar2 = FUN_005fbd80();
    if (cVar2 == '\0') {
      return 0;
    }
    piVar8 = *(int **)(param_1 + 0x225);
    pcStack_ac = (char *)0xfa;
    pcStack_b0 = (char *)0x64;
    uVar15 = 0;
    (**(code **)(*piVar8 + 0x90))(0);
    uVar4 = *(undefined4 *)(param_1 + 0x336);
    (**(code **)(*piVar8 + 0x2c))(uVar4);
    FUN_004a06f0();
    cVar2 = FUN_005fc1c0((undefined4 *)(param_1 + 0x235),s_sliBrightness_00740144);
    if (cVar2 == '\0') {
      return 0;
    }
    cVar2 = FUN_005fbf80(param_1 + 0x239,s_txtBrightness_00740154);
    if (cVar2 == '\0') {
      return 0;
    }
    cVar2 = FUN_005fbd80(param_1 + 0x23d,s_btnUpBrightness_00740164);
    if (cVar2 == '\0') {
      return 0;
    }
    cVar2 = FUN_005fbd80(param_1 + 0x241,s_btnDnBrightness_00740174);
    if (cVar2 == '\0') {
      return 0;
    }
    piVar8 = *(int **)(param_1 + 0x235);
    uVar14 = 0x32;
    uVar13 = 0xffffffce;
    uVar12 = 0;
    (**(code **)(*piVar8 + 0x90))(0,0xffffffce,0x32);
    uVar11 = *(undefined4 *)(param_1 + 0x33a);
    (**(code **)(*piVar8 + 0x2c))(uVar11);
    FUN_004a0750();
    cVar2 = FUN_005fbe20((undefined4 *)(param_1 + 0x245),s_chkAllowSettingGamma_00740184);
    if (cVar2 == '\0') {
      return 0;
    }
    uVar5 = (uint)*(byte *)(param_1 + 0x33e);
    (**(code **)(**(int **)(param_1 + 0x245) + 0x2c))(uVar5);
    FUN_004a05d0();
    cVar2 = FUN_005fc2b0(param_1 + 0x27d,s_ddnOpponentPitcrews_0074019c);
    if (cVar2 == '\0') {
      return 0;
    }
    piVar8 = (int *)(param_1 + 0x265);
    if (*(int *)(param_1 + 0x20) != 0) {
      pcVar7 = (char *)(param_1 + 0x279);
      cVar2 = FUN_005fc300(pcVar7,s_lstOpponentPitcrews_007401b0);
      if (cVar2 != '\x01') goto LAB_0049f0ba;
    }
    if (*(int *)(param_1 + 0x279) != 0) {
      FUN_006063b0();
    }
    iVar3 = *piVar8;
    while (0 < iVar3) {
      if (*(int *)(param_1 + 0x271) == 0) {
        iVar6 = param_1 + 0x269;
      }
      else {
        iVar6 = FUN_0045b2b0();
      }
      if (iVar3 == 0) {
        FUN_004a6c60(&pcStack_b0);
      }
      else {
        pcVar7 = (char *)FUN_0045b280();
        *piVar8 = *piVar8 + -1;
        FUN_005cfe04(iVar6);
        *(undefined4 *)(iVar6 + 8) = 0;
        *(undefined4 *)(iVar6 + 0xc) = 0;
        *(undefined4 *)(iVar6 + 4) = 0;
        FUN_004a75d0();
        FUN_004a75d0();
        FUN_005cfccc(iVar6);
        pcStack_b0 = pcVar7;
      }
      iVar3 = *piVar8;
    }
    if (*(int *)(param_1 + 0x279) != 0) {
      FUN_006063b0();
    }
    FUN_004a0e20();
    cVar2 = FUN_005fc2b0(param_1 + 0x2d9,s_ddnTextureFilteringQuality_007401c4);
    if (cVar2 == '\0') {
      return 0;
    }
    piVar8 = (int *)(param_1 + 0x2c1);
    if (*(int *)(param_1 + 0x20) != 0) {
      pcVar7 = (char *)(param_1 + 0x2d5);
      cVar2 = FUN_005fc300(pcVar7,s_lstTextureFilteringQuality_007401e0);
      if (cVar2 != '\x01') goto LAB_0049f0ba;
    }
    if (*(int *)(param_1 + 0x2d5) != 0) {
      FUN_006063b0();
    }
    iVar3 = *piVar8;
    while (0 < iVar3) {
      if (*(int *)(param_1 + 0x2cd) == 0) {
        iVar6 = param_1 + 0x2c5;
      }
      else {
        iVar6 = FUN_0045b2b0();
      }
      if (iVar3 == 0) {
        FUN_004a7160(&pcStack_b0);
      }
      else {
        pcVar7 = (char *)FUN_0045b280();
        *piVar8 = *piVar8 + -1;
        FUN_005cfe04(iVar6);
        *(undefined4 *)(iVar6 + 8) = 0;
        *(undefined4 *)(iVar6 + 0xc) = 0;
        *(undefined4 *)(iVar6 + 4) = 0;
        FUN_004a7600();
        FUN_004a7600();
        FUN_005cfccc(iVar6);
        pcStack_b0 = pcVar7;
      }
      iVar3 = *piVar8;
    }
    if (*(int *)(param_1 + 0x2d5) != 0) {
      FUN_006063b0();
    }
    FUN_004a0f30();
    cVar2 = FUN_005fc2b0(param_1 + 0x1c1,s_ddnMirrorDetailLvl_007401fc);
    if (cVar2 != '\0') {
      if (*(int *)(param_1 + 0x20) != 0) {
        cVar2 = FUN_005fc300((undefined4 *)(param_1 + 0x1bd),s_lstMirrorDetailLvl_00740210);
        if (cVar2 != '\x01') {
          *(undefined4 *)(param_1 + 0x1bd) = 0;
          return 0;
        }
      }
      if (*(int *)(param_1 + 0x1bd) != 0) {
        FUN_006063b0();
      }
      iVar3 = *(int *)(param_1 + 0x1a9);
      while (0 < iVar3) {
        if (*(int *)(param_1 + 0x1b5) == 0) {
          iVar6 = param_1 + 0x1ad;
        }
        else {
          iVar6 = FUN_0045b2b0();
        }
        if (iVar3 != 0) {
          FUN_0045b280();
          *(int *)(param_1 + 0x1a9) = *(int *)(param_1 + 0x1a9) + -1;
          FUN_005cfe04(iVar6);
          *(undefined4 *)(iVar6 + 8) = 0;
          *(undefined4 *)(iVar6 + 0xc) = 0;
          *(undefined4 *)(iVar6 + 4) = 0;
          FUN_004a7540();
          FUN_004a7540();
          FUN_005cfccc(iVar6);
        }
        iVar3 = *(int *)(param_1 + 0x1a9);
      }
      if (*(int *)(param_1 + 0x1bd) != 0) {
        FUN_006063b0();
      }
      FUN_004a0800();
      cVar2 = FUN_005fc2b0(param_1 + 0x1dd,s_ddnTracksideObjs_00740224);
      if (cVar2 != '\0') {
        if (*(int *)(param_1 + 0x20) != 0) {
          cVar2 = FUN_005fc300((undefined4 *)(param_1 + 0x1d9),s_lstTracksideObjs_00740238);
          if (cVar2 != '\x01') {
            *(undefined4 *)(param_1 + 0x1d9) = 0;
            return 0;
          }
        }
        if (*(int *)(param_1 + 0x1d9) != 0) {
          FUN_006063b0();
        }
        iVar3 = *(int *)(param_1 + 0x1c5);
        while (0 < iVar3) {
          if (*(int *)(param_1 + 0x1d1) == 0) {
            iVar6 = param_1 + 0x1c9;
          }
          else {
            iVar6 = FUN_0045b2b0();
          }
          if (iVar3 != 0) {
            FUN_0045b280();
            *(int *)(param_1 + 0x1c5) = *(int *)(param_1 + 0x1c5) + -1;
            FUN_005cfe04(iVar6);
            *(undefined4 *)(iVar6 + 8) = 0;
            *(undefined4 *)(iVar6 + 0xc) = 0;
            *(undefined4 *)(iVar6 + 4) = 0;
            FUN_004a7570();
            FUN_004a7570();
            FUN_005cfccc(iVar6);
          }
          iVar3 = *(int *)(param_1 + 0x1c5);
        }
        if (*(int *)(param_1 + 0x1d9) != 0) {
          FUN_006063b0();
        }
        FUN_004a0910();
        cVar2 = FUN_005fc2b0(param_1 + 0x1f9,s_ddnWorldDetailLvl_0074024c);
        if (cVar2 != '\0') {
          if (*(int *)(param_1 + 0x20) != 0) {
            cVar2 = FUN_005fc300((undefined4 *)(param_1 + 0x1f5),s_lstWorldDetailLvl_00740260);
            if (cVar2 != '\x01') {
              *(undefined4 *)(param_1 + 0x1f5) = 0;
              return 0;
            }
          }
          if (*(int *)(param_1 + 0x1f5) != 0) {
            FUN_006063b0();
          }
          iVar3 = *(int *)(param_1 + 0x1e1);
          while (0 < iVar3) {
            if (*(int *)(param_1 + 0x1ed) == 0) {
              iVar6 = param_1 + 0x1e5;
            }
            else {
              iVar6 = FUN_0045b2b0();
            }
            if (iVar3 != 0) {
              FUN_0045b280();
              *(int *)(param_1 + 0x1e1) = *(int *)(param_1 + 0x1e1) + -1;
              iVar3 = iVar6;
              FUN_005cfe04(iVar6);
              *(undefined4 *)(iVar6 + 8) = 0;
              *(undefined4 *)(iVar6 + 0xc) = 0;
              *(undefined4 *)(iVar6 + 4) = 0;
              FUN_004a75a0();
              if ((DAT_00fa1a54 & 1) == 0) {
                DAT_00fa1a54 = DAT_00fa1a54 | 1;
                FUN_006c4f40(&DAT_004a7700,iVar3,uVar5,uVar11,uVar12,uVar13,uVar14,uVar4,uVar15);
              }
              FUN_005cfccc(iVar6);
            }
            iVar3 = *(int *)(param_1 + 0x1e1);
          }
          if (*(int *)(param_1 + 0x1f5) != 0) {
            FUN_006063b0();
          }
          FUN_004a1010(*(undefined4 *)(param_1 + 0x31d));
          piVar8 = *(int **)(param_1 + 0x1fd);
          (**(code **)(*piVar8 + 0x90))(0,0,100);
          (**(code **)(*piVar8 + 0x2c))(*(undefined4 *)(param_1 + 0x325));
          cVar2 = FUN_005fbf80(param_1 + 0x21d,s_valueAhead_00740274);
          if ((cVar2 != '\0') &&
             (cVar2 = FUN_005fbf80(param_1 + 0x221,s_valueBehind_00740280), cVar2 != '\0')) {
            FUN_004a04a0();
            FUN_004a0500();
            FUN_005fbd80(param_1 + 0x309,s_btnRestoreGraphicsDefaults_0074028c);
            return 1;
          }
        }
      }
    }
  }
  else {
    pcVar7 = (char *)(param_1 + 0x25d);
    pcStack_ac = s_lstCarDetailLvl_00740054;
    pcStack_b0 = pcVar7;
    cVar2 = FUN_005fc300();
    if (cVar2 == '\x01') goto LAB_0049e7f7;
LAB_0049f0ba:
    pcVar7[0] = '\0';
    pcVar7[1] = '\0';
    pcVar7[2] = '\0';
    pcVar7[3] = '\0';
  }
  return 0;
}


