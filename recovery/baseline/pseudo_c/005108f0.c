/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005108f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005108f0(int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  uint uVar4;
  int iVar5;
  undefined4 *puVar6;
  int local_14;
  int local_10;
  
  _DAT_00bba5a0 = _DAT_006e97d8 / _DAT_006f45d8;
  _DAT_00ba724c = (int)ROUND(DAT_00bad918 * _DAT_00bba5a0) + 1;
  local_14 = 0;
  if (0 < DAT_00bad920) {
    local_10 = 0;
    do {
      iVar1 = local_10 + DAT_00bcf734;
      iVar2 = *(int *)(*(int *)(param_1 + 0xc) + local_14 * 4);
      *(int *)(iVar1 + 0x1538) = (int)ROUND(_DAT_00bba5a0 * *(float *)(iVar1 + 4));
      iVar3 = (int)ROUND(_DAT_00bba5a0 * *(float *)(iVar1 + 8)) + 1;
      *(int *)(iVar1 + 0x153c) = iVar3;
      iVar5 = *(int *)(iVar2 + 0x5a);
      if (iVar5 < 1) {
        iVar5 = 1;
      }
      iVar3 = FUN_005cfce4((undefined4 *)(iVar1 + 0x1544),(iVar3 * 8 + 0x14) * iVar5);
      if (iVar3 == 0) {
LAB_00510a65:
        FUN_00510a80();
        return 0;
      }
      puVar6 = *(undefined4 **)(iVar1 + 0x1544);
      for (uVar4 = (uint)((*(int *)(iVar1 + 0x153c) * 8 + 0x14) * iVar5) >> 2; uVar4 != 0;
          uVar4 = uVar4 - 1) {
        *puVar6 = 0;
        puVar6 = puVar6 + 1;
      }
      for (iVar3 = 0; iVar3 != 0; iVar3 = iVar3 + -1) {
        *(undefined1 *)puVar6 = 0;
        puVar6 = (undefined4 *)((int)puVar6 + 1);
      }
      *(undefined4 *)(iVar1 + 0x1540) = 0;
      uVar4 = *(uint *)(iVar2 + 0x5e);
      if (0 < (int)uVar4) {
        iVar3 = FUN_005cfce4((undefined4 *)(iVar1 + 0x154c),uVar4 << 5);
        if (iVar3 == 0) goto LAB_00510a65;
        puVar6 = *(undefined4 **)(iVar1 + 0x154c);
        for (iVar3 = (uVar4 & 0x7ffffff) << 3; iVar3 != 0; iVar3 = iVar3 + -1) {
          *puVar6 = 0;
          puVar6 = puVar6 + 1;
        }
        for (iVar3 = 0; iVar3 != 0; iVar3 = iVar3 + -1) {
          *(undefined1 *)puVar6 = 0;
          puVar6 = (undefined4 *)((int)puVar6 + 1);
        }
      }
      *(undefined4 *)(iVar1 + 0x1548) = 0;
      local_14 = local_14 + 1;
      local_10 = local_10 + 0x1550;
    } while (local_14 < DAT_00bad920);
  }
  return 1;
}


