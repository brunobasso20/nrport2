/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052b070 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0052b070(int param_1,int param_2)

{
  float fVar1;
  float10 fVar2;
  float10 fVar3;
  
  fVar2 = (float10)FUN_00516e1a();
  fVar2 = (fVar2 * (float10)(*(int *)(param_2 + 0x1a8a) - *(int *)(param_1 + 0x1a8a)) +
          (float10)*(float *)(param_2 + 0x186a)) - (float10)*(float *)(param_1 + 0x186a);
  fVar1 = ABS((float)fVar2);
  if (_DAT_006ecfc8 <= fVar1) {
    if (_DAT_006f51a4 <= fVar1) {
      fVar3 = (float10)_DAT_006e97d8;
    }
    else {
      fVar3 = ((float10)fVar1 - (float10)_DAT_006ecfc8) * (float10)_DAT_006f51a0;
    }
  }
  else {
    fVar3 = (float10)_DAT_006ea454;
  }
  return (((float10)_DAT_006e97d8 - fVar3) *
          ((float10)*(float *)(param_1 + 0x1ac2) + (float10)*(float *)(param_2 + 0x1ac2)) *
          (float10)_DAT_006ea44c + fVar3) * (float10)(float)fVar2;
}


