/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f56e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* double __cdecl rndNormal(unsigned int) */

double __cdecl rndNormal(uint param_1)

{
  float10 fVar1;
  uint extraout_EDX;
  uint extraout_EDX_00;
  float10 fVar2;
  double dVar3;
  double dVar4;
  
                    /* 0x1f56e0  261  ?rndNormal@@YANI@Z */
  do {
    dVar3 = rndUniform(param_1);
    dVar4 = rndUniform(extraout_EDX);
    fVar2 = (((float10)dVar4 - (float10)_DAT_006ea668) / (float10)dVar3) * (float10)_DAT_006f8b80;
    if (fVar2 * fVar2 <= (float10)_DAT_006ed050 - (float10)dVar3 * (float10)_DAT_006f8b78) {
      return (double)fVar2;
    }
    fVar1 = (float10)log2((float10)dVar3);
    param_1 = extraout_EDX_00;
  } while ((float10)0.6931471805599453 * fVar1 * (float10)_DAT_006f8b70 < fVar2 * fVar2);
  return (double)fVar2;
}


