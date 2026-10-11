/* NR2003.exe @ 00593510 FUN_00593510 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00593510(char param_1)

{
  int iVar1;
  float10 fVar2;
  
  DAT_00d8c320 = DAT_00d8c320 + 1 & 0x80000003;
  if ((int)DAT_00d8c320 < 0) {
    DAT_00d8c320 = (DAT_00d8c320 - 1 | 0xfffffffc) + 1;
  }
  if (param_1 != '\0') {
    FUN_00593650(1);
    FUN_00593990(0,1);
    return;
  }
  if (DAT_00d8c325 == '\0') {
    iVar1 = FUN_00538b30();
    if ((*(byte *)(iVar1 + 0x2c) & 4) != 0) {
      DAT_00d8c325 = '\x01';
      _DAT_00750988 = 1.0;
      goto LAB_00593560;
    }
    if (DAT_00d8c325 == '\0') goto LAB_00593560;
  }
  if (_DAT_00750988 <= _DAT_006ea454) {
    return;
  }
  _DAT_00750988 = _DAT_00750988 - _DAT_006ea48c;
  if (_DAT_00750988 < _DAT_006ea454 != (NAN(_DAT_00750988) || NAN(_DAT_006ea454))) {
    FUN_00593470();
    FUN_00593a20();
    return;
  }
LAB_00593560:
  FUN_00593650(0);
  _param_1 = 0.0;
  iVar1 = FUN_00567280();
  if (iVar1 == 7) {
    fVar2 = (float10)FUN_00593a00();
    _param_1 = (float)fVar2;
    FUN_00593990(_param_1,0);
  }
  if (((NAN(_param_1) || NAN(_DAT_00d8c310)) == (_param_1 == _DAT_00d8c310)) &&
     ((_DAT_00d8c310 = _param_1, DAT_00d8c320 == 1 ||
      (_param_1 < (float)_DAT_006ef6d8 != (NAN(_param_1) || NAN((float)_DAT_006ef6d8)))))) {
    FUN_00593a20();
    return;
  }
  return;
}

