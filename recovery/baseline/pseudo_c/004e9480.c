/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004e9480 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004e9480(undefined4 *param_1_00,undefined4 param_1)

{
  FUN_005cfdb6(param_1,param_1_00 + 1,0x30);
  FUN_005cfdb6(param_1,param_1_00 + 1,0x30);
  if ((float)param_1_00[10] != (float)param_1_00[9]) {
    param_1_00[0xb] = _DAT_006e97d8 / ((float)param_1_00[10] - (float)param_1_00[9]);
    (**(code **)*param_1_00)();
    return;
  }
  param_1_00[0xb] = 0x3f800000;
  (**(code **)*param_1_00)();
  return;
}


