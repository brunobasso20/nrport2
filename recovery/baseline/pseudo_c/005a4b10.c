/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005a4b10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_005a4b10(int param_1_00,int param_1,undefined4 param_3,undefined4 param_2,int param_5)

{
  float fVar1;
  float fVar2;
  int iVar3;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  uint uVar7;
  uint uVar8;
  uint uVar9;
  float10 fVar10;
  float10 fVar11;
  int iVar12;
  float10 fVar13;
  float10 fVar14;
  float10 fVar15;
  double dVar16;
  
  fVar1 = (float)((float10)(double)CONCAT44(param_2,param_3) * (float10)_DAT_006ee698);
  FUN_005f5890(param_1_00 + 0x2c8);
  iVar12 = **(int **)(param_1_00 + 700);
  iVar3 = **(int **)(param_1_00 + 0x2c4);
  FUN_005f58a0(param_1_00 + 0x2c8);
  fVar13 = (float10)fcos(((float10)(int)((-(uint)(iVar12 != iVar3) & 6) + param_1) + (float10)fVar1)
                         * (float10)_DAT_006f53c0 * (float10)_DAT_006ee720);
  fVar10 = (float10)_DAT_006e9808;
  fVar11 = (float10)_DAT_006ea44c;
  FUN_005f5890(param_1_00 + 400);
  uVar4 = **(uint **)(param_1_00 + 0x184);
  uVar5 = **(uint **)(param_1_00 + 0x18c);
  FUN_005f58a0(param_1_00 + 400);
  FUN_005f5890(param_1_00 + 0x164);
  uVar6 = **(uint **)(param_1_00 + 0x158);
  uVar7 = **(uint **)(param_1_00 + 0x160);
  FUN_005f58a0(param_1_00 + 0x164);
  FUN_005f5890(param_1_00 + 400);
  uVar8 = **(uint **)(param_1_00 + 0x184);
  uVar9 = **(uint **)(param_1_00 + 0x18c);
  FUN_005f58a0(param_1_00 + 400);
  iVar12 = FUN_006c5018();
  rndSeed(*(int *)(param_1_00 + 0x154) + iVar12,*(uint *)(param_1_00 + 0x2b8));
  dVar16 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar14 = ((float10)dVar16 - (float10)_DAT_006ea668) * (float10)*(float *)(param_5 + 4);
  fVar2 = (float)(fVar14 + fVar14);
  rndSeed(*(int *)(param_1_00 + 0x154) + 1 + iVar12,*(uint *)(param_1_00 + 0x2b8));
  dVar16 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
  fVar14 = ((float10)dVar16 - (float10)_DAT_006ea668) * (float10)*(float *)(param_5 + 4);
  fVar15 = (float10)fsin(((float10)((float)param_1 + fVar1) - (float10)iVar12) *
                         (float10)_DAT_006ee718);
  *(float *)(param_1_00 + 0x108) =
       (float)(((float10)(float)(uVar6 ^ uVar7) - (float10)(float)(uVar8 ^ uVar9)) *
               (float10)(float)((fVar13 + fVar10) * fVar11) + (float10)(float)(uVar4 ^ uVar5) +
              fVar15 * ((fVar14 + fVar14) - (float10)fVar2) + (float10)fVar2);
  return;
}


