/* NR2003.exe @ 005f56e0 rndNormal */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* double __cdecl rndNormal(unsigned int) */

double __cdecl rndNormal(uint param_1)

{
  uint extraout_EDX;
  uint extraout_EDX_00;
  double dVar1;
  double dVar2;
  
                    /* 0x1f56e0  261  ?rndNormal@@YANI@Z */
  do {
    dVar1 = rndUniform(param_1);
    dVar2 = rndUniform(extraout_EDX);
    dVar2 = ((dVar2 - _DAT_006ea668) / dVar1) * _DAT_006f8b80;
    if (dVar2 * dVar2 <= _DAT_006ed050 - dVar1 * _DAT_006f8b78) {
      return dVar2;
    }
    param_1 = extraout_EDX_00;
  } while (dVar1 * 0.6931471805599453 * _DAT_006f8b70 < dVar2 * dVar2);
  return dVar2;
}

