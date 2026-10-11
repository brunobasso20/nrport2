/* NR2003.exe @ 005a13f0 FUN_005a13f0 */

undefined4 __thiscall FUN_005a13f0(int param_1_00,int *param_1)

{
  if ((*(byte *)(param_1_00 + 0x324) & 0x10) != 0) {
    *param_1 = param_1_00 + 0x164;
    return 1;
  }
  *param_1 = 0;
  return 0;
}

