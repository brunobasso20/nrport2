/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056ea60 */

undefined4 __thiscall FUN_0056ea60(short *param_1_00,short *param_1)

{
  if ((*param_1_00 == *param_1) && (param_1_00[1] == param_1[1])) {
    if (*(float *)(param_1_00 + 2) == *(float *)(param_1 + 2)) {
      return 0;
    }
  }
  return 1;
}


