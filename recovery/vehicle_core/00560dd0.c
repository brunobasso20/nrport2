/* Ghidra pseudo-C; NR2003.exe @ 00560dd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00560dd0(undefined4 *param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  float fVar3;
  
  fVar3 = (float)param_1[2] * _DAT_006f5ce8;
  uVar2 = param_1[1];
  uVar1 = *param_1;
  FUN_0051a000(uVar1,uVar2,fVar3,uVar2);
  FUN_0051a870(uVar1,uVar2,fVar3);
  return;
}

