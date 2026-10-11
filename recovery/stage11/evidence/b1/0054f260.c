/* NR2003.exe @ 0054f260 FUN_0054f260 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0054f260(int param_1_00,float param_1,float param_2)

{
  int iVar1;
  uint **ppuVar2;
  float fVar3;
  float fVar4;
  uint uVar5;
  undefined4 *puVar6;
  float fVar7;
  float fVar8;
  uint uVar9;
  undefined4 uVar10;
  uint uVar11;
  uint *puVar12;
  
  fVar4 = DAT_00bf3a00;
  fVar3 = *(float *)(param_1_00 + 0x5c);
  ppuVar2 = (uint **)(param_1_00 + 0x26c);
  FUN_005f5890(param_1_00 + 0x278);
  uVar11 = **ppuVar2;
  uVar5 = **(uint **)(param_1_00 + 0x274);
  FUN_005f58a0(param_1_00 + 0x278);
  fVar7 = SQRT(fVar4) + _DAT_006e97d8;
  fVar8 = (float)(uVar11 ^ uVar5) - _DAT_0074c954;
  fVar4 = *(float *)(param_1_00 + 0x60);
  iVar1 = param_1_00 + 0x278;
  FUN_005f5890(iVar1);
  uVar11 = **ppuVar2;
  uVar5 = **(uint **)(param_1_00 + 0x274);
  FUN_005f58a0(iVar1);
  FUN_005f5890(iVar1);
  if ((**(uint **)(param_1_00 + 0x270) ^ DAT_00f72118) != **ppuVar2) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar9 = FUN_005cfcfc();
  if ((uVar9 & 0x3f) == 0) {
    puVar6 = *(undefined4 **)(param_1_00 + 0x274);
    uVar10 = FUN_005cfcfc();
    *puVar6 = uVar10;
  }
  **ppuVar2 = **(uint **)(param_1_00 + 0x274) ^
              (uint)((param_2 / fVar3 - fVar8 * fVar7 * fVar4) * param_1 + (float)(uVar11 ^ uVar5));
  **(uint **)(param_1_00 + 0x270) = **ppuVar2 ^ DAT_00f72118;
  uVar11 = FUN_005cfcfc();
  if ((uVar11 & 0x3ff) == 0) {
    uVar10 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x274));
    *(undefined4 *)(param_1_00 + 0x274) = uVar10;
  }
  uVar11 = FUN_005cfcfc();
  if ((uVar11 & 0x1ff) == 0) {
    puVar12 = (uint *)FUN_0051c5d0(*ppuVar2);
    *ppuVar2 = puVar12;
  }
  uVar11 = FUN_005cfcfc();
  if ((uVar11 & 0x7ff) == 0) {
    uVar10 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x270));
    *(undefined4 *)(param_1_00 + 0x270) = uVar10;
  }
  FUN_005f58a0(iVar1);
  return;
}

