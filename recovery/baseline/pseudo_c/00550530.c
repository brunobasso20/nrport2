/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00550530 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00550530(void)

{
  int iVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  
  DAT_00bf6360 = 0;
  _DAT_00bf6364 = 0;
  DAT_00bf6368 = 0;
  DAT_00bf636c = 0;
  DAT_00bf6370 = 0;
  _DAT_00bf6374 = 0x3f800000;
  _DAT_00bf6378 = 0;
  _DAT_00bf637c = 0;
  _DAT_00bf6380 = 0;
  FUN_00550640();
  puVar2 = &DAT_00bf6360;
  puVar3 = &DAT_00bf6e28;
  for (iVar1 = 9; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar3 = *puVar2;
    puVar2 = puVar2 + 1;
    puVar3 = puVar3 + 1;
  }
  DAT_00bf6ea0 = 0;
  DAT_00bf6e10 = 0;
  DAT_00bf6e0c = 0;
  _DAT_00bf6ec0 = 0;
  _DAT_00bf6ecc = 0;
  DAT_00bf6f28 = 0;
  _DAT_00bf6f2c = 0;
  _DAT_00bf63c8 = 0;
  _DAT_00bf6f14 = 0;
  _DAT_0074c98c = 0;
  _DAT_00bf6388 = 0;
  _DAT_00bf6e84 = 0;
  DAT_00bf63bc = 0;
  _DAT_00bf638c = 0;
  _DAT_00bf6390 = 0;
  DAT_00bf6eb0 = 0;
  _DAT_00bf639c = 0;
  DAT_00bf63a0 = 0;
  DAT_00bf6ef8 = 0;
  puVar2 = &DAT_00bf6360;
  puVar3 = &DAT_00bf6e58;
  for (iVar1 = 9; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar3 = *puVar2;
    puVar2 = puVar2 + 1;
    puVar3 = puVar3 + 1;
  }
  _DAT_00bf63a4 = 0;
  DAT_00bf6efc = 0;
  _DAT_00bf6eac = 0x3f800000;
  _DAT_00bf63a8 = 0;
  return;
}


