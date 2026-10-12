/* NR2003.exe @ 005d4340 FUN_005d4340 */

void FUN_005d4340(undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,
                 undefined4 param_5)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  
  iVar1 = *DAT_00f5e874;
  uVar2 = param_5;
  uVar3 = param_5;
  FUN_00446e70(&param_4);
  (**(code **)(iVar1 + 0x8c))(param_1,param_2,param_3,uVar2,uVar3);
  return;
}

