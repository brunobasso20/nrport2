/* NR2003.exe @ 004e9510 recovered_004e9510 */

void __thiscall recovered_004e9510(int param_1,int param_2,int param_3,float param_4,int param_5)

{
  *(float *)(param_2 + 4) =
       *(float *)(param_5 + 4 + param_3 * 8) -
       (*(float *)(param_1 + 0xc) - *(float *)(param_5 + 4 + param_3 * 8)) * param_4;
  return;
}

