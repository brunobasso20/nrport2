/* Ghidra pseudo-C; NR2003.exe @ 005614b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_005614b0(undefined4 *param_1)

{
  float fVar1;
  undefined4 *puVar2;
  int iVar3;
  float *pfVar4;
  float fStack_8;
  
  puVar2 = param_1;
  if (_DAT_006ed020 <= (float)param_1[3]) {
    param_1 = (undefined4 *)((float)param_1[2] + (float)param_1[1]);
  }
  else {
    param_1 = (undefined4 *)param_1[1];
  }
  iVar3 = FUN_006c5018();
  if ((&DAT_00c086e0)[iVar3] == 0) {
    pfVar4 = (float *)FUN_00557d60(iVar3 + 0x66);
    fStack_8 = *pfVar4;
  }
  else {
    pfVar4 = (float *)FUN_00557d60(0x67);
    fStack_8 = *pfVar4;
  }
  pfVar4 = (float *)FUN_00557d60(0x6e);
  fVar1 = fStack_8 * *pfVar4 * (float)param_1;
  if (_DAT_006ea454 <= fVar1) {
    pfVar4 = (float *)FUN_00557d60(0xa4);
    fVar1 = fVar1 * *pfVar4;
  }
  else {
    pfVar4 = (float *)FUN_00557d60(0xa3);
    fVar1 = -(fVar1 * *pfVar4);
  }
  fVar1 = (_DAT_006e97d8 - (_DAT_006e97d8 / _DAT_0074e860) * ABS((float)puVar2[5])) * fVar1;
  if (fVar1 < _DAT_006ea454) {
    fVar1 = _DAT_006ea454;
  }
  *(float *)*puVar2 = fVar1;
  return;
}

