/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00585da0 */

undefined4 FUN_00585da0(int *param_1,int param_2)

{
  if (*param_1 == 1) {
    if (param_2 == 0) {
      return 1;
    }
    if (*(int *)(param_2 + 0x8c) < param_1[0x23]) {
      return 1;
    }
  }
  return 0;
}


