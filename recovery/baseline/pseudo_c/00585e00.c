/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00585e00 */

bool FUN_00585e00(int param_1,int param_2)

{
  if (param_2 == 0) {
    return true;
  }
  return *(int *)(param_2 + 0x8c) < *(int *)(param_1 + 0x8c);
}


