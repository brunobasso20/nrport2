/* NR2003.exe @ 004ecc20 FUN_004ecc20 */

undefined4 * __thiscall FUN_004ecc20(undefined4 *param_1_00,int param_1,int param_2)

{
  int iVar1;
  char cVar2;
  undefined4 uVar3;
  int iVar4;
  int *piVar5;
  int *piVar6;
  int iVar7;
  int iStack_14;
  undefined4 *local_10;
  int local_4;

  FUN_004ea810(param_1);
  *param_1_00 = &PTR_FUN_006f39b0;
  param_1_00[0xb] = param_2;
  local_4 = *(int *)(param_1 + 0x1820);
  if (0 < local_4) {
    piVar5 = (int *)(param_1 + 0x17a0);
    local_10 = param_1_00 + 0x184;
    do {
      iVar1 = *piVar5;
      if ((((*(int *)(iVar1 + 0xa8) == 1) && (*(int *)(iVar1 + 0xb0) == param_2)) &&
          (iVar7 = 0, *(int *)(iVar1 + 0xa4) == 0)) && (*(int **)(iVar1 + 0xb4) != (int *)0x0)) {
        uVar3 = (**(code **)(**(int **)(iVar1 + 0xb4) + 4))();
        iStack_14 = 0;
        piVar6 = param_1_00 + 0x60;
        *local_10 = uVar3;
        do {
          iVar4 = 0;
          do {
            cVar2 = FUN_004ec250(iVar1,iStack_14,iVar4);
            if (cVar2 == '\0') {
              param_1_00[*piVar6 + iVar7 + 0x50] = iVar1;
              *piVar6 = *piVar6 + 1;
            }
            else {
              param_1_00[piVar6[-0x44] + iVar7 + 0xc] = iVar1;
              piVar6[-0x44] = piVar6[-0x44] + 1;
            }
            iVar4 = iVar4 + 1;
            iVar7 = iVar7 + 0x11;
            piVar6 = piVar6 + 0x11;
          } while (iVar4 < 2);
          iStack_14 = iStack_14 + 1;
        } while (iVar7 < 0x44);
      }
      local_10 = local_10 + 1;
      piVar5 = piVar5 + 1;
      local_4 = local_4 + -1;
    } while (local_4 != 0);
  }
  return param_1_00;
}
