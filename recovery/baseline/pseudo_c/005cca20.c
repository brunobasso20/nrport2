/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005cca20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005cca20(void)

{
  undefined2 uVar1;
  int iVar2;
  undefined2 extraout_var;
  undefined2 extraout_var_00;
  
  DAT_00f5bbe0 = FUN_005c6b20();
  if ((0 < DAT_00f5bbd8) && (DAT_00f5bbd8 < 0x10000)) {
    DAT_00f5bbe0 = (undefined2)DAT_00f5bbd8;
  }
  DAT_00f5bbdc = 0;
  if (DAT_00f5bb58 != '\0') {
    iVar2 = FUN_005c8050(&DAT_00f5bbdc,&DAT_00f5bb58,0);
    uVar1 = extraout_var;
    if (iVar2 == 0) {
      iVar2 = FUN_005c8120(&DAT_00f5bbdc,&DAT_00f5bb58);
      uVar1 = extraout_var_00;
      if (iVar2 == 0) goto LAB_005ccac5;
    }
    _DAT_00f5a374 = 0;
    _DAT_00f5a370 = 2;
    _DAT_00f5a378 = 0;
    _DAT_00f5a37c = 0;
    uVar1 = FUN_006c37ca(CONCAT22(uVar1,DAT_00f5bbe0));
    _DAT_00f5a370 = CONCAT22(uVar1,_DAT_00f5a370);
    _DAT_00f5a374 = FUN_006c37d6(DAT_00f5bbdc);
  }
LAB_005ccac5:
  _DAT_00753b54 = _DAT_00753b5c;
  if (_DAT_00753b5c < _DAT_006e9804) {
    _DAT_00753b54 = 4.0;
  }
  DAT_00f5bb40 = 1;
  _DAT_00753b58 = DAT_00f5bb50;
  if ((_DAT_006ea454 < DAT_00f5bb50) && (DAT_00f5bb50 < _DAT_006ea478)) {
    _DAT_00753b58 = 10.0;
  }
  return;
}


