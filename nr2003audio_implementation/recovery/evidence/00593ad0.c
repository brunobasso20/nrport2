/* NR2003.exe @ 00593ad0 recovered_00593ad0 */

undefined4 recovered_00593ad0(int param_1)

{
  char cVar1;
  undefined uVar2;
  undefined4 uVar3;
  int iVar4;
  uint uVar5;
  uint uVar6;
  undefined4 *puVar7;
  char *pcVar8;
  char *pcVar9;
  undefined4 *puVar10;
  undefined4 auStack_100 [64];

  iVar4 = -1;
  pcVar8 = *(char **)(&UNK_006f6b28 + param_1 * 9);
  do {
    if (iVar4 == 0) break;
    iVar4 = iVar4 + -1;
    cVar1 = *pcVar8;
    pcVar8 = pcVar8 + 1;
  } while (cVar1 != '\0');
  if (iVar4 == -2) {
    *(undefined4 *)(&DAT_00d8c358 + param_1 * 4) = 0;
    return 1;
  }
  uVar3 = FUN_005cfd1a();
  iVar4 = FUN_005cfd14(uVar3);
  if (iVar4 == 0) {
    return 0;
  }
  iVar4 = FUN_005cfd14(s_SOUND_00750b90);
  if (iVar4 == 0) {
    return 0;
  }
  puVar7 = auStack_100;
  for (iVar4 = 0x40; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar7 = 0;
    puVar7 = puVar7 + 1;
  }
  pcVar8 = (char *)0x750b98;
  if ((param_1 < 0x14) || (0x1f < param_1)) {
    uVar3 = *(undefined4 *)(&UNK_006f6b28 + param_1 * 9);
    goto LAB_00593bf9;
  }
  if (DAT_00d8c3fc < 0xcea1) {
    if (DAT_00d8c3fc == 0xcea0) {
      uVar3 = 0x750bb0;
      goto LAB_00593bf9;
    }
    if (DAT_00d8c3fc == 0x1c20) {
      uVar3 = 0x750ba8;
      goto LAB_00593bf9;
    }
    if (DAT_00d8c3fc == 0x801e) {
      uVar3 = 0x750ba0;
      goto LAB_00593bf9;
    }
  }
  else {
    if (DAT_00d8c3fc == 0x118bc) {
      uVar3 = 0x750bc8;
      goto LAB_00593bf9;
    }
    if (DAT_00d8c3fc == 0x18eb4) {
      uVar3 = 0x750bc0;
      goto LAB_00593bf9;
    }
  }
  uVar3 = *(undefined4 *)(&UNK_006f6b28 + param_1 * 9);
  pcVar8 = (char *)0x750bb8;
LAB_00593bf9:
  FUN_006c4b00(auStack_100,uVar3,0xfb);
  uVar5 = 0xffffffff;
  do {
    pcVar9 = pcVar8;
    if (uVar5 == 0) break;
    uVar5 = uVar5 - 1;
    pcVar9 = pcVar8 + 1;
    cVar1 = *pcVar8;
    pcVar8 = pcVar9;
  } while (cVar1 != '\0');
  uVar5 = ~uVar5;
  iVar4 = -1;
  puVar7 = auStack_100;
  do {
    puVar10 = puVar7;
    if (iVar4 == 0) break;
    iVar4 = iVar4 + -1;
    puVar10 = (undefined4 *)((int)puVar7 + 1);
    cVar1 = *(char *)puVar7;
    puVar7 = puVar10;
  } while (cVar1 != '\0');
  puVar7 = (undefined4 *)(pcVar9 + -uVar5);
  puVar10 = (undefined4 *)((int)puVar10 + -1);
  for (uVar6 = uVar5 >> 2; uVar6 != 0; uVar6 = uVar6 - 1) {
    *puVar10 = *puVar7;
    puVar7 = puVar7 + 1;
    puVar10 = puVar10 + 1;
  }
  uVar2 = (&UNK_006f6b2c)[param_1 * 9];
  for (uVar5 = uVar5 & 3; uVar5 != 0; uVar5 = uVar5 - 1) {
    *(undefined *)puVar10 = *(undefined *)puVar7;
    puVar7 = (undefined4 *)((int)puVar7 + 1);
    puVar10 = (undefined4 *)((int)puVar10 + 1);
  }
  iVar4 = FUN_004ed320(auStack_100,*(undefined4 *)(&UNK_006f6b2d + param_1 * 9),uVar2);
  *(int *)(&DAT_00d8c358 + param_1 * 4) = iVar4;
  if (iVar4 == 0) {
    if ((0x13 < param_1) && (param_1 < 0x20)) {
      uVar3 = FUN_004ed320(0x750bd0,*(undefined4 *)(&UNK_006f6b2d + param_1 * 9),
                           (&UNK_006f6b2c)[param_1 * 9]);
      *(undefined4 *)(&DAT_00d8c358 + param_1 * 4) = uVar3;
    }
  }
  else {
    *(undefined4 *)(iVar4 + 4) = 0;
  }
  if (*(int *)(&DAT_00d8c358 + param_1 * 4) == 0) {
    return 0;
  }
  return 1;
}
