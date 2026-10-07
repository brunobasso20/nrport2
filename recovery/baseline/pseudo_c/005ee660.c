/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005ee660 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005ee660(int *param_1,undefined4 *param_2,undefined1 param_3)

{
  undefined4 *puVar1;
  byte bVar6;
  ushort uVar2;
  int iVar3;
  undefined1 *puVar4;
  int iVar5;
  ushort uVar7;
  int iVar8;
  int iVar9;
  undefined1 local_38;
  undefined1 local_37;
  undefined1 local_36;
  undefined1 local_35;
  undefined1 local_34;
  undefined1 local_33;
  undefined1 local_32;
  undefined1 local_31;
  undefined1 local_30;
  undefined1 local_2f;
  undefined1 local_2e;
  undefined4 local_2c;
  byte bStack_26;
  undefined4 local_28;
  byte bStack_25;
  int local_24;
  undefined4 local_20;
  undefined4 local_1c;
  undefined4 local_18;
  undefined4 local_14;
  undefined1 local_e;
  undefined1 local_9;
  int local_8;
  int local_4;
  
  puVar1 = param_2;
  iVar8 = 0;
  iVar3 = param_1[1];
  iVar5 = *param_1;
  local_8 = iVar5;
  local_4 = iVar3;
  if (0 < iVar3) {
    do {
      iVar9 = 0;
      if (0 < iVar5) {
        local_24 = 0;
        do {
          iVar3 = *param_1 * iVar8 + iVar9;
          local_14 = *(undefined4 *)(*(int *)param_1[3] + iVar3 * 4);
          if (param_1[2] < 2) {
            local_1c = 0;
          }
          else {
            local_1c = *(undefined4 *)(*(int *)param_1[4] + iVar3 * 4);
          }
          if (param_1[2] < 3) {
            local_20 = 0;
          }
          else {
            local_20 = *(undefined4 *)(*(int *)param_1[5] + iVar3 * 4);
          }
          local_38 = FUN_006c5018();
          local_37 = FUN_006c5018();
          local_36 = FUN_006c5018();
          local_35 = FUN_006c5018();
          FUN_00446e70(&local_38);
          switch(*puVar1) {
          case 3:
            FUN_00446e70(&param_2);
            uVar7 = ((local_18._2_1_ & 0xfff8) << 5 | (ushort)((byte)(local_18 >> 8) & 0xfc)) << 3;
            uVar2 = (ushort)((byte)(local_18 >> 3) & 0x1f);
            goto LAB_005ee909;
          case 4:
            FUN_00446e70(&param_2);
            uVar7 = (((local_2c._3_1_ & 0xff80) * 2 | (ushort)(local_2c._2_1_ & 0xf8)) << 5 |
                    (ushort)((byte)(local_2c >> 8) & 0xf8)) << 2;
            uVar2 = (ushort)((byte)(local_2c >> 3) & 0x1f);
            goto LAB_005ee909;
          case 5:
            FUN_00446e70(&param_2);
            bVar6 = (byte)((uint)local_28 >> 8);
            uVar7 = ((bStack_25 & 0xfff0) << 4 | bStack_26 & 0xf0) << 4;
            uVar2 = (ushort)(((byte)local_28 >> 4 ^ bVar6) & 0xf ^ bVar6);
LAB_005ee909:
            *(ushort *)(puVar1[3] * iVar8 + iVar9 * 2 + puVar1[4]) = uVar7 | uVar2;
            break;
          case 6:
            FUN_00446e70(&param_2);
            puVar4 = (undefined1 *)(puVar1[3] * iVar8 + puVar1[4] + local_24);
            *puVar4 = local_2e;
            puVar4[1] = local_2f;
            puVar4[2] = local_30;
            break;
          case 7:
            FUN_00446e70(&param_2);
            puVar4 = (undefined1 *)(puVar1[3] * iVar8 + iVar9 * 4 + puVar1[4]);
            *puVar4 = local_34;
            puVar4[1] = local_33;
            puVar4[2] = local_32;
            puVar4[3] = local_31;
            break;
          case 8:
            FUN_00446e70(&param_2);
            *(undefined1 *)(puVar1[3] * iVar8 + puVar1[4] + iVar9) = local_e;
            break;
          case 9:
            FUN_00446e70(&param_2);
            *(undefined1 *)(puVar1[3] * iVar8 + puVar1[4] + iVar9) = local_9;
          }
          iVar9 = iVar9 + 1;
          local_24 = local_24 + 3;
          iVar5 = local_8;
          iVar3 = local_4;
        } while (iVar9 < local_8);
      }
      iVar8 = iVar8 + 1;
    } while (iVar8 < iVar3);
  }
  return;
}


