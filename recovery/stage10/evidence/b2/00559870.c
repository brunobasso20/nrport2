/* NR2003.exe @ 00559870 FUN_00559870 */

void FUN_00559870(void)

{
  char cVar1;
  byte bVar2;
  char cVar3;
  int iVar4;
  undefined4 uVar5;
  undefined4 *puVar6;
  char *pcVar7;
  undefined4 *puVar8;
  
  cVar3 = '\x01';
  iVar4 = FUN_0055a680();
  if (iVar4 != 0) {
    bVar2 = *(byte *)(iVar4 + 100);
    uVar5 = thunk_FUN_0055a6a0();
    cVar3 = FUN_0056e780(iVar4,uVar5);
    if ((bVar2 & 1) != 0) goto switchD_005598ab_caseD_7;
  }
  uVar5 = FUN_00567280();
  switch(uVar5) {
  case 1:
  case 2:
  case 3:
    break;
  case 4:
    iVar4 = -1;
    pcVar7 = &DAT_00c0281c;
    do {
      if (iVar4 == 0) break;
      iVar4 = iVar4 + -1;
      cVar1 = *pcVar7;
      pcVar7 = pcVar7 + 1;
    } while (cVar1 != '\0');
    if ((iVar4 == -2) || (puVar6 = (undefined4 *)&DAT_00c02430, cVar3 == '\0')) break;
    goto LAB_00559901;
  case 5:
  case 6:
    iVar4 = -1;
    pcVar7 = &DAT_00c01914;
    do {
      if (iVar4 == 0) break;
      iVar4 = iVar4 + -1;
      cVar3 = *pcVar7;
      pcVar7 = pcVar7 + 1;
    } while (cVar3 != '\0');
    if (iVar4 != -2) {
      puVar6 = (undefined4 *)&DAT_00c01528;
      goto LAB_00559901;
    }
    break;
  case 7:
    iVar4 = -1;
    pcVar7 = &DAT_00c0281c;
    do {
      if (iVar4 == 0) break;
      iVar4 = iVar4 + -1;
      cVar3 = *pcVar7;
      pcVar7 = pcVar7 + 1;
    } while (cVar3 != '\0');
    if (iVar4 != -2) {
      puVar6 = (undefined4 *)&DAT_00c02430;
      goto LAB_00559901;
    }
    break;
  default:
    goto switchD_005598ab_caseD_7;
  }
  puVar6 = (undefined4 *)&DAT_00c04250;
LAB_00559901:
  puVar8 = (undefined4 *)&DAT_00c055c0;
  for (iVar4 = 0x3bf; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar8 = *puVar6;
    puVar6 = puVar6 + 1;
    puVar8 = puVar8 + 1;
  }
  *(undefined *)puVar8 = *(undefined *)puVar6;
switchD_005598ab_caseD_7:
  uVar5 = FUN_00557de0(0x31);
  FUN_005581d0(0x31,uVar5);
  FUN_00550c60();
  return;
}

