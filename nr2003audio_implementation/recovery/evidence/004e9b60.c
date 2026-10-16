/* NR2003.exe @ 004e9b60 recovered_004e9b60 */

void __thiscall recovered_004e9b60(undefined4 *param_1,undefined4 param_2,int param_3)

{
  if (param_3 < 3) {
    FUN_005cfdb6(param_2,param_1 + 1,0x18);
    param_1[7] = 0;
    (**(code **)*param_1)();
    return;
  }
  FUN_005cfdb6(param_2,param_1 + 1,0x1c);
  (**(code **)*param_1)();
  return;
}

