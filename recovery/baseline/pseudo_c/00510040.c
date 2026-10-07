/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00510040 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00510040(int param_1)

{
  undefined4 *puVar1;
  
  DAT_0074b9d8 = *(undefined4 *)(param_1 + 0x50);
  DAT_0074b9dc = *(undefined4 *)(param_1 + 0x54);
  DAT_0074b9e0 = *(undefined4 *)(param_1 + 0x58);
  _DAT_0074b9e4 = *(undefined4 *)(param_1 + 0x5c);
  puVar1 = &DAT_0074fb30;
  do {
    *puVar1 = *(undefined4 *)(param_1 + -0x74fb30 + (int)puVar1);
    puVar1 = puVar1 + 1;
  } while ((int)puVar1 < 0x74fb80);
  return;
}


