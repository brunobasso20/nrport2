/* NR2003.exe @ 00424350 FUN_00424350 */

undefined * FUN_00424350(void)

{
  char cVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 unaff_ESI;
  int iVar4;
  undefined4 uVar5;
  
  iVar4 = 0;
  iVar2 = FUN_0056c030();
  if (0 < iVar2) {
    do {
      iVar2 = FUN_0056c120(iVar4);
      if (iVar2 == 0) break;
      iVar4 = iVar4 + 1;
      iVar2 = FUN_0056c030();
    } while (iVar4 < iVar2);
  }
  uVar5 = 0x18;
  DAT_00871a3c = 0;
  uVar3 = FUN_0056c0f0(iVar4,0x18);
  FUN_006c5260(&DAT_00871a3c,uVar3,uVar5,unaff_ESI);
  cVar1 = FUN_0055a770();
  if (cVar1 != '\0') {
    FUN_006c5260();
    return &DAT_00871a3c;
  }
  FUN_006c5260();
  return &DAT_00871a3c;
}

