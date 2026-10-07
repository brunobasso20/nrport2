/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f7200 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_004f7200(int *param_1)

{
  float fVar1;
  float fVar2;
  int iVar3;
  double dVar4;
  float local_8;
  
  iVar3 = taskGetRate();
  fVar1 = _DAT_006e97d8 / (float)iVar3;
  fVar2 = (float)param_1[0x56] - fVar1;
  param_1[0x56] = (int)fVar2;
  if (fVar2 < _DAT_006ea454 != (fVar2 == _DAT_006ea454)) {
    dVar4 = rndNormal(0);
    param_1[0x54] = (int)((float)dVar4 * (float)param_1[0x52] + (float)param_1[0x53]);
    dVar4 = rndUniform(0);
    param_1[0x56] = (int)((float)dVar4 * _DAT_006e9804 + _DAT_006e97d8);
  }
  fVar2 = ((float)param_1[0x54] - (float)param_1[0x55]) * fVar1 * _DAT_006f3e2c +
          (float)param_1[0x55];
  param_1[0x55] = (int)fVar2;
  param_1[0x4f] = (int)(fVar2 * (float)param_1[0x67]);
  fVar2 = (float)param_1[0x57] - fVar1;
  param_1[0x57] = (int)fVar2;
  if (fVar2 < _DAT_006ea454 != (fVar2 == _DAT_006ea454)) {
    dVar4 = rndNormal(0);
    param_1[0x5e] = (int)((float)dVar4 * (float)param_1[0x5b]);
    dVar4 = rndUniform(0);
    param_1[0x57] = (int)((float)dVar4 * _DAT_006e9804 + _DAT_006e97d8);
  }
  param_1[0x62] =
       (int)(((float)param_1[0x5e] - (float)param_1[0x62]) * fVar1 * _DAT_006f3e2c +
            (float)param_1[0x62]);
  fVar2 = (float)param_1[0x58] - fVar1;
  param_1[0x58] = (int)fVar2;
  if (fVar2 < _DAT_006ea454 != (fVar2 == _DAT_006ea454)) {
    dVar4 = rndNormal(0);
    param_1[0x5f] = (int)((float)dVar4 * (float)param_1[0x5c]);
    dVar4 = rndUniform(0);
    param_1[0x58] = (int)((float)dVar4 * _DAT_006e9804 + _DAT_006e97d8);
  }
  param_1[99] = (int)(((float)param_1[0x5f] - (float)param_1[99]) * fVar1 * _DAT_006f3e2c +
                     (float)param_1[99]);
  local_8 = ABS(*(float *)(*param_1 + 0x1872)) * _DAT_006f3e28;
  if (_DAT_006e97d8 < local_8) {
    local_8 = 1.0;
  }
  fVar2 = (float)param_1[0x59] - fVar1;
  param_1[0x59] = (int)fVar2;
  if (fVar2 < _DAT_006ea454 != (fVar2 == _DAT_006ea454)) {
    dVar4 = rndNormal(0);
    param_1[0x60] = (int)(ABS((float)dVar4) * (float)param_1[0x5d]);
    dVar4 = rndUniform(0);
    param_1[0x59] = (int)((float)dVar4 * _DAT_006e9804 + _DAT_006e97d8);
  }
  param_1[100] = (int)((local_8 * (float)param_1[0x60] - (float)param_1[100]) * fVar1 *
                       _DAT_006f3e2c + (float)param_1[100]);
  fVar2 = (float)param_1[0x5a] - fVar1;
  param_1[0x5a] = (int)fVar2;
  if (fVar2 < _DAT_006ea454 != (fVar2 == _DAT_006ea454)) {
    dVar4 = rndNormal(0);
    param_1[0x61] = (int)(ABS((float)dVar4) * (float)param_1[0x5d]);
    dVar4 = rndUniform(0);
    param_1[0x5a] = (int)((float)dVar4 * _DAT_006e9804 + _DAT_006e97d8);
  }
  param_1[0x65] =
       (int)((local_8 * (float)param_1[0x61] - (float)param_1[0x65]) * fVar1 * _DAT_006f3e2c +
            (float)param_1[0x65]);
  return;
}


