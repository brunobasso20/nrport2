/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00556e30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00556e30(int param_1,int param_2,int param_3,float param_4,float param_5,float param_6)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  
  *(int *)(param_1 + 0x120b + param_2 * 4) = param_3;
  if (((float)(&DAT_00c014f0)[param_3] < (float)(&DAT_0074ca2c)[param_3]) &&
     (*(float *)(&DAT_00c014e0 + param_3 * 4) < (float)(&DAT_0074ca1c)[param_3])) {
    switch(param_3) {
    case 0:
      break;
    case 1:
      fVar3 = ((param_5 - *(float *)(&DAT_00c014e0 + param_3 * 4)) /
              ((float)(&DAT_0074ca1c)[param_3] - *(float *)(&DAT_00c014e0 + param_3 * 4))) *
              _DAT_0074ca04;
      fVar2 = _DAT_006e97d8;
      if ((fVar3 <= _DAT_006e97d8) && (fVar2 = fVar3, fVar3 < _DAT_006ea454)) {
        fVar2 = _DAT_006ea454;
      }
      fVar3 = fVar2 * param_5 + (_DAT_006e97d8 - fVar2) * param_4;
      if ((float)(&DAT_00c014f0)[param_3] < fVar3) {
        fVar3 = (fVar3 - (float)(&DAT_00c014f0)[param_3]) /
                ((float)(&DAT_0074ca2c)[param_3] - (float)(&DAT_00c014f0)[param_3]);
        *(float *)(param_1 + 0x11cb + param_2 * 4) = fVar3;
        if (_DAT_006e97d8 < fVar3) {
          *(undefined4 *)(param_1 + 0x11cb + param_2 * 4) = 0x3f800000;
        }
        fVar3 = _DAT_006e97d8;
        *(float *)(param_1 + 0x11eb + param_2 * 4) = fVar2;
        if (fVar2 <= fVar3) {
          if (fVar2 < _DAT_006ea454) {
            *(undefined4 *)(param_1 + 0x11eb + param_2 * 4) = 0;
          }
        }
        else {
          *(undefined4 *)(param_1 + 0x11eb + param_2 * 4) = 0x3f800000;
        }
        fVar3 = _DAT_006e97d8;
        if (param_6 <= DAT_0074ca80) {
          *(undefined4 *)(param_1 + 0x11db + param_2 * 4) = 0x3f800000;
          return;
        }
        if (DAT_0074ca84 < param_6) {
          *(undefined4 *)(param_1 + 0x11db + param_2 * 4) = (&DAT_0074ca3c)[param_3];
          return;
        }
        pfVar1 = (float *)(param_1 + 0x11db + param_2 * 4);
        fVar2 = _DAT_006e97d8 - (param_6 - DAT_0074ca80) / (DAT_0074ca84 - DAT_0074ca80);
        fVar2 = fVar2 * fVar2 * fVar2;
        *pfVar1 = fVar2;
        if (fVar2 <= fVar3) {
          if ((float)(&DAT_0074ca3c)[param_3] <= fVar2) {
            return;
          }
          *pfVar1 = (float)(&DAT_0074ca3c)[param_3];
          return;
        }
        *pfVar1 = 1.0;
        return;
      }
      break;
    case 2:
    case 3:
    case 4:
      fVar3 = _DAT_006e97d8;
      if (((((float)_DAT_006ef6d8 <= param_4) &&
           (param_5 / param_4 <= (float)(&DAT_0074ca1c)[param_3])) &&
          (fVar2 = (param_5 / param_4) / (float)(&DAT_0074ca1c)[param_3], fVar2 <= _DAT_006e97d8))
         && (fVar3 = fVar2, fVar2 < _DAT_006ea454)) {
        fVar3 = _DAT_006ea454;
      }
      fVar4 = fVar3 * param_5 + (_DAT_006e97d8 - fVar3) * param_4;
      fVar2 = (float)(&DAT_0074ca5c)[param_3];
      if ((_DAT_006e97d8 <= fVar2) && ((float)(&DAT_00c014f0)[param_3] < fVar4)) {
        fVar4 = (fVar4 - (float)(&DAT_00c014f0)[param_3]) /
                ((float)(&DAT_0074ca2c)[param_3] - (float)(&DAT_00c014f0)[param_3]);
        *(float *)(param_1 + 0x11cb + param_2 * 4) = fVar4;
        if (_DAT_006e97d8 < fVar4) {
          *(undefined4 *)(param_1 + 0x11cb + param_2 * 4) = 0x3f800000;
        }
        fVar4 = _DAT_006e97d8;
        *(float *)(param_1 + 0x11eb + param_2 * 4) = fVar3;
        if (fVar3 <= fVar4) {
          if (fVar3 < _DAT_006ea454) {
            *(undefined4 *)(param_1 + 0x11eb + param_2 * 4) = 0;
          }
        }
        else {
          *(undefined4 *)(param_1 + 0x11eb + param_2 * 4) = 0x3f800000;
        }
        fVar3 = *(float *)(*(int *)(param_1 + 0x5ae) + 0x44);
        fVar4 = *(float *)(*(int *)(param_1 + 0x5ae) + 0x48);
        fVar3 = (SQRT(fVar3 * fVar3 + fVar4 * fVar4) / fVar2 - _DAT_006e97d8) *
                (float)(&DAT_0074ca6c)[param_3] + _DAT_006e97d8;
        if ((float)(&DAT_0074ca4c)[param_3] < fVar3) {
          *(undefined4 *)(param_1 + 0x11db + param_2 * 4) = (&DAT_0074ca4c)[param_3];
          return;
        }
        if (fVar3 < (float)(&DAT_0074ca3c)[param_3]) {
          fVar3 = (float)(&DAT_0074ca3c)[param_3];
        }
        *(float *)(param_1 + 0x11db + param_2 * 4) = fVar3;
        return;
      }
      break;
    default:
      goto switchD_00556e83_caseD_5;
    }
  }
  *(undefined4 *)(param_1 + 0x11cb + param_2 * 4) = 0;
switchD_00556e83_caseD_5:
  return;
}


