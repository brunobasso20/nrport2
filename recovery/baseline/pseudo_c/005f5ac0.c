/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5ac0 */

void FUN_005f5ac0(int param_1,undefined4 param_2,undefined4 *param_3)

{
  FUN_005f59f0(param_1,param_2);
  *(undefined4 *)(param_1 + 0x8c) = *param_3;
  *(undefined4 *)(param_1 + 0x90) = param_3[1];
  *(undefined4 *)(param_1 + 0x94) = param_3[2];
  return;
}


