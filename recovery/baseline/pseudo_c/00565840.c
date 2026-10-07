/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00565840 */

void FUN_00565840(undefined4 *param_1,undefined4 *param_2,int param_3,int param_4)

{
  *param_1 = *(undefined4 *)(&DAT_006f5d30 + param_3 * 4);
  if (param_3 == 1) {
    *param_2 = *(undefined4 *)(&DAT_006f5d70 + param_4 * 4);
    return;
  }
  *param_2 = *(undefined4 *)(&DAT_006f5d50 + param_3 * 4);
  return;
}


