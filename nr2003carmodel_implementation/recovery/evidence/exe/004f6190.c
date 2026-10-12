/* NR2003.exe @ 004f6190 FUN_004f6190 */

void __fastcall FUN_004f6190(int param_1)

{
  undefined4 uVar1;
  int iVar2;
  
  uVar1 = FUN_004233a0();
  *(undefined4 *)(param_1 + 0x58e) = uVar1;
  *(undefined4 *)(param_1 + 0x592) = *(undefined4 *)(param_1 + 0x1216);
  *(undefined4 *)(param_1 + 0x596) = *(undefined4 *)(param_1 + 0x121a);
  iVar2 = FUN_00432cf0((undefined4 *)(param_1 + 0x58e));
  *(int *)(param_1 + 0x58a) = iVar2;
  *(undefined4 *)(param_1 + 0x582) = *(undefined4 *)(iVar2 + 0x1bc);
  *(undefined4 *)(param_1 + 0x586) = *(undefined4 *)(iVar2 + 0x1c0);
  FUN_0051a730(param_1,**(undefined4 **)(param_1 + 0x58a),(*(undefined4 **)(param_1 + 0x58a))[0x26])
  ;
  return;
}

