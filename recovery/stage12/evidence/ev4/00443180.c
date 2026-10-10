/* NR2003.exe @ 00443180 FUN_00443180 */

void FUN_00443180(void)

{
  undefined4 uVar1;
  undefined4 *puVar2;
  int iVar3;
  undefined4 *puVar4;
  undefined4 uStack_1c;
  
  uVar1 = FUN_00443010();
  FUN_00571070(uVar1);
  uVar1 = FUN_00442ff0();
  FUN_00571040(uVar1);
  uVar1 = FUN_00443030();
  FUN_005710a0(uVar1);
  uVar1 = FUN_00443050();
  FUN_005710d0(uVar1);
  puVar2 = (undefined4 *)FUN_005d44c0();
  puVar4 = &uStack_1c;
  for (iVar3 = 7; iVar3 != 0; iVar3 = iVar3 + -1) {
    *puVar4 = *puVar2;
    puVar2 = puVar2 + 1;
    puVar4 = puVar4 + 1;
  }
  uStack_1c._3_1_ = FUN_00442fb0();
  FUN_005d44a0(&uStack_1c);
  return;
}

