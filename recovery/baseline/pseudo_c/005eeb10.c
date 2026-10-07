/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005eeb10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005eeb10(undefined4 param_1,undefined4 param_2)

{
  double dVar1;
  double dVar2;
  int iVar3;
  
  iVar3 = 0;
  dVar1 = _DAT_006e9808;
  dVar2 = _DAT_006e9808;
  do {
    iVar3 = iVar3 + 1;
    dVar2 = (((double)CONCAT44(param_2,param_1) * _DAT_006ea668) / (double)iVar3) * dVar2;
    dVar1 = dVar2 * dVar2 + dVar1;
  } while (dVar1 * _DAT_006f8b58 < dVar2 * dVar2);
  return;
}


