/* Ghidra pseudo-C; NR2003.exe @ 005b4e60 */

undefined4 FUN_005b4e60(int *param_1,int param_2)

{
  int iVar1;
  byte bVar2;
  int iVar3;
  uint uVar4;
  uint uVar5;
  int iVar6;
  int *piVar7;
  uint uVar8;
  uint *local_3c;
  int local_38;
  int local_30;
  int local_2c;
  int local_28;
  int local_20 [8];
  
  piVar7 = &local_2c;
  iVar6 = 4;
  do {
    iVar3 = FUN_006c5018();
    piVar7[-1] = iVar3;
    iVar3 = FUN_006c5018();
    *piVar7 = iVar3;
    iVar3 = FUN_006c5018();
    piVar7[1] = iVar3;
    piVar7 = piVar7 + 3;
    iVar6 = iVar6 + -1;
  } while (iVar6 != 0);
  *param_1 = local_30;
  param_1[1] = local_2c;
  param_1[2] = local_28;
  bVar2 = FUN_006c5018();
  *(ushort *)(param_1 + 3) = (ushort)(bVar2 & 0xf) | *(ushort *)(param_1 + 3) & 0xfff0;
  local_38 = 0;
  piVar7 = local_20;
  local_3c = (uint *)((int)param_1 + 0xe);
  while( true ) {
    iVar6 = piVar7[1];
    iVar3 = *piVar7;
    iVar1 = piVar7[-1];
    uVar5 = (*local_3c ^ iVar1 - local_30) & 0x3ff ^ *local_3c;
    uVar4 = ((iVar3 - local_2c) * 0x400 ^ uVar5) & 0xffc00 ^ uVar5;
    uVar8 = ((iVar6 - local_28) * 0x100000 ^ uVar4) & 0xff00000 ^ uVar4;
    *local_3c = uVar8;
    if ((((int)(uVar5 << 0x16) >> 0x16 != iVar1 - local_30) ||
        ((int)(uVar4 << 0xc) >> 0x16 != iVar3 - local_2c)) ||
       ((int)(uVar8 << 4) >> 0x18 != iVar6 - local_28)) break;
    iVar6 = FUN_006c5018();
    piVar7 = piVar7 + 3;
    *local_3c = uVar8 & 0xfffffff ^ iVar6 << 0x1c;
    local_38 = local_38 + 1;
    local_3c = local_3c + 1;
    if (2 < local_38) {
      *(undefined1 *)((int)param_1 + 0x1a) = *(undefined1 *)(param_2 + 0x34);
      return 1;
    }
  }
  return 0;
}

