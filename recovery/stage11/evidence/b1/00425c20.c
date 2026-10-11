/* NR2003.exe @ 00425c20 recovered_00425c20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_00425c20(float param_1)

{
  int iVar1;
  float fVar2;
  char cVar3;
  int iVar4;
  float *pfVar5;
  undefined4 *puVar6;
  uint *puVar7;
  int iVar8;
  undefined *puVar9;
  undefined4 uStack_1c;
  undefined4 uStack_18;
  undefined4 uStack_14;
  undefined4 uStack_10;
  undefined4 uStack_c;
  uint uStack_8;
  undefined4 uStack_4;
  
  FUN_00432cf0((int)param_1 + 0xef1);
  FUN_00538b20();
  cVar3 = func_0x00541100();
  if (cVar3 != '\0') {
    iVar4 = FUN_0051a000();
    param_1 = *(float *)(iVar4 + 0x540);
    pfVar5 = (float *)FUN_00557d60(0x5b);
    *pfVar5 = (DAT_00bddf2c / _DAT_00871a38) / (_DAT_006ed7ac * param_1);
    iVar4 = FUN_0051a000();
    FUN_005f5890(iVar4 + 0x518);
    FUN_0040e980(&uStack_8,*(undefined4 *)(iVar4 + 0x50c),*(undefined4 *)(iVar4 + 0x514),8);
    FUN_005f58a0(iVar4 + 0x518);
    pfVar5 = (float *)FUN_00557d60(0x5c);
    iVar8 = 0x4c;
    puVar9 = &DAT_00bf3c68;
    *pfVar5 = (float)(double)CONCAT44(uStack_4,uStack_8) * _DAT_006ed7ac;
    iVar4 = 0x57;
    do {
      FUN_005f5890(puVar9);
      FUN_00425e80(&param_1,*(undefined4 *)(puVar9 + -0xc),*(undefined4 *)(puVar9 + -4),4);
      FUN_005f58a0(puVar9);
      fVar2 = param_1;
      pfVar5 = (float *)FUN_00557d60(iVar8 + -1);
      *pfVar5 = fVar2;
      FUN_005f5890(puVar9 + -0x2c);
      FUN_00425e80(&uStack_1c,*(undefined4 *)(puVar9 + -0x38),*(undefined4 *)(puVar9 + -0x30),4);
      FUN_005f58a0(puVar9 + -0x2c);
      uStack_18 = uStack_1c;
      puVar6 = (undefined4 *)FUN_00557d60(iVar8);
      *puVar6 = uStack_18;
      FUN_005f5890(puVar9 + -0x58);
      FUN_00425e80(&uStack_14,*(undefined4 *)(puVar9 + -100),*(undefined4 *)(puVar9 + -0x5c),4);
      FUN_005f58a0(puVar9 + -0x58);
      uStack_10 = uStack_14;
      puVar6 = (undefined4 *)FUN_00557d60(iVar8 + 1);
      uStack_c = *(undefined4 *)(puVar9 + 0x58);
      *puVar6 = uStack_10;
      puVar6 = (undefined4 *)FUN_00557d60(iVar4 + -0x10);
      *puVar6 = uStack_c;
      FUN_005f5890(puVar9 + -0x1c8);
      uStack_8 = **(uint **)(puVar9 + -0x1d4) ^ **(uint **)(puVar9 + -0x1cc);
      FUN_005f58a0(puVar9 + -0x1c8);
      puVar7 = (uint *)FUN_00557d60(iVar4);
      iVar8 = iVar8 + 3;
      puVar9 = puVar9 + 0xa39;
      *puVar7 = uStack_8;
      iVar1 = iVar4 + -0x56;
      iVar4 = iVar4 + 1;
    } while (iVar1 < 4);
  }
  return;
}

