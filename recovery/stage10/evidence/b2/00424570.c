/* NR2003.exe @ 00424570 FUN_00424570 */

void FUN_00424570(int param_1)

{
  bool bVar1;
  char cVar2;
  undefined4 uVar3;
  int iVar4;
  undefined4 *puVar5;
  int iVar6;
  undefined4 uVar7;
  undefined4 uVar8;
  
  uVar3 = FUN_0055ab00();
  iVar4 = FUN_00562f70(uVar3);
  puVar5 = (undefined4 *)FUN_00557d70(0x32);
  uVar3 = *puVar5;
  bVar1 = inBackground();
  if (bVar1) {
    iVar6 = FUN_00567280();
  }
  else {
    iVar6 = FUN_005099b0();
  }
  bVar1 = inBackground();
  if (bVar1) {
    uVar7 = FUN_0055a680();
  }
  else {
    uVar7 = FUN_00544bf0();
  }
  bVar1 = inBackground();
  if (bVar1) {
    uVar8 = FUN_0055a6a0();
  }
  else {
    uVar8 = FUN_00509990();
  }
  if ((iVar6 == 5) || (iVar6 == 6)) {
    uVar3 = 0;
  }
  else {
    if (iVar6 != 7) {
      cVar2 = FUN_0056e780(uVar7,uVar8);
      if (cVar2 == '\0') goto LAB_00424600;
    }
    uVar3 = 1;
  }
LAB_00424600:
  uVar3 = FUN_00432cf0(param_1 + 0xef1,uVar3);
  uVar3 = FUN_00424210(uVar3);
  FUN_0051a730(iVar4,uVar3,*(undefined4 *)(*(int *)(iVar4 + 0x58a) + 0x98));
  return;
}

