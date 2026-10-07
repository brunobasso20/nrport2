/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f7b30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* void __cdecl taskSetRateAdjust(float) */

void __cdecl taskSetRateAdjust(float param_1)

{
                    /* 0x1f7b30  283  ?taskSetRateAdjust@@YAXM@Z */
  if (DAT_00f72154 == '\0') {
    DAT_00f72154 = '\x01';
    if (_DAT_006ea508 <= _DAT_007559a0) {
      if (_DAT_006ea44c < _DAT_007559a0) {
        _DAT_007559a0 = 0.5;
      }
    }
    else {
      _DAT_007559a0 = 0.05;
    }
  }
  if (_DAT_007559a0 + _DAT_006e97d8 < param_1) {
    param_1 = _DAT_007559a0 + _DAT_006e97d8;
  }
  if (_DAT_006e97d8 - _DAT_007559a0 <= param_1) {
    _DAT_007559b8 = param_1;
    return;
  }
  _DAT_007559b8 = _DAT_006e97d8 - _DAT_007559a0;
  return;
}


