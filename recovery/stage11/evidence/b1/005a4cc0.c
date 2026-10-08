/* NR2003.exe @ 005a4cc0 FUN_005a4cc0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_005a4cc0(undefined4 *param_1_00,undefined4 param_1,undefined4 param_2,undefined4 param_3,
            float param_4)

{
  float fVar1;
  uint uVar2;
  int iVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  int iVar7;
  int iVar8;
  float10 fVar9;
  uint uVar10;
  
  FUN_005f5890(param_1_00 + 0x4d);
  uVar10 = *(uint *)param_1_00[0x4a];
  uVar2 = *(uint *)param_1_00[0x4c];
  FUN_005f58a0(param_1_00 + 0x4d);
  if ((uVar10 ^ uVar2) == 1) {
    return;
  }
  iVar7 = rndInt(param_1_00[0xae]);
  FUN_005f5890(param_1_00 + 0x2f);
  FUN_005f58a0(param_1_00 + 0x2f);
  FUN_005f5890(param_1_00 + 0x3a);
  FUN_005f58a0(param_1_00 + 0x3a);
  uVar10 = param_1_00[0xae];
  iVar8 = FUN_006c5018();
  rndSeed(iVar8,uVar10);
  uVar6 = param_3;
  uVar5 = param_2;
  uVar4 = param_1;
  FUN_005a4690(param_1,param_2,param_3);
  FUN_005a4b10(uVar4,uVar5,uVar6,param_4);
  FUN_005f5890(param_1_00 + 0x2f);
  uVar10 = *(uint *)param_1_00[0x2c];
  uVar2 = *(uint *)param_1_00[0x2e];
  FUN_005f58a0(param_1_00 + 0x2f);
  if ((int)(uVar10 ^ uVar2) < 2) {
    FUN_005f5890(param_1_00 + 0xb2);
    iVar8 = *(int *)param_1_00[0xaf];
    iVar3 = *(int *)param_1_00[0xb1];
    FUN_005f58a0(param_1_00 + 0xb2);
    if (iVar8 == iVar3) {
      fVar1 = (float)param_1_00[0x42] + _DAT_006f6f84;
      goto LAB_005a4e0e;
    }
  }
  fVar1 = (float)param_1_00[0x42];
LAB_005a4e0e:
  param_1_00[0x43] = fVar1;
  FUN_005f5890(param_1_00 + 3);
  FUN_00425e80(&param_1,*param_1_00,param_1_00[2],4);
  FUN_005f58a0(param_1_00 + 3);
  FUN_005f5890(param_1_00 + 0xe);
  FUN_00425e80(&param_4,param_1_00[0xb],param_1_00[0xd],4);
  FUN_005f58a0(param_1_00 + 0xe);
  fVar9 = (float10)FUN_005a3ba0(param_1_00[0x43],param_4 * _DAT_006f6f7c,param_1);
  param_1_00[0x49] = (float)fVar9;
  rndSeed(iVar7,param_1_00[0xae]);
  return;
}

