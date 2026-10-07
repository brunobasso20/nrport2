/* NR2003.exe @ 005402b0 FUN_005402b0 */

undefined4 __thiscall FUN_005402b0(int param_1_00,undefined4 param_1)

{
  int iVar1;
  
  iVar1 = FUN_00558ed0(*(undefined4 *)(param_1_00 + 0x224),param_1_00 + 0x24,param_1);
  if (iVar1 != 0) {
    FUN_00558e70(0x200,param_1_00 + 0x228,(undefined4 *)(param_1_00 + 0x428));
    FUN_00540b80(1,param_1_00 + 0x228,*(undefined4 *)(param_1_00 + 0x428),0);
    return 1;
  }
  return 0;
}

