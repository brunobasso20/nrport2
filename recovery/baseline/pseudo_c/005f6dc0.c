/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f6dc0 */

void FUN_005f6dc0(float *param_1,float *param_2,float *param_3)

{
  float *pfVar1;
  float local_c [3];
  
  pfVar1 = local_c;
  if (param_1 != param_3) {
    pfVar1 = param_1;
  }
  *pfVar1 = *param_2 * *param_3 + param_2[3] * param_3[1] + param_2[6] * param_3[2];
  pfVar1[1] = param_2[4] * param_3[1] + param_2[7] * param_3[2] + param_2[1] * *param_3;
  pfVar1[2] = param_2[5] * param_3[1] + param_2[8] * param_3[2] + param_2[2] * *param_3;
  if (pfVar1 != param_1) {
    *param_1 = *pfVar1;
    param_1[1] = pfVar1[1];
    param_1[2] = pfVar1[2];
  }
  return;
}


