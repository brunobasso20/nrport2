/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00575780 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_00575780(undefined4 *param_1_00,undefined4 param_1,undefined4 param_2,undefined4 param_3,
            float param_4,undefined4 param_5,undefined4 param_6,undefined4 param_7)

{
  param_1_00[9] = param_1;
  param_1_00[5] = param_1;
  param_1_00[1] = param_6;
  param_1_00[10] = param_2;
  param_1_00[6] = param_2;
  param_1_00[2] = 0;
  param_1_00[3] = 0;
  *(undefined1 *)(param_1_00 + 0x10) = 0;
  *param_1_00 = &PTR_LAB_006f609c;
  param_1_00[0xb] = param_3;
  param_1_00[7] = param_3;
  param_1_00[0xf] = 0;
  param_1_00[0xc] = param_4;
  param_1_00[4] = param_7;
  param_1_00[0xe] = param_5;
  param_1_00[8] =
       _DAT_006e97d8 /
       SQRT((float)param_1_00[7] * (float)param_1_00[7] +
            (float)param_1_00[6] * (float)param_1_00[6] +
            (float)param_1_00[5] * (float)param_1_00[5]);
  param_1_00[0xd] = param_4 * param_4;
  return;
}


