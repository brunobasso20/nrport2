/* NR2003.exe @ 005a2720 FUN_005a2720 */

void FUN_005a2720(ushort *param_1,int param_2)

{
  ushort *puVar1;
  int iVar2;
  short sVar3;
  ushort uVar4;
  int iVar5;
  int iVar6;
  uint uVar7;
  uint uVar8;
  undefined8 uVar9;
  undefined4 local_8;
  float fStack_4;
  
  iVar2 = param_2;
  puVar1 = param_1;
  iVar6 = *(int *)(param_2 + 0x5b2);
  FUN_005c3670(param_1,0);
  iVar5 = getBGCount();
  sVar3 = FUN_005cebb0(iVar5);
  *puVar1 = (sVar3 * 2 ^ *puVar1) & 0x7fe ^ *puVar1;
  *(uint *)(puVar1 + 2) =
       (iVar6 << 0x18 ^ *(uint *)(puVar1 + 2)) & 0x7f000000 ^ *(uint *)(puVar1 + 2);
  *(uint *)(puVar1 + 6) = *(uint *)(puVar1 + 6) & 0x1fffffff ^ *(int *)(iVar2 + 0x14fc) << 0x1d;
  iVar6 = FUN_005beac0(&DAT_00e0b704,*(undefined4 *)(iVar2 + 0x1510));
  *puVar1 = *puVar1 & 0x7ff ^ (ushort)(iVar6 << 0xb);
  iVar6 = FUN_005beac0(&DAT_00e0b6c0,*(undefined4 *)(iVar2 + 0x1508));
  *(uint *)(puVar1 + 4) = (iVar6 << 10 ^ *(uint *)(puVar1 + 4)) & 0xffc00 ^ *(uint *)(puVar1 + 4);
  iVar6 = FUN_005beac0(&DAT_00e0b6dc,*(undefined4 *)(iVar2 + 0x1554));
  uVar8 = *(uint *)(puVar1 + 4);
  puVar1[1] = puVar1[1] & 0x3ff ^ (ushort)(iVar6 << 10);
  uVar7 = FUN_005a1420();
  *(uint *)(puVar1 + 4) = (uVar7 & 1) << 0x14 ^ uVar8 & 0xffefffff;
  uVar8 = *(uint *)(iVar2 + 0x14fc);
  uVar9 = FUN_005a2250(uVar8 >> 5 & 1,uVar8 >> 6 & 1,uVar8 >> 7 & 1);
  *(uint *)(puVar1 + 4) = (uint)((ulonglong)uVar9 >> 0x20) & 0x3fffffff ^ (int)uVar9 << 0x1e;
  uVar8 = *(int *)(iVar2 + 0x14fc) << 0x1c;
  *(uint *)(puVar1 + 2) = (*(uint *)(puVar1 + 2) ^ uVar8) & 0x7fffffff ^ uVar8;
  FUN_005f74c0(&param_2,&param_1,&local_8,*(int *)(iVar2 + 0x5ae) + 0x58);
  uVar8 = *(uint *)(puVar1 + 6);
  uVar7 = FUN_006c5018();
  *(uint *)(puVar1 + 6) = (uVar7 ^ uVar8) & 0xfff ^ uVar8;
  uVar4 = FUN_005beac0(&DAT_00e0b65c,param_1);
  puVar1[1] = (puVar1[1] ^ uVar4) & 0x3ff ^ puVar1[1];
  uVar8 = FUN_005beac0(&DAT_00e0b6a4,local_8);
  *(uint *)(puVar1 + 4) = (*(uint *)(puVar1 + 4) ^ uVar8) & 0x3ff ^ *(uint *)(puVar1 + 4);
  uVar8 = FUN_00516dfa(*(undefined4 *)(*(int *)(iVar2 + 0x5ae) + 0x3c));
  *(uint *)(puVar1 + 2) = (*(uint *)(puVar1 + 2) ^ uVar8) & 0xffffff ^ *(uint *)(puVar1 + 2);
  iVar6 = FUN_005beac0(&DAT_00e0b68c,*(undefined4 *)(*(int *)(iVar2 + 0x5ae) + 0x40));
  *(uint *)(puVar1 + 6) =
       (iVar6 << 0xc ^ *(uint *)(puVar1 + 6)) & 0x1ffff000 ^ *(uint *)(puVar1 + 6);
  fStack_4 = *(float *)(*(int *)(iVar2 + 0x5ae) + 8) - *(float *)(*(int *)(iVar2 + 0x5ae) + 0x20);
  iVar6 = FUN_005beac0(&DAT_00e0b640,fStack_4);
  *(uint *)(puVar1 + 4) =
       (iVar6 << 0x15 ^ *(uint *)(puVar1 + 4)) & 0x3fe00000 ^ *(uint *)(puVar1 + 4);
  return;
}

