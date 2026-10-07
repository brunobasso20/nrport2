/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00584640 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00584640(int param_1,int param_2)

{
  undefined1 uVar1;
  
  uVar1 = FUN_006c5018();
  *(undefined1 *)(param_1 + 1) = uVar1;
  if (_DAT_006f6874 <= *(float *)(param_2 + 0x14)) {
    *(undefined1 *)(param_1 + 2) = 0xff;
    return;
  }
  uVar1 = FUN_006c5018();
  *(undefined1 *)(param_1 + 2) = uVar1;
  return;
}


