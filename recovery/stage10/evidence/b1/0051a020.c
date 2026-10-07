/* NR2003.exe @ 0051a020 FUN_0051a020 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0051a020(int param_1_00,uint param_1)

{
  uint **ppuVar1;
  float fVar2;
  bool bVar3;
  uint uVar4;
  undefined4 uVar5;
  uint *puVar6;
  int iVar7;
  int iVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  int local_4;
  
  uVar5 = *(undefined4 *)(*(int *)(param_1_00 + 0x56a) + 0x2c);
  *(uint *)(param_1_00 + 0x478) = param_1;
  *(undefined4 *)(param_1_00 + 0x438) = uVar5;
  *(undefined4 *)(param_1_00 + 0x10) = 0;
  *(undefined4 *)(param_1_00 + 0x14) = 0x3ba3d70a;
  *(undefined4 *)(param_1_00 + 0x18) = 0x80;
  *(undefined4 *)(param_1_00 + 0x224) = 0;
  *(undefined4 *)(param_1_00 + 0x228) = 0x3ba3d70a;
  *(undefined4 *)(param_1_00 + 0x22c) = 0x80;
  local_4 = param_1_00;
  FUN_0051a4a0(param_1_00,*(int *)(param_1_00 + 0x56a));
  ppuVar1 = (uint **)(param_1_00 + 0x4a4);
  local_4 = 0x42ba0000;
  FUN_005f5890(param_1_00 + 0x4b0);
  param_1 = **(uint **)(param_1_00 + 0x4a8) ^ DAT_00f72118;
  if (param_1 != **ppuVar1) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x3f) == 0) {
    FUN_004f68c0(*(undefined4 *)(param_1_00 + 0x4ac),4);
  }
  FUN_00425e80(*ppuVar1,&local_4,*(undefined4 *)(param_1_00 + 0x4ac),4);
  FUN_00425e80(*(undefined4 *)(param_1_00 + 0x4a8),&DAT_00f72118,*ppuVar1,4);
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x3ff) == 0) {
    uVar5 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x4ac));
    *(undefined4 *)(param_1_00 + 0x4ac) = uVar5;
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x1ff) == 0) {
    puVar6 = (uint *)FUN_0051c5d0(*ppuVar1);
    *ppuVar1 = puVar6;
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x7ff) == 0) {
    uVar5 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x4a8));
    *(undefined4 *)(param_1_00 + 0x4a8) = uVar5;
  }
  FUN_005f58a0(param_1_00 + 0x4b0);
  FUN_0051a3c0(param_1_00,*(undefined4 *)(param_1_00 + 0x56a));
  FUN_0051a680(param_1_00,*(undefined4 *)(param_1_00 + 0x56a));
  ppuVar1 = (uint **)(param_1_00 + 0x4d4);
  local_4 = 0;
  uVar5 = *(undefined4 *)(*(int *)(param_1_00 + 0x56a) + 0x34);
  *(undefined4 *)(param_1_00 + 0x4d0) = 0x402e2650;
  *(undefined4 *)(param_1_00 + 0x4a0) = uVar5;
  *(undefined4 *)(param_1_00 + 0x49c) = *(undefined4 *)(*(int *)(param_1_00 + 0x56a) + 0x38);
  FUN_005f5890(param_1_00 + 0x4e0);
  FUN_00425e80(&param_1,*(undefined4 *)(param_1_00 + 0x4d8),&DAT_00f72118,4);
  if (param_1 != **ppuVar1) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x3f) == 0) {
    FUN_004f68c0(*(undefined4 *)(param_1_00 + 0x4dc),4);
  }
  FUN_00425e80(*ppuVar1,&local_4,*(undefined4 *)(param_1_00 + 0x4dc),4);
  FUN_00425e80(*(undefined4 *)(param_1_00 + 0x4d8),&DAT_00f72118,*ppuVar1,4);
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x3ff) == 0) {
    uVar5 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x4dc));
    *(undefined4 *)(param_1_00 + 0x4dc) = uVar5;
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x1ff) == 0) {
    puVar6 = (uint *)FUN_0051c5d0(*ppuVar1);
    *ppuVar1 = puVar6;
  }
  uVar4 = FUN_005cfcfc();
  if ((uVar4 & 0x7ff) == 0) {
    uVar5 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x4d8));
    *(undefined4 *)(param_1_00 + 0x4d8) = uVar5;
  }
  FUN_005f58a0(param_1_00 + 0x4e0);
  *(undefined4 *)(param_1_00 + 0x43c) = *(undefined4 *)(*(int *)(param_1_00 + 0x56a) + 0x3c);
  *(undefined4 *)(param_1_00 + 0x440) = *(undefined4 *)(*(int *)(param_1_00 + 0x56a) + 0x40);
  *(undefined4 *)(param_1_00 + 0x508) = 0;
  *(undefined4 *)(param_1_00 + 0x558) = 0;
  *(uint *)(param_1_00 + 0x548) = *(uint *)(param_1_00 + 0x548) & 0xffffffc0;
  *(undefined4 *)(param_1_00 + 0x504) = 0x415ccccd;
  bVar3 = inBackground();
  if (bVar3) {
    iVar7 = FUN_00567280();
  }
  else {
    iVar7 = FUN_005099b0();
  }
  bVar3 = inBackground();
  if (bVar3) {
    iVar8 = thunk_FUN_0055a730();
  }
  else {
    iVar8 = FUN_00509b60(0xffffffff);
  }
  if ((iVar7 == 7) && (iVar8 < 2)) {
    uVar4 = *(uint *)(param_1_00 + 0x548) & 0xfffffffd ^ 2;
  }
  else {
    uVar4 = *(uint *)(param_1_00 + 0x548) | 0x22;
  }
  *(uint *)(param_1_00 + 0x548) = uVar4;
  *(undefined4 *)(param_1_00 + 0x54c) = 0xffffffff;
  *(undefined4 *)(param_1_00 + 0x550) = 0x3e800000;
  fVar2 = _DAT_006ea454;
  if (((byte)*(undefined4 *)(param_1_00 + 0x548) & 0x20) == 0x20) {
    fVar2 = _DAT_006e97d8;
  }
  *(float *)(param_1_00 + 0x554) = fVar2;
  fVar2 = fVar2 * _DAT_006f473c;
  *(undefined4 *)(param_1_00 + 0x55c) = 0x488d9a00;
  *(undefined4 *)(param_1_00 + 0x560) = 0;
  *(undefined4 *)(param_1_00 + 0x494) = 0;
  *(undefined4 *)(param_1_00 + 0x498) = 0;
  *(undefined4 *)(param_1_00 + 0x48c) = 0;
  *(undefined4 *)(param_1_00 + 0x490) = 0;
  *(float *)(param_1_00 + 0x484) = fVar2;
  *(undefined *)(param_1_00 + 0x564) = 0;
  *(undefined *)(param_1_00 + 0x565) = 0;
  iVar7 = FUN_0051a000();
  if (iVar7 == param_1_00) {
    uVar10 = 0;
    uVar9 = 0x470;
    uVar5 = 3;
    FUN_00538b20(3,param_1_00,0x470,0);
    FUN_00540b80(uVar5,param_1_00,uVar9,uVar10);
  }
  return;
}

