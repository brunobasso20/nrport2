/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054d430 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void FUN_0054d430(int param_1,float param_2,float *param_3,float *param_4,float *param_5)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  
  fVar1 = SQRT(param_5[2] * param_5[2] + param_5[1] * param_5[1] + *param_5 * *param_5);
  if (_DAT_006f3fe8 < fVar1) {
    fVar1 = _DAT_006e97d8 / fVar1;
    fVar3 = (ABS((*(float *)(param_1 + 100) * param_5[1] +
                 *(float *)(param_1 + 0x70) * param_5[2] + *(float *)(param_1 + 0x58) * *param_5) *
                 fVar1) + _DAT_006e97d8) * param_2 * fVar1 * _DAT_006ea44c;
    fVar4 = (*(float *)(param_1 + 0x28) * param_5[2] - *(float *)(param_1 + 0x2c) * param_5[1]) *
            fVar3;
    fVar5 = (*(float *)(param_1 + 0x2c) * *param_5 - *(float *)(param_1 + 0x24) * param_5[2]) *
            fVar3;
    fVar3 = (*(float *)(param_1 + 0x24) * param_5[1] - *(float *)(param_1 + 0x28) * *param_5) *
            fVar3;
    fVar1 = param_4[1];
    fVar2 = param_4[2];
    *param_3 = *param_4 + fVar4;
    param_3[1] = fVar1 + fVar5;
    param_3[2] = fVar2 + fVar3;
    param_3[3] = *param_4 - fVar4;
    param_3[4] = param_4[1] - fVar5;
    param_3[5] = param_4[2] - fVar3;
    return;
  }
  return;
}


