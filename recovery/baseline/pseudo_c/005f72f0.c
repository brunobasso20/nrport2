/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f72f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f72f0(float *param_1,float param_2,float *param_3,float *param_4)

{
  float fVar1;
  float fVar2;
  float local_34;
  float local_30;
  float local_2c;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  local_34 = *param_4 - *param_3;
  local_30 = param_4[1] - param_3[1];
  local_2c = param_4[2] - param_3[2];
  fVar2 = param_4[3] - param_3[3];
  if (_DAT_006e97d8 <=
      fVar2 * fVar2 + local_34 * local_34 + local_30 * local_30 + local_2c * local_2c) {
    local_34 = *param_4 + *param_3;
    local_30 = param_4[1] + param_3[1];
    local_2c = param_4[2] + param_3[2];
    fVar2 = param_4[3] + param_3[3];
  }
  fVar1 = param_4[3];
  local_1c = ((local_34 * fVar1 - fVar2 * *param_4) -
             (local_2c * param_4[1] - local_30 * param_4[2])) * param_2;
  local_18 = ((local_30 * fVar1 - fVar2 * param_4[1]) -
             (local_34 * param_4[2] - local_2c * *param_4)) * param_2;
  local_14 = ((local_2c * fVar1 - fVar2 * param_4[2]) -
             (local_30 * *param_4 - local_34 * param_4[1])) * param_2;
  FUN_005f7150(&local_10,param_3,&local_1c);
  *param_1 = local_10 + *param_3;
  param_1[1] = local_c + param_3[1];
  param_1[2] = local_8 + param_3[2];
  param_1[3] = local_4 + param_3[3];
  FUN_005f6ff0(param_1);
  return;
}


