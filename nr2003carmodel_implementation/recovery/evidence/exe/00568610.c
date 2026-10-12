/* NR2003.exe @ 00568610 FUN_00568610 */

undefined4 FUN_00568610(void)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  char *pcVar5;
  int iVar6;
  char *pcVar7;
  int iVar8;
  undefined4 uStack_24;
  char acStack_20 [32];
  
  uVar2 = FUN_005cfd1a();
  iVar3 = FUN_005cfd14(uVar2);
  if (iVar3 != 0) {
    uVar2 = FUN_0056c020();
    iVar3 = FUN_005cfd14(uVar2);
    if (iVar3 != 0) {
      uVar2 = FUN_0056c0c0(0xffffffff);
      iVar3 = FUN_005cfd14(uVar2);
      if (iVar3 != 0) {
        iVar3 = 0;
        do {
          cVar1 = FUN_0056c150(iVar3,0xffffffff);
          if (cVar1 != '\0') {
            iVar4 = FUN_00427a30(iVar3);
            iVar8 = 0;
            if (0 < iVar4) {
              do {
                pcVar5 = (char *)FUN_00427a60(iVar3,iVar8);
                pcVar7 = acStack_20;
                do {
                  cVar1 = *pcVar5;
                  pcVar5 = pcVar5 + 1;
                  *pcVar7 = cVar1;
                  pcVar7 = pcVar7 + 1;
                } while (cVar1 != '\0');
                iVar6 = -1;
                pcVar7 = acStack_20;
                do {
                  pcVar5 = pcVar7;
                  if (iVar6 == 0) break;
                  iVar6 = iVar6 + -1;
                  pcVar5 = pcVar7 + 1;
                  cVar1 = *pcVar7;
                  pcVar7 = pcVar5;
                } while (cVar1 != '\0');
                *(undefined4 *)(pcVar5 + -1) = DAT_0074ec8c;
                pcVar5[3] = DAT_0074ec90;
                iVar6 = FUN_005cfd0e(&uStack_24,acStack_20);
                if (iVar6 == 0) {
                  return 0;
                }
                iVar6 = FUN_00568740(&DAT_00c5b070 + (iVar8 + iVar3 * 4) * 0x36,uStack_24);
                if (iVar6 == 0) {
                  FUN_005cfd08(uStack_24);
                  return 0;
                }
                iVar6 = FUN_005cfd08(uStack_24);
                if (iVar6 == 0) {
                  return 0;
                }
                iVar8 = iVar8 + 1;
              } while (iVar8 < iVar4);
            }
          }
          iVar3 = iVar3 + 1;
          if (4 < iVar3) {
            return 1;
          }
        } while( true );
      }
    }
  }
  return 0;
}

