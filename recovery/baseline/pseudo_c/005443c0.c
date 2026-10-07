/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005443c0 */

undefined4 __thiscall FUN_005443c0(int param_1_00,int param_1)

{
  if (param_1 < 0) {
    return 0xffffffff;
  }
  return *(undefined4 *)(param_1 * 0x10 + *(int *)(param_1_00 + 0x10));
}


