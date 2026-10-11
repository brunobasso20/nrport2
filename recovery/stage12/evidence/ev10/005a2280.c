/* NR2003.exe @ 005a2280 FUN_005a2280 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005a2280(ushort *param_1)

{
  float fVar1;
  float fVar2;
  bool bVar3;
  short sVar4;
  ushort uVar5;
  int iVar6;
  undefined4 uVar7;
  int iVar8;
  uint uVar9;
  uint uVar10;
  int iVar11;
  float10 fVar12;
  undefined local_c [4];
  undefined4 local_8;
  undefined4 local_4;
  
  iVar6 = FUN_0055ab00();
  FUN_005c3670(param_1,0);
  bVar3 = inServer();
  if (bVar3) {
    uVar7 = FUN_00546840();
    sVar4 = FUN_005cebb0(uVar7);
    *param_1 = (sVar4 * 2 ^ *param_1) & 0x7fe ^ *param_1;
    iVar8 = FUN_004f5970(iVar6);
  }
  else {
    iVar8 = getBGCount();
    sVar4 = FUN_005cebb0(iVar8);
    *param_1 = (sVar4 * 2 ^ *param_1) & 0x7fe ^ *param_1;
    iVar8 = FUN_00562f70(iVar6);
  }
  *(uint *)(param_1 + 2) =
       (iVar6 << 0x18 ^ *(uint *)(param_1 + 2)) & 0x7f000000 ^ *(uint *)(param_1 + 2);
  FUN_005f74c0(local_c,&local_8,&local_4,*(int *)(iVar8 + 0x5ae) + 0x58);
  uVar10 = *(uint *)(param_1 + 6);
  uVar9 = FUN_006c5018();
  *(uint *)(param_1 + 6) = (uVar9 ^ uVar10) & 0xfff ^ uVar10;
  uVar5 = FUN_005beac0(&DAT_00e0b65c,local_8);
  param_1[1] = (param_1[1] ^ uVar5) & 0x3ff ^ param_1[1];
  uVar10 = FUN_005beac0(&DAT_00e0b6a4,local_4);
  *(uint *)(param_1 + 4) = (*(uint *)(param_1 + 4) ^ uVar10) & 0x3ff ^ *(uint *)(param_1 + 4);
  uVar10 = FUN_00516dfa(*(undefined4 *)(*(int *)(iVar8 + 0x5ae) + 0x3c));
  *(uint *)(param_1 + 2) = (*(uint *)(param_1 + 2) ^ uVar10) & 0xffffff ^ *(uint *)(param_1 + 2);
  iVar11 = FUN_005beac0(&DAT_00e0b68c,*(undefined4 *)(*(int *)(iVar8 + 0x5ae) + 0x40));
  *(uint *)(param_1 + 6) =
       (iVar11 << 0xc ^ *(uint *)(param_1 + 6)) & 0x1ffff000 ^ *(uint *)(param_1 + 6);
  iVar8 = FUN_005beac0(&DAT_00e0b640,
                       *(float *)(*(int *)(iVar8 + 0x5ae) + 8) -
                       *(float *)(*(int *)(iVar8 + 0x5ae) + 0x20));
  *(uint *)(param_1 + 4) =
       (iVar8 << 0x15 ^ *(uint *)(param_1 + 4)) & 0x3fe00000 ^ *(uint *)(param_1 + 4);
  fVar12 = (float10)FUN_00554fa0();
  iVar8 = FUN_005beac0(&DAT_00e0b6dc,(float)fVar12);
  param_1[1] = param_1[1] & 0x3ff ^ (ushort)(iVar8 << 10);
  *(uint *)(param_1 + 4) =
       (DAT_00c0819c << 0x14 ^ *(uint *)(param_1 + 4)) & 0x100000 ^ *(uint *)(param_1 + 4);
  fVar12 = (float10)FUN_00554f10();
  iVar8 = FUN_005beac0(&DAT_00e0b6c0,(float)fVar12);
  *(uint *)(param_1 + 4) = (iVar8 << 10 ^ *(uint *)(param_1 + 4)) & 0xffc00 ^ *(uint *)(param_1 + 4)
  ;
  iVar6 = FUN_00562f70(iVar6);
  fVar1 = *(float *)(iVar6 + 0x1510);
  iVar6 = FUN_005beac0(&DAT_00e0b704,fVar1);
  fVar2 = _DAT_006ea67c;
  uVar10 = iVar6 << 0xb ^ *param_1 & 0x7ff;
  uVar5 = (ushort)uVar10;
  *param_1 = uVar5;
  if ((fVar2 < fVar1) && ((uVar10 & 0xf800) == 0)) {
    *param_1 = uVar5 & 0x7ff | 0x800;
  }
  iVar6 = FUN_00555060();
  *(uint *)(param_1 + 6) = *(uint *)(param_1 + 6) & 0x1fffffff ^ iVar6 << 0x1d;
  uVar7 = FUN_005550c0();
  uVar7 = FUN_005550a0(uVar7);
  uVar7 = FUN_00555080(uVar7);
  iVar6 = FUN_005a2250(uVar7);
  *(uint *)(param_1 + 4) = *(uint *)(param_1 + 4) & 0x3fffffff ^ iVar6 << 0x1e;
  iVar6 = FUN_00555120();
  *(uint *)(param_1 + 2) = *(uint *)(param_1 + 2) & 0x7fffffff ^ iVar6 << 0x1f;
  return;
}

