/* NR2003.exe @ 005acd70 FUN_005acd70 */

void FUN_005acd70(int param_1)

{
  undefined uVar1;
  undefined *puVar2;
  int iVar3;
  
  FUN_00501870(8);
  puVar2 = (undefined *)FUN_00501a20(4);
  if (puVar2 != (undefined *)0x0) {
    iVar3 = 1;
    *puVar2 = *(undefined *)(param_1 + 0x5b2);
    do {
      uVar1 = FUN_006c5018();
      puVar2[iVar3] = uVar1;
      iVar3 = iVar3 + 1;
    } while (iVar3 < 4);
  }
  FUN_00501a40();
  return;
}

