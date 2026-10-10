/* NR2003.exe @ 005a2980 FUN_005a2980 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005a2980(ushort *param_1,int param_2)

{
  ushort *puVar1;
  ushort uVar2;
  ushort uVar3;
  uint uVar4;
  uint uVar5;
  int iVar6;
  
  puVar1 = param_1;
  FUN_005c3670(param_1,0);
  uVar3 = *param_1;
  uVar2 = FUN_00546840();
  uVar5 = *(uint *)(param_1 + 6);
  *param_1 = (uVar2 & 0x3ff) * 2 ^ uVar3 & 0xf801;
  *(uint *)(param_1 + 2) =
       (*(int *)(param_2 + 0x5b2) << 0x18 ^ *(uint *)(param_1 + 2)) & 0x7f000000 ^
       *(uint *)(param_1 + 2);
  uVar4 = FUN_006c5018();
  *(uint *)(param_1 + 6) = (uVar4 ^ uVar5) & 0xfff ^ uVar5;
  uVar3 = FUN_005beac0(&DAT_00e0b65c,*(undefined4 *)(param_2 + 0x18ca));
  param_1[1] = (param_1[1] ^ uVar3) & 0x3ff ^ param_1[1];
  uVar5 = FUN_005beac0(&DAT_00e0b6a4,*(undefined4 *)(param_2 + 0x18ce));
  *(uint *)(param_1 + 4) = (*(uint *)(param_1 + 4) ^ uVar5) & 0x3ff ^ *(uint *)(param_1 + 4);
  uVar5 = FUN_00516dfa(*(undefined4 *)(param_2 + 0x186a));
  *(uint *)(param_1 + 2) = (*(uint *)(param_1 + 2) ^ uVar5) & 0xffffff ^ *(uint *)(param_1 + 2);
  iVar6 = FUN_005beac0(&DAT_00e0b68c,*(undefined4 *)(param_2 + 0x1886));
  *(uint *)(param_1 + 6) =
       (iVar6 << 0xc ^ *(uint *)(param_1 + 6)) & 0x1ffff000 ^ *(uint *)(param_1 + 6);
  iVar6 = *(int *)(param_2 + 0x5ae);
  if (iVar6 == 0) {
    param_1 = *(ushort **)(param_2 + 0x18b6);
  }
  else {
    param_1 = (ushort *)(*(float *)(iVar6 + 8) - *(float *)(iVar6 + 0x20));
  }
  iVar6 = FUN_005beac0(&DAT_00e0b640,param_1);
  *(uint *)(puVar1 + 4) =
       (iVar6 << 0x15 ^ *(uint *)(puVar1 + 4)) & 0x3fe00000 ^ *(uint *)(puVar1 + 4);
  iVar6 = FUN_005beac0(&DAT_00e0b6dc,
                       *(float *)(param_2 + 0x19b6) * _DAT_006ecfc8 +
                       *(float *)(param_2 + 0x199e) * _DAT_006ee598);
  puVar1[1] = puVar1[1] & 0x3ff ^ (ushort)(iVar6 << 10);
  *(uint *)(puVar1 + 4) =
       (*(int *)(param_2 + 0x21ec) << 0x14 ^ *(uint *)(puVar1 + 4)) & 0x100000 ^
       *(uint *)(puVar1 + 4);
  iVar6 = FUN_005beac0(&DAT_00e0b6c0,*(undefined4 *)(param_2 + 0x1902));
  *(uint *)(puVar1 + 4) = (iVar6 << 10 ^ *(uint *)(puVar1 + 4)) & 0xffc00 ^ *(uint *)(puVar1 + 4);
  iVar6 = FUN_005beac0(&DAT_00e0b704,*(undefined4 *)(param_2 + 0x19c2));
  *puVar1 = *puVar1 & 0x7ff ^ (ushort)(iVar6 << 0xb);
  iVar6 = 1;
  if (*(int *)(param_2 + 0x18fa) < 1) {
    iVar6 = *(int *)(param_2 + 0x18f6);
  }
  *(uint *)(puVar1 + 6) = *(uint *)(puVar1 + 6) & 0x1fffffff ^ iVar6 << 0x1d;
  iVar6 = FUN_0052e210();
  *(uint *)(puVar1 + 4) = *(uint *)(puVar1 + 4) & 0x3fffffff ^ iVar6 << 0x1e;
  *(uint *)(puVar1 + 2) =
       *(uint *)(puVar1 + 2) & 0x7fffffff ^ (uint)(0 < *(int *)(param_2 + 0x1b2a)) << 0x1f;
  return;
}

