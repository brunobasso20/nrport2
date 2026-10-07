/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055e490 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055e490(int param_1,float param_2,float param_3,float param_4,float param_5)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float *pfVar4;
  
  fVar1 = param_3 - param_4;
  param_3 = 0.0;
  pfVar4 = (float *)(param_1 + 0xc);
  do {
    fVar2 = (float)(int)param_3 * _DAT_006ea4a4;
    fVar3 = fVar2 * param_2;
    if (fVar1 < fVar2) {
      fVar2 = (fVar2 - fVar1) / param_4;
      fVar3 = fVar2 * fVar2 * fVar2 * param_5 + fVar3;
    }
    *pfVar4 = fVar3;
    param_3 = (float)((int)param_3 + 1);
    pfVar4 = pfVar4 + 1;
  } while ((int)param_3 < 0x14);
  *(float *)(param_1 + 0xc) = _DAT_006f5b1c * _DAT_006f5b2c * _DAT_006f5cd0 * _DAT_006ee5e4;
  return;
}


