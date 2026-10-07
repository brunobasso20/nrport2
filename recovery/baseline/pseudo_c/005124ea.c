/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005124ea */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

ushort FUN_005124ea(float param_1,float param_2,float param_3,float param_4,float param_5,
                   float param_6,float param_7,float param_8)

{
  float fVar1;
  float fVar2;
  
  fVar1 = param_3 * param_8 - param_4 * param_7;
  if (fVar1 == _DAT_006ea454) {
    return (ushort)(fVar1 < _DAT_006ea454) << 8 | (ushort)(NAN(fVar1) || NAN(_DAT_006ea454)) << 10 |
           (ushort)(fVar1 == _DAT_006ea454) << 0xe;
  }
  fVar2 = ((param_2 - param_6) * param_7 - (param_1 - param_5) * param_8) * (_DAT_006e97d8 / fVar1);
  fVar1 = ((param_2 - param_6) * param_3 - (param_1 - param_5) * param_4) * (_DAT_006e97d8 / fVar1);
  if ((((_DAT_006ea454 <= fVar2) && (fVar2 < _DAT_006e97d8 != (fVar2 == _DAT_006e97d8))) &&
      (_DAT_006ea454 <= fVar1)) && (fVar1 < _DAT_006e97d8 != (fVar1 == _DAT_006e97d8))) {
    return 1;
  }
  return 0;
}


