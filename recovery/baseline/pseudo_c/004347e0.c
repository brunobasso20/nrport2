/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004347e0 */

int * __thiscall FUN_004347e0(int *param_1_00,byte param_1)

{
  if (*param_1_00 != 0) {
    FUN_004347e0(1);
  }
  if (param_1_00[1] != 0) {
    FUN_004347e0(1);
  }
  if ((param_1 & 1) != 0) {
    FUN_00547e80(param_1_00,0x18);
  }
  return param_1_00;
}


