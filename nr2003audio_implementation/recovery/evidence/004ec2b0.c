/* NR2003.exe @ 004ec2b0 FUN_004ec2b0 */

undefined4 * __thiscall FUN_004ec2b0(undefined4 *param_1_00,int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  char cVar3;
  undefined4 uVar4;
  int *piVar5;
  int *piVar6;
  int iVar7;
  int iStack_18;
  undefined4 *local_14;
  int *local_10;
  int local_c;
  int iStack_8;
  int local_4;

  FUN_004ea810(param_1);
  *param_1_00 = &PTR_FUN_006f396c;
  param_1_00[0xb] = param_2;
  local_4 = *(int *)(param_1 + 0x1820);
  if (0 < local_4) {
    local_10 = (int *)(param_1 + 0x17a0);
    local_14 = param_1_00 + 0x184;
    do {
      iVar7 = 0;
      iVar1 = *local_10;
      if (((*(int *)(iVar1 + 0xa8) == 0) && (*(int *)(iVar1 + 0xb0) == param_2)) &&
         (*(int **)(iVar1 + 0xb4) != (int *)0x0)) {
        uVar4 = (**(code **)(**(int **)(iVar1 + 0xb4) + 4))();
        *local_14 = uVar4;
        if (*(int *)(iVar1 + 0xa4) == 0) {
          iStack_18 = 0;
          piVar5 = param_1_00 + 0x60;
          do {
            iStack_8 = 0;
            do {
              cVar3 = FUN_004ec250(iVar1,iStack_18,iStack_8);
              if (cVar3 == '\0') {
                param_1_00[*piVar5 + iVar7 + 0x50] = iVar1;
                *piVar5 = *piVar5 + 1;
              }
              else {
                param_1_00[piVar5[-0x44] + iVar7 + 0xc] = iVar1;
                piVar5[-0x44] = piVar5[-0x44] + 1;
              }
              iVar7 = iVar7 + 0x11;
              iStack_8 = iStack_8 + 1;
              piVar5 = piVar5 + 0x11;
            } while (iStack_8 < 2);
            iStack_18 = iStack_18 + 1;
          } while (iVar7 < 0x44);
        }
      }
      local_14 = local_14 + 1;
      local_10 = local_10 + 1;
      local_4 = local_4 + -1;
    } while (local_4 != 0);
  }
  local_c = *(int *)(param_1 + 0x1820);
  if (0 < local_c) {
    piVar5 = (int *)(param_1 + 0x17a0);
    do {
      iVar1 = *piVar5;
      iVar7 = 0;
      if (((*(int *)(iVar1 + 0xa8) == 0) && (*(int *)(iVar1 + 0xb0) == param_2)) &&
         (*(int *)(iVar1 + 0xb4) != 0)) {
        iVar2 = *(int *)(iVar1 + 0xa4);
        local_10 = (int *)0x0;
        piVar6 = param_1_00 + 0xe8;
        do {
          cVar3 = FUN_004ec250(iVar1,1,local_10);
          if (cVar3 == '\0') {
            if (iVar2 == 1) {
              param_1_00[piVar6[-0x22] + iVar7 + 0xb6] = iVar1;
              piVar6[-0x22] = piVar6[-0x22] + 1;
            }
            else if (iVar2 == 2) {
              param_1_00[piVar6[0x22] + iVar7 + 0xfa] = iVar1;
              piVar6[0x22] = piVar6[0x22] + 1;
            }
          }
          else if (iVar2 == 1) {
            param_1_00[piVar6[-0x44] + iVar7 + 0x94] = iVar1;
            piVar6[-0x44] = piVar6[-0x44] + 1;
          }
          else if (iVar2 == 2) {
            param_1_00[*piVar6 + iVar7 + 0xd8] = iVar1;
            *piVar6 = *piVar6 + 1;
          }
          iVar7 = iVar7 + 0x11;
          local_10 = (int *)((int)local_10 + 1);
          piVar6 = piVar6 + 0x11;
        } while (iVar7 < 0x22);
      }
      piVar5 = piVar5 + 1;
      local_c = local_c + -1;
    } while (local_c != 0);
  }
  return param_1_00;
}
