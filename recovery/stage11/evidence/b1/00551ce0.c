/* NR2003.exe @ 00551ce0 FUN_00551ce0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00551ce0(void)

{
  float fVar1;
  float local_1c;
  float local_18;
  undefined4 local_14;
  undefined4 local_10;
  undefined4 local_c;
  undefined4 local_8;
  undefined4 local_4;
  
  local_10 = DAT_00bf6d58;
  local_c = DAT_00bf6d5c;
  local_8 = DAT_00bf6d60;
  local_4 = DAT_00bf6d64;
  FUN_005f7570(&local_14,&local_18,&local_1c,&local_10);
  fVar1 = (local_1c * local_1c + local_18 * local_18) * _DAT_006f59d0;
  if (_DAT_006efb28 < fVar1) {
    fVar1 = _DAT_006efb28;
  }
  DAT_00bf6ea8 = (local_18 - DAT_00bf6ea8) * (fVar1 + _DAT_006ea4cc) + DAT_00bf6ea8;
  if (local_1c < _DAT_006f59cc == (NAN(local_1c) || NAN(_DAT_006f59cc))) {
    if ((_DAT_006ee480 < local_1c) &&
       (DAT_00bf6384 < _DAT_006f59cc != (NAN(DAT_00bf6384) || NAN(_DAT_006f59cc)))) {
      do {
        DAT_00bf6384 = DAT_00bf6384 + _DAT_006ee484;
      } while (DAT_00bf6384 < _DAT_006f59cc != (NAN(DAT_00bf6384) || NAN(_DAT_006f59cc)));
    }
  }
  else {
    for (; _DAT_006ee480 < DAT_00bf6384; DAT_00bf6384 = DAT_00bf6384 - _DAT_006ee484) {
    }
  }
  DAT_00bf6398 = local_14;
  DAT_00bf6384 = (local_1c - DAT_00bf6384) * (fVar1 + _DAT_006ea4cc) + DAT_00bf6384;
  return;
}

