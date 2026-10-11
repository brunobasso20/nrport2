/* NR2003.exe @ 005f7200 FUN_005f7200 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f7200(undefined4 *param_1,float param_2,float param_3,float param_4)

{
  float10 fVar1;
  float10 fVar2;
  undefined4 local_20;
  float local_1c;
  undefined4 local_18;
  float local_14;
  float local_10;
  undefined4 local_c;
  undefined4 local_8;
  float local_4;
  
  fVar1 = (float10)fcos((float10)(param_2 * _DAT_006ea44c));
  fVar2 = (float10)fsin((float10)(param_2 * _DAT_006ea44c));
  param_1[2] = (float)fVar2;
  param_3 = param_3 * _DAT_006ea44c;
  param_1[3] = (float)fVar1;
  fVar1 = (float10)fcos((float10)param_3);
  fVar2 = (float10)fsin((float10)param_3);
  local_14 = (float)fVar1;
  local_1c = (float)fVar2;
  fVar1 = (float10)fcos((float10)(param_4 * _DAT_006ea44c));
  fVar2 = (float10)fsin((float10)(param_4 * _DAT_006ea44c));
  local_4 = (float)fVar1;
  local_10 = (float)fVar2;
  local_c = 0;
  local_8 = 0;
  local_20 = 0;
  local_18 = 0;
  *param_1 = 0;
  param_1[1] = 0;
  FUN_005f7050(&local_20,&local_20,&local_10);
  FUN_005f7050(param_1,param_1,&local_20);
  return;
}

