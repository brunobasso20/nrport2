/* NR2003.exe @ 005500c0 recovered_005500c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_005500c0(int param_1,float param_2)

{
  param_2 = param_2 * _DAT_006ea4a4;
  if ((NAN(param_2) || NAN(_DAT_006ea454)) != (param_2 == _DAT_006ea454)) {
    (&DAT_0074c990)[param_1] = _DAT_006e97d8;
    return;
  }
  (&DAT_0074c990)[param_1] = (_DAT_006e97d8 / param_2) * (float)_DAT_006f59c0;
  return;
}

