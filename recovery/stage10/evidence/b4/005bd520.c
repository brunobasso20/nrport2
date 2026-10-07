/* NR2003.exe @ 005bd520 FUN_005bd520 */

void FUN_005bd520(uint *param_1,undefined4 param_2)

{
  uint uVar1;
  uint *puVar2;
  int iVar3;
  undefined4 uVar4;
  int extraout_ECX;
  
  puVar2 = param_1;
  iVar3 = FUN_005bd610(&param_1,param_1);
  if (iVar3 != 0) {
    FUN_005bd650(puVar2,param_2);
    return;
  }
  uVar1 = puVar2[3];
  puVar2[3] = uVar1 - 1;
  if (uVar1 - 1 == 0) {
    if (((*(byte *)puVar2 & 2) != 0) && (param_1 != (uint *)0x0)) {
      uVar4 = FUN_005bd5a0(param_1);
      FUN_005bd5e0(uVar4);
    }
    if ((*puVar2 & 2) == 0) {
      iVar3 = FUN_005bd200(puVar2);
      if (iVar3 == 0) {
        FUN_005bd490(extraout_ECX >> 2,puVar2[1],puVar2[2],param_2);
      }
    }
  }
  return;
}

