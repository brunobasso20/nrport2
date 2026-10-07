/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b0230 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005b0230(undefined4 param_1,float param_2)

{
  bool bVar1;
  
  FUN_00567818(&DAT_00e7d274,&DAT_006f7228,param_1);
  bVar1 = _DAT_006f5350 <= param_2;
  return ((float10)(float)(&DAT_00e7d278)[bVar1] - (float10)(float)(&DAT_00e7d274)[bVar1]) *
         ((float10)param_2 - (float10)(float)(&DAT_006f7334)[bVar1]) * (float10)_DAT_006f7350 +
         (float10)(float)(&DAT_00e7d274)[bVar1];
}


