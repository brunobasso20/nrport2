/* NR2003.exe @ 004808c0 FUN_004808c0 */

void __thiscall FUN_004808c0(int param_1_00,undefined4 param_1)

{
  int *piVar1;
  
  piVar1 = (int *)(**(code **)(**(int **)(param_1_00 + 0x20) + 0x3c))(param_1);
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 0x4c))();
  }
  return;
}

