/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005634a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005634a0(int param_1,float *param_2)

{
  float fVar1;
  float fVar2;
  float *pfVar3;
  
  if ((DAT_00c08764 & 1) == 0) {
    _DAT_00c5345c = _DAT_006f5d00 * _DAT_006f5e24;
    DAT_00c08764 = DAT_00c08764 | 1;
    _DAT_00c53460 = 0;
    _DAT_00c53464 = 0;
  }
  pfVar3 = *(float **)(param_1 + 0x5ae);
  FUN_005f6d20(param_2,pfVar3 + 0x16,&DAT_00c5345c);
  fVar1 = pfVar3[1];
  fVar2 = pfVar3[2];
  *param_2 = *pfVar3 + *param_2;
  param_2[1] = fVar1 + param_2[1];
  param_2[2] = fVar2 + param_2[2];
  return;
}


