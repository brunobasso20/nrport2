/* NR2003.exe @ 005b0900 FUN_005b0900 */

undefined4 FUN_005b0900(int param_1)

{
  if ((((-1 < param_1) && (param_1 < 0xff)) && ((DAT_00e7d666 != 0 || (0x7f < param_1)))) &&
     (*(char *)((int)&DAT_00e7d66a + param_1) != '\0')) {
    return 1;
  }
  return 0;
}

