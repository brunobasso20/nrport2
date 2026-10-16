/* NR2003.exe @ 004e9540 recovered_004e9540 */

void recovered_004e9540(int param_1,int param_2,float param_3,int param_4)

{
  *(float *)(param_1 + 4) =
       (*(float *)(param_4 + 0xc + param_2 * 8) - *(float *)(param_4 + 4 + param_2 * 8)) * param_3 +
       *(float *)(param_4 + 4 + param_2 * 8);
  return;
}

