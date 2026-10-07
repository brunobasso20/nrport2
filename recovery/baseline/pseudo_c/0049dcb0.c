/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0049dcb0 */

undefined4 __fastcall FUN_0049dcb0(int param_1)

{
  int *piVar1;
  int iVar2;
  int *piVar3;
  int *piVar4;
  int iVar5;
  int iVar6;
  char cVar7;
  int iVar8;
  char *local_48 [18];
  
  local_48[0] = s_defSteerng_0073fbc8;
  local_48[1] = s_defSteerng_0073fbd4;
  local_48[2] = s_defThrtl_0073fbe0;
  local_48[3] = s_defBrake_0073fbec;
  local_48[4] = s_defClutch_0073fbf8;
  local_48[5] = s_defShiftUp_0073fc04;
  local_48[6] = s_defShiftDwn_0073fc10;
  local_48[7] = s_defCockpitLook_0073fc1c;
  local_48[8] = s_defCockpitLook_0073fc2c;
  local_48[9] = s_defRaiseArm_0073fc3c;
  local_48[10] = s_defReverse_0073fc48;
  local_48[0xb] = s_defNeutral_0073fc54;
  local_48[0xc] = s_def1stGear_0073fc60;
  local_48[0xd] = s_def2ndGear_0073fc6c;
  local_48[0xe] = s_def3rdGear_0073fc78;
  local_48[0xf] = s_def4thGear_0073fc84;
  local_48[0x10] = s_def5thGear_0073fc90;
  local_48[0x11] = s_def6thGear_0073fc9c;
  iVar8 = 0;
  do {
    piVar1 = (int *)(param_1 + 0x85 + iVar8 * 4);
    cVar7 = FUN_005fbdd0(piVar1,local_48[iVar8]);
    if (cVar7 == '\0') {
      return 0;
    }
    if (iVar8 == 0) {
      *(undefined4 *)(param_1 + 0xcd) = *(undefined4 *)(*(int *)(param_1 + 0x85) + 0x1de);
      *(undefined4 *)(param_1 + 0xd1) = 0xfff90825;
    }
    iVar2 = *piVar1;
    FUN_0060bfa0(0x2715);
    iVar6 = *(int *)(param_1 + 0xd1);
    iVar5 = *(int *)(param_1 + 0xd1);
    if (*(int *)(iVar2 + 0x1de) != iVar5) {
      *(int *)(iVar2 + 0x1de) = iVar5;
      if (*(char *)(iVar2 + 0x8f) != '\0') {
        FUN_00616bf0(4,iVar6);
      }
      (**(code **)(**(int **)(iVar2 + 0x1fa) + 8))();
    }
    iVar8 = iVar8 + 1;
  } while (iVar8 < 0x12);
  cVar7 = FUN_005fc350(param_1 + 0x81,s_radGearbox_0073fca8);
  if (cVar7 != '\0') {
    FUN_0060a670(*(undefined4 *)(param_1 + 0x129));
    cVar7 = FUN_005fbe20((undefined4 *)(param_1 + 0xd5),s_chkForceFeedback_0073fcb4);
    if (cVar7 != '\0') {
      (**(code **)(**(int **)(param_1 + 0xd5) + 0x2c))(*(undefined1 *)(param_1 + 0x132));
      cVar7 = FUN_005fbd80(param_1 + 0xd9,s_btnUpFFStrength_0073fcc8);
      if ((((cVar7 != '\0') &&
           (cVar7 = FUN_005fbd80(param_1 + 0xdd,s_btnDnFFStrength_0073fcd8), cVar7 != '\0')) &&
          (cVar7 = FUN_005fbf80(param_1 + 0xe1,s_txtFFStrength_0073fce8), cVar7 != '\0')) &&
         (((cVar7 = FUN_005fc1c0(param_1 + 0xe5,s_sliFFStrength_0073fcf8), cVar7 != '\0' &&
           (cVar7 = FUN_005fbd80(param_1 + 0xe9,s_btnUpFFDamping_0073fd08), cVar7 != '\0')) &&
          ((cVar7 = FUN_005fbd80(param_1 + 0xed,s_btnDnFFDamping_0073fd18), cVar7 != '\0' &&
           (cVar7 = FUN_005fbf80(param_1 + 0xf1,s_txtFFDamping_0073fd28), cVar7 != '\0')))))) {
        cVar7 = FUN_005fc1c0((undefined4 *)(param_1 + 0xf5),s_sliFFDamping_0073fd38);
        if (((cVar7 != '\0') &&
            (cVar7 = FUN_005fbd80(param_1 + 0xf9,s_btnUpFFLatency_0073fd48), cVar7 != '\0')) &&
           ((cVar7 = FUN_005fbd80(param_1 + 0xfd,s_btnDnFFLatency_0073fd58), cVar7 != '\0' &&
            (cVar7 = FUN_005fbf80(param_1 + 0x101,s_txtFFLatency_0073fd68), cVar7 != '\0')))) {
          cVar7 = FUN_005fc1c0((undefined4 *)(param_1 + 0x105),s_sliFFLatency_0073fd78);
          if (cVar7 != '\0') {
            piVar1 = *(int **)(param_1 + 0xe5);
            (**(code **)(*piVar1 + 0x90))(0,0,100);
            piVar3 = *(int **)(param_1 + 0xf5);
            (**(code **)(*piVar3 + 0x90))(0,0,100);
            piVar4 = *(int **)(param_1 + 0x105);
            (**(code **)(*piVar4 + 0x90))(0,0,0xfa);
            (**(code **)(*piVar1 + 0x2c))(*(undefined4 *)(param_1 + 0x133));
            (**(code **)(*piVar3 + 0x2c))(*(undefined4 *)(param_1 + 0x137));
            (**(code **)(*piVar4 + 0x2c))(*(undefined4 *)(param_1 + 0x13b));
            FUN_004a0380();
            FUN_004a03e0();
            FUN_004a0440();
            cVar7 = FUN_005fc350(param_1 + 0x125,s_radJoystkDrvr_0073fd88);
            if (cVar7 != '\0') {
              FUN_0060a670(*(undefined4 *)(param_1 + 0x12d));
              cVar7 = FUN_005fbe20((undefined4 *)(param_1 + 0x109),s_chkAutoShift_0073fd98);
              if ((((cVar7 != '\0') &&
                   (cVar7 = FUN_005fbe20(param_1 + 0x10d,s_chkAutoClutch_0073fda8), cVar7 != '\0'))
                  && (cVar7 = FUN_005fbe20(param_1 + 0x111,s_chkBrakingHelp_0073fdb8), cVar7 != '\0'
                     )) && (cVar7 = FUN_005fbe20(param_1 + 0x115,s_chkThrottleHelp_0073fdc8),
                           cVar7 != '\0')) {
                cVar7 = FUN_005fbe20((undefined4 *)(param_1 + 0x119),s_chkStabilityControl_0073fdd8)
                ;
                if (cVar7 != '\0') {
                  iVar8 = *(int *)(param_1 + 0x129);
                  piVar1 = *(int **)(param_1 + 0x109);
                  if (iVar8 == 2) {
                    (**(code **)(*piVar1 + 0x2c))(0);
                    (**(code **)(*piVar1 + 0x48))();
                  }
                  else {
                    (**(code **)(*piVar1 + 0x2c))(*(undefined4 *)(param_1 + 0x13f));
                    (**(code **)(*piVar1 + 0x44))();
                  }
                  if ((*(int *)(param_1 + 0x13f) == 0) || (iVar8 == 2)) {
                    piVar1 = *(int **)(param_1 + 0x10d);
                    (**(code **)(*piVar1 + 0x2c))(*(undefined4 *)(param_1 + 0x143));
                    (**(code **)(*piVar1 + 0x44))();
                  }
                  else {
                    piVar1 = *(int **)(param_1 + 0x10d);
                    (**(code **)(*piVar1 + 0x2c))(1);
                    (**(code **)(*piVar1 + 0x48))();
                  }
                  (**(code **)(**(int **)(param_1 + 0x119) + 0x2c))
                            (*(undefined4 *)(param_1 + 0x14f));
                  (**(code **)(**(int **)(param_1 + 0x111) + 0x2c))
                            (*(undefined4 *)(param_1 + 0x147));
                  (**(code **)(**(int **)(param_1 + 0x115) + 0x2c))
                            (*(undefined4 *)(param_1 + 0x14b));
                  cVar7 = FUN_005fbe20((undefined4 *)(param_1 + 0x11d),s_chkShowRacingLine_0073fdec)
                  ;
                  if (cVar7 != '\0') {
                    (**(code **)(**(int **)(param_1 + 0x11d) + 0x2c))
                              (*(undefined1 *)(param_1 + 0x156));
                    cVar7 = FUN_005fbe20((undefined4 *)(param_1 + 0x121),
                                         s_chkReportLapTimes_0073fe00);
                    if (cVar7 != '\0') {
                      (**(code **)(**(int **)(param_1 + 0x121) + 0x2c))
                                (*(undefined1 *)(param_1 + 0x155));
                      FUN_004a45a0();
                      FUN_004a4e30();
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
  return 0;
}


