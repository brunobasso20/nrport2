/* NR2003.exe @ 005a3c00 FUN_005a3c00 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_005a3c00(int param_1_00,float param_1)

{
  uint **ppuVar1;
  float fVar2;
  uint uVar3;
  undefined4 uVar4;
  uint *puVar5;
  int iVar6;
  int iVar7;
  float10 fVar8;
  float10 fVar9;
  uint local_c;
  uint local_8;
  undefined4 uStack_4;
  
  iVar7 = (int)param_1;
  local_8 = *(uint *)((int)param_1 + 0x54);
  ppuVar1 = (uint **)(param_1_00 + 0x128);
  FUN_005f5890(param_1_00 + 0x134);
  FUN_005a5820(&local_c,*(undefined4 *)(param_1_00 + 300),&DAT_00f7211c,4);
  if (local_c != **ppuVar1) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3f) == 0) {
    FUN_005a5bf0(*(undefined4 *)(param_1_00 + 0x130),4);
  }
  FUN_005a5820(*ppuVar1,&local_8,*(undefined4 *)(param_1_00 + 0x130),4);
  FUN_005a5820(*(undefined4 *)(param_1_00 + 300),&DAT_00f7211c,*ppuVar1,4);
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3ff) == 0) {
    uVar4 = FUN_005a5970(*(undefined4 *)(param_1_00 + 0x130));
    *(undefined4 *)(param_1_00 + 0x130) = uVar4;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x1ff) == 0) {
    puVar5 = (uint *)FUN_005a5970(*ppuVar1);
    *ppuVar1 = puVar5;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x7ff) == 0) {
    uVar4 = FUN_005a5970(*(undefined4 *)(param_1_00 + 300));
    *(undefined4 *)(param_1_00 + 300) = uVar4;
  }
  FUN_005f58a0(param_1_00 + 0x134);
  ppuVar1 = (uint **)(param_1_00 + 700);
  local_c = *(uint *)(iVar7 + 0x48) >> 1 & 1;
  FUN_005f5890(param_1_00 + 0x2c8);
  FUN_005a5820(&local_8,*(undefined4 *)(param_1_00 + 0x2c0),&DAT_00f7211c,4);
  if (local_8 != **ppuVar1) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3f) == 0) {
    FUN_005a5bf0(*(undefined4 *)(param_1_00 + 0x2c4),4);
  }
  FUN_005a5820(*ppuVar1,&local_c,*(undefined4 *)(param_1_00 + 0x2c4),4);
  FUN_005a5820(*(undefined4 *)(param_1_00 + 0x2c0),&DAT_00f7211c,*ppuVar1,4);
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3ff) == 0) {
    uVar4 = FUN_005a5970(*(undefined4 *)(param_1_00 + 0x2c4));
    *(undefined4 *)(param_1_00 + 0x2c4) = uVar4;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x1ff) == 0) {
    puVar5 = (uint *)FUN_005a5970(*ppuVar1);
    *ppuVar1 = puVar5;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x7ff) == 0) {
    uVar4 = FUN_005a5970(*(undefined4 *)(param_1_00 + 0x2c0));
    *(undefined4 *)(param_1_00 + 0x2c0) = uVar4;
  }
  FUN_005f58a0(param_1_00 + 0x2c8);
  local_c = *(uint *)(iVar7 + 0x58);
  ppuVar1 = (uint **)(param_1_00 + 0xb0);
  FUN_005f5890(param_1_00 + 0xbc);
  FUN_005a5820(&local_8,*(undefined4 *)(param_1_00 + 0xb4),&DAT_00f7211c,4);
  if (local_8 != **ppuVar1) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3f) == 0) {
    FUN_005a5bf0(*(undefined4 *)(param_1_00 + 0xb8),4);
  }
  FUN_005a5820(*ppuVar1,&local_c,*(undefined4 *)(param_1_00 + 0xb8),4);
  FUN_005a5820(*(undefined4 *)(param_1_00 + 0xb4),&DAT_00f7211c,*ppuVar1,4);
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3ff) == 0) {
    uVar4 = FUN_005a5970(*(undefined4 *)(param_1_00 + 0xb8));
    *(undefined4 *)(param_1_00 + 0xb8) = uVar4;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x1ff) == 0) {
    puVar5 = (uint *)FUN_005a5970(*ppuVar1);
    *ppuVar1 = puVar5;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x7ff) == 0) {
    uVar4 = FUN_005a5970(*(undefined4 *)(param_1_00 + 0xb4));
    *(undefined4 *)(param_1_00 + 0xb4) = uVar4;
  }
  FUN_005f58a0(param_1_00 + 0xbc);
  FUN_005f5890(param_1_00 + 0xbc);
  FUN_005a5820(&local_8,*ppuVar1,*(undefined4 *)(param_1_00 + 0xb8),4);
  FUN_005f58a0(param_1_00 + 0xbc);
  FUN_0051c3f0(&DAT_006f6f64 + local_8 * 4);
  iVar7 = (int)param_1;
  param_1 = (float)(uint)*(byte *)((int)param_1 + 0x5c);
  *(float *)(param_1_00 + 0x108) = ((float)(int)param_1 - _DAT_006efe7c) * _DAT_006f53b8;
  FUN_005f5890(param_1_00 + 0xbc);
  FUN_005a5820(&param_1,*ppuVar1,*(undefined4 *)(param_1_00 + 0xb8),4);
  FUN_005f58a0(param_1_00 + 0xbc);
  if ((int)param_1 < 2) {
    iVar6 = FUN_005a57f0();
    if (iVar6 == 0) {
      fVar2 = *(float *)(param_1_00 + 0x108) + _DAT_006f6f84;
      goto LAB_005a3f9a;
    }
  }
  fVar2 = *(float *)(param_1_00 + 0x108);
LAB_005a3f9a:
  *(float *)(param_1_00 + 0x10c) = fVar2;
  uStack_4 = 0;
  local_8 = *(uint *)(iVar7 + 0x4c) >> 0x1a & 7;
  param_1 = (float)(ulonglong)local_8 * _DAT_006f6f80;
  FUN_0051c3f0(&param_1);
  param_1 = (float)(uint)*(byte *)(iVar7 + 0x5d);
  *(float *)(param_1_00 + 0x114) = (float)(int)param_1 * (float)_DAT_006ef7b0;
  fVar8 = (float10)FUN_0054fb50();
  *(float *)(param_1_00 + 0x110) = (float)fVar8;
  uVar3 = *(uint *)(param_1_00 + 0x2b8);
  fVar9 = (float10)fcos((float10)DAT_00bdbcf8 - fVar8);
  *(float *)(param_1_00 + 0x118) = (float)-(fVar9 * (float10)*(float *)(param_1_00 + 0x114));
  fVar8 = (float10)fsin((float10)DAT_00bdbcf8 - fVar8);
  *(float *)(param_1_00 + 0x11c) = (float)-(fVar8 * (float10)*(float *)(param_1_00 + 0x114));
  *(undefined4 *)(param_1_00 + 0x154) = *(undefined4 *)(iVar7 + 0x40);
  iVar6 = FUN_005a57f0();
  uStack_4 = 0;
  local_8 = iVar6 + *(int *)(iVar7 + 0x40);
  param_1 = (float)(ulonglong)local_8;
  FUN_0054fb50();
  iVar7 = FUN_006c5018();
  rndSeed(iVar7,uVar3);
  rndUniform(*(uint *)(param_1_00 + 0x2b8));
  param_1 = (float)FUN_006c5018();
  FUN_005a5620(&param_1);
  fVar8 = (float10)FUN_0054fb50();
  fVar8 = (float10)FUN_0054fb50((float)fVar8);
  fVar8 = (float10)FUN_005a3ba0(*(undefined4 *)(param_1_00 + 0x10c),
                                (float)(fVar8 * (float10)_DAT_006f6f7c));
  *(float *)(param_1_00 + 0x124) = (float)fVar8;
  return;
}

