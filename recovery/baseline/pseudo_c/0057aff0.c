/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0057aff0 */

void FUN_0057aff0(undefined4 *param_1,undefined4 *param_2,undefined4 *param_3,undefined4 *param_4,
                 undefined4 *param_5,undefined4 param_6,undefined4 *param_7)

{
  char *pcVar1;
  char cVar2;
  undefined4 uVar3;
  undefined *puVar4;
  uint uVar5;
  int iVar6;
  uint uVar7;
  int iVar8;
  char *pcVar9;
  char *pcVar10;
  char *pcVar11;
  char local_8 [8];
  
  *param_1 = param_7[4];
  *(bool *)param_6 = param_7[3] != 0;
  *param_4 = param_7[2];
  iVar8 = param_7[4];
  if (iVar8 == 1) {
    if ((param_7[5] & 0x7fffffff) < 0x10) {
      *param_2 = &DAT_0074fc68 + ((uint)(*(char *)(param_7 + 7) != '\0') + param_7[5] * 2) * 4;
    }
    else {
      *param_2 = &DAT_0074fd52;
    }
    uVar5 = 0;
    *param_5 = param_7[5];
    goto LAB_0057b1a0;
  }
  if (iVar8 != 2) {
    if (iVar8 != 4) {
      *param_2 = &DAT_00d3b02d;
      *param_3 = &DAT_00d3b02e;
      return;
    }
    uVar3 = FUN_005d0170(param_7[5]);
    *param_2 = uVar3;
    *param_5 = param_7[5];
    uVar5 = param_7[6];
    goto LAB_0057b1a0;
  }
  if ((param_7 < &DAT_00d37cb8) || (&DAT_00d394f6 < param_7)) {
    if (param_7 != (undefined4 *)&DAT_00d37c7d) goto LAB_0057b147;
    iVar8 = 0xd7;
  }
  else {
    iVar8 = (int)(param_7 + -0x34df2e) / 0x1d;
    if (iVar8 == -1) {
LAB_0057b147:
      *param_2 = &DAT_0074fd50;
      *param_5 = param_7[5];
      uVar5 = param_7[6];
      goto LAB_0057b1a0;
    }
  }
  pcVar1 = &DAT_00d39520 + iVar8 * 0x20;
  iVar8 = 0;
  *pcVar1 = '\0';
  do {
    if ((param_7[5] & 1 << ((byte)iVar8 & 0x1f)) != 0) {
      puVar4 = &DAT_0074fd44;
      if (*pcVar1 == '\0') {
        puVar4 = &DAT_00d3b02f;
      }
      FUN_006c4f81(local_8,s___1s_d_0074fd48,puVar4,iVar8);
      uVar5 = 0xffffffff;
      pcVar9 = local_8;
      do {
        pcVar11 = pcVar9;
        if (uVar5 == 0) break;
        uVar5 = uVar5 - 1;
        pcVar11 = pcVar9 + 1;
        cVar2 = *pcVar9;
        pcVar9 = pcVar11;
      } while (cVar2 != '\0');
      uVar5 = ~uVar5;
      iVar6 = -1;
      pcVar9 = pcVar1;
      do {
        pcVar10 = pcVar9;
        if (iVar6 == 0) break;
        iVar6 = iVar6 + -1;
        pcVar10 = pcVar9 + 1;
        cVar2 = *pcVar9;
        pcVar9 = pcVar10;
      } while (cVar2 != '\0');
      pcVar9 = pcVar11 + -uVar5;
      pcVar11 = pcVar10 + -1;
      for (uVar7 = uVar5 >> 2; uVar7 != 0; uVar7 = uVar7 - 1) {
        *(undefined4 *)pcVar11 = *(undefined4 *)pcVar9;
        pcVar9 = pcVar9 + 4;
        pcVar11 = pcVar11 + 4;
      }
      for (uVar5 = uVar5 & 3; uVar5 != 0; uVar5 = uVar5 - 1) {
        *pcVar11 = *pcVar9;
        pcVar9 = pcVar9 + 1;
        pcVar11 = pcVar11 + 1;
      }
    }
    iVar8 = iVar8 + 1;
  } while (iVar8 < 0x20);
  *param_2 = pcVar1;
  *param_5 = param_7[5];
  uVar5 = param_7[6];
LAB_0057b1a0:
  *param_3 = &DAT_0074fc44 +
             ((uint)((uVar5 & 0x300000) != 0) + (-(uint)((uVar5 & 0xc0000) != 0) & 2) +
             (-(uint)((uVar5 & 0x30000) != 0) & 4)) * 4;
  return;
}


