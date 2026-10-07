/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00579f10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

float10 FUN_00579f10(float *param_1,undefined4 *param_2,float *param_3,undefined4 param_4,
                    float param_5,float param_6,float *param_7,float *param_8,float *param_9,
                    float param_10,float param_11,undefined4 param_12,float param_13,float param_14)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float10 fVar6;
  float10 fVar7;
  float10 extraout_ST1;
  float local_18;
  float local_14;
  float local_10;
  
  fVar5 = param_14 * param_14;
  *param_2 = 0;
  FUN_00579e80(param_4,param_5);
  fVar6 = (float10)FUN_00579ea0(param_4,param_5);
  fVar6 = fVar6 * (float10)param_10 * (float10)param_14 + extraout_ST1;
  fVar1 = (float)fVar6;
  *param_1 = (float)(fVar6 * (float10)*param_7);
  param_1[1] = fVar1 * param_7[1];
  param_1[2] = fVar1 * param_7[2];
  fVar6 = (float10)FUN_00579e80(param_4,param_5);
  fVar6 = fVar6 * (float10)fVar5 * (float10)param_13;
  fVar2 = *param_9;
  fVar3 = param_9[1];
  fVar4 = param_9[2];
  fVar7 = (float10)FUN_00579ea0(param_4,param_5);
  fVar7 = fVar7 * (float10)param_11 * (float10)param_14;
  local_18 = (float)(fVar6 * (float10)fVar2) + (float)(fVar7 * (float10)*param_8);
  local_14 = (float)(fVar6 * (float10)fVar3) + (float)(fVar7 * (float10)param_8[1]);
  local_10 = (float)(fVar6 * (float10)fVar4) + (float)(fVar7 * (float10)param_8[2]);
  param_5 = SQRT(local_18 * local_18 + local_14 * local_14 + local_10 * local_10);
  param_14 = ABS(fVar1 * param_6);
  if (_DAT_006f6614 < param_14) {
    param_14 = 40000.0;
  }
  fVar2 = _DAT_006e97d8;
  if (param_14 < param_5) {
    fVar2 = param_14 / param_5;
    param_5 = param_14;
    local_18 = local_18 * fVar2;
    local_14 = local_14 * fVar2;
    local_10 = local_10 * fVar2;
  }
  *param_3 = fVar2 * fVar5 * param_13;
  *param_1 = *param_1 + local_18;
  param_1[1] = param_1[1] + local_14;
  param_1[2] = param_1[2] + local_10;
  return (float10)param_5 * (float10)_DAT_006ea50c + (float10)ABS(fVar1);
}


