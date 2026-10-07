/* NR2003.exe @ 00559470 FUN_00559470 */

undefined4 __thiscall FUN_00559470(undefined4 *param_1_00,undefined4 param_1,undefined4 param_2)

{
  char cVar1;
  int iVar2;
  char *pcVar3;
  int iVar4;
  undefined4 *puVar5;
  char *pcVar6;
  undefined4 *puVar7;
  bool bVar8;
  char local_30c [260];
  char local_208 [260];
  char local_104 [260];
  
  iVar2 = 0;
  do {
    cVar1 = (&DAT_00c064c6)[iVar2];
    local_30c[iVar2] = cVar1;
    iVar2 = iVar2 + 1;
  } while (cVar1 != '\0');
  iVar2 = 0;
  do {
    cVar1 = (&DAT_00c064c7)[iVar2];
    local_208[iVar2] = cVar1;
    iVar2 = iVar2 + 1;
  } while (cVar1 != '\0');
  iVar2 = 0;
  do {
    cVar1 = (&DAT_00c064c8)[iVar2];
    local_104[iVar2] = cVar1;
    iVar2 = iVar2 + 1;
  } while (cVar1 != '\0');
  FUN_005591f0(param_1,param_2,local_30c,local_208,local_104);
  iVar2 = -1;
  pcVar3 = local_30c;
  do {
    if (iVar2 == 0) break;
    iVar2 = iVar2 + -1;
    cVar1 = *pcVar3;
    pcVar3 = pcVar3 + 1;
  } while (cVar1 != '\0');
  if (iVar2 == -2) {
LAB_00559511:
    pcVar3 = local_104;
  }
  else {
    iVar2 = 7;
    bVar8 = true;
    pcVar3 = &DAT_00739bc4;
    pcVar6 = local_30c;
    do {
      if (iVar2 == 0) break;
      iVar2 = iVar2 + -1;
      bVar8 = *pcVar3 == *pcVar6;
      pcVar3 = pcVar3 + 1;
      pcVar6 = pcVar6 + 1;
    } while (bVar8);
    pcVar3 = local_30c;
    if (bVar8) goto LAB_00559511;
  }
  iVar2 = FUN_005595e0(param_1,param_2,pcVar3);
  iVar4 = 0x3bf;
  puVar5 = param_1_00;
  puVar7 = (undefined4 *)&DAT_00c01528;
  if (iVar2 == 0) {
    puVar5 = (undefined4 *)&DAT_00c03350;
  }
  for (; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar7 = *puVar5;
    puVar5 = puVar5 + 1;
    puVar7 = puVar7 + 1;
  }
  *(undefined *)puVar7 = *(undefined *)puVar5;
  iVar2 = -1;
  pcVar3 = local_208;
  do {
    if (iVar2 == 0) break;
    iVar2 = iVar2 + -1;
    cVar1 = *pcVar3;
    pcVar3 = pcVar3 + 1;
  } while (cVar1 != '\0');
  if (iVar2 != -2) {
    iVar2 = 7;
    bVar8 = true;
    pcVar3 = &DAT_00739bc4;
    pcVar6 = local_208;
    do {
      if (iVar2 == 0) break;
      iVar2 = iVar2 + -1;
      bVar8 = *pcVar3 == *pcVar6;
      pcVar3 = pcVar3 + 1;
      pcVar6 = pcVar6 + 1;
    } while (bVar8);
    pcVar3 = local_208;
    if (!bVar8) goto LAB_00559570;
  }
  pcVar3 = local_104;
LAB_00559570:
  iVar2 = FUN_005595e0(param_1,param_2,pcVar3);
  iVar4 = 0x3bf;
  puVar5 = param_1_00;
  puVar7 = (undefined4 *)&DAT_00c02430;
  if (iVar2 == 0) {
    puVar5 = (undefined4 *)&DAT_00c03350;
  }
  for (; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar7 = *puVar5;
    puVar5 = puVar5 + 1;
    puVar7 = puVar7 + 1;
  }
  *(undefined *)puVar7 = *(undefined *)puVar5;
  iVar2 = FUN_005595e0(param_1,param_2,local_104);
  iVar4 = 0x3bf;
  puVar5 = (undefined4 *)&DAT_00c04250;
  if (iVar2 == 0) {
    param_1_00 = (undefined4 *)&DAT_00c03350;
  }
  for (; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar5 = *param_1_00;
    param_1_00 = param_1_00 + 1;
    puVar5 = puVar5 + 1;
  }
  *(undefined *)puVar5 = *(undefined *)param_1_00;
  return 1;
}

