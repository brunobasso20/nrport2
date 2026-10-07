/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005c1330 */

undefined4 * __thiscall FUN_005c1330(undefined4 *param_1_00,byte param_1)

{
  FUN_0040c120(param_1_00[0x14a]);
  FUN_0040c120(param_1_00[0x148]);
  FUN_0040c120(param_1_00[0x149]);
  FUN_005f5880(param_1_00 + 0x14b);
  FUN_0054f880();
  FUN_0054f880();
  *param_1_00 = &PTR_DAT_006e97e4;
  if ((param_1 & 1) != 0) {
    FUN_005cfccc(param_1_00);
  }
  return param_1_00;
}


