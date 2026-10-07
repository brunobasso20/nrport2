/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005790c0 */

void __thiscall FUN_005790c0(int param_1_00,undefined4 param_1)

{
  int *piVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  undefined4 *puVar5;
  int *piVar6;
  int iVar7;
  int local_9e0;
  int local_9dc;
  int local_9d8 [6];
  undefined4 local_9c0 [624];
  
  iVar3 = *(int *)(param_1_00 + 0x993c);
  if (iVar3 != 0) {
    iVar7 = *(int *)(iVar3 + 0xc);
    puVar5 = (undefined4 *)(param_1_00 + 0x9940);
    iVar3 = FUN_00517e9a(local_9c0,local_9d8,*(undefined4 *)(iVar7 + 0xd4),
                         *(undefined4 *)(iVar7 + 0x40),*(undefined4 *)(iVar7 + 0xd8),0x40533333,
                         *(undefined4 *)(iVar7 + 0xec),puVar5,5,iVar3);
    if (0 < iVar3) {
      iVar7 = 0;
      piVar6 = local_9d8;
      local_9e0 = 5;
      do {
        uVar2 = *puVar5;
        local_9dc = 0;
        if (0 < *piVar6) {
          do {
            iVar4 = FUN_00578450(uVar2,local_9c0[iVar7],param_1);
            if (iVar4 != 0) {
              piVar1 = (int *)(param_1_00 + 0x138c + *(int *)(param_1_00 + 0x6c14) * 0x2c44);
              piVar1[*(int *)(param_1_00 + 0x138c + *(int *)(param_1_00 + 0x6c14) * 0x2c44) + 1] =
                   iVar4;
              *piVar1 = *piVar1 + 1;
            }
            local_9dc = local_9dc + 1;
            iVar7 = iVar7 + 1;
          } while (local_9dc < *piVar6);
        }
        puVar5 = puVar5 + 1;
        piVar6 = piVar6 + 1;
        local_9e0 = local_9e0 + -1;
      } while (local_9e0 != 0);
      for (; iVar7 < iVar3; iVar7 = iVar7 + 1) {
        iVar4 = FUN_00578450(*(undefined4 *)(param_1_00 + 0x993c),local_9c0[iVar7],param_1);
        if (iVar4 != 0) {
          piVar6 = (int *)(param_1_00 + 0x138c + *(int *)(param_1_00 + 0x6c14) * 0x2c44);
          piVar6[*(int *)(param_1_00 + 0x138c + *(int *)(param_1_00 + 0x6c14) * 0x2c44) + 1] = iVar4
          ;
          *piVar6 = *piVar6 + 1;
        }
      }
    }
    puVar5 = local_9c0 + iVar3;
    iVar3 = FUN_005796e0(puVar5,*(undefined4 *)(param_1_00 + 0x993c));
    if (0 < iVar3) {
      do {
        iVar7 = FUN_00578450(*(undefined4 *)(param_1_00 + 0x993c),*puVar5,param_1);
        if (iVar7 != 0) {
          piVar6 = (int *)(param_1_00 + 0x138c + *(int *)(param_1_00 + 0x6c14) * 0x2c44);
          piVar6[*(int *)(param_1_00 + 0x138c + *(int *)(param_1_00 + 0x6c14) * 0x2c44) + 1] = iVar7
          ;
          *piVar6 = *piVar6 + 1;
        }
        puVar5 = puVar5 + 1;
        iVar3 = iVar3 + -1;
      } while (iVar3 != 0);
    }
  }
  return;
}


