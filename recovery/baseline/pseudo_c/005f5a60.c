/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5a60 */

void FUN_005f5a60(int param_1,undefined4 *param_2)

{
  *(undefined4 *)(param_1 + 0x7c) = *param_2;
  *(undefined4 *)(param_1 + 0x80) = param_2[1];
  *(undefined4 *)(param_1 + 0x84) = param_2[2];
  *(undefined4 *)(param_1 + 0x88) = param_2[3];
  FUN_005f6e40();
  return;
}


