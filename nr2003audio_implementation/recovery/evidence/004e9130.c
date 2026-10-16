/* NR2003.exe @ 004e9130 recovered_004e9130 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall recovered_004e9130(int param_1,float *param_2,float param_3,char param_4)

{
  param_2[1] = param_3 * *(float *)(param_1 + 0x83d) * _DAT_006f3814 + *(float *)(param_1 + 0x39);
  if (param_4 == '\0') {
    *param_2 = param_3;
    return;
  }
  *param_2 = param_3 * *(float *)(param_1 + 0x841) * _DAT_006f3814 + *(float *)(param_1 + 0x35);
  return;
}

