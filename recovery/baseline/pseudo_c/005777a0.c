/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005777a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005777a0(void)

{
  int *piVar1;
  
  piVar1 = &DAT_00cb7310;
  DAT_00cb7304 = &DAT_00cb7310;
  _DAT_00cb7308 = 0x70800;
  DAT_00cb730c = 0x30;
  do {
    *piVar1 = DAT_00cb730c + (int)piVar1;
    piVar1 = (int *)((int)piVar1 + DAT_00cb730c);
  } while (piVar1 < &DAT_00d27b10);
  *(undefined4 *)((int)piVar1 - DAT_00cb730c) = 0;
  _DAT_00cb7300 = DAT_00cb7304;
  return;
}


