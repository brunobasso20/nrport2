/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c050 */

undefined4 FUN_0056c050(int param_1)

{
  if ((-1 < param_1) && (param_1 < DAT_00c5ca20)) {
    FUN_0056c870();
    DAT_00c5c2e0 = param_1;
    FUN_005995a0(*(undefined4 *)(&DAT_00c5c3c4 + param_1 * 0x6c));
    return 1;
  }
  return 0;
}


