/* Ghidra pseudo-C; NR2003.exe @ 005b5760 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005b5760(undefined4 param_1,int param_2,int *param_3,float param_4)

{
  int iVar1;
  int iVar2;
  uint uVar3;
  
  iVar1 = DAT_007522b0;
  iVar2 = DAT_007522bc;
  if ((param_3 != (int *)0x0) && (uVar3 = (param_2 - 4U) / 0x23, (param_2 - 4U) % 0x23 == 0)) {
    iVar1 = *param_3;
    if (param_4 < _DAT_006ea454) {
      DAT_00eab1c8 = DAT_007522bc;
      FUN_005b5150(DAT_007522bc + 1);
      DAT_007522bc = iVar1;
      DAT_007522b0 = iVar1;
      return;
    }
    DAT_00eab1c8 = iVar1;
    FUN_005b5150(iVar1);
    param_3 = param_3 + 1;
    for (; iVar2 = iVar1, uVar3 != 0; uVar3 = uVar3 - 1) {
      FUN_005b50f0(param_3);
      param_3 = (int *)((int)param_3 + 0x23);
    }
  }
  DAT_007522bc = iVar2;
  DAT_007522b0 = iVar1;
  return;
}

