/* NR2003.exe @ 00516e5a FUN_00516e5a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00516e5a(float *param_1)

{
  int *piVar1;
  float fVar2;
  float10 fVar3;
  float10 fVar4;
  
  piVar1 = (int *)(((uint)param_1[0x15] & 0x7fff) * 0x1550 + DAT_00bcf734);
  if (*piVar1 == 2) {
    fVar2 = (*param_1 - (float)piVar1[0xc]) * (*param_1 - (float)piVar1[0xc]) +
            (param_1[1] - (float)piVar1[0xd]) * (param_1[1] - (float)piVar1[0xd]);
    fVar3 = (float10)fVar2 * (float10)_DAT_006ea44c;
    fVar2 = (float)(0xbe7ffffdU - (int)fVar2 >> 1);
    fVar4 = ((float10)_DAT_006ea494 - (float10)fVar2 * (float10)fVar2 * fVar3) * (float10)fVar2;
    fVar4 = ((float10)_DAT_006ea494 - fVar4 * fVar4 * fVar3) * fVar4;
    fVar4 = ((float10)_DAT_006ea494 - fVar4 * fVar4 * fVar3) * fVar4;
    return ((float10)_DAT_006ea494 - fVar4 * fVar4 * fVar3) * fVar4 * (float10)(float)piVar1[4];
  }
  return (float10)_DAT_006ea454;
}

