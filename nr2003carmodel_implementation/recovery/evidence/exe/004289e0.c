/* NR2003.exe @ 004289e0 FUN_004289e0 */

undefined4 FUN_004289e0(undefined4 param_1,int param_2)

{
  int *piVar1;
  
  piVar1 = (int *)(param_2 + 8);
  if (*(int **)(&DAT_00872700 + *piVar1 * 0xe00) != (int *)0x0) {
    param_2 = 0;
    (**(code **)(**(int **)(&DAT_00872700 + *piVar1 * 0xe00) + 8))(&param_2);
    return param_1;
  }
  return 0;
}

