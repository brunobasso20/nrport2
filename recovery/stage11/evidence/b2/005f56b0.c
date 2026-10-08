/* NR2003.exe @ 005f56b0 rndUniform */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* double __cdecl rndUniform(unsigned int) */

double __cdecl rndUniform(uint param_1)

{
  uint uVar1;
  
                    /* 0x1f56b0  263  ?rndUniform@@YANI@Z */
  uVar1 = rndInt(param_1);
  return (double)(uVar1 & 0x7ffffffe | 1) * _DAT_006f8b68;
}

