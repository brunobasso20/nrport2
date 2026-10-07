/* NR2003.exe @ 0056e780 FUN_0056e780 */

undefined4 FUN_0056e780(int param_1,int param_2)

{
  if ((((-1 < param_2) && (param_2 < *(int *)(param_1 + 0x67) + -1)) &&
      (*(short *)(param_1 + 0x6b + param_2 * 8) == 4)) &&
     (*(short *)(param_1 + 0x73 + param_2 * 8) == 7)) {
    return 1;
  }
  return 0;
}

