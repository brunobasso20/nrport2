/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005ab4f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005ab4f0(uint *param_1)

{
  undefined4 uVar1;
  int iVar2;
  uint uVar3;
  uint uVar4;
  int iVar5;
  float *pfVar6;
  float10 fVar7;
  undefined1 local_c [4];
  undefined4 local_8;
  undefined4 local_4;
  
  uVar1 = FUN_0055ab00();
  iVar2 = FUN_00562f70(uVar1);
  uVar4 = *param_1;
  uVar3 = FUN_006c5018();
  *param_1 = (uVar3 ^ uVar4) & 0x3ffffff ^ uVar4;
  uVar4 = FUN_005beac0(&DAT_00e7336c,*(undefined4 *)(*(int *)(iVar2 + 0x5ae) + 0x40));
  param_1[1] = (param_1[1] ^ uVar4) & 0xfffff ^ param_1[1];
  iVar5 = FUN_005beac0(&DAT_00e73240,
                       *(float *)(*(int *)(iVar2 + 0x5ae) + 8) -
                       *(float *)(*(int *)(iVar2 + 0x5ae) + 0x20));
  param_1[1] = param_1[1] & 0xfffff ^ iVar5 << 0x14;
  iVar5 = FUN_0051a000();
  uVar4 = FUN_005beac0(&DAT_00e733e8,*(undefined4 *)(iVar5 + 0x484));
  param_1[2] = (param_1[2] ^ uVar4) & 0x3ff ^ param_1[2];
  FUN_005f74c0(local_c,&local_8,&local_4,*(int *)(iVar2 + 0x5ae) + 0x58);
  uVar4 = param_1[2];
  iVar5 = FUN_006c5018();
  param_1[2] = (iVar5 << 10 ^ uVar4) & 0x3ffc00 ^ uVar4;
  iVar5 = FUN_005beac0(&DAT_00e7325c,local_8);
  param_1[2] = param_1[2] & 0x3fffff ^ iVar5 << 0x16;
  uVar4 = FUN_005beac0(&DAT_00e733cc,local_4);
  uVar4 = param_1[3] & 0xfffe0000 ^ uVar4 & 0x3ff;
  param_1[3] = uVar4;
  iVar5 = FUN_006c5018();
  param_1[3] = (iVar5 << 0x11 ^ uVar4) & 0x1fe0000 ^ uVar4;
  fVar7 = (float10)FUN_00554fa0();
  iVar5 = FUN_005beac0(&DAT_00e73404,(float)fVar7);
  param_1[3] = param_1[3] & 0x1ffffff ^ iVar5 << 0x19;
  param_1[8] = (param_1[8] ^ DAT_00c0819c) & 1 ^ param_1[8];
  iVar5 = FUN_00555120();
  *param_1 = (iVar5 << 0x1a ^ *param_1) & 0x4000000 ^ *param_1;
  iVar5 = FUN_00555060();
  *param_1 = (iVar5 << 0x1b ^ *param_1) & 0x38000000 ^ *param_1;
  FUN_00551920(0);
  uVar4 = param_1[4];
  iVar5 = FUN_006c5018();
  param_1[4] = (iVar5 << 2 ^ uVar4) & 0xffc ^ uVar4;
  FUN_00551920(1);
  iVar5 = FUN_006c5018();
  param_1[4] = param_1[4] & 0x3fffff ^ iVar5 << 0x16;
  FUN_00551920(2);
  uVar4 = param_1[5];
  iVar5 = FUN_006c5018();
  param_1[5] = (iVar5 << 0xc ^ uVar4) & 0x3ff000 ^ uVar4;
  FUN_00551920(3);
  uVar4 = param_1[6];
  iVar5 = FUN_006c5018();
  param_1[6] = (iVar5 << 2 ^ uVar4) & 0xffc ^ uVar4;
  if (DAT_00e73498 == '\0') {
    DAT_00e73420 = param_1[4] >> 2 & 0x3ff;
    DAT_00e73424 = param_1[4] >> 0x16;
    DAT_00e73428 = param_1[5] >> 0xc & 0x3ff;
    DAT_00e7342c = param_1[6] >> 2 & 0x3ff;
  }
  taskGetRate();
  FUN_00551950(0);
  iVar5 = FUN_006c5018();
  uVar4 = ((param_1[4] >> 2) - DAT_00e73420) - iVar5 & 0x3ff;
  if (0x200 < uVar4) {
    uVar4 = uVar4 - 0x400;
  }
  uVar4 = iVar5 + uVar4;
  uVar3 = (uint)(0x3ff < (int)((uVar4 ^ (int)uVar4 >> 0x1f) - ((int)uVar4 >> 0x1f))) << 0x1f |
          *param_1 & 0x7fffffff;
  *param_1 = ((uint)((int)uVar4 < 0) << 0x1e ^ uVar3) & 0x40000000 ^ uVar3;
  FUN_00551950(1);
  iVar5 = FUN_006c5018();
  uVar4 = ((param_1[4] >> 0x16) - DAT_00e73424) - iVar5 & 0x3ff;
  if (0x200 < uVar4) {
    uVar4 = uVar4 - 0x400;
  }
  uVar4 = iVar5 + uVar4;
  uVar3 = ((uint)(0x3ff < (int)((uVar4 ^ (int)uVar4 >> 0x1f) - ((int)uVar4 >> 0x1f))) * 2 ^
          param_1[4]) & 2 ^ param_1[4];
  param_1[4] = ((int)uVar4 < 0 ^ uVar3) & 1 ^ uVar3;
  FUN_00551950(2);
  iVar5 = FUN_006c5018();
  uVar4 = ((param_1[5] >> 0xc) - DAT_00e73428) - iVar5 & 0x3ff;
  if (0x200 < uVar4) {
    uVar4 = uVar4 - 0x400;
  }
  uVar4 = iVar5 + uVar4;
  uVar3 = ((uint)(0x3ff < (int)((uVar4 ^ (int)uVar4 >> 0x1f) - ((int)uVar4 >> 0x1f))) * 2 ^
          param_1[5]) & 2 ^ param_1[5];
  param_1[5] = ((int)uVar4 < 0 ^ uVar3) & 1 ^ uVar3;
  FUN_00551950(3);
  iVar5 = FUN_006c5018();
  uVar4 = ((param_1[6] >> 2) - DAT_00e7342c) - iVar5 & 0x3ff;
  if (0x200 < uVar4) {
    uVar4 = uVar4 - 0x400;
  }
  uVar4 = iVar5 + uVar4;
  uVar3 = ((uint)(0x3ff < (int)((uVar4 ^ (int)uVar4 >> 0x1f) - ((int)uVar4 >> 0x1f))) * 2 ^
          param_1[6]) & 2 ^ param_1[6];
  DAT_00e73420 = param_1[4] >> 2 & 0x3ff;
  param_1[6] = ((int)uVar4 < 0 ^ uVar3) & 1 ^ uVar3;
  DAT_00e73424 = param_1[4] >> 0x16;
  DAT_00e73428 = param_1[5] >> 0xc & 0x3ff;
  DAT_00e7342c = param_1[6] >> 2 & 0x3ff;
  DAT_00e73498 = 1;
  FUN_00551890(0);
  uVar4 = param_1[4];
  iVar5 = FUN_006c5018();
  param_1[4] = (iVar5 << 0xc ^ uVar4) & 0x3ff000 ^ uVar4;
  FUN_00551890(1);
  uVar4 = param_1[5];
  iVar5 = FUN_006c5018();
  param_1[5] = (iVar5 << 2 ^ uVar4) & 0xffc ^ uVar4;
  FUN_00551890(2);
  iVar5 = FUN_006c5018();
  param_1[5] = param_1[5] & 0x3fffff ^ iVar5 << 0x16;
  FUN_00551890(3);
  uVar4 = param_1[6];
  iVar5 = FUN_006c5018();
  param_1[6] = (iVar5 << 0xc ^ uVar4) & 0x3ff000 ^ uVar4;
  FUN_0051a000();
  uVar4 = param_1[6];
  iVar5 = FUN_006c5018();
  param_1[6] = (iVar5 << 0x16 ^ uVar4) & 0x1fc00000 ^ uVar4;
  pfVar6 = (float *)FUN_00562f50();
  iVar5 = FUN_005beac0(&DAT_00e73430,*(float *)(iVar2 + 0x153c) - *pfVar6);
  param_1[6] = param_1[6] & 0x1fffffff ^ iVar5 << 0x1d;
  param_1[7] = iVar5 >> 3 & 0xfU | param_1[7] & 0xfffffff0;
  iVar5 = FUN_005beac0(&DAT_00e73430,*(float *)(iVar2 + 0x1540) - pfVar6[1]);
  param_1[7] = (iVar5 << 4 ^ param_1[7]) & 0x7f0 ^ param_1[7];
  iVar5 = FUN_005beac0(&DAT_00e73430,*(float *)(iVar2 + 0x1544) - pfVar6[2]);
  param_1[7] = (iVar5 << 0xb ^ param_1[7]) & 0x3f800 ^ param_1[7];
  iVar5 = FUN_005beac0(&DAT_00e733b4,*(float *)(iVar2 + 0x154c) - *(float *)(iVar2 + 0x1534));
  param_1[7] = (iVar5 << 0x12 ^ param_1[7]) & 0x1fc0000 ^ param_1[7];
  iVar2 = FUN_005beac0(&DAT_00e733b4,*(float *)(iVar2 + 0x1550) - *(float *)(iVar2 + 0x1538));
  uVar4 = param_1[8];
  param_1[7] = param_1[7] & 0x1ffffff ^ iVar2 << 0x19;
  iVar2 = FUN_006c5018();
  uVar4 = (iVar2 * 2 ^ uVar4) & 0x1fe ^ uVar4;
  param_1[8] = uVar4;
  iVar2 = FUN_006c5018();
  uVar4 = (iVar2 << 9 ^ uVar4) & 0x1fe00 ^ uVar4;
  param_1[8] = uVar4;
  uVar3 = FUN_006c5018();
  param_1[8] = (uVar3 & 0xff) << 0x11 ^ uVar4 & 0x1ffff;
  return;
}


