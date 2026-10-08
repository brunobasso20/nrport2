/* NR2003.exe @ 005a2040 FUN_005a2040 */

void FUN_005a2040(ushort *param_1)

{
  undefined4 *puVar1;
  bool bVar2;
  ushort uVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  int iVar6;
  uint uVar7;
  float10 fVar8;
  
  uVar4 = FUN_0055ab00();
  FUN_005c3670(param_1,0x20);
  *param_1 = (ushort)(*(byte *)param_1 & 0x3f | 0xc0);
  bVar2 = inServer();
  if (bVar2) {
    uVar5 = FUN_00546840();
    uVar3 = FUN_005cebb0(uVar5);
    param_1[1] = (param_1[1] ^ uVar3) & 0x3ff ^ param_1[1];
    iVar6 = FUN_004f5970(uVar4);
  }
  else {
    iVar6 = getBGCount();
    uVar3 = FUN_005cebb0(iVar6);
    param_1[1] = (param_1[1] ^ uVar3) & 0x3ff ^ param_1[1];
    iVar6 = FUN_00562f70(uVar4);
  }
  puVar1 = *(undefined4 **)(iVar6 + 0x5ae);
  *(uint *)(param_1 + 0x1e) =
       (*(uint *)(iVar6 + 0x5b2) ^ *(uint *)(param_1 + 0x1e)) & 0x7f ^ *(uint *)(param_1 + 0x1e);
  iVar6 = FUN_00562f70(uVar4);
  iVar6 = FUN_005beac0(&DAT_00e0b704,*(undefined4 *)(iVar6 + 0x1510));
  param_1[1] = ((ushort)(iVar6 << 10) ^ param_1[1]) & 0x7c00 ^ param_1[1];
  iVar6 = FUN_00555120();
  param_1[1] = param_1[1] & 0x7fff ^ (ushort)(iVar6 << 0xf);
  fVar8 = (float10)FUN_00554fa0();
  iVar6 = FUN_005beac0(&DAT_00e0b6dc,(float)fVar8);
  uVar7 = (iVar6 << 7 ^ *(uint *)(param_1 + 0x1e)) & 0x3f80 ^ *(uint *)(param_1 + 0x1e);
  *(uint *)(param_1 + 0x1e) = uVar7;
  *(uint *)(param_1 + 0x1e) = uVar7 & 0x7fffffff ^ DAT_00c0819c << 0x1f;
  iVar6 = FUN_00555060();
  *(uint *)(param_1 + 0x1e) =
       (iVar6 << 0xe ^ *(uint *)(param_1 + 0x1e)) & 0x1c000 ^ *(uint *)(param_1 + 0x1e);
  uVar4 = FUN_005550c0();
  uVar4 = FUN_005550a0(uVar4);
  uVar4 = FUN_00555080(uVar4);
  iVar6 = FUN_005a2250(uVar4);
  *(uint *)(param_1 + 0x1e) =
       (iVar6 << 0x11 ^ *(uint *)(param_1 + 0x1e)) & 0x60000 ^ *(uint *)(param_1 + 0x1e);
  fVar8 = (float10)FUN_00554f10();
  iVar6 = FUN_005beac0(&DAT_00e0b6c0,(float)fVar8);
  *(uint *)(param_1 + 0x1e) =
       (iVar6 << 0x13 ^ *(uint *)(param_1 + 0x1e)) & 0x1ff80000 ^ *(uint *)(param_1 + 0x1e);
  iVar6 = FUN_005a1de0();
  *(uint *)(param_1 + 0x1e) =
       (iVar6 << 0x1d ^ *(uint *)(param_1 + 0x1e)) & 0x60000000 ^ *(uint *)(param_1 + 0x1e);
  *(undefined4 *)(param_1 + 0x1c) = puVar1[0x15];
  *(undefined4 *)(param_1 + 2) = *puVar1;
  *(undefined4 *)(param_1 + 4) = puVar1[1];
  *(undefined4 *)(param_1 + 6) = puVar1[2];
  *(undefined4 *)(param_1 + 8) = puVar1[0x1f];
  *(undefined4 *)(param_1 + 10) = puVar1[0x20];
  *(undefined4 *)(param_1 + 0xc) = puVar1[0x21];
  *(undefined4 *)(param_1 + 0xe) = puVar1[0x22];
  *(undefined4 *)(param_1 + 0x10) = puVar1[3];
  *(undefined4 *)(param_1 + 0x12) = puVar1[4];
  *(undefined4 *)(param_1 + 0x14) = puVar1[5];
  *(undefined4 *)(param_1 + 0x16) = puVar1[0x23];
  *(undefined4 *)(param_1 + 0x18) = puVar1[0x24];
  *(undefined4 *)(param_1 + 0x1a) = puVar1[0x25];
  return;
}

