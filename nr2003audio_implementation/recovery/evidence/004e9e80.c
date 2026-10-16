/* NR2003.exe @ 004e9e80 FUN_004e9e80 */

void __thiscall FUN_004e9e80(int param_1_00,undefined4 param_1,undefined4 param_3)

{
  FUN_005cfdb6(param_1,(undefined4 *)(param_1_00 + 4),4);
  FUN_004e9d10(*(undefined4 *)(param_1_00 + 4));
  if (*(int **)(param_1_00 + 0x14) != (int *)0x0) {
    (**(code **)(**(int **)(param_1_00 + 0x14) + 8))(param_1,param_3);
  }
  return;
}

