/* NR2003.exe @ 00546f80 recovered_00546f80 */

void recovered_00546f80(void)

{
  bool bVar1;
  char cVar2;
  bool bVar3;
  int iVar4;
  undefined4 uVar5;
  undefined4 *puVar6;
  undefined4 uStack_9c;
  undefined4 auStack_98 [38];
  
  func_0x005cfda4(0x74c8fc,0x3c00);
  FUN_00567704(1,3);
  FUN_00544e70(0);
  DAT_00bebe46 = 0;
  svSleep();
  bVar1 = fgIsRunning();
  if (bVar1) {
    do {
      bVar1 = bgIsRunning();
      if (!bVar1) break;
      iVar4 = FUN_005c2940(&DAT_00bef36c);
      if (iVar4 != 0) {
        FUN_004fa760(DAT_00bef36c);
        iVar4 = FUN_005c2e10(DAT_00bef36c);
        iVar4 = FUN_005cf120(&DAT_00be126f + iVar4 * 0x3ec);
        if (iVar4 != 0) {
          auStack_98[0] = 1;
          FUN_00544d50(DAT_00bef36c,auStack_98);
          FUN_004f8d90();
          cVar2 = FUN_005cc7b0();
          if (cVar2 != '\0') {
            FUN_00547350();
          }
          FUN_00547240();
          FUN_0056e680(&DAT_00bebd38);
          FUN_00547230();
          FUN_004f5990();
          bVar1 = false;
          puVar6 = &DAT_00bef2ea;
          for (iVar4 = 0x1b; iVar4 != 0; iVar4 = iVar4 + -1) {
            *puVar6 = 0;
            puVar6 = puVar6 + 1;
          }
          FUN_005a81b0();
          DAT_00bef364 = '\0';
          do {
            bVar3 = fgIsRunning();
            if (!bVar3) break;
            iVar4 = FUN_005676f0();
            if (iVar4 != 0x77f) {
              FUN_00567704(1,3);
            }
            FUN_00544e20(FUN_00547270);
            FUN_00544de0(&LAB_00546860);
            FUN_004fadd0();
            iVar4 = FUN_005c2d40(DAT_00bef36c);
            if (iVar4 == 2) {
              FUN_0057abc0();
              if ((!bVar1) && (cVar2 = FUN_0061f420(), cVar2 != '\0')) {
                FUN_00624780();
                bVar1 = true;
              }
              FUN_0055c830();
              uVar5 = FUN_00544e60();
              switch(uVar5) {
              case 0:
                FUN_00544e70(1);
                break;
              case 1:
                FUN_00545760();
                break;
              case 2:
                FUN_00546200();
                break;
              case 3:
                FUN_00546720();
              }
              cVar2 = FUN_005cc7b0();
              if (((cVar2 != '\0') || (cVar2 = FUN_0061d950(), cVar2 != '\0')) &&
                 (iVar4 = FUN_00544e60(), iVar4 != 0)) {
                FUN_00547360();
              }
            }
            else if ((2 < iVar4) && (iVar4 < 5)) {
              DAT_00bef364 = '\x01';
            }
            FUN_00547750();
            svSleep();
          } while (DAT_00bef364 == '\0');
          iVar4 = FUN_00544e60();
          if ((1 < iVar4) && (iVar4 = FUN_00544e60(), iVar4 < 4)) {
            FUN_004f9cd0();
          }
          cVar2 = FUN_005cc7b0();
          if (cVar2 != '\0') {
            FUN_00547350();
            FUN_005cc900();
          }
          FUN_00544e70(0);
          FUN_00544de0(FUN_005c2a20);
          do {
            svSleep();
            uStack_9c = 0;
            cVar2 = FUN_005c2db0(&uStack_9c);
          } while (cVar2 != '\0');
          if ((bVar1) && (cVar2 = FUN_0061f420(), cVar2 != '\0')) {
            FUN_006248e0();
          }
          thunk_FUN_004346f0();
          FUN_00544e20(&LAB_00547250);
        }
        FUN_00544e20(FUN_005c29d0);
      }
      bVar1 = fgIsRunning();
    } while (bVar1);
  }
  FUN_005cfd80(&DAT_0074c900,0x3c00);
  return;
}

