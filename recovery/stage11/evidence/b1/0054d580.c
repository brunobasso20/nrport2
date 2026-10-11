/* NR2003.exe @ 0054d580 FUN_0054d580 */

void FUN_0054d580(undefined4 param_1,undefined4 param_2,undefined4 *param_3,undefined4 *param_4,
                 undefined4 param_5,undefined4 param_6,undefined4 param_7,undefined4 param_8)

{
  int extraout_EDX;
  undefined4 local_8;
  undefined4 local_4;
  
  FUN_0054d430(param_1,param_2,param_3 + 6,param_5,param_6);
  local_4 = param_7;
  local_8 = *param_4;
  FUN_005b5800(param_3,*(undefined4 *)(extraout_EDX + 0x3c),&local_8,param_8);
  *param_3 = param_3[6];
  param_3[1] = param_3[7];
  param_3[2] = param_3[8];
  param_3[3] = param_3[9];
  param_3[4] = param_3[10];
  param_3[5] = param_3[0xb];
  *param_4 = param_7;
  return;
}

