/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005841d0 */

void FUN_005841d0(void)

{
  undefined4 uVar1;
  bool bVar2;
  byte bVar3;
  byte bVar4;
  uint uVar5;
  uint uVar6;
  uint uVar7;
  int iVar8;
  byte *pbVar9;
  byte *pbVar10;
  int iVar11;
  byte local_23;
  char local_22;
  int local_20;
  byte *local_1c;
  byte local_10;
  
  iVar11 = DAT_00d6a5e0;
  bVar2 = true;
  local_23 = 0;
  local_1c = (byte *)0x0;
  local_22 = '\0';
  if (DAT_00d6a5dc < 1) {
    return;
  }
  local_20 = 1;
  pbVar9 = &DAT_00d76149;
  FUN_00501870(5);
  if (iVar11 != 0) {
    do {
      bVar3 = local_23;
      uVar5 = FUN_006c5018();
      uVar6 = FUN_006c5018();
      uVar7 = FUN_006c5018();
      if ((((bVar2) || (0x7fe < (int)((uVar5 ^ (int)uVar5 >> 0x1f) - ((int)uVar5 >> 0x1f)))) ||
          (0x7fe < (int)((uVar6 ^ (int)uVar6 >> 0x1f) - ((int)uVar6 >> 0x1f)))) ||
         (0x7e < (int)((uVar7 ^ (int)uVar7 >> 0x1f) - ((int)uVar7 >> 0x1f)))) {
        bVar2 = false;
        if (*(int *)(iVar11 + 0x28) == 0x20) {
          pbVar10 = pbVar9 + 0x12;
          local_20 = local_20 + 0x12;
          uVar5 = *(uint *)(pbVar9 + 0xe);
          uVar6 = FUN_006c5018();
          uVar5 = (uVar6 ^ uVar5) & 0xfff ^ uVar5;
          *(uint *)(pbVar9 + 0xe) = uVar5;
          iVar8 = FUN_006c5018();
          *(uint *)(pbVar9 + 0xe) = (iVar8 << 0xc ^ uVar5) & 0xfff000 ^ uVar5;
          bVar4 = FUN_006c5018();
          pbVar9[0x11] = bVar4;
          *(undefined4 *)(pbVar9 + 2) = *(undefined4 *)(iVar11 + 0x2c);
          *(undefined4 *)(pbVar9 + 6) = *(undefined4 *)(iVar11 + 0x30);
          uVar1 = *(undefined4 *)(iVar11 + 0x34);
          *pbVar9 = 0x20;
          *(undefined4 *)(pbVar9 + 10) = uVar1;
          if (*(int *)(iVar11 + 0x1c) < 2) {
            *pbVar9 = 0xa0;
          }
          if (local_1c != (byte *)0x0) {
            local_23 = 0;
            *local_1c = bVar3;
          }
          local_1c = pbVar9 + 1;
        }
        else {
          pbVar10 = pbVar9 + 0x10;
          local_20 = local_20 + 0x10;
          switch(*(int *)(iVar11 + 0x28)) {
          case 1:
          case 2:
          case 0x10:
            FUN_00584640(pbVar9,iVar11);
            break;
          case 8:
            FUN_00584690(pbVar9,iVar11);
            break;
          case 0x40:
            FUN_005846d0(pbVar9,iVar11);
          }
          *(undefined4 *)(pbVar9 + 3) = *(undefined4 *)(iVar11 + 0x2c);
          *(undefined4 *)(pbVar9 + 7) = *(undefined4 *)(iVar11 + 0x30);
          *(undefined4 *)(pbVar9 + 0xb) = *(undefined4 *)(iVar11 + 0x34);
          bVar4 = *(byte *)(iVar11 + 0x28);
          *pbVar9 = bVar4;
          if (*(int *)(iVar11 + 0x1c) < 2) {
            *pbVar9 = bVar4 | 0x80;
          }
          if (local_1c != (byte *)0x0) {
            local_23 = 0;
            *local_1c = bVar3;
          }
          local_1c = pbVar9 + 0xf;
        }
      }
      else {
        local_23 = local_23 + 1;
        local_10 = (byte)uVar7;
        if (*(int *)(iVar11 + 0x28) == 0x20) {
          *pbVar9 = 0x20;
          pbVar10 = pbVar9 + 9;
          local_20 = local_20 + 9;
          if (*(int *)(iVar11 + 0x1c) < 2) {
            *pbVar9 = 0xa0;
          }
          uVar7 = *(uint *)(pbVar9 + 5);
          uVar5 = (*(uint *)(pbVar9 + 1) ^ uVar5) & 0xfff ^ *(uint *)(pbVar9 + 1);
          *(uint *)(pbVar9 + 1) = (uVar6 << 0xc ^ uVar5) & 0xfff000 ^ uVar5;
          pbVar9[4] = local_10;
          uVar5 = FUN_006c5018();
          uVar7 = (uVar5 ^ uVar7) & 0xfff ^ uVar7;
          *(uint *)(pbVar9 + 5) = uVar7;
          iVar8 = FUN_006c5018();
          *(uint *)(pbVar9 + 5) = (iVar8 << 0xc ^ uVar7) & 0xfff000 ^ uVar7;
          bVar3 = FUN_006c5018();
          pbVar9[8] = bVar3;
        }
        else {
          pbVar10 = pbVar9 + 7;
          local_20 = local_20 + 7;
          switch(*(int *)(iVar11 + 0x28)) {
          case 1:
          case 2:
          case 0x10:
            FUN_00584640(pbVar9,iVar11);
            break;
          case 8:
            FUN_00584690(pbVar9,iVar11);
            break;
          case 0x40:
            FUN_005846d0(pbVar9,iVar11);
          }
          bVar3 = *(byte *)(iVar11 + 0x28);
          *pbVar9 = bVar3;
          if (*(int *)(iVar11 + 0x1c) < 2) {
            *pbVar9 = bVar3 | 0x80;
          }
          uVar5 = (*(uint *)(pbVar9 + 3) ^ uVar5) & 0xfff ^ *(uint *)(pbVar9 + 3);
          *(uint *)(pbVar9 + 3) = (uVar6 << 0xc ^ uVar5) & 0xfff000 ^ uVar5;
          pbVar9[6] = local_10;
        }
      }
      local_22 = local_22 + '\x01';
      iVar11 = *(int *)(iVar11 + 0xa8);
      pbVar9 = pbVar10;
    } while (iVar11 != 0);
    if (local_1c != (byte *)0x0) {
      *local_1c = local_23;
    }
  }
  DAT_00d76148 = local_22;
  FUN_005019e0(local_20,&DAT_00d76148);
  FUN_00501a40();
  return;
}


