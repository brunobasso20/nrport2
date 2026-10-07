/* Ghidra pseudo-C; NR2003.exe @ 005b3f50 */

void FUN_005b3f50(int param_1)

{
  int iVar1;
  
  FUN_005b7fe0(param_1 + 0x385,param_1 + 0x29d);
  FUN_005b7fe0(param_1 + 0x2b5,&PTR_DAT_006f746c);
  FUN_005b7fe0(param_1 + 0x39d,param_1 + 0x2b5);
  FUN_005b39e0(param_1,param_1 + 0x29d,&PTR_DAT_0074fd9c);
  FUN_005b7fe0(param_1 + 0x3cd,param_1 + 0x385);
  FUN_005b2ef0(param_1,FUN_005b3fd0);
  iVar1 = 0;
  do {
    FUN_0055d9c0(iVar1);
    iVar1 = iVar1 + 1;
  } while (iVar1 < 4);
  FUN_005b3990();
  return;
}

