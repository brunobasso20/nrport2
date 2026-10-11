/* NR2003.exe @ 005d0060 FUN_005d0060 */

uint FUN_005d0060(int param_1)

{
  return CONCAT31((int3)((uint)param_1 >> 8),*(undefined *)(&DAT_00f5cd90 + param_1)) & 0xffffff01;
}

