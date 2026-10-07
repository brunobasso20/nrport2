/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00584690 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00584690(int param_1,int param_2)

{
  undefined1 uVar1;
  
  *(undefined1 *)(param_1 + 1) = *(undefined1 *)(param_2 + 0x18);
  if (_DAT_006f6870 <= *(float *)(param_2 + 0x14)) {
    *(undefined1 *)(param_1 + 2) = 0xff;
    return;
  }
  uVar1 = FUN_006c5018();
  *(undefined1 *)(param_1 + 2) = uVar1;
  return;
}


