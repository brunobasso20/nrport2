/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005a4690 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_005a4690(int param_1_00,float param_1,undefined4 param_3,undefined4 param_2)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  uint uVar7;
  uint uVar8;
  uint uVar9;
  int iVar10;
  int iVar11;
  float fVar12;
  float10 fVar13;
  float10 fVar14;
  float10 extraout_ST0;
  float10 fVar15;
  float10 fVar16;
  float10 fVar17;
  float10 fVar18;
  float10 fVar19;
  float10 fVar20;
  float10 fVar21;
  float10 extraout_ST1;
  double dVar22;
  double dVar23;
  double dVar24;
  double dVar25;
  
  fVar2 = (float)((float10)(int)param_1 +
                 (float10)(double)CONCAT44(param_2,param_3) * (float10)_DAT_006ee698);
  FUN_005f5890(param_1_00 + 0x214);
  uVar4 = **(uint **)(param_1_00 + 0x208);
  uVar5 = **(uint **)(param_1_00 + 0x210);
  FUN_005f58a0(param_1_00 + 0x214);
  if (fVar2 <= (float)(uVar4 ^ uVar5)) {
    FUN_005f5890(param_1_00 + 0x214);
    uVar4 = **(uint **)(param_1_00 + 0x208);
    uVar5 = **(uint **)(param_1_00 + 0x210);
    FUN_005f58a0(param_1_00 + 0x214);
    fVar17 = (float10)fsin(((float10)fVar2 / (float10)(float)(uVar4 ^ uVar5)) *
                           (float10)_DAT_006ee718);
    FUN_005f5890(param_1_00 + 0x1bc);
    uVar4 = **(uint **)(param_1_00 + 0x1b0);
    uVar5 = **(uint **)(param_1_00 + 0x1b8);
    FUN_005f58a0(param_1_00 + 0x1bc);
    FUN_005f5890(param_1_00 + 0x1e8);
    uVar8 = **(uint **)(param_1_00 + 0x1e4);
    uVar9 = **(uint **)(param_1_00 + 0x1dc);
    FUN_005f58a0(param_1_00 + 0x1e8);
    FUN_005f5890(param_1_00 + 0x1bc);
    uVar6 = **(uint **)(param_1_00 + 0x1b0);
    uVar7 = **(uint **)(param_1_00 + 0x1b8);
    FUN_005f58a0(param_1_00 + 0x1bc);
    param_1 = ((float)(uVar8 ^ uVar9) - (float)(uVar6 ^ uVar7)) * (float)fVar17 +
              (float)(uVar4 ^ uVar5);
  }
  else {
    FUN_005f5890(param_1_00 + 0x1e8);
    param_1 = (float)(**(uint **)(param_1_00 + 0x1dc) ^ **(uint **)(param_1_00 + 0x1e4));
    FUN_005f58a0(param_1_00 + 0x1e8);
  }
  FUN_005f5890(param_1_00 + 0x298);
  uVar4 = **(uint **)(param_1_00 + 0x28c);
  uVar5 = **(uint **)(param_1_00 + 0x294);
  FUN_005f58a0(param_1_00 + 0x298);
  fVar13 = (float10)fcos((float10)param_1);
  FUN_005f5890(param_1_00 + 0x298);
  uVar8 = **(uint **)(param_1_00 + 0x28c);
  uVar9 = **(uint **)(param_1_00 + 0x294);
  FUN_005f58a0(param_1_00 + 0x298);
  fVar14 = (float10)fsin((float10)param_1);
  iVar10 = FUN_006c5018();
  iVar11 = FUN_006c5018();
  fVar15 = (float10)fsin((extraout_ST1 - (float10)iVar10) * (float10)_DAT_006ee718);
  fVar16 = (float10)fsin((extraout_ST0 - (float10)iVar11) * (float10)_DAT_006ee718);
  FUN_005f5890(param_1_00 + 0x240);
  fVar12 = (float)(**(uint **)(param_1_00 + 0x234) ^ **(uint **)(param_1_00 + 0x23c));
  FUN_005f58a0(param_1_00 + 0x240);
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar10,*(uint *)(param_1_00 + 0x2b8));
  dVar22 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar17 = ((float10)dVar22 - (float10)_DAT_006ea668) * (float10)fVar12;
  fVar2 = (float)(fVar17 + fVar17);
  dVar22 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar17 = (float10)_DAT_006ee728;
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar10 + 1,*(uint *)(param_1_00 + 0x2b8));
  dVar23 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar18 = ((float10)dVar23 - (float10)_DAT_006ea668) * (float10)fVar12;
  dVar23 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar21 = (float10)_DAT_006ee728;
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar11,*(uint *)(param_1_00 + 0x2b8));
  dVar24 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar19 = ((float10)dVar24 - (float10)_DAT_006ea668) * (float10)fVar12;
  fVar3 = (float)(fVar19 + fVar19);
  dVar24 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar19 = (float10)_DAT_006ee728;
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar11 + 1,*(uint *)(param_1_00 + 0x2b8));
  dVar25 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar20 = ((float10)dVar25 - (float10)_DAT_006ea668) * (float10)fVar12;
  fVar2 = ((float)(fVar18 + fVar18) - fVar2) * (float)fVar15 + fVar2;
  fVar3 = (float)(((fVar20 + fVar20) - (float10)fVar3) * (float10)(float)fVar16 + (float10)fVar3);
  fVar12 = ((float)((float10)dVar23 * fVar21) - (float)((float10)dVar22 * fVar17)) * (float)fVar15 +
           (float)((float10)dVar22 * fVar17);
  dVar22 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar17 = (float10)_DAT_006ee728;
  pfVar1 = (float *)(param_1_00 + 0x118);
  *(undefined4 *)(param_1_00 + 0x120) = 0;
  fVar17 = ((float10)dVar22 * fVar17 - (float10)(float)((float10)dVar24 * fVar19)) *
           (float10)(float)fVar16 + (float10)(float)((float10)dVar24 * fVar19);
  fVar21 = (float10)fcos((float10)fVar12);
  fVar19 = (float10)fsin((float10)fVar12);
  fVar15 = (float10)fcos(fVar17);
  fVar17 = (float10)fsin(fVar17);
  *pfVar1 = (float)(-(fVar15 * (float10)fVar3) + -(fVar21 * (float10)fVar2) +
                   (float10)(float)(-fVar13 * (float10)(float)(uVar4 ^ uVar5)));
  *(float *)(param_1_00 + 0x11c) =
       (float)-(fVar17 * (float10)fVar3) + (float)-(fVar19 * (float10)fVar2) +
       (float)(-fVar14 * (float10)(float)(uVar8 ^ uVar9));
  *(float *)(param_1_00 + 0x114) =
       SQRT(*(float *)(param_1_00 + 0x120) * *(float *)(param_1_00 + 0x120) +
            *(float *)(param_1_00 + 0x11c) * *(float *)(param_1_00 + 0x11c) + *pfVar1 * *pfVar1);
  FUN_005f6a70(pfVar1);
  fVar17 = (float10)fpatan((float10)*(float *)(param_1_00 + 0x11c),(float10)*pfVar1);
  *(float *)(param_1_00 + 0x110) = (float)fVar17;
  return;
}


