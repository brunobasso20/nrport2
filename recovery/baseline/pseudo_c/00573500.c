/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573500 */

undefined4 FUN_00573500(int param_1)

{
  undefined4 *puVar1;
  int *piVar2;
  char cVar3;
  undefined4 uVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  char *pcVar8;
  int iVar9;
  int iVar10;
  undefined4 local_86c;
  int iStack_868;
  int *local_864;
  int *piStack_860;
  int *piStack_85c;
  int *piStack_858;
  int local_854;
  int local_850;
  int iStack_84c;
  int iStack_848;
  int local_844;
  int local_840;
  int iStack_83c;
  int iStack_838;
  int local_834;
  char local_830 [16];
  char acStack_820 [16];
  undefined1 local_810 [1032];
  undefined1 auStack_408 [1032];
  
  local_86c = 1;
  FUN_00573480();
  local_834 = *(int *)(param_1 + 0x10);
  local_844 = 0;
  if (local_834 < 1) {
    return 1;
  }
  do {
    iVar9 = 0;
    local_854 = *(int *)(*(int *)(param_1 + 0xc) + local_844 * 4);
    iVar10 = *(int *)(local_854 + 0x46);
    if (0 < iVar10) {
      do {
        iVar7 = *(int *)(*(int *)(*(int *)(local_854 + 0x52) + iVar9 * 4) + 0x1d);
        if ((((iVar7 != 0) && (*(int *)(iVar7 + 8) == 0)) && (*(int *)(iVar7 + 0x14) != 0)) &&
           (iVar6 = *(int *)(*(int *)(iVar7 + 0x14) + 0x10), iVar6 != 0)) {
          FUN_00573a00(local_810,iVar6);
          local_864 = (int *)0x0;
          iVar5 = FUN_005d3d80(local_810,&local_864);
          iVar6 = DAT_0074f3dc;
          if (iVar5 == 1) {
            DAT_0074f3dc = DAT_0074f3dc + 1;
            FUN_006c4f81(local_830,s__WEA_d_0074f5bc,iVar6);
            iVar6 = FUN_005d8c50(local_830);
            if (iVar6 == 0) {
              local_86c = 0;
              (**(code **)(*local_864 + 4))();
            }
            else {
              uVar4 = *(undefined4 *)(*(int *)(iVar7 + 0x14) + 0xc);
              piStack_858 = (int *)0x0;
              FUN_005d3e50(uVar4);
              iVar7 = FUN_005d39d0(uVar4,&piStack_858,1);
              if (iVar7 != 0) {
                iVar6 = FUN_005cfce4(&iStack_83c,0x1c);
                iVar7 = iStack_83c;
                if ((iVar6 != 0) && (iStack_83c != 0)) {
                  pcVar8 = local_830;
                  do {
                    cVar3 = *pcVar8;
                    pcVar8[iStack_83c - (int)local_830] = cVar3;
                    pcVar8 = pcVar8 + 1;
                  } while (cVar3 != '\0');
                  *(int **)(iStack_83c + 0x14) = local_864;
                  *(int **)(iStack_83c + 0x10) = piStack_858;
                  *(undefined4 *)(iStack_83c + 0x18) = 0;
                  if (DAT_00c7212c < DAT_00c72130) {
LAB_005736e9:
                    piVar2 = (int *)(DAT_00c72138 + DAT_00c7212c * 4);
                    if (piVar2 != (int *)0x0) {
                      *piVar2 = iVar7;
                    }
                    DAT_00c7212c = DAT_00c7212c + 1;
                    iVar7 = DAT_00c72138 + DAT_00c7212c * 4;
                    iVar6 = iVar7 + -4;
                  }
                  else {
                    iStack_868 = 0;
                    iVar6 = FUN_005cfce4(&iStack_868,(DAT_00c72134 + DAT_00c72130) * 4);
                    if (iVar6 != 0) {
                      DAT_00c72130 = DAT_00c72130 + DAT_00c72134;
                      iVar6 = 0;
                      if (0 < DAT_00c7212c) {
                        do {
                          puVar1 = (undefined4 *)(iStack_868 + iVar6 * 4);
                          if (puVar1 != (undefined4 *)0x0) {
                            *puVar1 = *(undefined4 *)(DAT_00c72138 + iVar6 * 4);
                          }
                          iVar6 = iVar6 + 1;
                        } while (iVar6 < DAT_00c7212c);
                      }
                      if (DAT_00c72138 != 0) {
                        FUN_005cfccc(DAT_00c72138);
                      }
                      DAT_00c72138 = iStack_868;
                      goto LAB_005736e9;
                    }
                    iVar7 = DAT_00c72138 + DAT_00c7212c * 4;
                    iVar6 = iVar7;
                  }
                  if (iVar6 == iVar7) {
                    local_86c = 0;
                  }
                  goto LAB_00573747;
                }
                (**(code **)(*piStack_858 + 4))();
              }
              local_86c = 0;
            }
          }
        }
LAB_00573747:
        iVar9 = iVar9 + 1;
      } while (iVar9 < iVar10);
    }
    iVar10 = *(int *)(local_854 + 0x4a);
    local_850 = 0;
    iVar9 = local_854;
    local_840 = iVar10;
    if (0 < iVar10) {
      do {
        iStack_84c = 0;
        iStack_848 = *(int *)(*(int *)(iVar9 + 0x56) + local_850 * 4);
        if (0 < *(int *)(iStack_848 + 0x59)) {
          iVar7 = 0;
          do {
            iVar10 = 0;
            do {
              if (((*(int *)(iStack_848 + 0x5d) != 0) &&
                  (iVar9 = *(int *)(iVar10 + iVar7 + *(int *)(iStack_848 + 0x5d)), iVar9 != 0)) &&
                 ((*(int *)(iVar9 + 8) == 0 &&
                  ((*(int *)(iVar9 + 0x14) != 0 &&
                   (iVar6 = *(int *)(*(int *)(iVar9 + 0x14) + 0x10), iVar6 != 0)))))) {
                FUN_00573a00(auStack_408,iVar6);
                piStack_85c = (int *)0x0;
                iVar5 = FUN_005d3d80(auStack_408,&piStack_85c);
                iVar6 = DAT_0074f3dc;
                if (iVar5 == 1) {
                  DAT_0074f3dc = DAT_0074f3dc + 1;
                  FUN_006c4f81(acStack_820,s__WEA_d_0074f5c4,iVar6);
                  iVar6 = FUN_005d8c50(acStack_820);
                  if (iVar6 == 0) {
                    local_86c = 0;
                    (**(code **)(*piStack_85c + 4))();
                  }
                  else {
                    uVar4 = *(undefined4 *)(*(int *)(iVar9 + 0x14) + 0xc);
                    piStack_860 = (int *)0x0;
                    FUN_005d3e50(uVar4);
                    iVar9 = FUN_005d39d0(uVar4,&piStack_860,1);
                    if (iVar9 != 0) {
                      iVar6 = FUN_005cfce4(&iStack_838,0x1c);
                      iVar9 = iStack_838;
                      if ((iVar6 != 0) && (iStack_838 != 0)) {
                        pcVar8 = acStack_820;
                        do {
                          cVar3 = *pcVar8;
                          pcVar8[iStack_838 - (int)acStack_820] = cVar3;
                          pcVar8 = pcVar8 + 1;
                        } while (cVar3 != '\0');
                        *(int **)(iStack_838 + 0x14) = piStack_85c;
                        *(int **)(iStack_838 + 0x10) = piStack_860;
                        *(undefined4 *)(iStack_838 + 0x18) = 0;
                        if (DAT_00c7212c < DAT_00c72130) {
LAB_00573927:
                          piVar2 = (int *)(DAT_00c72138 + DAT_00c7212c * 4);
                          if (piVar2 != (int *)0x0) {
                            *piVar2 = iVar9;
                          }
                          DAT_00c7212c = DAT_00c7212c + 1;
                          iVar9 = DAT_00c72138 + DAT_00c7212c * 4;
                          iVar6 = iVar9 + -4;
                        }
                        else {
                          iStack_868 = 0;
                          iVar6 = FUN_005cfce4(&iStack_868,(DAT_00c72134 + DAT_00c72130) * 4);
                          if (iVar6 != 0) {
                            DAT_00c72130 = DAT_00c72130 + DAT_00c72134;
                            iVar6 = 0;
                            if (0 < DAT_00c7212c) {
                              do {
                                puVar1 = (undefined4 *)(iStack_868 + iVar6 * 4);
                                if (puVar1 != (undefined4 *)0x0) {
                                  *puVar1 = *(undefined4 *)(DAT_00c72138 + iVar6 * 4);
                                }
                                iVar6 = iVar6 + 1;
                              } while (iVar6 < DAT_00c7212c);
                            }
                            if (DAT_00c72138 != 0) {
                              FUN_005cfccc(DAT_00c72138);
                            }
                            DAT_00c72138 = iStack_868;
                            goto LAB_00573927;
                          }
                          iVar9 = DAT_00c72138 + DAT_00c7212c * 4;
                          iVar6 = iVar9;
                        }
                        if (iVar6 == iVar9) {
                          local_86c = 0;
                        }
                        goto LAB_00573985;
                      }
                      (**(code **)(*piStack_860 + 4))();
                    }
                    local_86c = 0;
                  }
                }
              }
LAB_00573985:
              iVar10 = iVar10 + 4;
            } while (iVar10 < 0x14);
            iStack_84c = iStack_84c + 1;
            iVar7 = iVar7 + 0x53a;
            iVar9 = local_854;
            iVar10 = local_840;
          } while (iStack_84c < *(int *)(iStack_848 + 0x59));
        }
        local_850 = local_850 + 1;
      } while (local_850 < iVar10);
    }
    local_844 = local_844 + 1;
    if (local_834 <= local_844) {
      return local_86c;
    }
  } while( true );
}


