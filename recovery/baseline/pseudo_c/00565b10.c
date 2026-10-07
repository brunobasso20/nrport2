/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00565b10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00565b10(float param_1)

{
  undefined4 uVar1;
  
  if (ABS(param_1) < (float)_DAT_006ed030) {
    return 0;
  }
  uVar1 = 1;
  if ((float)_DAT_006ea440 <= ABS(param_1)) {
    uVar1 = 2;
  }
  return uVar1;
}


