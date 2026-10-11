/* NR2003.exe @ 00521bc0 FUN_00521bc0 */

void __fastcall FUN_00521bc0(int param_1)

{
  undefined4 uVar1;
  int iVar2;
  undefined1 *puVar3;
  int iVar4;
  int iVar5;
  undefined4 *puVar6;
  float *pfVar7;
  float10 fVar8;
  undefined8 uVar9;
  
  iVar2 = 0;
  *(undefined4 *)(param_1 + 0x8f) = 0;
  *(undefined4 *)(param_1 + 0xab) = 0;
  *(undefined4 *)(param_1 + 0xa7) = 0;
  *(undefined4 *)(param_1 + 0x93) = 2;
  *(undefined4 *)(param_1 + 0xb3) = 0;
  *(undefined *)(param_1 + 0xb7) = 0;
  *(undefined *)(param_1 + 0xb8) = 0;
  *(undefined4 *)(param_1 + 0xb9) = 0;
  *(undefined4 *)(param_1 + 0xbd) = 0;
  *(undefined4 *)(param_1 + 0xc1) = 0;
  *(undefined4 *)(param_1 + 0x9f) = 0;
  *(undefined4 *)(param_1 + 0xa3) = 0;
  *(undefined4 *)(param_1 + 0x82) = 0;
  *(undefined *)(param_1 + 0x86) = 0;
  *(undefined *)(param_1 + 0xfc) = 1;
  *(undefined *)(param_1 + 0xfd) = 1;
  *(undefined4 *)(param_1 + 0x104) = 0;
  *(undefined *)(param_1 + 0x108) = 0;
  *(undefined *)(param_1 + 0x10e) = 0;
  *(undefined *)(param_1 + 0x10d) = 1;
  *(undefined *)(param_1 + 0x111) = 1;
  *(undefined *)(param_1 + 0x10f) = 0;
  *(undefined *)(param_1 + 0x110) = 0;
  *(undefined *)(param_1 + 0x112) = 0;
  *(undefined *)(param_1 + 0x113) = 0;
  *(undefined *)(param_1 + 0x100) = 0;
  *(undefined *)(param_1 + 0x101) = 0;
  *(undefined *)(param_1 + 0x102) = 0;
  *(undefined *)(param_1 + 0x103) = 0;
  *(undefined4 *)(param_1 + 0xc5) = 0;
  FUN_005234b0(1,0);
  FUN_00523520(1,0);
  FUN_00523590(5);
  iVar4 = 0;
  do {
    FUN_005235b0(iVar4,0);
    iVar4 = iVar4 + 1;
  } while (iVar4 < 4);
  if (*(char *)(*(int *)(param_1 + 0x89) + 0x59b) != '\0') {
    FUN_00521950();
  }
  *(undefined *)(param_1 + 0x8e) = 0;
  FUN_00521ee0(1);
  iVar5 = 0;
  iVar4 = FUN_0040ece0();
  if (0 < iVar4) {
    do {
      *(undefined *)(param_1 + 0xb3b + iVar5) = 0;
      iVar5 = iVar5 + 1;
      iVar4 = FUN_0040ece0();
    } while (iVar5 < iVar4);
  }
  iVar4 = 0;
  uVar9 = FUN_0040ecf0();
  uVar1 = (undefined4)((ulonglong)uVar9 >> 0x20);
  if (0 < (int)uVar9) {
    do {
      FUN_0051fdc0(param_1,iVar4);
      iVar4 = iVar4 + 1;
      uVar9 = FUN_0040ecf0();
      uVar1 = (undefined4)((ulonglong)uVar9 >> 0x20);
    } while (iVar4 < (int)uVar9);
  }
  FUN_00520130(*(undefined4 *)(param_1 + 0x89),
               CONCAT31((int3)((uint)uVar1 >> 8),*(undefined *)(param_1 + 0x8d)),param_1);
  iVar5 = 0;
  iVar4 = FUN_0040ecf0();
  if (0 < iVar4) {
    puVar6 = (undefined4 *)(param_1 + 0x287);
    do {
      *(undefined *)((int)puVar6 + -5) = 1;
      puVar6[-1] = 0;
      *puVar6 = 0;
      puVar6[1] = 0;
      puVar6[2] = 0;
      puVar6[3] = 0;
      iVar5 = iVar5 + 1;
      puVar6 = (undefined4 *)((int)puVar6 + 0xcb);
      iVar4 = FUN_0040ecf0();
    } while (iVar5 < iVar4);
  }
  if (*(char *)(param_1 + 0x8d) == '\0') {
    FUN_00523ac0(&DAT_00bd64e8 + *(int *)(*(int *)(param_1 + 0x89) + 0x5b2) * 0x68);
    iVar2 = 0;
    do {
      FUN_00523b00(&DAT_00bd44a8 + (iVar2 + *(int *)(*(int *)(param_1 + 0x89) + 0x5b2) * 2) * 0x34,
                   (&DAT_0074ba58)[iVar2],0);
      iVar2 = iVar2 + 1;
    } while (iVar2 < 2);
    iVar2 = *(int *)(param_1 + 0x89);
    *(undefined4 *)(iVar2 + 0x18ee) = 0;
    *(undefined4 *)(iVar2 + 0x1af2) = *(undefined4 *)(iVar2 + 0x1aee);
    return;
  }
  FUN_00523ac0(&DAT_00bd2318);
  iVar5 = 0;
  iVar4 = FUN_0040ecf0();
  if (0 < iVar4) {
    puVar3 = &DAT_00bd0ef0;
    do {
      FUN_00523b00(puVar3,iVar5,0);
      iVar5 = iVar5 + 1;
      puVar3 = puVar3 + 0x34;
      iVar4 = FUN_0040ecf0();
    } while (iVar5 < iVar4);
  }
  FUN_005503d0(0xc9742400,0xc9742400);
  pfVar7 = (float *)(param_1 + 0xda);
  do {
    fVar8 = (float10)FUN_00557e40(iVar2);
    *pfVar7 = (float)fVar8;
    iVar2 = iVar2 + 1;
    pfVar7 = pfVar7 + 1;
  } while (iVar2 < 4);
  uVar1 = FUN_00557ee0(0x40);
  *(undefined4 *)(param_1 + 0xea) = uVar1;
  fVar8 = (float10)FUN_00557e40(0x2e);
  *(float *)(param_1 + 0xee) = (float)fVar8;
  uVar1 = FUN_00557ee0(0x3b);
  *(undefined4 *)(param_1 + 0xf2) = uVar1;
  FUN_00520330(1);
  return;
}

