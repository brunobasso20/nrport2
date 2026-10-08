/* NR2003.exe @ 0054a710 FUN_0054a710 */

undefined4 FUN_0054a710(undefined4 param_1,undefined4 param_2)

{
  bool bVar1;
  int iVar2;
  undefined4 uVar3;
  
  bVar1 = inBackground();
  if (bVar1) {
    iVar2 = FUN_00562f70(param_1);
  }
  else {
    iVar2 = FUN_004f5970(param_1);
  }
  if ((&DAT_00890490)[*(int *)(iVar2 + 0x58e)] != 0) {
    uVar3 = FUN_00547e20(param_2);
    return uVar3;
  }
  return 0xffffffff;
}

