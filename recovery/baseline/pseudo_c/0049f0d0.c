/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0049f0d0 */

undefined4 __fastcall FUN_0049f0d0(int param_1)

{
  int *piVar1;
  int iVar2;
  byte bVar3;
  char cVar4;
  uint uVar5;
  uint uVar6;
  int iVar7;
  undefined4 unaff_EBX;
  undefined4 unaff_EBP;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  int iVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  undefined4 uVar11;
  undefined4 uVar12;
  undefined4 uVar13;
  undefined4 uVar14;
  undefined4 uVar15;
  undefined4 uVar16;
  undefined4 uVar17;
  undefined4 uVar18;
  undefined4 uVar19;
  undefined4 uVar20;
  undefined4 uVar21;
  undefined4 uVar22;
  undefined4 uVar23;
  undefined4 uVar24;
  undefined4 uVar25;
  undefined4 uVar26;
  undefined4 uVar27;
  undefined4 uVar28;
  undefined4 uVar29;
  undefined4 uVar30;
  undefined4 uVar31;
  undefined4 uVar32;
  undefined4 uVar33;
  undefined4 uVar34;
  undefined4 uVar35;
  undefined4 uVar36;
  undefined4 uVar37;
  undefined4 uVar38;
  undefined4 uVar39;
  undefined4 uVar40;
  
  cVar4 = FUN_005fbd80(param_1 + 0x36e,s_btnUpMasterVolume_007402a8);
  if (((cVar4 != '\0') &&
      (cVar4 = FUN_005fbd80(param_1 + 0x372,s_btnDnMasterVolume_007402bc), cVar4 != '\0')) &&
     (cVar4 = FUN_005fbf80(param_1 + 0x376,s_txtMasterVolume_007402d0), cVar4 != '\0')) {
    cVar4 = FUN_005fc1c0((undefined4 *)(param_1 + 0x37a),s_sliVolume_007402e0);
    if (cVar4 != '\0') {
      piVar1 = *(int **)(param_1 + 0x37a);
      uVar40 = 100;
      uVar39 = 0;
      uVar38 = 0;
      (**(code **)(*piVar1 + 0x90))(0,0,100);
      uVar37 = *(undefined4 *)(param_1 + 0x40a);
      (**(code **)(*piVar1 + 0x2c))(uVar37);
      FUN_004a1190();
      cVar4 = FUN_005fbd80(param_1 + 0x37e,s_btnUpPlayerEngine_007402ec);
      if (((cVar4 != '\0') &&
          (cVar4 = FUN_005fbd80(param_1 + 0x382,s_btnDnPlayerEngine_00740300), cVar4 != '\0')) &&
         (cVar4 = FUN_005fbf80(param_1 + 0x386,s_txtPlayerEngine_00740314), cVar4 != '\0')) {
        cVar4 = FUN_005fc1c0((undefined4 *)(param_1 + 0x38a),s_sliPlayerEngine_00740324);
        if (cVar4 != '\0') {
          piVar1 = *(int **)(param_1 + 0x38a);
          uVar36 = 100;
          uVar35 = 0;
          uVar34 = 0;
          (**(code **)(*piVar1 + 0x90))(0,0,100);
          uVar33 = *(undefined4 *)(param_1 + 0x40e);
          (**(code **)(*piVar1 + 0x2c))(uVar33);
          FUN_004a11f0();
          cVar4 = FUN_005fbd80(param_1 + 0x38e,s_btnUpOpponentEngines_00740334);
          if (((cVar4 != '\0') &&
              (cVar4 = FUN_005fbd80(param_1 + 0x392,s_btnDnOpponentEngines_0074034c), cVar4 != '\0')
              ) && (cVar4 = FUN_005fbf80(param_1 + 0x396,s_txtOpponentEngines_00740364),
                   cVar4 != '\0')) {
            cVar4 = FUN_005fc1c0((undefined4 *)(param_1 + 0x39a),s_sliOpponentEngines_00740378);
            if (cVar4 != '\0') {
              piVar1 = *(int **)(param_1 + 0x39a);
              uVar32 = 100;
              uVar31 = 0;
              uVar30 = 0;
              (**(code **)(*piVar1 + 0x90))(0,0,100);
              uVar29 = *(undefined4 *)(param_1 + 0x412);
              (**(code **)(*piVar1 + 0x2c))(uVar29);
              FUN_004a1250();
              cVar4 = FUN_005fbd80(param_1 + 0x39e,s_btnUpSpotterCrewChief_0074038c);
              if (((cVar4 != '\0') &&
                  (cVar4 = FUN_005fbd80(param_1 + 0x3a2,s_btnDnSpotterCrewChief_007403a4),
                  cVar4 != '\0')) &&
                 (cVar4 = FUN_005fbf80(param_1 + 0x3a6,s_txtSpotterCrewChief_007403bc),
                 cVar4 != '\0')) {
                cVar4 = FUN_005fc1c0((undefined4 *)(param_1 + 0x3aa),s_sliSpotterVolume_007403d0);
                if (cVar4 != '\0') {
                  piVar1 = *(int **)(param_1 + 0x3aa);
                  uVar28 = 100;
                  uVar27 = 0;
                  uVar26 = 0;
                  (**(code **)(*piVar1 + 0x90))(0,0,100);
                  uVar25 = *(undefined4 *)(param_1 + 0x416);
                  (**(code **)(*piVar1 + 0x2c))(uVar25);
                  FUN_004a12b0();
                  cVar4 = FUN_005fbd80(param_1 + 0x3ae,s_btnUpSkids_007403e4);
                  if (((cVar4 != '\0') &&
                      (cVar4 = FUN_005fbd80(param_1 + 0x3b2,s_btnDnSkids_007403f0), cVar4 != '\0'))
                     && (cVar4 = FUN_005fbf80(param_1 + 0x3b6,s_txtSkids_007403fc), cVar4 != '\0'))
                  {
                    cVar4 = FUN_005fc1c0((undefined4 *)(param_1 + 0x3ba),s_sliSkids_00740408);
                    if (cVar4 != '\0') {
                      piVar1 = *(int **)(param_1 + 0x3ba);
                      uVar24 = 100;
                      uVar23 = 0;
                      uVar22 = 0;
                      (**(code **)(*piVar1 + 0x90))(0,0,100);
                      uVar21 = *(undefined4 *)(param_1 + 0x41a);
                      (**(code **)(*piVar1 + 0x2c))(uVar21);
                      FUN_004a1310();
                      cVar4 = FUN_005fbd80(param_1 + 0x3be,s_btnUpCrashes_00740414);
                      if (((cVar4 != '\0') &&
                          (cVar4 = FUN_005fbd80(param_1 + 0x3c2,s_btnDnCrashes_00740424),
                          cVar4 != '\0')) &&
                         (cVar4 = FUN_005fbf80(param_1 + 0x3c6,s_txtCrashes_00740434), cVar4 != '\0'
                         )) {
                        cVar4 = FUN_005fc1c0((undefined4 *)(param_1 + 0x3ca),s_sliCrashes_00740440);
                        if (cVar4 != '\0') {
                          piVar1 = *(int **)(param_1 + 0x3ca);
                          uVar20 = 100;
                          uVar19 = 0;
                          uVar18 = 0;
                          (**(code **)(*piVar1 + 0x90))(0,0,100);
                          uVar17 = *(undefined4 *)(param_1 + 0x41e);
                          (**(code **)(*piVar1 + 0x2c))(uVar17);
                          FUN_004a1370();
                          cVar4 = FUN_005fbd80(param_1 + 0x3ce,s_btnUpOtherEffects_0074044c);
                          if (((cVar4 != '\0') &&
                              (cVar4 = FUN_005fbd80(param_1 + 0x3d2,s_btnDnOtherEffects_00740460),
                              cVar4 != '\0')) &&
                             (cVar4 = FUN_005fbf80(param_1 + 0x3d6,s_txtOtherEffects_00740474),
                             cVar4 != '\0')) {
                            cVar4 = FUN_005fc1c0((undefined4 *)(param_1 + 0x3da),
                                                 s_sliOtherEffects_00740484);
                            if (cVar4 != '\0') {
                              piVar1 = *(int **)(param_1 + 0x3da);
                              uVar16 = 100;
                              uVar15 = 0;
                              uVar14 = 0;
                              (**(code **)(*piVar1 + 0x90))(0,0,100);
                              uVar13 = *(undefined4 *)(param_1 + 0x422);
                              (**(code **)(*piVar1 + 0x2c))(uVar13);
                              FUN_004a13d0();
                              cVar4 = FUN_005fbd80(param_1 + 0x3de,s_btnUpUI_00740494);
                              if (((cVar4 != '\0') &&
                                  (cVar4 = FUN_005fbd80(param_1 + 0x3e2,s_btnDnUI_0074049c),
                                  cVar4 != '\0')) &&
                                 (cVar4 = FUN_005fbf80(param_1 + 0x3e6,s_txtUI_007404a4),
                                 cVar4 != '\0')) {
                                FUN_005fc1c0(param_1 + 0x3ea,s_sliUI_007404ac);
                              }
                              piVar1 = *(int **)(param_1 + 0x3ea);
                              if (piVar1 != (int *)0x0) {
                                (**(code **)(*piVar1 + 0x90))(0,0,100);
                                (**(code **)(*piVar1 + 0x2c))(*(undefined4 *)(param_1 + 0x426));
                                FUN_004a1430();
                              }
                              cVar4 = FUN_005fbd80(param_1 + 0x3ee,s_btnUpMaxSndsHrd_007404b4);
                              if ((cVar4 != '\0') &&
                                 (cVar4 = FUN_005fbd80(param_1 + 0x3f2,s_btnDnMaxSndsHrd_007404c4),
                                 cVar4 != '\0')) {
                                cVar4 = FUN_005fc1c0((undefined4 *)(param_1 + 0x3f6),
                                                     s_sliMaxSndsHrd_007404d4);
                                if ((cVar4 != '\0') &&
                                   (cVar4 = FUN_005fbf80(param_1 + 0x3fa,s_txtMaxSndsHrd_007404e4),
                                   cVar4 != '\0')) {
                                  piVar1 = *(int **)(param_1 + 0x3f6);
                                  uVar12 = 0x18;
                                  uVar11 = 8;
                                  uVar10 = 0;
                                  (**(code **)(*piVar1 + 0x90))(0,8,0x18);
                                  uVar9 = *(undefined4 *)(param_1 + 0x42a);
                                  (**(code **)(*piVar1 + 0x2c))(uVar9);
                                  FUN_004a1490();
                                  cVar4 = FUN_005fbe20((undefined4 *)(param_1 + 0x3fe),
                                                       s_chkInGameAudio_007404f4);
                                  if (cVar4 != '\0') {
                                    uVar5 = (uint)*(byte *)(param_1 + 0x42e);
                                    (**(code **)(**(int **)(param_1 + 0x3fe) + 0x2c))(uVar5);
                                    cVar4 = FUN_005fbe20((undefined4 *)(param_1 + 0x402),
                                                         s_ch3DSound_00740504);
                                    if (cVar4 != '\0') {
                                      uVar6 = (uint)*(byte *)(param_1 + 0x42f);
                                      (**(code **)(**(int **)(param_1 + 0x402) + 0x2c))(uVar6);
                                      if (*(int *)(param_1 + 0x20) != 0) {
                                        cVar4 = FUN_005fc300((undefined4 *)(param_1 + 0x460),
                                                             s_lstOutputType_00740510);
                                        if (cVar4 != '\x01') {
                                          *(undefined4 *)(param_1 + 0x460) = 0;
                                          iVar8 = *(int *)(param_1 + 0x430);
                                          while (0 < iVar8) {
                                            if (*(int *)(param_1 + 0x43c) == 0) {
                                              iVar7 = param_1 + 0x434;
                                            }
                                            else {
                                              iVar7 = FUN_0045b2b0();
                                            }
                                            if (iVar8 != 0) {
                                              *(int *)(param_1 + 0x430) = iVar8 + -1;
                                              iVar8 = iVar7;
                                              FUN_005cfe04(iVar7);
                                              *(undefined4 *)(iVar7 + 8) = 0;
                                              *(undefined4 *)(iVar7 + 0xc) = 0;
                                              *(undefined4 *)(iVar7 + 4) = 0;
                                              FUN_004a7630();
                                              if ((DAT_00fa1a52 & 1) == 0) {
                                                DAT_00fa1a52 = DAT_00fa1a52 | 1;
                                                FUN_006c4f40(&DAT_004a76a0,iVar8,unaff_EBX,uVar6,
                                                             uVar5,uVar9,uVar10,uVar11,uVar12,uVar13
                                                             ,uVar14,uVar15,uVar16,uVar17,uVar18,
                                                             uVar19,uVar20,uVar21,uVar22,uVar23,
                                                             uVar24,uVar25,uVar26,uVar27,uVar28,
                                                             uVar29,uVar30,uVar31,uVar32,uVar33,
                                                             uVar34,uVar35,uVar36,uVar37,uVar38,
                                                             uVar39,uVar40,unaff_EDI,unaff_ESI,
                                                             unaff_EBP);
                                              }
                                              FUN_005cfccc(iVar7);
                                            }
                                            iVar8 = *(int *)(param_1 + 0x430);
                                          }
                                          *(undefined4 *)(param_1 + 0x444) = 0;
                                          return 0;
                                        }
                                      }
                                      if (*(int *)(param_1 + 0x460) != 0) {
                                        FUN_006063b0();
                                      }
                                      iVar8 = *(int *)(param_1 + 0x44c);
                                      while (0 < iVar8) {
                                        iVar7 = *(int *)(param_1 + 0x458);
                                        if (iVar7 == 0) {
                                          iVar7 = param_1 + 0x450;
                                        }
                                        else {
                                          for (iVar2 = *(int *)(iVar7 + 8); iVar2 != 0;
                                              iVar2 = *(int *)(iVar2 + 8)) {
                                            iVar7 = iVar2;
                                          }
                                        }
                                        if (iVar8 != 0) {
                                          *(int *)(param_1 + 0x44c) = iVar8 + -1;
                                          iVar8 = iVar7;
                                          FUN_005cfe04(iVar7);
                                          *(undefined4 *)(iVar7 + 8) = 0;
                                          *(undefined4 *)(iVar7 + 0xc) = 0;
                                          *(undefined4 *)(iVar7 + 4) = 0;
                                          FUN_004a7660();
                                          if ((DAT_00fa1a53 & 1) == 0) {
                                            DAT_00fa1a53 = DAT_00fa1a53 | 1;
                                            FUN_006c4f40(&DAT_004a7690,iVar8,uVar6,uVar5,uVar9,
                                                         uVar10,uVar11,uVar12,uVar13,uVar14,uVar15,
                                                         uVar16,uVar17,uVar18,uVar19,uVar20,uVar21,
                                                         uVar22,uVar23,uVar24,uVar25,uVar26,uVar27,
                                                         uVar28,uVar29,uVar30,uVar31,uVar32,uVar33,
                                                         uVar34,uVar35,uVar36,uVar37,uVar38,uVar39,
                                                         uVar40,unaff_EDI,unaff_ESI,unaff_EBP);
                                          }
                                          FUN_005cfccc(iVar7);
                                        }
                                        iVar8 = *(int *)(param_1 + 0x44c);
                                      }
                                      if (*(int *)(param_1 + 0x460) != 0) {
                                        FUN_006063b0();
                                      }
                                      FUN_004a15f0();
                                      if (*(int *)(param_1 + 0x20) != 0) {
                                        cVar4 = FUN_005fc300((undefined4 *)(param_1 + 0x444),
                                                             s_lstSpotterSupport_00740520);
                                        if (cVar4 != '\x01') {
                                          *(undefined4 *)(param_1 + 0x444) = 0;
                                          return 0;
                                        }
                                      }
                                      if (*(int *)(param_1 + 0x444) != 0) {
                                        FUN_006063b0();
                                      }
                                      iVar8 = *(int *)(param_1 + 0x430);
                                      while (0 < iVar8) {
                                        iVar7 = *(int *)(param_1 + 0x43c);
                                        if (iVar7 == 0) {
                                          iVar7 = param_1 + 0x434;
                                        }
                                        else {
                                          for (iVar2 = *(int *)(iVar7 + 8); iVar2 != 0;
                                              iVar2 = *(int *)(iVar2 + 8)) {
                                            iVar7 = iVar2;
                                          }
                                        }
                                        if (iVar8 != 0) {
                                          *(int *)(param_1 + 0x430) = iVar8 + -1;
                                          iVar8 = iVar7;
                                          FUN_005cfe04(iVar7);
                                          bVar3 = DAT_00fa1a52;
                                          *(undefined4 *)(iVar7 + 8) = 0;
                                          *(undefined4 *)(iVar7 + 0xc) = 0;
                                          *(undefined4 *)(iVar7 + 4) = 0;
                                          if ((bVar3 & 1) == 0) {
                                            DAT_00fa1a52 = bVar3 | 1;
                                            FUN_006c4f40(&DAT_004a76a0,iVar8,uVar6,uVar5,uVar9,
                                                         uVar10,uVar11,uVar12,uVar13,uVar14,uVar15,
                                                         uVar16,uVar17,uVar18,uVar19,uVar20,uVar21,
                                                         uVar22,uVar23,uVar24,uVar25,uVar26,uVar27,
                                                         uVar28,uVar29,uVar30,uVar31,uVar32,uVar33,
                                                         uVar34,uVar35,uVar36,uVar37,uVar38,uVar39,
                                                         uVar40,unaff_EDI,unaff_ESI,unaff_EBP);
                                            if ((DAT_00fa1a52 & 1) == 0) {
                                              DAT_00fa1a52 = DAT_00fa1a52 | 1;
                                              FUN_006c4f40();
                                            }
                                          }
                                          FUN_005cfccc(iVar7);
                                        }
                                        iVar8 = *(int *)(param_1 + 0x430);
                                      }
                                      if (*(int *)(param_1 + 0x444) != 0) {
                                        FUN_006063b0();
                                      }
                                      FUN_004a14e0();
                                      cVar4 = FUN_005fbd80(param_1 + 0x468,
                                                           s_btnRestoreSoundDefaults_00740534);
                                      if (cVar4 != '\0') {
                                        FUN_004a47a0();
                                        return 1;
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return 0;
}


