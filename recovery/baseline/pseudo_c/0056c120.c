/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c120 */

undefined4 FUN_0056c120(uint param_1)

{
  if (0x7fffffff < param_1) {
    param_1 = DAT_00c5c2e0;
  }
  if ((int)param_1 < DAT_00c5ca20) {
    return *(undefined4 *)(&DAT_00c5c3c4 + param_1 * 0x6c);
  }
  return 0;
}


