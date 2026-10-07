/* NR2003.exe @ 005a4690 FUN_005a4690 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_005a4690(int param_1_00,float param_1,undefined4 param_3,undefined4 param_2)

{
  float *pfVar1;
  uint uVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  uint uVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  int iVar14;
  int iVar15;
  float fVar16;
  float10 fVar17;
  float10 fVar18;
  float10 extraout_ST0;
  float10 fVar19;
  float10 fVar20;
  float10 fVar21;
  float10 fVar22;
  float10 extraout_ST1;
  double dVar23;
  double dVar24;
  double dVar25;
  double dVar26;
  
  fVar8 = (float)(int)param_1 + (float)(double)CONCAT44(param_2,param_3) * (float)_DAT_006ee698;
  FUN_005f5890(param_1_00 + 0x214);
  uVar2 = **(uint **)(param_1_00 + 0x208);
  uVar3 = **(uint **)(param_1_00 + 0x210);
  FUN_005f58a0(param_1_00 + 0x214);
  if (fVar8 <= (float)(uVar2 ^ uVar3)) {
    FUN_005f5890(param_1_00 + 0x214);
    uVar2 = **(uint **)(param_1_00 + 0x208);
    uVar3 = **(uint **)(param_1_00 + 0x210);
    FUN_005f58a0(param_1_00 + 0x214);
    fVar19 = (float10)fsin(((float10)fVar8 / (float10)(float)(uVar2 ^ uVar3)) *
                           (float10)_DAT_006ee718);
    FUN_005f5890(param_1_00 + 0x1bc);
    uVar2 = **(uint **)(param_1_00 + 0x1b0);
    uVar3 = **(uint **)(param_1_00 + 0x1b8);
    FUN_005f58a0(param_1_00 + 0x1bc);
    FUN_005f5890(param_1_00 + 0x1e8);
    uVar6 = **(uint **)(param_1_00 + 0x1e4);
    uVar7 = **(uint **)(param_1_00 + 0x1dc);
    FUN_005f58a0(param_1_00 + 0x1e8);
    FUN_005f5890(param_1_00 + 0x1bc);
    uVar4 = **(uint **)(param_1_00 + 0x1b0);
    uVar5 = **(uint **)(param_1_00 + 0x1b8);
    FUN_005f58a0(param_1_00 + 0x1bc);
    param_1 = ((float)(uVar6 ^ uVar7) - (float)(uVar4 ^ uVar5)) * (float)fVar19 +
              (float)(uVar2 ^ uVar3);
  }
  else {
    FUN_005f5890(param_1_00 + 0x1e8);
    param_1 = (float)(**(uint **)(param_1_00 + 0x1dc) ^ **(uint **)(param_1_00 + 0x1e4));
    FUN_005f58a0(param_1_00 + 0x1e8);
  }
  FUN_005f5890(param_1_00 + 0x298);
  uVar2 = **(uint **)(param_1_00 + 0x28c);
  uVar3 = **(uint **)(param_1_00 + 0x294);
  FUN_005f58a0(param_1_00 + 0x298);
  fVar17 = (float10)fcos((float10)param_1);
  FUN_005f5890(param_1_00 + 0x298);
  uVar6 = **(uint **)(param_1_00 + 0x28c);
  uVar7 = **(uint **)(param_1_00 + 0x294);
  FUN_005f58a0(param_1_00 + 0x298);
  fVar18 = (float10)fsin((float10)param_1);
  iVar14 = FUN_006c5018();
  iVar15 = FUN_006c5018();
  fVar19 = (float10)fsin((extraout_ST1 - (float10)iVar14) * (float10)_DAT_006ee718);
  fVar20 = (float10)fsin((extraout_ST0 - (float10)iVar15) * (float10)_DAT_006ee718);
  FUN_005f5890(param_1_00 + 0x240);
  fVar16 = (float)(**(uint **)(param_1_00 + 0x234) ^ **(uint **)(param_1_00 + 0x23c));
  FUN_005f58a0(param_1_00 + 0x240);
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar14,*(uint *)(param_1_00 + 0x2b8));
  dVar23 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar8 = ((float)dVar23 - (float)_DAT_006ea668) * fVar16;
  fVar8 = fVar8 + fVar8;
  dVar23 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar9 = (float)_DAT_006ee728;
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar14 + 1,*(uint *)(param_1_00 + 0x2b8));
  dVar24 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar10 = ((float)dVar24 - (float)_DAT_006ea668) * fVar16;
  dVar24 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar11 = (float)_DAT_006ee728;
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar15,*(uint *)(param_1_00 + 0x2b8));
  dVar25 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar12 = ((float)dVar25 - (float)_DAT_006ea668) * fVar16;
  fVar12 = fVar12 + fVar12;
  dVar25 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar13 = (float)_DAT_006ee728;
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar15 + 1,*(uint *)(param_1_00 + 0x2b8));
  dVar26 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar16 = ((float)dVar26 - (float)_DAT_006ea668) * fVar16;
  fVar8 = ((fVar10 + fVar10) - fVar8) * (float)fVar19 + fVar8;
  fVar12 = ((fVar16 + fVar16) - fVar12) * (float)fVar20 + fVar12;
  fVar9 = ((float)dVar24 * fVar11 - (float)dVar23 * fVar9) * (float)fVar19 + (float)dVar23 * fVar9;
  dVar23 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar19 = (float10)_DAT_006ee728;
  pfVar1 = (float *)(param_1_00 + 0x118);
  *(undefined4 *)(param_1_00 + 0x120) = 0;
  fVar19 = ((float10)dVar23 * fVar19 - (float10)((float)dVar25 * fVar13)) * (float10)(float)fVar20 +
           (float10)((float)dVar25 * fVar13);
  fVar20 = (float10)fcos((float10)fVar9);
  fVar21 = (float10)fsin((float10)fVar9);
  fVar22 = (float10)fcos(fVar19);
  fVar19 = (float10)fsin(fVar19);
  *pfVar1 = (float)(-(fVar22 * (float10)fVar12) + -(fVar20 * (float10)fVar8) +
                   (float10)(float)(-fVar17 * (float10)(float)(uVar2 ^ uVar3)));
  *(float *)(param_1_00 + 0x11c) =
       (float)-(fVar19 * (float10)fVar12) + (float)-(fVar21 * (float10)fVar8) +
       (float)(-fVar18 * (float10)(float)(uVar6 ^ uVar7));
  *(float *)(param_1_00 + 0x114) =
       SQRT(*(float *)(param_1_00 + 0x120) * *(float *)(param_1_00 + 0x120) +
            *(float *)(param_1_00 + 0x11c) * *(float *)(param_1_00 + 0x11c) + *pfVar1 * *pfVar1);
  FUN_005f6a70(pfVar1);
  fVar19 = (float10)fpatan((float10)*(float *)(param_1_00 + 0x11c),(float10)*pfVar1);
  *(float *)(param_1_00 + 0x110) = (float)fVar19;
  return;
}

