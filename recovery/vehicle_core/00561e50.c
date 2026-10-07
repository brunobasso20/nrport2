/* Ghidra pseudo-C; NR2003.exe @ 00561e50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_00561e50(undefined4 *param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  undefined4 *puVar10;
  char cVar11;
  float fVar12;
  float10 fVar13;
  float10 fVar14;
  float fStack_18;
  float fStack_14;
  float fStack_10;
  float fStack_8;
  float fStack_4;
  
  puVar10 = param_1;
  *(undefined4 *)*param_1 = 0;
  *(undefined4 *)param_1[1] = 0;
  *(undefined4 *)param_1[2] = 0;
  *(undefined4 *)param_1[3] = 0;
  *(undefined4 *)param_1[4] = 0;
  *(undefined4 *)param_1[5] = 0;
  DAT_00c086ac = 0.0;
  if (((_DAT_006e97d8 < _DAT_00bf6f2c) && (0xf < DAT_00bf6f28)) ||
     (cVar11 = FUN_005501d0(), cVar11 != '\0')) {
    fStack_10 = (float)param_1[8];
    fStack_14 = (float)param_1[7];
    fStack_18 = (float)param_1[6];
    fVar12 = fStack_18 * fStack_18 + fStack_14 * fStack_14 + fStack_10 * fStack_10;
    FUN_005f6a70(&fStack_18);
    if ((_DAT_006e97d8 < _DAT_00bf6f2c) && (0xf < DAT_00bf6f28)) {
      fVar1 = (_DAT_00bf6f2c - _DAT_006e97d8) * (float)(DAT_00bf6f28 + -0xf) * _DAT_006ed6e4;
      fStack_8 = fVar1 * fStack_14;
      fStack_4 = fVar1 * fStack_10;
      *(float *)*param_1 = fStack_18 * fVar1 + *(float *)*param_1;
      *(float *)param_1[1] = fStack_8 + *(float *)param_1[1];
      *(float *)param_1[2] = fStack_4 + *(float *)param_1[2];
    }
    cVar11 = FUN_005501d0();
    if ((cVar11 != '\0') && (_DAT_0074decc * _DAT_0074decc < fVar12)) {
      fVar12 = SQRT(fVar12);
      fVar1 = _DAT_006e97d8;
      if ((fVar12 <= _DAT_0074ded4) && (fVar1 = _DAT_006ea454, _DAT_0074ded0 < fVar12)) {
        fVar1 = (fVar12 - _DAT_0074ded0) / (_DAT_0074ded4 - _DAT_0074ded0);
      }
      fVar12 = _DAT_006e97d8 - fVar1;
      param_1 = (undefined4 *)0x0;
      fVar9 = _DAT_0074dee4 * fVar1 + _DAT_0074dee0 * fVar12;
      fVar8 = _DAT_0074deec * fVar1 + _DAT_0074dee8 * fVar12;
      fVar7 = _DAT_0074dedc * fVar1 + _DAT_0074ded8 * fVar12;
      fVar6 = _DAT_00c086a8 * fVar1 + _DAT_00c086a4 * fVar12;
      fVar5 = _DAT_0074defc * fVar1 + _DAT_0074def8 * fVar12;
      fVar4 = _DAT_0074def4 * fVar1 + _DAT_0074def0 * fVar12;
      fVar3 = fVar12 * _DAT_0074df08;
      fVar2 = _DAT_0074df0c * fVar1;
      fVar14 = (float10)fpatan((float10)fStack_14,(float10)fStack_18);
      if (fVar14 < (float10)_DAT_006f59cc) {
        fVar14 = (float10)_DAT_006f4a48 - fVar14;
      }
      if ((float10)_DAT_006ee480 < fVar14) {
        fVar14 = (float10)_DAT_006f4a4c - fVar14;
      }
      if (-(float10)fVar7 <= fVar14) {
        if (((float10)fVar7 < fVar14) &&
           (fVar13 = (fVar14 - (float10)fVar7) * (float10)fVar9,
           param_1 = (undefined4 *)(float)fVar13, (float10)fVar8 < fVar13)) {
          param_1 = (undefined4 *)fVar8;
        }
      }
      else {
        param_1 = (undefined4 *)(float)(((float10)fVar7 + fVar14) * (float10)fVar9);
        if ((float)param_1 < -fVar8) {
          param_1 = (undefined4 *)-fVar8;
        }
      }
      if (-(float10)fVar4 <= fVar14) {
        if ((float10)fVar4 < fVar14) {
          DAT_00c086ac = (float)((fVar14 - (float10)fVar4) * (float10)fVar6);
        }
      }
      else {
        DAT_00c086ac = (float)-((fVar14 + (float10)fVar4) * (float10)fVar6);
      }
      DAT_00c086ac = ABS((float)param_1) * (_DAT_0074df04 * fVar1 + _DAT_0074df00 * fVar12) +
                     DAT_00c086ac;
      if (DAT_00c086ac < fVar5) {
        DAT_00c086ac = fVar5;
      }
      fVar12 = ABS(DAT_00c086ac);
      fStack_14 = DAT_00c086ac * fStack_14;
      fStack_10 = DAT_00c086ac * fStack_10;
      *(float *)*puVar10 = fStack_18 * DAT_00c086ac + *(float *)*puVar10;
      *(float *)puVar10[1] = fStack_14 + *(float *)puVar10[1];
      *(float *)puVar10[2] = fVar12 * (fVar2 + fVar3) + *(float *)puVar10[2] + fStack_10;
      *(float *)puVar10[5] = (float)param_1 + *(float *)puVar10[5];
    }
  }
  return;
}

