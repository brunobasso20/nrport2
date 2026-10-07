/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c090 */

undefined * FUN_0056c090(uint param_1)

{
  if (0x7fffffff < param_1) {
    param_1 = DAT_00c5c2e0;
  }
  if ((int)param_1 < DAT_00c5ca20) {
    return &DAT_00c5c360 + param_1 * 0x6c;
  }
  return &DAT_00c5caf5;
}


