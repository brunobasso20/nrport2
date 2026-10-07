/* NR2003.exe @ 00424640 FUN_00424640 */

void FUN_00424640(void)

{
  bool bVar1;
  int iVar2;
  undefined4 uVar3;
  
  bVar1 = inBackground();
  if (bVar1) {
    iVar2 = FUN_00567280();
  }
  else {
    iVar2 = FUN_005099b0();
  }
  if ((iVar2 == 5) || (iVar2 == 6)) {
    uVar3 = 0;
  }
  else {
    uVar3 = 1;
  }
  uVar3 = FUN_004233c0(uVar3);
  uVar3 = FUN_00432d10(uVar3);
  FUN_00424210(uVar3);
  return;
}

