/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005539c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005539c0(void)

{
  char cVar1;
  int iVar2;
  int iVar3;
  float10 fVar4;
  float local_58;
  float local_54;
  float local_50;
  undefined4 local_4c;
  undefined4 local_48;
  undefined4 local_44;
  undefined1 local_40 [4];
  undefined1 local_3c [4];
  undefined1 local_38 [4];
  undefined1 local_34 [4];
  undefined1 local_30 [4];
  undefined1 local_2c [4];
  undefined1 local_28 [4];
  undefined1 local_24 [36];
  
  DAT_00bf63d8 = '\0';
  cVar1 = FUN_005b0540();
  if ((((cVar1 != '\0') && (cVar1 = FUN_005b0550(), cVar1 != '\0')) &&
      (cVar1 = FUN_005b08d0(), cVar1 != '\0')) && (cVar1 = FUN_005b08e0(), cVar1 != '\0')) {
    cVar1 = FUN_005b08f0();
    if (cVar1 == '\0') {
      iVar2 = FUN_00555140();
      iVar3 = FUN_005b2180();
      if (iVar3 != iVar2 + -1) goto LAB_00553a21;
    }
    cVar1 = FUN_005b0950();
    if (cVar1 == '\0') {
      FUN_005b0580();
    }
    else {
      DAT_00bf63d8 = '\x01';
    }
  }
LAB_00553a21:
  cVar1 = FUN_00551880();
  if (cVar1 != '\0') {
    _DAT_00bf6ef8 = (double)(_DAT_0074fd74 + (float)_DAT_00bf6ef8);
    DAT_00bf6ea4 = _DAT_00bf6394 + DAT_00bf6ea4;
    _DAT_00bf63c0 = _DAT_00bf6e88 + _DAT_00bf63c0;
    FUN_00554d30();
    DAT_00bf6360 = _DAT_00bf63c0 - DAT_00c086b0;
    DAT_00bf6368 = DAT_00bf6ea4;
    _DAT_00bf6364 = _DAT_00c086b4 + _DAT_00bf63c0;
    DAT_00bf636c = DAT_00bf636c + _DAT_00bf6358;
    DAT_00bf6370 = _DAT_00bf6e50 + _DAT_00bf6e14;
    _DAT_00bf6e14 = DAT_00bf6370;
    FUN_00553d70();
    _DAT_00bf6374 = (float)DAT_0074c97c;
    iVar2 = FUN_0051a000();
    local_58 = *(float *)(iVar2 + 0x438);
    fVar4 = (float10)FUN_00554f10();
    local_54 = (float)fVar4;
    if (((float10)local_58 < fVar4) ||
       ((local_50 = local_58 * _DAT_006f5a3c, local_58 - local_50 < local_54 &&
        (DAT_00bf6f3c != '\0')))) {
      DAT_00bf6368 = 0.0;
      DAT_00bf6f3c = '\x01';
    }
    else {
      iVar2 = FUN_0051a000();
      if (local_54 <= *(float *)(iVar2 + 0x438) - local_50) {
        DAT_00bf6f3c = '\0';
      }
    }
    if (DAT_00bf63d8 != '\0') {
      DAT_00bf6f40 = FUN_0051370a(&local_50,local_28,local_2c,local_30,local_34,local_38,&local_54,
                                  &local_58,&local_4c,&local_48,&local_44,local_3c,local_40,
                                  **(undefined4 **)(DAT_00bf6e1c + 0x2cd),
                                  **(undefined4 **)(DAT_00bf6e1c + 0x2d1),
                                  **(undefined4 **)(DAT_00bf6e1c + 0x2d9),DAT_00bf6f40);
      fVar4 = (float10)FUN_00516e1a();
      _DAT_00bf63f6 = (float)((float10)local_50 / fVar4);
      if ((float10)local_50 / fVar4 <= (float10)_DAT_006e97d8) {
        if (_DAT_00bf63f6 < _DAT_006ea454) {
          _DAT_00bf63f6 = _DAT_00bf63f6 + _DAT_006e97d8;
        }
      }
      else {
        _DAT_00bf63f6 = _DAT_00bf63f6 - _DAT_006e97d8;
      }
      _DAT_00bf63fa = DAT_00bf6d40;
      _DAT_00bf63fe = DAT_00bf6d48;
      _DAT_00bf6406 = DAT_00bf6d44;
      _DAT_00bf6402 = DAT_00bf6d50;
      _DAT_00bf640a = DAT_00bf6d4c;
      _DAT_00bf640e = DAT_00bf6d54;
      FUN_005f6e40(local_24,&DAT_00bf6d58);
      FUN_005f74c0(&DAT_00bf6412,&DAT_00bf6416,&DAT_00bf641a,local_24);
      _DAT_00bf641e = DAT_00bf6d68;
      _DAT_00bf6422 = DAT_00bf6d6c;
      _DAT_00bf6426 = DAT_00bf6d70;
      _DAT_00bf642a = local_54;
      _DAT_00bf643e = _DAT_00bf6ed0 * _DAT_006f5a38;
      _DAT_00bf642e = local_58;
      _DAT_00bf6432 = local_4c;
      _DAT_00bf6436 = local_48;
      _DAT_00bf643a = local_44;
      _DAT_00bf64ce = DAT_00bf6368;
      _DAT_00bf64d2 = DAT_00bf636c;
      _DAT_00bf64d6 = DAT_00bf6370;
      _DAT_00bf64da = DAT_00bf6360;
      _DAT_00bf64de = FUN_006c5018();
      _DAT_00bf64de = _DAT_00bf64de + -1;
    }
    FUN_005b2b90(DAT_00bf6e1c,&DAT_00bf6360);
    FUN_005b2cb0(&DAT_00bf6d40,DAT_00bf6e1c);
    FUN_005543f0();
    FUN_00551480();
    return;
  }
  return;
}


