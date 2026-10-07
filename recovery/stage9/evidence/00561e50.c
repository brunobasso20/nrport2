/* NR2003.exe @ 00561e50 recovered_00561e50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_00561e50(float **param_1)

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
  float **ppfVar10;
  char cVar11;
  float fVar12;
  float10 fVar13;
  float10 fVar14;
  float *pfStack_18;
  float *pfStack_14;
  float *pfStack_10;
  float fStack_8;
  float fStack_4;
  
  ppfVar10 = param_1;
  **param_1 = 0.0;
  *param_1[1] = 0.0;
  *param_1[2] = 0.0;
  *param_1[3] = 0.0;
  *param_1[4] = 0.0;
  *param_1[5] = 0.0;
  DAT_00c086ac = 0.0;
  if (((_DAT_006e97d8 < _DAT_00bf6f2c) && (0xf < DAT_00bf6f28)) ||
     (cVar11 = FUN_005501d0(), cVar11 != '\0')) {
    pfStack_10 = param_1[8];
    pfStack_14 = param_1[7];
    pfStack_18 = param_1[6];
    fVar1 = (float)pfStack_18 * (float)pfStack_18 +
            (float)pfStack_14 * (float)pfStack_14 + (float)pfStack_10 * (float)pfStack_10;
    FUN_005f6a70(&pfStack_18);
    if ((_DAT_006e97d8 < _DAT_00bf6f2c) && (0xf < DAT_00bf6f28)) {
      fVar2 = (_DAT_00bf6f2c - _DAT_006e97d8) * (float)(DAT_00bf6f28 + -0xf) * _DAT_006ed6e4;
      fStack_8 = fVar2 * (float)pfStack_14;
      fStack_4 = fVar2 * (float)pfStack_10;
      **param_1 = (float)pfStack_18 * fVar2 + **param_1;
      *param_1[1] = fStack_8 + *param_1[1];
      *param_1[2] = fStack_4 + *param_1[2];
    }
    cVar11 = FUN_005501d0();
    if ((cVar11 != '\0') &&
       (_DAT_0074decc * _DAT_0074decc < fVar1 != (NAN(_DAT_0074decc * _DAT_0074decc) || NAN(fVar1)))
       ) {
      fVar1 = SQRT(fVar1);
      fVar2 = _DAT_006e97d8;
      if ((fVar1 <= _DAT_0074ded4) && (fVar2 = _DAT_006ea454, _DAT_0074ded0 < fVar1)) {
        fVar2 = (fVar1 - _DAT_0074ded0) / (_DAT_0074ded4 - _DAT_0074ded0);
      }
      fVar12 = _DAT_006e97d8 - fVar2;
      param_1 = (float **)0x0;
      fVar9 = _DAT_0074dee4 * fVar2 + _DAT_0074dee0 * fVar12;
      fVar1 = _DAT_0074deec * fVar2 + _DAT_0074dee8 * fVar12;
      fVar8 = _DAT_0074dedc * fVar2 + _DAT_0074ded8 * fVar12;
      fVar7 = _DAT_00c086a8 * fVar2 + _DAT_00c086a4 * fVar12;
      fVar6 = _DAT_0074defc * fVar2 + _DAT_0074def8 * fVar12;
      fVar5 = _DAT_0074def4 * fVar2 + _DAT_0074def0 * fVar12;
      fVar4 = fVar12 * _DAT_0074df08;
      fVar3 = _DAT_0074df0c * fVar2;
      fVar14 = (float10)fpatan((float10)(float)pfStack_14,(float10)(float)pfStack_18);
      if (fVar14 < (float10)_DAT_006f59cc != (NAN(fVar14) || NAN((float10)_DAT_006f59cc))) {
        fVar14 = (float10)_DAT_006f4a48 - fVar14;
      }
      if ((float10)_DAT_006ee480 < fVar14) {
        fVar14 = (float10)_DAT_006f4a4c - fVar14;
      }
      if (fVar14 < -(float10)fVar8 == (NAN(fVar14) || NAN(-(float10)fVar8))) {
        if (((float10)fVar8 < fVar14) &&
           (fVar13 = (fVar14 - (float10)fVar8) * (float10)fVar9, param_1 = (float **)(float)fVar13,
           (float10)fVar1 < fVar13)) {
          param_1 = (float **)fVar1;
        }
      }
      else {
        param_1 = (float **)(float)(((float10)fVar8 + fVar14) * (float10)fVar9);
        fVar1 = -fVar1;
        if ((float)param_1 < fVar1 != (NAN((float)param_1) || NAN(fVar1))) {
          param_1 = (float **)fVar1;
        }
      }
      if (fVar14 < -(float10)fVar5 == (NAN(fVar14) || NAN(-(float10)fVar5))) {
        if ((float10)fVar5 < fVar14) {
          DAT_00c086ac = (float)((fVar14 - (float10)fVar5) * (float10)fVar7);
        }
      }
      else {
        DAT_00c086ac = (float)-((fVar14 + (float10)fVar5) * (float10)fVar7);
      }
      DAT_00c086ac = (float)((uint)param_1 & 0x7fffffff) *
                     (_DAT_0074df04 * fVar2 + _DAT_0074df00 * fVar12) + DAT_00c086ac;
      if (DAT_00c086ac < fVar6 != (NAN(DAT_00c086ac) || NAN(fVar6))) {
        DAT_00c086ac = fVar6;
      }
      fVar12 = (float)((uint)DAT_00c086ac & 0x7fffffff);
      fVar1 = DAT_00c086ac * (float)pfStack_14;
      fVar2 = DAT_00c086ac * (float)pfStack_10;
      **ppfVar10 = (float)pfStack_18 * DAT_00c086ac + **ppfVar10;
      *ppfVar10[1] = fVar1 + *ppfVar10[1];
      *ppfVar10[2] = fVar12 * (fVar3 + fVar4) + *ppfVar10[2] + fVar2;
      *ppfVar10[5] = (float)param_1 + *ppfVar10[5];
    }
  }
  return;
}

