/* NR2003.exe @ 0059a960 FUN_0059a960 */

void FUN_0059a960(undefined4 param_1,undefined4 param_2_00,undefined4 param_2,char param_4)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  
  iVar1 = FUN_006c5018();
  iVar2 = FUN_006c5018();
  uVar3 = FUN_006c5018();
  uVar4 = FUN_006c5018();
  if ((9 < iVar1) || (iVar1 < 0)) {
    FUN_006c4f81(param_1,s____02d__02d__02d_007511d8,iVar2,uVar3,uVar4);
    return;
  }
  if ((param_4 != '\0') && (iVar1 < 1)) {
    if (0 < iVar2) {
      FUN_006c4f81(param_1,s__d__02d__02d_007511ac,iVar2);
      return;
    }
    FUN_006c4f81(param_1,s__d__02d_007511bc,uVar3,uVar4);
    return;
  }
  FUN_006c4f81(param_1,s__01d__02d__02d__02d_007511c4,iVar1,iVar2,uVar3,uVar4);
  return;
}

