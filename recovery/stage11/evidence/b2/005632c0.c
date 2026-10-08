/* NR2003.exe @ 005632c0 FUN_005632c0 */

undefined4 FUN_005632c0(undefined4 param_1,int param_2)

{
  if (-1 < param_2) {
    return *(undefined4 *)(&DAT_006f5da4 + param_2 * 4);
  }
  return 6;
}

