/* NR2003.exe @ 005a3ba0 FUN_005a3ba0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005a3ba0(float param_1,float param_2,float param_3)

{
  float10 fVar1;
  
  param_2 = param_2 * _DAT_006f6f78;
  fVar1 = (float10)FUN_005a3be0(param_1);
  return ((float10)param_2 - fVar1 * (float10)param_3 * (float10)_DAT_006f6f74) /
         ((float10)param_1 + (float10)_DAT_006ee350);
}

