/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b5270 */

void __fastcall FUN_005b5270(int param_1)

{
  *(undefined4 *)(param_1 + 5) = 0;
  *(undefined4 *)(param_1 + 1) = *(undefined4 *)(param_1 + 9);
  *(uint *)(param_1 + 1) = *(uint *)(param_1 + 1) & 0x3ff;
  return;
}


