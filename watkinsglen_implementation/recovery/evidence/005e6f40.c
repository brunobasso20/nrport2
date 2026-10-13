/* NR2003.exe @ 005e6f40 FUN_005e6f40 */

char __thiscall FUN_005e6f40(int param_1_00,int param_1,undefined4 param_2)

{
  uint uVar1;
  int *piVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  undefined4 uVar6;
  undefined4 *puVar7;
  undefined4 *puVar8;
  int iVar9;
  uint local_c;
  int iStack_8;
  int iStack_4;

  cVar3 = FUN_005e6280(param_1,param_2);
  if (cVar3 == '\0') {
    return '\0';
  }
  *(undefined4 *)(param_1 + 0x15) = *(undefined4 *)(param_1_00 + 0x15);
  *(undefined4 *)(param_1 + 0x19) = *(undefined4 *)(param_1_00 + 0x19);
  *(undefined4 *)(param_1 + 0x1d) = *(undefined4 *)(param_1_00 + 0x1d);
  *(undefined4 *)(param_1 + 0x21) = *(undefined4 *)(param_1_00 + 0x21);
  *(undefined4 *)(param_1 + 0x25) = *(undefined4 *)(param_1_00 + 0x25);
  *(undefined4 *)(param_1 + 0x29) = *(undefined4 *)(param_1_00 + 0x29);
  *(undefined4 *)(param_1 + 0x2d) = *(undefined4 *)(param_1_00 + 0x2d);
  *(undefined4 *)(param_1 + 0x31) = *(undefined4 *)(param_1_00 + 0x31);
  *(undefined4 *)(param_1 + 0x35) = *(undefined4 *)(param_1_00 + 0x35);
  *(undefined4 *)(param_1 + 0x39) = *(undefined4 *)(param_1_00 + 0x39);
  *(undefined4 *)(param_1 + 0x3d) = *(undefined4 *)(param_1_00 + 0x3d);
  *(undefined4 *)(param_1 + 0x41) = *(undefined4 *)(param_1_00 + 0x41);
  *(undefined4 *)(param_1 + 0x45) = *(undefined4 *)(param_1_00 + 0x45);
  iVar4 = *(int *)(param_1_00 + 0x49);
  *(int *)(param_1 + 0x49) = iVar4;
  if (iVar4 == 1) {
    iVar4 = *(int *)(param_1 + 0x4d);
    if (*(int *)(param_1_00 + 0x4d) != 0) {
      if (iVar4 == 0) {
        iVar4 = FUN_005cfce4(&local_c,0x28);
        *(uint *)(param_1 + 0x4d) = -(uint)(iVar4 != 0) & local_c;
      }
      puVar7 = *(undefined4 **)(param_1_00 + 0x4d);
      puVar8 = *(undefined4 **)(param_1 + 0x4d);
      for (iVar4 = 10; iVar4 != 0; iVar4 = iVar4 + -1) {
        *puVar8 = *puVar7;
        puVar7 = puVar7 + 1;
        puVar8 = puVar8 + 1;
      }
      goto LAB_005e7011;
    }
  }
  else {
    iVar4 = *(int *)(param_1 + 0x4d);
  }
  if (iVar4 != 0) {
    FUN_005cfccc(iVar4);
    *(undefined4 *)(param_1 + 0x4d) = 0;
  }
LAB_005e7011:
  *(undefined4 *)(param_1 + 0x51) = *(undefined4 *)(param_1_00 + 0x51);
  *(undefined4 *)(param_1 + 0x55) = *(undefined4 *)(param_1_00 + 0x55);
  *(undefined *)(param_1 + 0x14) = *(undefined *)(param_1_00 + 0x14);
  *(undefined4 *)(param_1 + 0x59) = *(undefined4 *)(param_1_00 + 0x59);
  if (*(int *)(param_1 + 0x5d) != 0) {
    FUN_005cfccc(*(int *)(param_1 + 0x5d));
  }
  *(undefined4 *)(param_1 + 0x5d) = 0;
  uVar1 = *(uint *)(param_1_00 + 0x59);
  if (0 < (int)uVar1) {
    iVar4 = FUN_005cfce4(&iStack_8,uVar1 * 0x53a);
    if ((iVar4 == 0) || (iStack_4 = iStack_8, iStack_8 == 0)) {
      iStack_8 = 0;
    }
    else if (-1 < (int)(uVar1 - 1)) {
      iVar4 = iStack_8 + 0x14;
      local_c = uVar1;
      do {
        iVar5 = 0;
        puVar7 = (undefined4 *)(iVar4 + 0x1c);
        do {
          *(undefined4 *)(iVar4 + -0x14 + iVar5 * 4) = 0;
          *(undefined4 *)(iVar4 + iVar5 * 4) = 0;
          *puVar7 = 0x1010101;
          iVar5 = iVar5 + 1;
          *(undefined2 *)(puVar7 + 1) = 0x101;
          puVar7 = (undefined4 *)((int)puVar7 + 6);
        } while (iVar5 < 5);
        iVar4 = iVar4 + 0x53a;
        local_c = local_c - 1;
      } while (local_c != 0);
    }
    *(int *)(param_1 + 0x5d) = iStack_8;
    if (iStack_8 == 0) {
      return '\0';
    }
    local_c = 0;
    if (0 < *(int *)(param_1_00 + 0x59)) {
      iVar4 = 0;
      do {
        puVar7 = (undefined4 *)(iVar4 + 0x30 + *(int *)(param_1_00 + 0x5d));
        puVar8 = (undefined4 *)(iVar4 + 0x30 + *(int *)(param_1 + 0x5d));
        for (iVar5 = 7; iVar5 != 0; iVar5 = iVar5 + -1) {
          *puVar8 = *puVar7;
          puVar7 = puVar7 + 1;
          puVar8 = puVar8 + 1;
        }
        *(undefined2 *)puVar8 = *(undefined2 *)puVar7;
        puVar7 = (undefined4 *)(iVar4 + 0x4e + *(int *)(param_1_00 + 0x5d));
        puVar8 = (undefined4 *)(iVar4 + 0x4e + *(int *)(param_1 + 0x5d));
        for (iVar5 = 0xf; iVar5 != 0; iVar5 = iVar5 + -1) {
          *puVar8 = *puVar7;
          puVar7 = puVar7 + 1;
          puVar8 = puVar8 + 1;
        }
        puVar7 = (undefined4 *)(iVar4 + 0x8a + *(int *)(param_1_00 + 0x5d));
        puVar8 = (undefined4 *)(iVar4 + 0x8a + *(int *)(param_1 + 0x5d));
        for (iVar5 = 0x78; iVar5 != 0; iVar5 = iVar5 + -1) {
          *puVar8 = *puVar7;
          puVar7 = puVar7 + 1;
          puVar8 = puVar8 + 1;
        }
        puVar7 = (undefined4 *)(iVar4 + 0x26a + *(int *)(param_1_00 + 0x5d));
        puVar8 = (undefined4 *)(iVar4 + 0x26a + *(int *)(param_1 + 0x5d));
        for (iVar5 = 0xb4; iVar5 != 0; iVar5 = iVar5 + -1) {
          *puVar8 = *puVar7;
          puVar7 = puVar7 + 1;
          puVar8 = puVar8 + 1;
        }
        iVar9 = 0;
        iVar5 = iVar4;
        do {
          piVar2 = *(int **)(iVar5 + *(int *)(param_1_00 + 0x5d));
          if (piVar2 != (int *)0x0) {
            uVar6 = (**(code **)(*piVar2 + 0x14))(param_2);
            *(undefined4 *)(iVar5 + *(int *)(param_1 + 0x5d)) = uVar6;
            if (*(int *)(iVar5 + *(int *)(param_1 + 0x5d)) != 0) goto LAB_005e717f;
LAB_005e71b5:
            cVar3 = '\0';
            break;
          }
LAB_005e717f:
          piVar2 = *(int **)(iVar5 + 0x14 + *(int *)(param_1_00 + 0x5d));
          if (piVar2 != (int *)0x0) {
            uVar6 = (**(code **)(*piVar2 + 0x14))(param_2);
            *(undefined4 *)(iVar5 + 0x14 + *(int *)(param_1 + 0x5d)) = uVar6;
            if (*(int *)(iVar5 + 0x14 + *(int *)(param_1 + 0x5d)) == 0) goto LAB_005e71b5;
          }
          iVar9 = iVar9 + 1;
          iVar5 = iVar5 + 4;
        } while (iVar9 < 5);
        local_c = local_c + 1;
        iVar4 = iVar4 + 0x53a;
      } while ((int)local_c < *(int *)(param_1_00 + 0x59));
    }
  }
  return cVar3;
}
