/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c230 */

undefined4 FUN_0056c230(int param_1,char *param_2,undefined4 param_3)

{
  char cVar1;
  undefined4 uVar2;
  uint uVar3;
  int iVar4;
  char *pcVar5;
  char *pcVar6;
  char local_428 [36];
  undefined1 auStack_404 [1028];
  
  FUN_0056c870();
  if (param_2 == (char *)0x0) {
    uVar3 = 0xffffffff;
    pcVar5 = &DAT_0074ee48;
    do {
      if (uVar3 == 0) break;
      uVar3 = uVar3 - 1;
      cVar1 = *pcVar5;
      pcVar5 = pcVar5 + 1;
    } while (cVar1 != '\0');
    uVar2 = FUN_0056c0c0(0xffffffff,0x23 - (~uVar3 - 1));
    FUN_006c4b00(local_428,uVar2);
    iVar4 = -1;
    pcVar5 = local_428;
    do {
      pcVar6 = pcVar5;
      if (iVar4 == 0) break;
      iVar4 = iVar4 + -1;
      pcVar6 = pcVar5 + 1;
      cVar1 = *pcVar5;
      pcVar5 = pcVar6;
    } while (cVar1 != '\0');
    param_2 = local_428;
    *(undefined4 *)(pcVar6 + -1) = DAT_0074ee50;
    pcVar6[3] = DAT_0074ee54;
  }
  iVar4 = FUN_0056c1e0();
  if (iVar4 != 0) {
    FUN_0056c600(0 < param_1,param_2,param_3);
    if (param_1 == 2) {
      iVar4 = FUN_005cfe40(auStack_404,s___car_0074ee58);
      if (iVar4 != 0) {
        do {
          cVar1 = FUN_0056c340(auStack_404);
          if (cVar1 == '\0') {
            iVar4 = FUN_0056c390(0,auStack_404,param_3);
            if (iVar4 != 0) {
              DAT_00c5caf4 = 1;
            }
          }
          iVar4 = FUN_005cfe3a(auStack_404);
        } while (iVar4 != 0);
        FUN_005cfd32();
      }
    }
    return 1;
  }
  return 0;
}


