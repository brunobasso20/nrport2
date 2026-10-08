/* NR2003.exe @ 005484e0 FUN_005484e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined FUN_005484e0(undefined4 param_1,undefined4 param_2)

{
  float10 fVar1;
  
  fVar1 = (float10)FUN_005486a0(param_1,param_2);
  if ((NAN(fVar1) || NAN((float10)_DAT_006ea4a0)) != (fVar1 == (float10)_DAT_006ea4a0)) {
    return 3;
  }
  if ((float10)_DAT_006ea504 <= fVar1) {
    return 2;
  }
  return (float10)_DAT_006ef640 <= fVar1;
}

