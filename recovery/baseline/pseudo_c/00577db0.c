/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577db0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00577db0(void)

{
  int *piVar1;
  
  piVar1 = &DAT_00c7e7c0;
  DAT_00c7e7b4 = &DAT_00c7e7c0;
  _DAT_00c7e7b8 = 0x38b20;
  DAT_00c7e7bc = 0x52;
  do {
    *piVar1 = DAT_00c7e7bc + (int)piVar1;
    piVar1 = (int *)((int)piVar1 + DAT_00c7e7bc);
  } while (piVar1 < &DAT_00cb72e0);
  *(undefined4 *)((int)piVar1 - DAT_00c7e7bc) = 0;
  _DAT_00c7e7b0 = DAT_00c7e7b4;
  return;
}


