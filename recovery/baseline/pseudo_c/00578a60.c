/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578a60 */

void __fastcall FUN_00578a60(int param_1)

{
  int *piVar1;
  int iVar2;
  int *piVar3;
  int iVar4;
  char cVar5;
  int iVar6;
  uint uVar7;
  int *piVar8;
  undefined4 uStack_34;
  undefined1 *local_30;
  undefined4 uStack_2c;
  int iStack_28;
  int **ppiStack_24;
  int *local_10;
  int *local_c;
  int local_8;
  uint local_4;
  
  if (*(int *)(param_1 + 0x6c18) != 0) {
    *(undefined4 *)(param_1 + 0x6c18) = 0;
  }
  if (*(int *)(param_1 + 4) != 0) {
    *(undefined4 *)(param_1 + 4) = 0;
  }
  local_c = (int *)(param_1 + 0x9940);
  local_4 = 5;
  do {
    iVar2 = *local_c;
    piVar8 = *(int **)(iVar2 + 0x10);
    while (piVar8 != (int *)0x0) {
      if ((short)piVar8[2] == 0) {
        ppiStack_24 = &local_10;
        *(undefined2 *)(piVar8 + 2) = 1;
        iStack_28 = 0x578ace;
        local_10 = piVar8;
        FUN_00579a90();
        local_8 = *local_10;
        if (*(char *)(local_8 + 0x58) == '\0') {
          ppiStack_24 = (int **)&local_8;
          iStack_28 = 0x578aeb;
          FUN_00579a70();
          *(undefined1 *)(local_8 + 0x58) = 1;
        }
        ppiStack_24 = (int **)local_10[1];
        if (*(int *)((int)ppiStack_24 + 0xc) != 0) {
          iStack_28 = 0x578b09;
          FUN_00579a50();
        }
      }
      if (iVar2 == *piVar8) {
        piVar8 = *(int **)((int)piVar8 + 0x42);
      }
      else if (iVar2 == piVar8[1]) {
        piVar8 = *(int **)((int)piVar8 + 0x4a);
      }
    }
    local_c = local_c + 1;
    local_4 = local_4 + -1;
  } while (local_4 != 0);
  iVar6 = 2;
  local_8 = 2;
  iVar2 = param_1 + *(int *)(param_1 + 0x6c14) * 0x2c44;
  piVar8 = (int *)(iVar2 + 0x1390);
  local_10 = (int *)(iVar2 + 0x1390 +
                    *(int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44) * 4);
  local_4 = 0;
  if (piVar8 != local_10) {
    do {
      ppiStack_24 = (int **)0x578b81;
      FUN_00577fa0();
      ppiStack_24 = (int **)0x578b88;
      cVar5 = FUN_00578390();
      if (cVar5 != '\0') {
        piVar3 = (int *)*piVar8;
        if ((*(char *)(*piVar3 + 0x5a) != '\0') ||
           (local_4 = local_4 & 0xffffff00, *(char *)(piVar3[1] + 0x5a) != '\0')) {
          local_4 = CONCAT31(local_4._1_3_,1);
        }
        if ((short)piVar3[2] == 0) {
          piVar1 = (int *)(param_1 + 0x6c18);
          *(undefined2 *)(piVar3 + 2) = 1;
          *(int **)(param_1 + 0x6c1c + *piVar1 * 4) = piVar3;
          *piVar1 = *piVar1 + 1;
          ppiStack_24 = (int **)*piVar3;
          iStack_28 = 0x578bd9;
          FUN_00579a50();
          ppiStack_24 = (int **)piVar3[1];
          if (*(int *)((int)ppiStack_24 + 0xc) != 0) {
            iStack_28 = 0x578beb;
            FUN_00579a50();
          }
        }
        iVar2 = *(int *)*piVar8;
        if ((*(char *)(iVar2 + 0x59) == '\0') && (*(char *)(iVar2 + 0x5a) == '\0')) {
          ppiStack_24 = (int **)(param_1 + 0x9930);
          *(undefined1 *)(iVar2 + 0x59) = 1;
          iStack_28 = 0x578c0f;
          FUN_005799a0();
          *(int *)(param_1 + 0x9cc + *(int *)(param_1 + 0x9c8) * 4) = iVar2;
          *(int *)(param_1 + 0x9c8) = *(int *)(param_1 + 0x9c8) + 1;
        }
        uVar7 = local_4 & 0xff;
        local_30 = (undefined1 *)&uStack_2c;
        uStack_34 = 0x578c3f;
        ppiStack_24 = (int **)uVar7;
        FUN_005799f0();
        FUN_005799d0(&uStack_34);
        FUN_00578140();
        iVar2 = local_8;
        piVar3 = *(int **)(*piVar8 + 4);
        if (piVar3[3] != 0) {
          local_c = piVar3;
          if ((*(char *)((int)piVar3 + 0x59) == '\0') && (*(char *)((int)piVar3 + 0x5a) == '\0')) {
            *(undefined1 *)((int)piVar3 + 0x59) = 1;
            piVar1 = (int *)(param_1 + 0x9930);
            if (*(int *)(param_1 + 0x9930) != 0) {
              *(int **)(*(int *)(param_1 + 0x9930) + 0x54) = piVar3 + 0x14;
            }
            piVar3[0x14] = *piVar1;
            piVar3[0x15] = (int)piVar1;
            *piVar1 = (int)piVar3;
            ppiStack_24 = &local_c;
            iStack_28 = 0x578cab;
            FUN_00579a70();
            iVar6 = iVar2;
          }
          local_30 = (undefined1 *)&uStack_2c;
          uStack_34 = 0x578cb7;
          ppiStack_24 = (int **)uVar7;
          FUN_00579a30();
          FUN_00579a10(&uStack_34);
          FUN_00578140();
        }
      }
      piVar8 = piVar8 + 1;
    } while (piVar8 != local_10);
  }
  do {
    if (*(int *)(param_1 + 0x9c8) == 0) {
      return;
    }
    ppiStack_24 = (int **)(param_1 + 0x9cc + *(int *)(param_1 + 0x9c8) * 4);
    iStack_28 = param_1 + 0x9cc;
    iVar6 = iVar6 + -1;
    uStack_2c = 0x578cfd;
    FUN_00578f80();
    if (*(int *)(param_1 + 0x9c8) != 0) {
      *(undefined4 *)(param_1 + 0x9c8) = 0;
    }
    iVar2 = *(int *)(param_1 + 0x6c14);
    iVar4 = *(int *)(param_1 + 0x138c + iVar2 * 0x2c44);
    for (; piVar8 != (int *)(param_1 + iVar2 * 0x2c44 + 0x1390 + iVar4 * 4); piVar8 = piVar8 + 1) {
      local_30 = (undefined1 *)&uStack_2c;
      uStack_34 = 0x578d49;
      ppiStack_24 = (int **)iVar6;
      FUN_005799f0();
      FUN_005799d0(&uStack_34);
      FUN_00578140();
      if (*(int *)(*(int *)(*piVar8 + 4) + 0xc) != 0) {
        local_30 = (undefined1 *)&uStack_2c;
        uStack_34 = 0x578d71;
        ppiStack_24 = (int **)iVar6;
        FUN_00579a30();
        FUN_00579a10(&uStack_34);
        FUN_00578140();
      }
    }
  } while (iVar6 != 0);
  return;
}


