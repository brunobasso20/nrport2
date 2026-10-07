/* NR2003.exe @ 00553080 FUN_00553080 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00553080(void)

{
  float fVar1;
  char cVar2;
  int iVar3;
  float10 fVar4;
  float10 fVar5;
  float local_2c;
  uint local_28;
  float local_24;
  float local_20;
  float local_1c;
  float local_14;
  undefined4 local_10;
  undefined4 local_c;
  undefined4 local_8;
  undefined4 local_4;
  
  iVar3 = FUN_005c2d20(DAT_00c08194);
  if (iVar3 == 1) {
    iVar3 = FUN_00509b60(0xffffffff);
  }
  else {
    iVar3 = thunk_FUN_0055a730();
  }
  if (iVar3 == 1) {
    local_2c = 1.0;
  }
  else {
    fVar4 = (float10)FUN_00552d00(6);
    local_2c = (float)fVar4;
  }
  fVar4 = (float10)FUN_00554f50();
  if ((fVar4 < (float10)_DAT_006efb28 == (NAN(fVar4) || NAN((float10)_DAT_006efb28))) ||
     ((_DAT_00bf6390 < _DAT_006e9824 == (NAN(_DAT_00bf6390) || NAN(_DAT_006e9824)) &&
      (DAT_0074c97c != 1)))) goto LAB_0055327b;
  local_10 = DAT_00bf6d58;
  local_c = DAT_00bf6d5c;
  local_8 = DAT_00bf6d60;
  local_4 = DAT_00bf6d64;
  FUN_005f7570(&local_20,&local_24,&local_28,&local_10);
  if ((float)((uint)local_24 & 0x7fffffff) < _DAT_006f5a30 !=
      (NAN((float)((uint)local_24 & 0x7fffffff)) || NAN(_DAT_006f5a30))) {
    fVar4 = (float10)local_2c;
    if (fVar4 < (float10)_DAT_006efac8 == (NAN(fVar4) || NAN((float10)_DAT_006efac8))) {
      return fVar4;
    }
    fVar4 = (float10)_DAT_00bf6eac + (float10)_DAT_006f53c0;
    if (fVar4 < (float10)_DAT_006efac8 != (fVar4 == (float10)_DAT_006efac8)) {
      return fVar4;
    }
    return (float10)_DAT_006efac8;
  }
  local_1c = (float)(local_28 & 0x7fffffff);
  if (local_1c <= _DAT_006ea454) {
LAB_0055323f:
    local_20 = 0.2;
  }
  else {
    local_1c = (float)((uint)local_24 & 0x7fffffff);
    local_14 = (float)(local_28 & 0x7fffffff);
    fVar1 = (local_1c * (float)_DAT_006f5a28) / local_14;
    if (_DAT_006e97d8 < fVar1) {
      fVar1 = _DAT_006e97d8;
    }
    local_20 = (_DAT_006e97d8 - fVar1) * _DAT_006efac8;
    if (local_20 < _DAT_006e9824 != (NAN(local_20) || NAN(_DAT_006e9824))) goto LAB_0055323f;
  }
  if (local_2c < local_20 != (NAN(local_2c) || NAN(local_20))) {
    fVar4 = (float10)_DAT_00bf6eac + (float10)_DAT_006f53c0;
    if (fVar4 < (float10)local_20 != (fVar4 == (float10)local_20)) {
      return fVar4;
    }
    return (float10)local_20;
  }
LAB_0055327b:
  cVar2 = FUN_0057af60(6);
  if (cVar2 != '\0') {
    fVar4 = (float10)FUN_00552d00(5);
    local_14 = (float)fVar4;
    if (_DAT_00bf6eac < local_2c == (NAN(_DAT_00bf6eac) || NAN(local_2c))) {
      fVar1 = local_2c;
      if (local_2c < _DAT_00bf6eac) {
        if (local_14 < _DAT_006ea44c == (NAN(local_14) || NAN(_DAT_006ea44c))) {
          fVar1 = _DAT_00bf6eac - _DAT_006f4614;
        }
        else {
          fVar1 = _DAT_00bf6eac - _DAT_006f5a24;
        }
      }
    }
    else {
      fVar1 = _DAT_00bf6eac + _DAT_006f53c0;
    }
    local_2c = _DAT_006ea454;
    if ((fVar1 < _DAT_006ea454 == (NAN(fVar1) || NAN(_DAT_006ea454))) &&
       (local_2c = fVar1, _DAT_006e97d8 < fVar1)) {
      local_2c = _DAT_006e97d8;
    }
  }
  cVar2 = FUN_00550130();
  if ((cVar2 != '\0') && (_DAT_00bf6eac < local_2c != (_DAT_00bf6eac == local_2c))) {
    fVar4 = (float10)FUN_00554f50();
    if (fVar4 <= (float10)_DAT_006ea68c) {
      return (float10)local_2c * (float10)_DAT_006ed020;
    }
    local_24 = DAT_00bf3cd4;
    local_20 = DAT_00bf5146;
    if (DAT_00bf3cd4 < DAT_00bf470d) {
      local_24 = DAT_00bf470d;
    }
    if (DAT_00bf5146 < DAT_00bf5b7f) {
      local_20 = DAT_00bf5b7f;
    }
    fVar1 = DAT_00bf3cd4;
    if ((DAT_00bf470d < DAT_00bf3cd4 != (NAN(DAT_00bf470d) || NAN(DAT_00bf3cd4))) &&
       ((NAN(DAT_00bf470d) || NAN(_DAT_006ea454)) == (DAT_00bf470d == _DAT_006ea454))) {
      fVar1 = DAT_00bf470d;
    }
    if ((DAT_00bf5146 < fVar1 != (NAN(DAT_00bf5146) || NAN(fVar1))) &&
       ((NAN(DAT_00bf5146) || NAN(_DAT_006ea454)) == (DAT_00bf5146 == _DAT_006ea454))) {
      fVar1 = DAT_00bf5146;
    }
    if ((DAT_00bf5b7f < fVar1 != (NAN(DAT_00bf5b7f) || NAN(fVar1))) &&
       ((NAN(DAT_00bf5b7f) || NAN(_DAT_006ea454)) == (DAT_00bf5b7f == _DAT_006ea454))) {
      fVar1 = DAT_00bf5b7f;
    }
    if (fVar1 <= _DAT_006efbf0) {
      fVar5 = ((float10)local_20 - (float10)_DAT_006ea494) * (float10)_DAT_006f5a20;
      fVar1 = (local_24 - _DAT_006f5a1c) * _DAT_006f5a18;
      fVar4 = (float10)fVar1;
      if (fVar5 < fVar4 == (NAN(fVar5) || NAN(fVar4))) {
        fVar5 = (float10)fVar1;
      }
      if ((float10)_DAT_006ea454 <= fVar5) {
        fVar5 = ((float10)_DAT_006ea494 - (float10)local_20) * (float10)_DAT_006f5a14;
      }
      fVar4 = fVar5 * (float10)_DAT_006f4614 + (float10)_DAT_00bf6eac;
      if (fVar4 < (float10)_DAT_006ef640 != (NAN(fVar4) || NAN((float10)_DAT_006ef640))) {
        fVar4 = (float10)_DAT_006ef640;
      }
      if (fVar4 <= (float10)local_2c) {
        return fVar4;
      }
    }
  }
  return (float10)local_2c;
}

