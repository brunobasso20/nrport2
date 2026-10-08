/* NR2003.exe @ 00550a50 FUN_00550a50 */

void FUN_00550a50(void)

{
  char cVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 *puVar4;
  
  cVar1 = FUN_00551880();
  if (cVar1 != '\0') {
    FUN_00538b20();
    iVar2 = FUN_00541040();
    if (iVar2 == 2) {
      FUN_00538b20();
      cVar1 = FUN_00541060();
      if (cVar1 != '\0') {
        uVar3 = FUN_0055ab00(1);
        uVar3 = FUN_00562f70(uVar3);
        FUN_00563080(uVar3);
        FUN_00550c40();
        FUN_00550c60();
        FUN_005512d0();
        if (DAT_00bf63c4 != (code *)0x0) {
          (*DAT_00bf63c4)();
        }
        FUN_00538b20();
        puVar4 = (undefined4 *)FUN_005410f0();
        FUN_00538b20();
        iVar2 = FUN_005410f0();
        FUN_00538b20(*(undefined4 *)(iVar2 + 8));
        iVar2 = FUN_005410f0();
        FUN_005512f0(*puVar4,*(undefined4 *)(iVar2 + 4));
        uVar3 = FUN_0055ab00();
        iVar2 = FUN_00562f70(uVar3);
        *(undefined4 *)(iVar2 + 0x1518) = 0;
        FUN_00550070(0);
        FUN_00524930();
        FUN_005500b0(0);
      }
    }
  }
  FUN_00538b20();
  FUN_00541080();
  return;
}

