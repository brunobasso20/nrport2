/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050ee70 */

void FUN_0050ee70(undefined4 param_1)

{
  undefined *puVar1;
  char cVar2;
  undefined *puVar3;
  undefined *puVar4;
  int iVar5;
  char *pcVar6;
  int iVar7;
  undefined4 uVar8;
  uint uVar9;
  uint uVar10;
  undefined4 *puVar11;
  undefined4 unaff_EBX;
  int iVar12;
  int *piVar13;
  undefined4 unaff_EBP;
  undefined4 *puVar14;
  undefined4 *puVar15;
  undefined4 *puVar16;
  char *pcVar17;
  char *pcVar18;
  undefined **ppuVar19;
  
  iVar5 = 0;
  do {
    pcVar6 = s_ai_track__0074b84c + iVar5;
    (&DAT_00b915d8)[iVar5] = *pcVar6;
    iVar5 = iVar5 + 1;
  } while (*pcVar6 != '\0');
  pcVar6 = (char *)FUN_0056c0f0(0xffffffff);
  uVar9 = 0xffffffff;
  do {
    pcVar18 = pcVar6;
    if (uVar9 == 0) break;
    uVar9 = uVar9 - 1;
    pcVar18 = pcVar6 + 1;
    cVar2 = *pcVar6;
    pcVar6 = pcVar18;
  } while (cVar2 != '\0');
  uVar9 = ~uVar9;
  iVar12 = 0;
  iVar5 = -1;
  pcVar6 = &DAT_00b915d8;
  do {
    pcVar17 = pcVar6;
    if (iVar5 == 0) break;
    iVar5 = iVar5 + -1;
    pcVar17 = pcVar6 + 1;
    cVar2 = *pcVar6;
    pcVar6 = pcVar17;
  } while (cVar2 != '\0');
  pcVar6 = pcVar18 + -uVar9;
  pcVar18 = pcVar17 + -1;
  for (uVar10 = uVar9 >> 2; uVar10 != 0; uVar10 = uVar10 - 1) {
    *(undefined4 *)pcVar18 = *(undefined4 *)pcVar6;
    pcVar6 = pcVar6 + 4;
    pcVar18 = pcVar18 + 4;
  }
  puVar14 = &DAT_00b93050;
  for (uVar9 = uVar9 & 3; uVar9 != 0; uVar9 = uVar9 - 1) {
    *pcVar18 = *pcVar6;
    pcVar6 = pcVar6 + 1;
    pcVar18 = pcVar18 + 1;
  }
  ppuVar19 = &PTR_s_physics_0074aa74;
  iVar5 = 0;
  do {
    FUN_005cfcc6(ppuVar19[-1],*ppuVar19,ppuVar19[1],ppuVar19[2],2,2);
    puVar1 = ppuVar19[3];
    puVar3 = *ppuVar19;
    *(undefined **)((int)&DAT_00b9163e + iVar5) = puVar1;
    *(undefined **)((int)&DAT_00b91642 + iVar5) = puVar1;
    *(undefined ***)((int)&DAT_00b9163a + iVar5) = ppuVar19 + 3;
    iVar7 = FUN_006c6530(s_ai_track_0074b858,puVar3);
    if (iVar7 == 0) {
      puVar1 = ppuVar19[2];
      puVar3 = ppuVar19[1];
      puVar4 = ppuVar19[-1];
      (&DAT_00b8fb20)[iVar12] = 1;
      *puVar14 = 0xcceb79a3;
      FUN_005cfcc6(puVar4,&DAT_00b915d8,puVar3,puVar1,2,2);
      uVar8 = *puVar14;
      *(undefined4 **)((int)&DAT_00b8fc1a + iVar5) = puVar14;
      *(undefined4 *)((int)&DAT_00b8fc1e + iVar5) = uVar8;
      *(undefined4 *)((int)&DAT_00b8fc22 + iVar5) = uVar8;
    }
    else {
      (&DAT_00b8fb20)[iVar12] = 0;
    }
    iVar5 = iVar5 + 0x2e;
    iVar12 = iVar12 + 1;
    puVar14 = puVar14 + 1;
    ppuVar19 = ppuVar19 + 6;
  } while (iVar5 < 0x19e0);
  uVar8 = FUN_005cfd1a();
  FUN_005cfd14(uVar8);
  FUN_005cfd26(0x42,s_papy_ai_ini_0074b864);
  FUN_00529b90();
  FUN_005cfd14(s_tracks_0074b870);
  FUN_005cfd14(param_1);
  FUN_005cfd26(0x45,s_track_ini_0074b878);
  iVar5 = 0;
  piVar13 = &DAT_0074aa80;
  do {
    if ((&DAT_00b8fb20)[iVar5] != '\0') {
      if ((&DAT_00b93050)[iVar5] != -0x3314865d) {
        *piVar13 = (&DAT_00b93050)[iVar5];
      }
      FUN_005cfcc0();
    }
    FUN_005cfcc0();
    iVar5 = iVar5 + 1;
    piVar13 = piVar13 + 6;
  } while (iVar5 < 0x90);
  if ((DAT_00b6f468 & 1) == 0) {
    DAT_00b6f468 = DAT_00b6f468 | 1;
    iVar5 = 0x1e;
    puVar14 = &DAT_00b6f56c;
    do {
      puVar14[-1] = 0;
      *puVar14 = 0;
      puVar14[1] = 0;
      *(undefined1 *)(puVar14 + 4) = 0;
      *(undefined1 *)((int)puVar14 + 0x11) = 0;
      *(undefined4 *)((int)puVar14 + 0x12) = 0;
      puVar14[-3] = &PTR_FUN_006ed6e8;
      puVar14 = (undefined4 *)((int)puVar14 + 0x2e);
      iVar5 = iVar5 + -1;
    } while (iVar5 != 0);
    FUN_006c4f40(&LAB_004fff10,unaff_EBX,unaff_EBP,unaff_EBX);
  }
  if (DAT_00b6fac8 == '\0') {
    puVar15 = &DAT_00b6f582;
    puVar14 = (undefined4 *)&DAT_00b6f484;
    do {
      FUN_006c4f81();
      puVar16 = &DAT_00748d8c;
      puVar11 = puVar14;
      do {
        *puVar11 = puVar16[1];
        FUN_005cfcc6();
        uVar8 = *puVar11;
        *puVar15 = puVar11;
        puVar16 = puVar16 + 6;
        puVar15[1] = uVar8;
        puVar15[2] = uVar8;
        puVar11 = puVar11 + 1;
        puVar15 = (undefined4 *)((int)puVar15 + 0x2e);
      } while ((int)puVar16 < 0x748ef4);
      puVar14 = puVar14 + 0x10;
    } while ((int)puVar14 < 0xb6f504);
    DAT_00b6fac8 = '\x01';
  }
  FUN_005cfd26();
  return;
}


