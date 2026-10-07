/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050b4c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0050b4c0(float param_1,float param_2)

{
  float10 fVar1;
  float10 fVar2;
  float10 fVar3;
  float10 fVar4;
  
  param_1 = param_1 / _DAT_006f40b0;
  fVar1 = (float10)FUN_0050a1f0(-param_1);
  fVar2 = (float10)FUN_0050a1b0(-param_1);
  fVar4 = (float10)1.4426950408889634 * (float10)param_2 * (float10)_DAT_006f4114;
  fVar3 = ROUND(fVar4);
  fVar4 = (float10)f2xm1(fVar4 - fVar3);
  fVar3 = (float10)fscale((float10)1 + fVar4,fVar3);
  return fVar3 * (fVar2 + (float10)(float)fVar1) * (float10)_DAT_00749468 * (float10)_DAT_006ea44c *
         (float10)_DAT_006f4110;
}


