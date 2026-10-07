/* Ghidra pseudo-C; NR2003.exe @ 0057d3f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_0057d3f0(undefined4 *param_1,undefined4 *param_2)

{
  if (*(float *)*param_2 == _DAT_006ea454) {
    *(undefined4 *)*param_1 = 0x3f800000;
    return;
  }
  *(float *)*param_1 = _DAT_006e97d8 / *(float *)*param_2;
  return;
}

