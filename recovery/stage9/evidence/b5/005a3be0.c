/* NR2003.exe @ 005a3be0 FUN_005a3be0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005a3be0(float param_1)

{
  float *pfVar1;
  float *pfVar2;
  float10 fVar3;
  
  fVar3 = (float10)_DAT_006f6f60;
  pfVar1 = (float *)&DAT_006f6f5c;
  do {
    pfVar2 = pfVar1 + -1;
    fVar3 = fVar3 * (float10)param_1 + (float10)*pfVar1;
    pfVar1 = pfVar2;
  } while (0x6f6f4f < (int)pfVar2);
  return fVar3;
}

