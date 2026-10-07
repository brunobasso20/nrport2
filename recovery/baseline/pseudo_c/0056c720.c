/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c720 */

undefined4 FUN_0056c720(char *param_1)

{
  char cVar1;
  undefined4 uVar2;
  undefined *puVar3;
  int iVar4;
  uint uVar5;
  int iVar6;
  char *pcVar7;
  int iVar8;
  char *pcVar9;
  char local_24 [36];
  
  pcVar7 = param_1;
  if (param_1 == (char *)0x0) {
    uVar5 = 0xffffffff;
    pcVar7 = &DAT_0074ee64;
    do {
      if (uVar5 == 0) break;
      uVar5 = uVar5 - 1;
      cVar1 = *pcVar7;
      pcVar7 = pcVar7 + 1;
    } while (cVar1 != '\0');
    uVar2 = FUN_0056c0c0(0xffffffff,0x23 - (~uVar5 - 1));
    FUN_006c4b00(local_24,uVar2);
    iVar6 = -1;
    pcVar7 = local_24;
    do {
      pcVar9 = pcVar7;
      if (iVar6 == 0) break;
      iVar6 = iVar6 + -1;
      pcVar9 = pcVar7 + 1;
      cVar1 = *pcVar7;
      pcVar7 = pcVar9;
    } while (cVar1 != '\0');
    pcVar7 = local_24;
    *(undefined4 *)(pcVar9 + -1) = DAT_0074ee6c;
    pcVar9[3] = DAT_0074ee70;
  }
  iVar6 = FUN_0056c1e0();
  if (iVar6 != 0) {
    iVar6 = FUN_005cfdda(&param_1,pcVar7);
    if (iVar6 != 0) {
      iVar6 = 0;
      if (0 < *DAT_00c5ca24) {
        iVar8 = 0;
        do {
          puVar3 = &DAT_0074ee72;
          if (*(char *)(iVar8 + DAT_00c5c2e8) == '\0') {
            puVar3 = &DAT_0074ee74;
          }
          iVar4 = FUN_005cfd2c(param_1,puVar3,1);
          if (iVar4 == 0) break;
          uVar5 = 0xffffffff;
          pcVar7 = *(char **)(iVar8 + 1 + DAT_00c5c2e8);
          pcVar9 = pcVar7;
          do {
            if (uVar5 == 0) break;
            uVar5 = uVar5 - 1;
            cVar1 = *pcVar9;
            pcVar9 = pcVar9 + 1;
          } while (cVar1 != '\0');
          iVar4 = FUN_005cfd2c(param_1,pcVar7,~uVar5 - 1);
          if (iVar4 == 0) break;
          uVar5 = 0xffffffff;
          pcVar7 = &DAT_0074ee78;
          do {
            if (uVar5 == 0) break;
            uVar5 = uVar5 - 1;
            cVar1 = *pcVar7;
            pcVar7 = pcVar7 + 1;
          } while (cVar1 != '\0');
          iVar4 = FUN_005cfd2c(param_1,&DAT_0074ee7c,~uVar5 - 1);
          if (iVar4 == 0) break;
          iVar6 = iVar6 + 1;
          iVar8 = iVar8 + 5;
        } while (iVar6 < *DAT_00c5ca24);
      }
      FUN_005cfd08(param_1);
      if (iVar6 == *DAT_00c5ca24) {
        return 1;
      }
    }
  }
  return 0;
}


