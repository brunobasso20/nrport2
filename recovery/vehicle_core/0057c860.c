/* Ghidra pseudo-C; NR2003.exe @ 0057c860 */

undefined4 FUN_0057c860(undefined4 *param_1)

{
  param_1 = (undefined4 *)*param_1;
  if ((&DAT_00d3b02f < param_1) && (param_1 < &DAT_00d3fe50)) {
    return (&DAT_00d3fe50)[(int)(param_1 + -0x34ec0c) >> 2];
  }
  return 0;
}

