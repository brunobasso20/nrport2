/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c940 */

undefined4 FUN_0056c940(int param_1)

{
  if ((-1 < param_1) && (param_1 < 4)) {
    return *(undefined4 *)(&DAT_00c5ca28 + param_1 * 4);
  }
  return 0;
}


