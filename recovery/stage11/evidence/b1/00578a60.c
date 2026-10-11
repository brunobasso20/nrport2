/* NR2003.exe @ 00578a60 FUN_00578a60 */

void __fastcall FUN_00578a60(int param_1)

{
  int *piVar1;
  int **ppiVar2;
  int iVar3;
  int *piVar4;
  int **ppiVar5;
  int iVar6;
  char cVar7;
  int *piVar8;
  uint uVar9;
  int **ppiVar10;
  undefined4 uStack_34;
  undefined4 *local_30;
  undefined4 uStack_2c;
  int iStack_28;
  int ***pppiStack_24;
  int **local_10;
  int **local_c;
  int *local_8;
  undefined4 local_4;
  
  if (*(int *)(param_1 + 0x6c18) != 0) {
    *(undefined4 *)(param_1 + 0x6c18) = 0;
  }
  if (*(int *)(param_1 + 4) != 0) {
    *(undefined4 *)(param_1 + 4) = 0;
  }
  local_c = (int **)(param_1 + 0x9940);
  local_4 = 5;
  do {
    piVar8 = *local_c;
    ppiVar10 = (int **)piVar8[4];
    while (ppiVar10 != (int **)0x0) {
      if (*(short *)(ppiVar10 + 2) == 0) {
        pppiStack_24 = &local_10;
        *(undefined2 *)(ppiVar10 + 2) = 1;
        iStack_28 = 0x578ace;
        local_10 = ppiVar10;
        FUN_00579a90();
        local_8 = *local_10;
        if (*(char *)(local_8 + 0x16) == '\0') {
          pppiStack_24 = (int ***)&local_8;
          iStack_28 = 0x578aeb;
          FUN_00579a70();
          *(undefined *)(local_8 + 0x16) = 1;
        }
        pppiStack_24 = (int ***)local_10[1];
        if (((int *)pppiStack_24)[3] != 0) {
          iStack_28 = 0x578b09;
          FUN_00579a50();
        }
      }
      if (piVar8 == *ppiVar10) {
        ppiVar10 = *(int ***)((int)ppiVar10 + 0x42);
      }
      else if (piVar8 == ppiVar10[1]) {
        ppiVar10 = *(int ***)((int)ppiVar10 + 0x4a);
      }
    }
    local_c = local_c + 1;
    local_4 = local_4 + -1;
  } while (local_4 != 0);
  piVar8 = (int *)0x2;
  local_8 = (int *)0x2;
  iVar3 = param_1 + *(int *)(param_1 + 0x6c14) * 0x2c44;
  ppiVar10 = (int **)(iVar3 + 0x1390);
  local_10 = (int **)(iVar3 + 0x1390 +
                     *(int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44) * 4);
  local_4 = 0;
  if (ppiVar10 != local_10) {
    do {
      pppiStack_24 = (int ***)0x578b81;
      FUN_00577fa0();
      pppiStack_24 = (int ***)0x578b88;
      cVar7 = FUN_00578390();
      if (cVar7 != '\0') {
        piVar4 = *ppiVar10;
        if ((*(char *)(*piVar4 + 0x5a) != '\0') ||
           (local_4 = local_4 & 0xffffff00, *(char *)(piVar4[1] + 0x5a) != '\0')) {
          local_4 = CONCAT31(local_4._1_3_,1);
        }
        if (*(short *)(piVar4 + 2) == 0) {
          piVar1 = (int *)(param_1 + 0x6c18);
          *(undefined2 *)(piVar4 + 2) = 1;
          *(int **)(param_1 + 0x6c1c + *piVar1 * 4) = piVar4;
          *piVar1 = *piVar1 + 1;
          pppiStack_24 = (int ***)*piVar4;
          iStack_28 = 0x578bd9;
          FUN_00579a50();
          pppiStack_24 = (int ***)piVar4[1];
          if (*(int *)((int)pppiStack_24 + 0xc) != 0) {
            iStack_28 = 0x578beb;
            FUN_00579a50();
          }
        }
        iVar3 = **ppiVar10;
        if ((*(char *)(iVar3 + 0x59) == '\0') && (*(char *)(iVar3 + 0x5a) == '\0')) {
          pppiStack_24 = (int ***)(param_1 + 0x9930);
          *(undefined *)(iVar3 + 0x59) = 1;
          iStack_28 = 0x578c0f;
          FUN_005799a0();
          *(int *)(param_1 + 0x9cc + *(int *)(param_1 + 0x9c8) * 4) = iVar3;
          *(int *)(param_1 + 0x9c8) = *(int *)(param_1 + 0x9c8) + 1;
        }
        uVar9 = local_4 & 0xff;
        local_30 = &uStack_2c;
        uStack_34 = 0x578c3f;
        pppiStack_24 = (int ***)uVar9;
        FUN_005799f0();
        FUN_005799d0(&uStack_34);
        FUN_00578140();
        piVar4 = local_8;
        ppiVar5 = (int **)(*ppiVar10)[1];
        if (ppiVar5[3] != (int *)0x0) {
          local_c = ppiVar5;
          if ((*(char *)((int)ppiVar5 + 0x59) == '\0') && (*(char *)((int)ppiVar5 + 0x5a) == '\0'))
          {
            *(undefined *)((int)ppiVar5 + 0x59) = 1;
            ppiVar2 = (int **)(param_1 + 0x9930);
            if (*(int *)(param_1 + 0x9930) != 0) {
              *(int ***)(*(int *)(param_1 + 0x9930) + 0x54) = ppiVar5 + 0x14;
            }
            ppiVar5[0x14] = *ppiVar2;
            ppiVar5[0x15] = (int *)ppiVar2;
            *ppiVar2 = (int *)ppiVar5;
            pppiStack_24 = &local_c;
            iStack_28 = 0x578cab;
            FUN_00579a70();
            piVar8 = piVar4;
          }
          local_30 = &uStack_2c;
          uStack_34 = 0x578cb7;
          pppiStack_24 = (int ***)uVar9;
          FUN_00579a30();
          FUN_00579a10(&uStack_34);
          FUN_00578140();
        }
      }
      ppiVar10 = ppiVar10 + 1;
    } while (ppiVar10 != local_10);
  }
  do {
    if (*(int *)(param_1 + 0x9c8) == 0) {
      return;
    }
    pppiStack_24 = (int ***)(param_1 + 0x9cc + *(int *)(param_1 + 0x9c8) * 4);
    iStack_28 = param_1 + 0x9cc;
    piVar8 = (int *)((int)piVar8 + -1);
    uStack_2c = 0x578cfd;
    FUN_00578f80();
    if (*(int *)(param_1 + 0x9c8) != 0) {
      *(undefined4 *)(param_1 + 0x9c8) = 0;
    }
    iVar3 = *(int *)(param_1 + 0x6c14);
    iVar6 = *(int *)(param_1 + 0x138c + iVar3 * 0x2c44);
    for (; ppiVar10 != (int **)(param_1 + iVar3 * 0x2c44 + 0x1390 + iVar6 * 4);
        ppiVar10 = ppiVar10 + 1) {
      local_30 = &uStack_2c;
      uStack_34 = 0x578d49;
      pppiStack_24 = (int ***)piVar8;
      FUN_005799f0();
      FUN_005799d0(&uStack_34);
      FUN_00578140();
      if (*(int *)((*ppiVar10)[1] + 0xc) != 0) {
        local_30 = &uStack_2c;
        uStack_34 = 0x578d71;
        pppiStack_24 = (int ***)piVar8;
        FUN_00579a30();
        FUN_00579a10(&uStack_34);
        FUN_00578140();
      }
    }
  } while (piVar8 != (int *)0x0);
  return;
}

