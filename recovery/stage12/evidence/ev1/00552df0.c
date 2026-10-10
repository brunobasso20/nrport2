/* NR2003.exe @ 00552df0 FUN_00552df0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00552df0(void)

{
  bool bVar1;
  char cVar2;
  float10 fVar3;
  float local_14;
  float local_10;
  
  fVar3 = (float10)FUN_00552d00(5);
  local_14 = (float)fVar3;
  cVar2 = FUN_0057af60(5);
  if (cVar2 == '\0') {
    DAT_00bf6eba = 0;
  }
  else {
    DAT_00bf6eba = _DAT_006ea44c < local_14;
    fVar3 = (float10)FUN_00552d00(6);
    if (_DAT_00bf6390 < local_14 == (NAN(_DAT_00bf6390) || NAN(local_14))) {
      bVar1 = local_14 < _DAT_00bf6390;
      local_14 = _DAT_00bf6390;
      if (bVar1) {
        if ((float)fVar3 < _DAT_006ea44c == (NAN((float)fVar3) || NAN(_DAT_006ea44c))) {
          local_14 = _DAT_00bf6390 - _DAT_006ee4c4;
        }
        else {
          local_14 = _DAT_00bf6390 - _DAT_006ea508;
        }
      }
    }
    else {
      local_14 = _DAT_00bf6390 + _DAT_006ea4cc;
    }
    if (local_14 < _DAT_006ea454 == (NAN(local_14) || NAN(_DAT_006ea454))) {
      if (_DAT_006e97d8 < local_14) {
        local_14 = _DAT_006e97d8;
      }
    }
    else {
      local_14 = _DAT_006ea454;
    }
  }
  cVar2 = FUN_00550180();
  if (((cVar2 != '\0') && (DAT_0074c97c != 1)) &&
     (_DAT_00bf6390 < local_14 != (_DAT_00bf6390 == local_14))) {
    local_10 = (float)(_DAT_00bf513e & 0x7fffffff);
    if (local_10 < (float)(_DAT_00bf5b77 & 0x7fffffff)) {
      local_10 = (float)(_DAT_00bf5b77 & 0x7fffffff);
    }
    fVar3 = (float10)FUN_00554f50();
    if (fVar3 < (float10)_DAT_006ea4a4) {
      fVar3 = (float10)_DAT_006ea4a4;
    }
    if (fVar3 < (float10)_DAT_006f598c == (NAN(fVar3) || NAN((float10)_DAT_006f598c))) {
      if (fVar3 < (float10)_DAT_006f5988 != (NAN(fVar3) || NAN((float10)_DAT_006f5988))) {
        local_10 = (float)(((fVar3 - (float10)_DAT_006f598c) /
                           ((float10)_DAT_006f5988 - (float10)_DAT_006f598c)) * (float10)local_10);
      }
      fVar3 = (float10)FUN_00554f50();
      fVar3 = ((float10)_DAT_006f5988 - fVar3) / ((float10)_DAT_006f5988 - (float10)_DAT_006f598c);
      if (fVar3 < (float10)_DAT_006ea454 != (NAN(fVar3) || NAN((float10)_DAT_006ea454))) {
        fVar3 = (float10)_DAT_006ea454;
      }
      fVar3 = fVar3 * (float10)_DAT_006f5a10 + (float10)_DAT_006f5a0c;
      if ((float10)local_10 <= fVar3) {
        fVar3 = (fVar3 - (float10)local_10) / fVar3;
      }
      else {
        fVar3 = -(((float10)local_10 - fVar3) / ((float10)_DAT_006f5a08 - fVar3));
      }
      fVar3 = fVar3 * (float10)_DAT_006ee398 + (float10)_DAT_00bf6390;
      if (fVar3 < (float10)_DAT_006ef640 != (NAN(fVar3) || NAN((float10)_DAT_006ef640))) {
        fVar3 = (float10)_DAT_006ef640;
      }
    }
    else {
      fVar3 = (float10)_DAT_00bf6390 + (float10)_DAT_006e9824;
    }
    if (fVar3 <= (float10)local_14) {
      return fVar3;
    }
  }
  return (float10)local_14;
}

