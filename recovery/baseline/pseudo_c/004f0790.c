/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f0790 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004f0790(int param_1_00,float param_1)

{
  if (param_1 < _DAT_006ea454) {
    *(undefined4 *)(param_1_00 + 0x20) = 0;
    return;
  }
  if (_DAT_006e97d8 < param_1) {
    *(undefined4 *)(param_1_00 + 0x20) = 0x3f800000;
    return;
  }
  *(float *)(param_1_00 + 0x20) = param_1;
  return;
}


