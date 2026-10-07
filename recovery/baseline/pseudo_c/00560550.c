/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00560550 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00560550(undefined4 param_1)

{
  switch(param_1) {
  case 0:
    return (float10)*(float *)(DAT_00c084c0 + 0x4c);
  case 1:
    return (float10)*(float *)(DAT_00c08310 + 0x4c);
  case 2:
    return (float10)*(float *)(DAT_00c084b4 + 0x4c) + (float10)*(float *)(DAT_00c08254 + 0x4c) +
           (float10)_DAT_00c0869c;
  case 3:
    return ((float10)*(float *)(DAT_00c084b8 + 0x4c) + (float10)*(float *)(DAT_00c08254 + 0x4c)) -
           (float10)_DAT_00c0869c;
  default:
    return (float10)_DAT_006ea454;
  }
}


