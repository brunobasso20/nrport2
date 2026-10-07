/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005195d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall
FUN_005195d0(int param_1_00,float param_1,float param_2,float param_3,float param_4)

{
  if (*(int *)(param_1_00 + 8) == 0) {
    param_2 = (param_1 * *(float *)(param_1_00 + 0x10) + *(float *)(param_1_00 + 0xc)) - param_2;
  }
  else {
    param_2 = (param_3 - *(float *)(param_1_00 + 0x14)) * *(float *)(param_1_00 + 0x20) -
              (param_4 - *(float *)(param_1_00 + 0x18)) * *(float *)(param_1_00 + 0x1c);
  }
  if (_DAT_006ea454 <= param_2) {
    return 1;
  }
  return 0;
}


