/* NR2003.exe @ 0040bde0 FUN_0040bde0 */

float10 __thiscall FUN_0040bde0(uint **param_1,double *param_2)

{
  uint uVar1;
  uint ***pppuVar2;
  uint uVar3;
  uint **ppuVar4;
  undefined4 uVar5;
  uint *puVar6;
  double *pdVar7;
  uint *puVar8;
  uint *puVar9;
  uint **ppuVar10;
  int iVar11;
  undefined4 *puVar12;
  bool bVar13;
  uint **local_c;
  uint *puStack_8;
  uint **local_4;
  
  local_4 = param_1 + 3;
  FUN_005f5890(local_4);
  puVar6 = param_1[1];
  puVar9 = &DAT_00f72120;
  pppuVar2 = &local_c;
  iVar11 = 2;
  do {
    uVar3 = *puVar6;
    puVar6 = puVar6 + 1;
    *pppuVar2 = (uint **)(uVar3 ^ *puVar9);
    pppuVar2 = pppuVar2 + 1;
    puVar9 = puVar9 + 1;
    iVar11 = iVar11 + -1;
  } while (iVar11 != 0);
  puVar6 = *param_1;
  iVar11 = 2;
  bVar13 = true;
  pppuVar2 = &local_c;
  puVar9 = puVar6;
  do {
    if (iVar11 == 0) break;
    iVar11 = iVar11 + -1;
    bVar13 = *pppuVar2 == (uint **)*puVar9;
    pppuVar2 = pppuVar2 + 1;
    puVar9 = puVar9 + 1;
  } while (bVar13);
  if (!bVar13) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3f) == 0) {
    puVar9 = param_1[2];
    iVar11 = 2;
    do {
      uVar3 = FUN_005cfcfc();
      *puVar9 = uVar3;
      puVar9 = puVar9 + 1;
      iVar11 = iVar11 + -1;
    } while (iVar11 != 0);
  }
  local_c = (uint **)param_1[2];
  iVar11 = 2;
  puVar9 = puVar6;
  pdVar7 = param_2;
  ppuVar10 = local_c;
  do {
    uVar3 = *(uint *)pdVar7;
    uVar1 = (uint)*ppuVar10;
    pdVar7 = (double *)((int)pdVar7 + 4);
    ppuVar10 = ppuVar10 + 1;
    iVar11 = iVar11 + -1;
    *puVar9 = uVar3 ^ uVar1;
    puVar9 = puVar9 + 1;
  } while (iVar11 != 0);
  puVar9 = param_1[1];
  puVar8 = &DAT_00f72120;
  iVar11 = 2;
  do {
    uVar3 = *puVar8;
    puVar8 = puVar8 + 1;
    *puVar9 = uVar3 ^ *puVar6;
    puVar9 = puVar9 + 1;
    puVar6 = puVar6 + 1;
    iVar11 = iVar11 + -1;
  } while (iVar11 != 0);
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x3ff) == 0) {
    if (DAT_00f7212b == '\0') {
      FUN_0040c1f0(&DAT_00f6f118,0x1800,5);
      DAT_00f7212b = '\x01';
      FUN_0040c050(&DAT_00f72120,8);
    }
    ppuVar10 = local_c;
    puStack_8 = local_c[1];
    local_c = (uint **)*local_c;
    ppuVar4 = (uint **)FUN_0040c090();
    FUN_0040c120(ppuVar10);
    *ppuVar4 = (uint *)local_c;
    ppuVar4[1] = puStack_8;
    param_1[2] = (uint *)ppuVar4;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x1ff) == 0) {
    ppuVar10 = (uint **)*param_1;
    if (DAT_00f7212b == '\0') {
      FUN_0040c1f0(&DAT_00f6f118,0x1800,5);
      DAT_00f7212b = '\x01';
      FUN_0040c050(&DAT_00f72120,8);
    }
    local_c = (uint **)*ppuVar10;
    puStack_8 = ppuVar10[1];
    ppuVar4 = (uint **)FUN_0040c090();
    FUN_0040c120(ppuVar10);
    *ppuVar4 = (uint *)local_c;
    ppuVar4[1] = puStack_8;
    *param_1 = (uint *)ppuVar4;
  }
  uVar3 = FUN_005cfcfc();
  if ((uVar3 & 0x7ff) == 0) {
    ppuVar10 = (uint **)param_1[1];
    if (DAT_00f7212b == '\0') {
      FUN_0040c1f0(&DAT_00f6f118,0x1800,5);
      DAT_00f7212b = '\x01';
      puVar12 = &DAT_00f72120;
      iVar11 = 2;
      do {
        uVar5 = FUN_005cfcfc();
        *puVar12 = uVar5;
        puVar12 = puVar12 + 1;
        iVar11 = iVar11 + -1;
      } while (iVar11 != 0);
    }
    puStack_8 = ppuVar10[1];
    local_c = (uint **)*ppuVar10;
    ppuVar4 = (uint **)FUN_0040c090();
    FUN_0040c120(ppuVar10);
    *ppuVar4 = (uint *)local_c;
    ppuVar4[1] = puStack_8;
    param_1[1] = (uint *)ppuVar4;
  }
  FUN_005f58a0(local_4);
  return (float10)*param_2;
}

