/* NR2003.exe @ 0055cef0 recovered_0055cef0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_0055cef0(void)

{
  bool bVar1;
  char cVar2;
  int iVar3;
  __uint64 _Var4;
  
  func_0x005cfda4(0x74deb8,0x3c00);
  func_0x0055d0e0();
  bgSleep();
  (*_DAT_0074daf8)(0,&DAT_00c067ec);
  bVar1 = svIsRunning();
  if (bVar1) {
    do {
      bVar1 = fgIsRunning();
      if (!bVar1) break;
      iVar3 = FUN_0055a5a0();
      if (iVar3 == 7) break;
      iVar3 = FUN_005676f0();
      if (iVar3 != 0x77f) {
        FUN_00567704(1,3);
      }
      _Var4 = taskGetExpectedNextWakeCycleCount();
      func_0x0055a620(_Var4);
      func_0x005f8ec0();
      bVar1 = taskOutstandingClockSmash();
      if (bVar1) {
        func_0x0055d060();
        taskClearOutstandingClockSmash();
      }
      cVar2 = FUN_005c2cf0();
      if (cVar2 == '\0') {
LAB_0055cfba:
        FUN_0057abc0();
      }
      else {
        iVar3 = FUN_005c2d20();
        if (iVar3 != 1) goto LAB_0055cfba;
        iVar3 = FUN_005c2d40();
        if (iVar3 != 2) goto LAB_0055cfba;
      }
      cVar2 = FUN_005c2cf0();
      if (cVar2 == '\0') {
LAB_0055cfe5:
        FUN_0055c830();
      }
      else {
        iVar3 = FUN_005c2d20();
        if (iVar3 != 1) goto LAB_0055cfe5;
      }
      func_0x005743f0();
      FUN_00538b00();
      func_0x0053ab70();
      FUN_00538b00();
      func_0x0053add0();
      FUN_00538b10();
      func_0x0053c440();
      func_0x0055d390();
      func_0x0059b650();
      bgSleep();
      bVar1 = svIsRunning();
    } while (bVar1);
  }
  func_0x0055d430();
  FUN_0055ab30();
  FUN_0055a4f0(0);
  FUN_005cfd80(0x74debc,0x3c00);
  return;
}

