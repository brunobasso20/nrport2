/* NR2003.exe @ 00548760 FUN_00548760 */

void FUN_00548760(undefined4 *param_1,int param_2)

{
  *param_1 = *(undefined4 *)(&DAT_006f56c1 + param_2 * 0x15);
  param_1[1] = *(undefined4 *)(&DAT_006f56c5 + param_2 * 0x15);
  param_1[2] = *(undefined4 *)(&DAT_006f56c9 + param_2 * 0x15);
  return;
}

