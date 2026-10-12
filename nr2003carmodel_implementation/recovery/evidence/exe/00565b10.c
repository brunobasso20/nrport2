/* NR2003.exe @ 00565b10 FUN_00565b10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00565b10(float param_1)

{
  undefined4 uVar1;
  
  param_1 = ABS(param_1);
  if (param_1 < (float)_DAT_006ed030 != (NAN(param_1) || NAN((float)_DAT_006ed030))) {
    return 0;
  }
  uVar1 = 1;
  if (param_1 < (float)_DAT_006ea440 == (NAN(param_1) || NAN((float)_DAT_006ea440))) {
    uVar1 = 2;
  }
  return uVar1;
}

