/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0058b280 */

undefined1 __thiscall FUN_0058b280(int param_1_00,int *param_1,undefined4 param_2)

{
  undefined4 *puVar1;
  int *piVar2;
  char cVar3;
  int iVar4;
  undefined4 uVar5;
  int iVar6;
  int *piVar7;
  int *piVar8;
  undefined *puVar9;
  int *piVar10;
  int iVar11;
  int *piStack_f8;
  int *piStack_f4;
  int *piStack_f0;
  undefined1 *puVar12;
  int *piVar13;
  int *piVar14;
  int *piStack_dc;
  int *piStack_d8;
  int local_d4;
  int *piStack_d0;
  int *piStack_cc;
  undefined1 auStack_c8 [4];
  int local_c4 [9];
  int aiStack_a0 [34];
  undefined4 uStack_18;
  
  *(undefined4 *)(param_1_00 + 0x2b1) = param_2;
  *(undefined1 *)(param_1_00 + 0x12) = 0;
  *(undefined1 *)(param_1_00 + 0x13) = 0;
  piStack_f0 = (int *)0x58b2aa;
  local_d4 = param_1_00;
  iVar4 = getIntCount();
  piStack_f0 = param_1;
  *(int *)(param_1_00 + 0xe) = iVar4;
  piStack_f4 = (int *)0x58b2bc;
  cVar3 = FUN_0058c810();
  if (cVar3 == '\0') {
    return 0;
  }
  if (DAT_00d86fe8 == 0) {
    piStack_f4 = local_c4;
    piStack_f0 = (int *)0x2e;
    piStack_f8 = (int *)0x58b2e2;
    iVar4 = FUN_005cfce4();
    if ((iVar4 == 0) || (local_c4[0] == 0)) {
      DAT_00d86fe8 = 0;
    }
    else {
      piStack_f0 = (int *)0x58b2f6;
      DAT_00d86fe8 = FUN_00471360();
    }
  }
  iVar4 = DAT_00d86fe8;
  piStack_f0 = (int *)s_grpModemStatus_0075095c;
  puVar1 = (undefined4 *)(DAT_00d86fe8 + 10);
  *(int **)(DAT_00d86fe8 + 6) = param_1;
  piStack_f8 = (int *)0x58b314;
  piStack_f4 = puVar1;
  cVar3 = FUN_005fbce0();
  if (cVar3 != '\0') {
    piStack_f4 = (int *)(iVar4 + 0xe);
    piStack_f0 = (int *)s_lblModemStatus_0075094c;
    piStack_f8 = (int *)0x58b32d;
    cVar3 = FUN_005fbf80();
    if (cVar3 != '\0') {
      piStack_f4 = (int *)(iVar4 + 0x12);
      piStack_f0 = (int *)s_shdModemStatus_0075093c;
      piStack_f8 = (int *)0x58b346;
      cVar3 = FUN_005fbf80();
      if (cVar3 != '\0') {
        piStack_f4 = (int *)(iVar4 + 0x16);
        piStack_f0 = (int *)s_wtModemStatus_0075092c;
        piStack_f8 = (int *)0x58b35f;
        cVar3 = FUN_005fc020();
        if (cVar3 != '\0') {
          piStack_f4 = (int *)(iVar4 + 0x1a);
          piStack_f0 = (int *)s_btnModemStatusCancel_00750914;
          piStack_f8 = (int *)0x58b378;
          cVar3 = FUN_005fbdd0();
          if (cVar3 != '\0') {
            piStack_f0 = (int *)0x58b387;
            (**(code **)(*(int *)*puVar1 + 0x4c))();
            if (param_1 != (int *)0x0) {
              piStack_f0 = (int *)s_lstConnectVia_0075057c;
              piStack_f8 = (int *)0x58b3a2;
              piStack_f4 = (undefined4 *)(param_1_00 + 0x68);
              cVar3 = FUN_005fc300();
              if (cVar3 != '\x01') {
                *(undefined4 *)(param_1_00 + 0x68) = 0;
                return 0;
              }
            }
            if (*(int *)(param_1_00 + 0x68) != 0) {
              piStack_f0 = (int *)0x58b3c7;
              FUN_006063b0();
            }
            if (param_1 != (int *)0x0) {
              piStack_f0 = (int *)s_lstClientSpeeds_0075058c;
              piStack_f8 = (int *)0x58b3de;
              piStack_f4 = (undefined4 *)(param_1_00 + 0x80);
              cVar3 = FUN_005fc300();
              if (cVar3 != '\x01') {
                *(undefined4 *)(param_1_00 + 0x80) = 0;
                return 0;
              }
            }
            if (*(int *)(param_1_00 + 0x80) != 0) {
              piStack_f0 = (int *)0x58b406;
              FUN_006063b0();
            }
            piVar7 = (int *)0x0;
            piVar10 = (int *)(param_1_00 + 0x98);
            do {
              piStack_f8 = aiStack_a0;
              piStack_f4 = (int *)s_lstServerSpeeds_d_0075059c;
              piStack_f0 = piVar7;
              FUN_006c4f81();
              if (param_1 != (int *)0x0) {
                piStack_f0 = aiStack_a0;
                piStack_f8 = (int *)0x58b432;
                piStack_f4 = piVar10;
                cVar3 = FUN_005fc300();
                if (cVar3 != '\x01') goto LAB_0058b4c8;
              }
              if (*piVar10 != 0) {
                piStack_f0 = (int *)0x58b44c;
                FUN_006063b0();
              }
              piVar7 = (int *)((int)piVar7 + 1);
              piVar10 = piVar10 + 6;
            } while ((int)piVar7 < 8);
            piVar7 = (int *)(param_1_00 + 0x158);
            piVar8 = (int *)0x0;
            piVar10 = piVar7;
            do {
              piStack_f8 = aiStack_a0;
              piStack_f4 = (int *)s_lstMaxPlayers_d_007505b0;
              piStack_f0 = piVar8;
              FUN_006c4f81();
              if (param_1 != (int *)0x0) {
                piStack_f0 = aiStack_a0;
                piStack_f8 = (int *)0x58b48a;
                piStack_f4 = piVar10;
                cVar3 = FUN_005fc300();
                param_1_00 = local_d4;
                if (cVar3 != '\x01') {
LAB_0058b4c8:
                  *piVar10 = 0;
                  return 0;
                }
              }
              if (*piVar10 != 0) {
                piStack_f0 = (int *)0x58b49d;
                FUN_006063b0();
              }
              piVar8 = (int *)((int)piVar8 + 1);
              piVar10 = piVar10 + 6;
            } while ((int)piVar8 < 8);
            piStack_f0 = (int *)0x58b4ab;
            cVar3 = FUN_0056e3c0();
            if (cVar3 == '\0') {
              piStack_f0 = (int *)&DAT_00d86e98;
              piStack_f4 = (int *)0x58b4ed;
              (**(code **)(**(int **)(param_1_00 + 0x251) + 0x30))();
            }
            else {
              iVar4 = **(int **)(param_1_00 + 0x251);
              piStack_f0 = (int *)0x58b4bc;
              piStack_f0 = (int *)FUN_0056e430();
              piStack_f4 = (int *)0x58b4c6;
              (**(code **)(iVar4 + 0x30))();
            }
            piStack_f4 = (int *)&DAT_00d86ef0;
            piStack_f8 = (int *)0x58b4fd;
            (**(code **)(**(int **)(param_1_00 + 0x259) + 0x30))();
            piStack_f8 = (int *)&DAT_00d86f48;
            (**(code **)(**(int **)(param_1_00 + 0x261) + 0x30))();
            (**(code **)(**(int **)(param_1_00 + 0x269) + 0x30))(&DAT_00d86fa0);
            FUN_00606530(param_1_00 + 0x336);
            FUN_00606610(param_1_00 + 0x336);
            FUN_00606530(param_1_00 + 0x346);
            FUN_00606610(param_1_00 + 0x346);
            (**(code **)(**(int **)(param_1_00 + 0x241) + 0x78))(param_1_00 + 0x33a);
            (**(code **)(**(int **)(param_1_00 + 0x245) + 0x78))(param_1_00 + 0x33e);
            (**(code **)(**(int **)(param_1_00 + 0x230) + 0xa0))(param_1_00 + 0x342);
            if (*(int *)(param_1_00 + 0x2b1) != 0) {
              (**(code **)(**(int **)(param_1_00 + 0x2bd) + 0x78))(param_1_00 + 0x3ca);
              (**(code **)(**(int **)(param_1_00 + 0x2c1) + 0x78))(param_1_00 + 0x3ce);
              (**(code **)(**(int **)(param_1_00 + 0x2c5) + 0x78))(param_1_00 + 0x3d2);
              (**(code **)(**(int **)(param_1_00 + 0x2b5) + 0xa0))(param_1_00 + 0x3d6);
              FUN_00601ec0(param_1_00 + 0x3de);
              FUN_00601fa0(param_1_00 + 0x3da);
            }
            piVar10 = (int *)0x0;
            piStack_dc = (int *)0x0;
            cVar3 = FUN_005c7d30();
            if (cVar3 != '\0') {
              piStack_f4 = (int *)0x0;
              iVar4 = FUN_005c7d80();
              if (0 < iVar4) {
                iVar4 = param_1_00 + 0x38a;
                piVar8 = (int *)(param_1_00 + 0x402);
                piStack_f0 = (int *)&DAT_00d869cf;
                do {
                  uVar5 = FUN_005c7da0(piStack_f4,0x40);
                  piVar14 = piStack_f0;
                  FUN_006c4b00((undefined1 *)((int)piStack_f0 + -0x3f),uVar5);
                  *(undefined1 *)piVar14 = 0;
                  if ((int)piVar10 < 8) {
                    piStack_d0 = (int *)FUN_00596680(piStack_f4);
                    piVar14 = (int *)(param_1_00 + 0x44);
                    if (*piVar14 < *(int *)(param_1_00 + 0x48)) {
LAB_0058b719:
                      if (*(int *)(param_1_00 + 0x50) + *piVar14 * 0x28 != 0) {
                        FUN_00591630(piStack_d0);
                      }
                      iVar6 = *piVar14;
                      *piVar14 = iVar6 + 1;
                      piStack_f8 = (int *)(*(int *)(param_1_00 + 0x50) + -0x28 + (iVar6 + 1) * 0x28)
                      ;
                    }
                    else {
                      iVar6 = FUN_005cfce4(&stack0xffffff1c,
                                           (*(int *)(param_1_00 + 0x4c) +
                                           *(int *)(param_1_00 + 0x48)) * 0x28);
                      if (iVar6 != 0) {
                        iVar6 = 0;
                        *(int *)(param_1_00 + 0x48) =
                             *(int *)(param_1_00 + 0x48) + *(int *)(param_1_00 + 0x4c);
                        if (0 < *piVar14) {
                          iVar11 = 0;
                          do {
                            if (iVar11 != 0) {
                              FUN_005922e0(*(int *)(param_1_00 + 0x50) + iVar11);
                            }
                            iVar6 = iVar6 + 1;
                            iVar11 = iVar11 + 0x28;
                            piVar10 = piStack_dc;
                          } while (iVar6 < *piVar14);
                        }
                        FUN_00472730(*(undefined4 *)(param_1_00 + 0x50),*piVar14);
                        if (*(int *)(param_1_00 + 0x50) != 0) {
                          FUN_005cfccc(*(int *)(param_1_00 + 0x50));
                        }
                        *(undefined4 *)(param_1_00 + 0x50) = 0;
                        goto LAB_0058b719;
                      }
                      FUN_00590e20(&piStack_f8);
                    }
                    FUN_00596920();
                    if (piStack_f8 != (int *)(*(int *)(param_1_00 + 0x50) + *piVar14 * 0x28)) {
                      piStack_d0 = piStack_f8;
                      uVar5 = (**(code **)(*piStack_f8 + 4))();
                      FUN_00592570(param_1_00 + 0x54,param_1_00 + 0x68,uVar5,&piStack_d0);
                      uVar5 = (**(code **)(*piStack_f8 + 4))();
                      if ((int *)**(int **)(*piVar8 + 0x1ae) != (int *)0x0) {
                        (**(code **)(*(int *)**(int **)(*piVar8 + 0x1ae) + 0x68))(uVar5);
                      }
                      FUN_00596a40(piVar7 + -5);
                      iVar6 = *piVar7;
                      *(int **)(iVar4 + 4) = piVar10;
                      if (iVar6 != 0) {
                        FUN_00606530(iVar4);
                      }
                      piVar14 = piStack_f4;
                      iVar6 = 0;
                      if (0 < (int)(&DAT_00d7ffa0)[(int)piStack_f4]) {
                        iVar6 = (&DAT_00d7ffa0)[(int)piStack_f4] + -1;
                      }
                      if (*piVar7 != 0) {
                        FUN_00606850(iVar6);
                      }
                      FUN_0058f290(piVar10);
                      cVar3 = (&DAT_00d814e8)[(int)piVar14];
                      *(undefined1 *)(piVar10 + 0x36119a) = 0;
                      if (cVar3 != '\0') {
                        *(undefined1 *)(piVar10 + 0x36119a) = 1;
                        *(int *)(param_1_00 + 0x2e4) = *(int *)(param_1_00 + 0x2e4) + 1;
                      }
                      cVar3 = FUN_0056e3c0();
                      if (cVar3 != '\0') {
                        FUN_0056e3e0(&piStack_cc);
                        FUN_005c7e20(&piStack_d8,piStack_f4);
                        if (piStack_cc == piStack_d8) {
                          DAT_00d86e90 = piVar10;
                        }
                      }
                      piVar10 = (int *)((int)piVar10 + 1);
                      piVar8 = piVar8 + 1;
                      iVar4 = iVar4 + 8;
                      piVar7 = piVar7 + 6;
                      piStack_dc = piVar10;
                    }
                  }
                  puVar9 = (undefined *)((int)piStack_f4 + 1);
                  piStack_f0 = piStack_f0 + 0x10;
                  piStack_f4 = (int *)puVar9;
                  iVar6 = FUN_005c7d80();
                } while ((int)puVar9 < iVar6);
              }
            }
            cVar3 = FUN_005c7e70();
            if (cVar3 != '\0') {
              piStack_f4 = (int *)0x0;
              iVar4 = FUN_005c7ea0();
              if (0 < iVar4) {
                iVar4 = param_1_00 + 0x38a + (int)piVar10 * 8;
                piVar7 = (int *)(param_1_00 + 0x402 + (int)piVar10 * 4);
                piVar8 = (int *)(param_1_00 + 0x158 + (int)piVar10 * 0x18);
                puVar12 = &DAT_00d84630;
                do {
                  piVar14 = piStack_f4;
                  uVar5 = FUN_005c7f00(piStack_f4);
                  uVar5 = FUN_005c7ec0(piVar14,uVar5);
                  FUN_006c4f81(puVar12,s__s__s_007505c0,uVar5);
                  if ((int)piVar10 < 8) {
                    piStack_d8 = (int *)FUN_00596b40(piVar14);
                    piVar14 = (int *)(param_1_00 + 0x34);
                    if (*piVar14 < *(int *)(param_1_00 + 0x38)) {
LAB_0058b9d3:
                      if (*(int *)(param_1_00 + 0x40) + *piVar14 * 0x28 != 0) {
                        FUN_00591560(piStack_d8);
                      }
                      iVar6 = *piVar14;
                      *piVar14 = iVar6 + 1;
                      piStack_f8 = (int *)(*(int *)(param_1_00 + 0x40) + -0x28 + (iVar6 + 1) * 0x28)
                      ;
                    }
                    else {
                      piStack_f0 = (int *)0x0;
                      iVar6 = FUN_005cfce4(&piStack_f0,
                                           (*(int *)(param_1_00 + 0x3c) +
                                           *(int *)(param_1_00 + 0x38)) * 0x28);
                      if (iVar6 != 0) {
                        iVar6 = 0;
                        *(int *)(param_1_00 + 0x38) =
                             *(int *)(param_1_00 + 0x38) + *(int *)(param_1_00 + 0x3c);
                        if (0 < *piVar14) {
                          iVar11 = 0;
                          do {
                            if ((undefined1 *)((int)piStack_f0 + iVar11) != (undefined1 *)0x0) {
                              FUN_00592210(*(int *)(param_1_00 + 0x40) + iVar11);
                            }
                            iVar6 = iVar6 + 1;
                            iVar11 = iVar11 + 0x28;
                            piVar10 = piStack_dc;
                          } while (iVar6 < *piVar14);
                        }
                        FUN_00472700(*(undefined4 *)(param_1_00 + 0x40),*piVar14);
                        if (*(int *)(param_1_00 + 0x40) != 0) {
                          FUN_005cfccc(*(int *)(param_1_00 + 0x40));
                        }
                        *(int **)(param_1_00 + 0x40) = piStack_f0;
                        goto LAB_0058b9d3;
                      }
                      FUN_00590db0(&piStack_f8);
                    }
                    FUN_00596df0();
                    if (piStack_f8 != (int *)(*(int *)(param_1_00 + 0x40) + *piVar14 * 0x28)) {
                      piStack_d8 = piStack_f8;
                      uVar5 = (**(code **)(*piStack_f8 + 4))();
                      FUN_00592570(param_1_00 + 0x54,param_1_00 + 0x68,uVar5,&piStack_d8);
                      uVar5 = (**(code **)(*piStack_f8 + 4))();
                      if ((int *)**(int **)(*piVar7 + 0x1ae) != (int *)0x0) {
                        (**(code **)(*(int *)**(int **)(*piVar7 + 0x1ae) + 0x68))(uVar5);
                      }
                      FUN_00596f10(piVar8 + -5);
                      iVar6 = *piVar8;
                      *(int **)(iVar4 + 4) = piVar10;
                      if (iVar6 != 0) {
                        FUN_00606530(iVar4);
                      }
                      piVar14 = piStack_f4;
                      iVar6 = 0;
                      if (0 < (int)(&DAT_00d844ac)[(int)piStack_f4]) {
                        iVar6 = (&DAT_00d844ac)[(int)piStack_f4] + -1;
                      }
                      if (*piVar8 != 0) {
                        FUN_00606850(iVar6);
                      }
                      FUN_0058f290(piVar10);
                      cVar3 = (&DAT_00d814ee)[(int)piVar14];
                      *(undefined1 *)(piVar10 + 0x36119a) = 0;
                      if (cVar3 != '\0') {
                        *(undefined1 *)(piVar10 + 0x36119a) = 1;
                        *(int *)(param_1_00 + 0x2e4) = *(int *)(param_1_00 + 0x2e4) + 1;
                      }
                      piVar10 = (int *)((int)piVar10 + 1);
                      piVar7 = piVar7 + 1;
                      iVar4 = iVar4 + 8;
                      piVar8 = piVar8 + 6;
                      piStack_f4 = piVar14;
                      piStack_dc = piVar10;
                    }
                  }
                  iVar11 = (int)piStack_f4 + 1;
                  puVar12 = puVar12 + 0x18;
                  piStack_f4 = (int *)iVar11;
                  iVar6 = FUN_005c7ea0();
                } while (iVar11 < iVar6);
              }
            }
            piVar7 = (int *)0x0;
            piStack_f4 = (int *)0x0;
            iVar4 = FUN_005ca230();
            if (0 < iVar4) {
              iVar4 = param_1_00 + 0x34a + (int)piVar10 * 8;
              piVar8 = (int *)(param_1_00 + 0x402 + (int)piVar10 * 4);
              piVar14 = (int *)(param_1_00 + 0x98 + (int)piVar10 * 0x18);
              piVar13 = &DAT_00d84900;
              do {
                if ((int)piVar10 < 8) {
                  piStack_d8 = (int *)FUN_00595a90(piVar7);
                  piVar2 = (int *)(param_1_00 + 0x24);
                  if (*piVar2 < *(int *)(param_1_00 + 0x28)) {
LAB_0058bc03:
                    if (*piVar2 * 0xa0 + *(int *)(param_1_00 + 0x30) != 0) {
                      FUN_00591470(piStack_d8);
                    }
                    iVar6 = *piVar2;
                    *piVar2 = iVar6 + 1;
                    piStack_f8 = (int *)((iVar6 + 1) * 0xa0 + -0xa0 + *(int *)(param_1_00 + 0x30));
                  }
                  else {
                    piStack_f0 = (int *)0x0;
                    iVar6 = FUN_005cfce4(&piStack_f0,
                                         (*(int *)(param_1_00 + 0x2c) + *(int *)(param_1_00 + 0x28))
                                         * 0xa0);
                    if (iVar6 != 0) {
                      iVar6 = 0;
                      *(int *)(param_1_00 + 0x28) =
                           *(int *)(param_1_00 + 0x28) + *(int *)(param_1_00 + 0x2c);
                      if (0 < *piVar2) {
                        iVar11 = 0;
                        do {
                          if ((undefined1 *)((int)piStack_f0 + iVar11) != (undefined1 *)0x0) {
                            FUN_00592120(*(int *)(param_1_00 + 0x30) + iVar11);
                          }
                          iVar6 = iVar6 + 1;
                          iVar11 = iVar11 + 0xa0;
                          piVar10 = piStack_dc;
                        } while (iVar6 < *piVar2);
                      }
                      FUN_004726c0(*(undefined4 *)(param_1_00 + 0x30),*piVar2);
                      if (*(int *)(param_1_00 + 0x30) != 0) {
                        FUN_005cfccc(*(int *)(param_1_00 + 0x30));
                      }
                      *(int **)(param_1_00 + 0x30) = piStack_f0;
                      goto LAB_0058bc03;
                    }
                    FUN_00590d30(&piStack_f8);
                  }
                  FUN_00595d30();
                  piVar7 = piStack_f4;
                  if (piStack_f8 != (int *)(*piVar2 * 0xa0 + *(int *)(param_1_00 + 0x30))) {
                    piStack_d8 = piStack_f8;
                    uVar5 = (**(code **)(*piStack_f8 + 4))();
                    FUN_00606460(uVar5);
                    piStack_cc = *(int **)(param_1_00 + 0x54);
                    FUN_00592660(&piStack_d0,&piStack_cc,&piStack_d8);
                    FUN_00591700(auStack_c8);
                    uVar5 = (**(code **)(*piStack_f8 + 4))();
                    if ((int *)**(int **)(*piVar8 + 0x1ae) != (int *)0x0) {
                      (**(code **)(*(int *)**(int **)(*piVar8 + 0x1ae) + 0x68))(uVar5);
                    }
                    FUN_00595e90(piVar14 + -5);
                    iVar6 = *piVar14;
                    *(int **)(iVar4 + 4) = piVar10;
                    if (iVar6 != 0) {
                      FUN_00606530(iVar4);
                    }
                    iVar6 = 0;
                    if (0 < piStack_f8[0x23]) {
                      do {
                        iVar11 = FUN_00595e50(iVar6);
                        if (iVar11 == *piVar13) break;
                        iVar6 = iVar6 + 1;
                      } while (iVar6 < piStack_f8[0x23]);
                    }
                    if (piStack_f8[0x23] <= iVar6) {
                      iVar6 = 0;
                    }
                    if (*piVar14 != 0) {
                      FUN_00606850(iVar6);
                    }
                    FUN_0058f050(piVar10);
                    *(undefined1 *)(piVar10 + 0x36119a) = 0;
                    if ((&DAT_00d844b8)[(int)piStack_f4] != '\0') {
                      *(undefined1 *)(piVar10 + 0x36119a) = 1;
                      *(int *)(param_1_00 + 0x2e4) = *(int *)(param_1_00 + 0x2e4) + 1;
                    }
                    piVar10 = (int *)((int)piVar10 + 1);
                    piVar8 = piVar8 + 1;
                    iVar4 = iVar4 + 8;
                    piVar14 = piVar14 + 6;
                    piVar7 = piStack_f4;
                    piStack_dc = piVar10;
                  }
                }
                piVar7 = (int *)((int)piVar7 + 1);
                piVar13 = piVar13 + 1;
                piStack_f4 = piVar7;
                iVar6 = FUN_005ca230();
              } while ((int)piVar7 < iVar6);
            }
            piVar7 = (int *)0x0;
            piStack_f4 = (int *)0x0;
            iVar4 = FUN_005cbbd0();
            if (0 < iVar4) {
              iVar4 = param_1_00 + 0x34a + (int)piVar10 * 8;
              piVar8 = (int *)(param_1_00 + 0x402 + (int)piVar10 * 4);
              piVar14 = (int *)(param_1_00 + 0x98 + (int)piVar10 * 0x18);
              piVar13 = (int *)&DAT_00d86dc0;
              do {
                if ((int)piVar10 < 8) {
                  piStack_d8 = (int *)FUN_005960a0(piVar7);
                  piVar2 = (int *)(param_1_00 + 0x14);
                  if (*piVar2 < *(int *)(param_1_00 + 0x18)) {
LAB_0058beaf:
                    if (*(int *)(param_1_00 + 0x20) + *piVar2 * 0x54 != 0) {
                      FUN_00591320(piStack_d8);
                    }
                    iVar6 = *piVar2;
                    *piVar2 = iVar6 + 1;
                    piStack_f8 = (int *)(*(int *)(param_1_00 + 0x20) + -0x54 + (iVar6 + 1) * 0x54);
                  }
                  else {
                    iVar11 = 0;
                    piStack_f0 = (int *)0x0;
                    iVar6 = FUN_005cfce4(&piStack_f0,
                                         (*(int *)(param_1_00 + 0x1c) + *(int *)(param_1_00 + 0x18))
                                         * 0x54);
                    if (iVar6 != 0) {
                      *(int *)(param_1_00 + 0x18) =
                           *(int *)(param_1_00 + 0x18) + *(int *)(param_1_00 + 0x1c);
                      if (0 < *piVar2) {
                        iVar6 = 0;
                        do {
                          if ((undefined1 *)((int)piStack_f0 + iVar6) != (undefined1 *)0x0) {
                            FUN_00592060(*(int *)(param_1_00 + 0x20) + iVar6);
                          }
                          iVar11 = iVar11 + 1;
                          iVar6 = iVar6 + 0x54;
                        } while (iVar11 < *piVar2);
                      }
                      for (iVar6 = *piVar2; iVar6 != 0; iVar6 = iVar6 + -1) {
                        FUN_00596390();
                      }
                      if (*(int *)(param_1_00 + 0x20) != 0) {
                        FUN_005cfccc(*(int *)(param_1_00 + 0x20));
                      }
                      *(int **)(param_1_00 + 0x20) = piStack_f0;
                      goto LAB_0058beaf;
                    }
                    FUN_00590cb0(&piStack_f8);
                  }
                  FUN_00596390();
                  piVar7 = piStack_f4;
                  piVar10 = piStack_dc;
                  if (piStack_f8 != (int *)(*(int *)(param_1_00 + 0x20) + *piVar2 * 0x54)) {
                    piStack_d8 = piStack_f8;
                    uVar5 = (**(code **)(*piStack_f8 + 4))();
                    FUN_00606460(uVar5);
                    piStack_cc = *(int **)(param_1_00 + 0x54);
                    uVar5 = FUN_00592500(&piStack_cc,&piStack_d8);
                    FUN_00592850(auStack_c8,uVar5);
                    FUN_00591700(&piStack_d0);
                    uVar5 = (**(code **)(*piStack_f8 + 4))();
                    if ((int *)**(int **)(*piVar8 + 0x1ae) != (int *)0x0) {
                      (**(code **)(*(int *)**(int **)(*piVar8 + 0x1ae) + 0x68))(uVar5);
                    }
                    FUN_005964c0(piVar14 + -5);
                    iVar6 = *piVar14;
                    *(int **)(iVar4 + 4) = piStack_dc;
                    if (iVar6 != 0) {
                      FUN_00606530(iVar4);
                    }
                    iVar6 = 0;
                    if (0 < piStack_f8[0x10]) {
                      do {
                        iVar11 = FUN_00596490(iVar6);
                        if (iVar11 == *piVar13) break;
                        iVar6 = iVar6 + 1;
                      } while (iVar6 < piStack_f8[0x10]);
                    }
                    if (piStack_f8[0x10] <= iVar6) {
                      iVar6 = 0;
                    }
                    if (*piVar14 != 0) {
                      FUN_00606850(iVar6);
                    }
                    FUN_0058f050(piStack_dc);
                    *(undefined1 *)(piStack_dc + 0x36119a) = 0;
                    if ((&DAT_00d7f93c)[(int)piStack_f4] != '\0') {
                      *(undefined1 *)(piStack_dc + 0x36119a) = 1;
                      *(int *)(param_1_00 + 0x2e4) = *(int *)(param_1_00 + 0x2e4) + 1;
                    }
                    piStack_dc = (int *)((int)piStack_dc + 1);
                    piVar8 = piVar8 + 1;
                    iVar4 = iVar4 + 8;
                    piVar14 = piVar14 + 6;
                    piVar7 = piStack_f4;
                    piVar10 = piStack_dc;
                  }
                }
                piVar7 = (int *)((int)piVar7 + 1);
                piVar13 = piVar13 + 1;
                piStack_f4 = piVar7;
                iVar6 = FUN_005cbbd0();
              } while ((int)piVar7 < iVar6);
            }
            if (*(int *)(param_1_00 + 0x54) == 0) {
              iVar4 = param_1_00 + 0x58;
            }
            else {
              piStack_d8 = DAT_00d86e90;
              local_d4 = *(int *)(*(int *)(param_1_00 + 0x60) + 0x14);
              piVar10 = (int *)FUN_005924b0(auStack_c8,&piStack_d8);
              iVar4 = *piVar10;
            }
            if (((iVar4 != param_1_00 + 0x58) && (iVar4 != -0x14)) &&
               (*(int *)(param_1_00 + 0x68) != 0)) {
              FUN_00606850(DAT_00d86e90);
            }
            cVar3 = FUN_0056e3c0();
            if (cVar3 == '\0') {
              cVar3 = FUN_0056e100();
              if (cVar3 != '\0') {
                DAT_00d86e8c = 1;
              }
            }
            else {
              DAT_00d86e8c = 0;
            }
            FUN_0060b360();
            *(undefined4 *)(param_1_00 + 4) = uStack_18;
            if (*(int *)(param_1_00 + 0x2b1) != 0) {
              FUN_0058fc90();
            }
            iVar4 = 0;
            do {
              if ((&DAT_00d84668)[iVar4] != '\0') {
                FUN_0060b360();
              }
              iVar4 = iVar4 + 1;
            } while (iVar4 < 8);
            iVar4 = getIntCount();
            *(int *)(param_1_00 + 8) = iVar4;
            FUN_005901e0();
            if ((*(int *)(param_1_00 + 0x234) != 0) &&
               (piVar10 = (int *)**(int **)(*(int *)(param_1_00 + 0x234) + 0x1ae),
               piVar10 != (int *)0x0)) {
              (**(code **)(*piVar10 + 0x70))(0x8d4);
            }
            *(undefined1 *)(param_1_00 + 0x2e8) = 1;
            *(undefined1 *)(param_1_00 + 0x2e9) = 1;
            return 1;
          }
        }
      }
    }
  }
  return 0;
}


