/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577af0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00577af0(void)

{
  int *piVar1;
  
  piVar1 = &DAT_00d27b20;
  DAT_00d27b14 = &DAT_00d27b20;
  _DAT_00d27b18 = 0xddd0;
  DAT_00d27b1c = 0x5b;
  do {
    *piVar1 = DAT_00d27b1c + (int)piVar1;
    piVar1 = (int *)((int)piVar1 + DAT_00d27b1c);
  } while (piVar1 < &DAT_00d358f0);
  *(undefined4 *)((int)piVar1 - DAT_00d27b1c) = 0;
  _DAT_00d27b10 = DAT_00d27b14;
  return;
}


