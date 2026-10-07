/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00541640 */

void __thiscall
FUN_00541640(int param_1_00,int param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,
            undefined4 param_5,undefined4 param_6,undefined4 param_7)

{
  param_1_00 = param_1_00 + param_1 * 0x19;
  *(undefined4 *)(param_1_00 + 0x1c) = param_2;
  *(undefined4 *)(param_1_00 + 0x20) = param_3;
  *(undefined4 *)(param_1_00 + 0x24) = param_4;
  *(undefined4 *)(param_1_00 + 0x28) = param_5;
  *(undefined4 *)(param_1_00 + 0x2c) = param_6;
  *(undefined4 *)(param_1_00 + 0x30) = param_7;
  *(undefined1 *)(param_1_00 + 0x34) = 0;
  return;
}


