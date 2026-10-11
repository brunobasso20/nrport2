/* NR2003.exe @ 00550b30 FUN_00550b30 */

void FUN_00550b30(void)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_00551880();
  if (cVar1 != '\0') {
    FUN_00538b20();
    iVar2 = FUN_00541040();
    if (iVar2 == 3) {
      FUN_00538b20();
      cVar1 = FUN_00541060();
      if (cVar1 != '\0') {
        if (DAT_00bf63c4 != (code *)0x0) {
          (*DAT_00bf63c4)();
        }
        FUN_00538b20();
        puVar3 = (undefined4 *)FUN_005410f0();
        FUN_00538b20();
        iVar2 = FUN_005410f0();
        FUN_00538b20(*(undefined4 *)(iVar2 + 8));
        iVar2 = FUN_005410f0();
        FUN_005512f0(*puVar3,*(undefined4 *)(iVar2 + 4));
        FUN_00550070(0);
        FUN_005500b0(0);
      }
    }
  }
  FUN_00538b20();
  FUN_00541080();
  return;
}

