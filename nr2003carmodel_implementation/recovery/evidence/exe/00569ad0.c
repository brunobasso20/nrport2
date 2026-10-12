/* NR2003.exe @ 00569ad0 FUN_00569ad0 */

undefined4 FUN_00569ad0(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  float10 fVar1;
  float10 fVar2;
  
  fVar1 = (float10)FUN_00516daa(param_1,param_2);
  fVar2 = (float10)FUN_00516daa(param_1,param_3);
  if ((float10)(float)fVar1 < fVar2) {
    return 1;
  }
  return 0;
}

