/* NR2003.exe @ 00550c60 FUN_00550c60 */

void FUN_00550c60(void)

{
  int **ppiVar1;
  float fVar2;
  uint uVar3;
  short sVar4;
  undefined4 uVar5;
  int iVar6;
  float *pfVar7;
  uint uVar8;
  int *piVar9;
  double *pdVar10;
  uint *puVar11;
  uint *puVar12;
  int iVar13;
  undefined4 *puVar14;
  bool bVar15;
  double local_18;
  double local_10;
  
  uVar5 = FUN_0055ab00();
  iVar6 = FUN_00562f70(uVar5);
  iVar6 = *(int *)(iVar6 + 0x58a);
  sVar4 = FUN_0055a690();
  if (sVar4 == 2) {
    pfVar7 = (float *)FUN_00557d60(0x31);
    fVar2 = *pfVar7;
    iVar6 = FUN_0051a000();
    ppiVar1 = (int **)(iVar6 + 0x50c);
    local_10 = (double)fVar2;
    FUN_005f5890(iVar6 + 0x518);
    puVar11 = *(uint **)(iVar6 + 0x510);
    puVar12 = &DAT_00f72120;
    iVar13 = 2;
    pdVar10 = &local_18;
    do {
      uVar8 = *puVar11;
      uVar3 = *puVar12;
      puVar11 = puVar11 + 1;
      puVar12 = puVar12 + 1;
      iVar13 = iVar13 + -1;
      *(uint *)pdVar10 = uVar8 ^ uVar3;
      pdVar10 = (double *)((int)pdVar10 + 4);
    } while (iVar13 != 0);
    iVar13 = 2;
    bVar15 = true;
    pdVar10 = &local_18;
    piVar9 = *ppiVar1;
    do {
      if (iVar13 == 0) break;
      iVar13 = iVar13 + -1;
      bVar15 = *(int *)pdVar10 == *piVar9;
      pdVar10 = (double *)((int)pdVar10 + 4);
      piVar9 = piVar9 + 1;
    } while (bVar15);
    if (!bVar15) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x3f) == 0) {
      puVar14 = *(undefined4 **)(iVar6 + 0x514);
      iVar13 = 2;
      do {
        uVar5 = FUN_005cfcfc();
        *puVar14 = uVar5;
        puVar14 = puVar14 + 1;
        iVar13 = iVar13 + -1;
      } while (iVar13 != 0);
    }
    FUN_0040e980(*ppiVar1,&local_10,*(undefined4 *)(iVar6 + 0x514),8);
    FUN_0040e980(*(undefined4 *)(iVar6 + 0x510),&DAT_00f72120,*ppiVar1,8);
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x3ff) == 0) {
      uVar5 = FUN_0051c850(*(undefined4 *)(iVar6 + 0x514));
      *(undefined4 *)(iVar6 + 0x514) = uVar5;
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x1ff) == 0) {
      piVar9 = (int *)FUN_0051c850(*ppiVar1);
      *ppiVar1 = piVar9;
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x7ff) == 0) {
      uVar5 = FUN_0051c850(*(undefined4 *)(iVar6 + 0x510));
      *(undefined4 *)(iVar6 + 0x510) = uVar5;
    }
    FUN_005f58a0(iVar6 + 0x518);
  }
  else {
    fVar2 = *(float *)(iVar6 + 0x24);
    iVar6 = FUN_0051a000();
    ppiVar1 = (int **)(iVar6 + 0x50c);
    local_18 = (double)fVar2;
    FUN_005f5890(iVar6 + 0x518);
    puVar11 = *(uint **)(iVar6 + 0x510);
    puVar12 = &DAT_00f72120;
    iVar13 = 2;
    pdVar10 = &local_10;
    do {
      uVar8 = *puVar12;
      uVar3 = *puVar11;
      puVar11 = puVar11 + 1;
      puVar12 = puVar12 + 1;
      iVar13 = iVar13 + -1;
      *(uint *)pdVar10 = uVar8 ^ uVar3;
      pdVar10 = (double *)((int)pdVar10 + 4);
    } while (iVar13 != 0);
    iVar13 = 2;
    bVar15 = true;
    pdVar10 = &local_10;
    piVar9 = *ppiVar1;
    do {
      if (iVar13 == 0) break;
      iVar13 = iVar13 + -1;
      bVar15 = *(int *)pdVar10 == *piVar9;
      pdVar10 = (double *)((int)pdVar10 + 4);
      piVar9 = piVar9 + 1;
    } while (bVar15);
    if (!bVar15) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x3f) == 0) {
      puVar14 = *(undefined4 **)(iVar6 + 0x514);
      iVar13 = 2;
      do {
        uVar5 = FUN_005cfcfc();
        *puVar14 = uVar5;
        puVar14 = puVar14 + 1;
        iVar13 = iVar13 + -1;
      } while (iVar13 != 0);
    }
    FUN_0040e980(*ppiVar1,&local_18,*(undefined4 *)(iVar6 + 0x514),8);
    FUN_0040e980(*(undefined4 *)(iVar6 + 0x510),&DAT_00f72120,*ppiVar1,8);
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x3ff) == 0) {
      uVar5 = FUN_0051c850(*(undefined4 *)(iVar6 + 0x514));
      *(undefined4 *)(iVar6 + 0x514) = uVar5;
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x1ff) == 0) {
      piVar9 = (int *)FUN_0051c850(*ppiVar1);
      *ppiVar1 = piVar9;
    }
    uVar8 = FUN_005cfcfc();
    if ((uVar8 & 0x7ff) == 0) {
      uVar5 = FUN_0051c850(*(undefined4 *)(iVar6 + 0x510));
      *(undefined4 *)(iVar6 + 0x510) = uVar5;
    }
    FUN_005f58a0(iVar6 + 0x518);
  }
  *(undefined4 *)(iVar6 + 0x538) = 0;
  *(undefined4 *)(iVar6 + 0x53c) = 0xbff00000;
  return;
}

