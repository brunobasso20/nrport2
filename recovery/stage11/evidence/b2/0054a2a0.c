/* NR2003.exe @ 0054a2a0 FUN_0054a2a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0054a2a0(undefined4 param_1,float param_2)

{
  float fVar1;
  int iVar2;
  double dVar3;
  
  iVar2 = FUN_00592db0(param_1);
  fVar1 = *(float *)(iVar2 + 0x54);
  if ((_DAT_006ea454 < fVar1) &&
     (((*(byte *)(iVar2 + 0xf) & 1) == 0 ||
      ((NAN(*(float *)(iVar2 + 0x54)) || NAN(_DAT_006ea454)) !=
       (*(float *)(iVar2 + 0x54) == _DAT_006ea454))))) {
    dVar3 = rndUniform(0);
    if (dVar3 <= (double)fVar1 * (double)param_2 * (double)_DAT_006ea508) {
      FUN_0054b7d0(1);
      FUN_0054b800(0x3f800000);
      FUN_00592dc0(param_1,1);
    }
  }
  return;
}

