/* NR2003.exe @ 005bd300 FUN_005bd300 */

void FUN_005bd300(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 uVar1;
  int iVar2;
  
  uVar1 = FUN_005bd250(param_3);
  iVar2 = FUN_005bd100(0xf,0,uVar1);
  *(undefined4 *)(iVar2 + 4) = param_2;
  FUN_005bd160(param_1,iVar2);
  return;
}

