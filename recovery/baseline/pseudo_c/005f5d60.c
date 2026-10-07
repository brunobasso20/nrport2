/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5d60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f5d60(undefined4 *param_1,undefined4 *param_2,undefined4 *param_3,float *param_4,
                 float *param_5)

{
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  if (param_5[2] != _DAT_006ea454) {
    param_4[2] = -((param_5[1] * param_4[1] + *param_4 * *param_5) / param_5[2]);
    FUN_005f6a70(param_4);
    local_24 = *param_4;
    local_18 = param_4[1];
    local_c = param_4[2];
    local_8 = *param_5 * param_4[1] - param_5[1] * *param_4;
    local_1c = *param_5;
    local_10 = param_5[1];
    local_20 = param_4[2] * param_5[1] - param_4[1] * param_5[2];
    local_4 = param_5[2];
    local_14 = *param_4 * param_5[2] - param_4[2] * *param_5;
    FUN_005f74c0(param_1,param_2,param_3,&local_24);
    return;
  }
  param_4[2] = 0.0;
  *param_1 = 0;
  *param_2 = 0;
  *param_3 = 0;
  return;
}


