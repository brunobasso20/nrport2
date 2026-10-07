/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040bde0 */

float10 __thiscall FUN_0040bde0(undefined4 *param_1,double *param_2)

{
  uint uVar1;
  uint **ppuVar2;
  uint uVar3;
  undefined4 uVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  uint *puVar7;
  double *pdVar8;
  uint *puVar9;
  uint *puVar10;
  int iVar11;
  bool bVar12;
  uint *local_c;
  uint uStack_8;
  undefined4 *local_4;
  
  local_4 = param_1 + 3;
  FUN_005f5890(local_4);
  puVar7 = (uint *)param_1[1];
  puVar10 = &DAT_00f72120;
  ppuVar2 = &local_c;
  iVar11 = 2;
  do {
    uVar3 = *puVar7;
    puVar7 = puVar7 + 1;
    *ppuVar2 = (uint *)(uVar3 ^ *puVar10);
    ppuVar2 = ppuVar2 + 1;
    puVar10 = puVar10 + 1;
    iVar11 = iVar11 + -1;
  } while (iVar11 != 0);
  puVar7 = (uint *)*param_1;
  iVar11 = 2;
  bVar12 = true;
  ppuVar2 = &local_c;
  puVar10 = puVar7;
  do {
    if (iVar11 == 0) break;
    iVar11 = iVar11 + -1;
    bVar12 = *ppuVar2 == (uint *)*puVar10;
    ppuVar2 = ppuVar2 + 1;
    puVar10 = puVar10 + 1;
  } while (bVar12);
  if (!bVar12) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3f) == 0) {
    puVar5 = (undefined4 *)param_1[2];
    iVar11 = 2;
    do {
      uVar4 = FUN_005cfcfc();
      *puVar5 = uVar4;
      puVar5 = puVar5 + 1;
      iVar11 = iVar11 + -1;
    } while (iVar11 != 0);
  }
  local_c = (uint *)param_1[2];
  iVar11 = 2;
  puVar10 = puVar7;
  pdVar8 = param_2;
  puVar9 = local_c;
  do {
    uVar3 = *(uint *)pdVar8;
    uVar1 = *puVar9;
    pdVar8 = (double *)((int)pdVar8 + 4);
    puVar9 = puVar9 + 1;
    iVar11 = iVar11 + -1;
    *puVar10 = uVar3 ^ uVar1;
    puVar10 = puVar10 + 1;
  } while (iVar11 != 0);
  puVar10 = (uint *)param_1[1];
  puVar9 = &DAT_00f72120;
  iVar11 = 2;
  do {
    uVar3 = *puVar9;
    puVar9 = puVar9 + 1;
    *puVar10 = uVar3 ^ *puVar7;
    puVar10 = puVar10 + 1;
    puVar7 = puVar7 + 1;
    iVar11 = iVar11 + -1;
  } while (iVar11 != 0);
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3ff) == 0) {
    if (DAT_00f7212b == '\0') {
      FUN_0040c1f0(&DAT_00f6f118,0x1800,5);
      DAT_00f7212b = '\x01';
      FUN_0040c050(&DAT_00f72120,8);
    }
    puVar7 = local_c;
    uStack_8 = local_c[1];
    local_c = (uint *)*local_c;
    puVar5 = (undefined4 *)FUN_0040c090();
    FUN_0040c120(puVar7);
    *puVar5 = local_c;
    puVar5[1] = uStack_8;
    param_1[2] = puVar5;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x1ff) == 0) {
    puVar5 = (undefined4 *)*param_1;
    if (DAT_00f7212b == '\0') {
      FUN_0040c1f0(&DAT_00f6f118,0x1800,5);
      DAT_00f7212b = '\x01';
      FUN_0040c050(&DAT_00f72120,8);
    }
    local_c = (uint *)*puVar5;
    uStack_8 = puVar5[1];
    puVar6 = (undefined4 *)FUN_0040c090();
    FUN_0040c120(puVar5);
    *puVar6 = local_c;
    puVar6[1] = uStack_8;
    *param_1 = puVar6;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x7ff) == 0) {
    puVar5 = (undefined4 *)param_1[1];
    if (DAT_00f7212b == '\0') {
      FUN_0040c1f0(&DAT_00f6f118,0x1800,5);
      DAT_00f7212b = '\x01';
      puVar6 = &DAT_00f72120;
      iVar11 = 2;
      do {
        uVar4 = FUN_005cfcfc();
        *puVar6 = uVar4;
        puVar6 = puVar6 + 1;
        iVar11 = iVar11 + -1;
      } while (iVar11 != 0);
    }
    uStack_8 = puVar5[1];
    local_c = (uint *)*puVar5;
    puVar6 = (undefined4 *)FUN_0040c090();
    FUN_0040c120(puVar5);
    *puVar6 = local_c;
    puVar6[1] = uStack_8;
    param_1[1] = puVar6;
  }
  FUN_005f58a0(local_4);
  return (float10)*param_2;
}


