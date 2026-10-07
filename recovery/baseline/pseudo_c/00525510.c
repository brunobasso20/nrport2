/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00525510 */

undefined4 FUN_00525510(void)

{
  bool bVar1;
  bool bVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  undefined4 uVar6;
  char *pcVar7;
  int iVar8;
  undefined1 *puVar9;
  char *pcVar10;
  int iStack_c;
  int *piStack_8;
  int *piStack_4;
  
  bVar1 = false;
  bVar2 = false;
  iVar4 = FUN_00536160();
  while (iVar4 = iVar4 + -1, -1 < iVar4) {
    iVar5 = FUN_00536260(iVar4);
    if (*(char *)(iVar5 + 8) == '\0') {
      bVar1 = true;
    }
    else {
      bVar2 = true;
    }
  }
  FUN_00525870();
  cVar3 = FUN_0056e2b0();
  if (cVar3 == '\0') {
    uVar6 = FUN_005cfd1a();
    iVar4 = FUN_005cfd14(uVar6);
    if ((iVar4 != 0) && (iVar4 = FUN_005cfd14(&DAT_0074baec), iVar4 != 0)) {
      iVar5 = 0;
      iVar4 = FUN_0040ecf0();
      if (0 < iVar4) {
        puVar9 = &DAT_00761080;
        do {
          FUN_00525bd0(puVar9,(&PTR_s_jack_guy_0071f8d0)[iVar5]);
          iVar5 = iVar5 + 1;
          puVar9 = puVar9 + 0x370;
          iVar4 = FUN_0040ecf0();
        } while (iVar5 < iVar4);
      }
      iStack_c = 0;
      iVar4 = FUN_0040ecf0();
      if (0 < iVar4) {
        pcVar10 = &DAT_00761080;
        do {
          iVar5 = 0;
          pcVar7 = pcVar10 + 0x44;
          iVar4 = 0x30;
          do {
            pcVar7[0xd6] = '\0';
            pcVar7[0xd7] = '\0';
            pcVar7[0xd8] = '\0';
            pcVar7[0xd9] = '\0';
            pcVar7[0] = '\0';
            pcVar7[1] = '\0';
            pcVar7[2] = '\0';
            pcVar7[3] = '\0';
            pcVar7 = pcVar7 + 4;
            iVar4 = iVar4 + -1;
          } while (iVar4 != 0);
          if ((bVar1) && (*pcVar10 != '\0')) {
            iVar4 = FUN_005d3eb0(pcVar10,pcVar10 + 0x40,0,0);
            if (iVar4 == 1) {
              pcVar7 = pcVar10 + 0x104;
              iVar4 = (**(code **)(**(int **)(pcVar10 + 0x40) + 0x24))(s_timeValue_0074baf4,pcVar7);
              if (iVar4 == 1) {
                (**(code **)**(undefined4 **)pcVar7)(0);
              }
              else {
                pcVar7[0] = '\0';
                pcVar7[1] = '\0';
                pcVar7[2] = '\0';
                pcVar7[3] = '\0';
              }
              iVar4 = 0;
              pcVar7 = pcVar10 + 0x10c;
              do {
                iVar8 = (**(code **)(**(int **)(pcVar10 + 0x40) + 0x24))
                                  ((&PTR_s_show_pole_0074bab8)[iVar5],pcVar7);
                if (iVar8 == 1) {
                  (**(code **)**(undefined4 **)pcVar7)(0);
                  pcVar10[iVar4 + 0x114] = (char)iVar5;
                  iVar4 = iVar4 + 1;
                  pcVar7 = pcVar7 + 4;
                  if (1 < iVar4) goto LAB_005256a1;
                }
                iVar5 = iVar5 + 1;
              } while (iVar5 < 3);
              if (iVar4 < 2) {
                pcVar7 = pcVar10 + iVar4 * 4 + 0x10c;
                do {
                  pcVar7[0] = '\0';
                  pcVar7[1] = '\0';
                  pcVar7[2] = '\0';
                  pcVar7[3] = '\0';
                  pcVar10[iVar4 + 0x114] = -1;
                  iVar4 = iVar4 + 1;
                  pcVar7 = pcVar7 + 4;
                } while (iVar4 < 2);
              }
LAB_005256a1:
              pcVar7 = pcVar10 + 0x108;
              iVar4 = (**(code **)(**(int **)(pcVar10 + 0x40) + 0x28))(s_paintjob_0074bb00,pcVar7);
              if (iVar4 == 1) {
                if (DAT_00bd786c == 0) {
                  iVar4 = (**(code **)(**(int **)pcVar7 + 4))(&DAT_00bd786c);
                  if (iVar4 != 1) {
                    DAT_00bd786c = 0;
                  }
                }
                else {
                  iVar4 = (**(code **)(**(int **)pcVar7 + 4))(&piStack_8);
                  if (iVar4 == 1) {
                    (**(code **)(*piStack_8 + 4))();
                    (**(code **)**(undefined4 **)pcVar7)(DAT_00bd786c);
                  }
                }
              }
              else {
                pcVar7[0] = '\0';
                pcVar7[1] = '\0';
                pcVar7[2] = '\0';
                pcVar7[3] = '\0';
              }
            }
          }
          if ((bVar2) && (pcVar10[0x20] != '\0')) {
            iVar4 = FUN_005d3eb0(pcVar10 + 0x20,pcVar10 + 0x116,0,0);
            if (iVar4 == 1) {
              pcVar7 = pcVar10 + 0x1da;
              iVar4 = (**(code **)(**(int **)(pcVar10 + 0x116) + 0x24))(s_timeValue_0074bb0c,pcVar7)
              ;
              if (iVar4 == 1) {
                (**(code **)**(undefined4 **)pcVar7)(0);
              }
              else {
                pcVar7[0] = '\0';
                pcVar7[1] = '\0';
                pcVar7[2] = '\0';
                pcVar7[3] = '\0';
              }
              iVar5 = 0;
              iVar4 = 0;
              pcVar7 = pcVar10 + 0x1e2;
              do {
                iVar8 = (**(code **)(**(int **)(pcVar10 + 0x116) + 0x24))
                                  ((&PTR_s_show_pole_0074bab8)[iVar4],pcVar7);
                if (iVar8 == 1) {
                  (**(code **)**(undefined4 **)pcVar7)(0);
                  pcVar10[iVar5 + 0x1ea] = (char)iVar4;
                  iVar5 = iVar5 + 1;
                  pcVar7 = pcVar7 + 4;
                  if (1 < iVar5) goto LAB_005257d0;
                }
                iVar4 = iVar4 + 1;
              } while (iVar4 < 3);
              if (iVar5 < 2) {
                pcVar7 = pcVar10 + iVar5 * 4 + 0x1e2;
                do {
                  pcVar7[0] = '\0';
                  pcVar7[1] = '\0';
                  pcVar7[2] = '\0';
                  pcVar7[3] = '\0';
                  pcVar10[iVar5 + 0x1ea] = -1;
                  iVar5 = iVar5 + 1;
                  pcVar7 = pcVar7 + 4;
                } while (iVar5 < 2);
              }
LAB_005257d0:
              pcVar7 = pcVar10 + 0x1de;
              iVar4 = (**(code **)(**(int **)(pcVar10 + 0x116) + 0x28))(s_paintjob_0074bb18,pcVar7);
              if (iVar4 == 1) {
                if (DAT_00bd786c == 0) {
                  iVar4 = (**(code **)(**(int **)pcVar7 + 4))(&DAT_00bd786c);
                  if (iVar4 != 1) {
                    DAT_00bd786c = 0;
                  }
                }
                else {
                  iVar4 = (**(code **)(**(int **)pcVar7 + 4))(&piStack_4);
                  if (iVar4 == 1) {
                    (**(code **)(*piStack_4 + 4))();
                    (**(code **)**(undefined4 **)pcVar7)(DAT_00bd786c);
                  }
                }
              }
              else {
                pcVar7[0] = '\0';
                pcVar7[1] = '\0';
                pcVar7[2] = '\0';
                pcVar7[3] = '\0';
              }
            }
          }
          pcVar10 = pcVar10 + 0x370;
          iStack_c = iStack_c + 1;
          iVar4 = FUN_0040ecf0();
        } while (iStack_c < iVar4);
      }
    }
  }
  return 1;
}


