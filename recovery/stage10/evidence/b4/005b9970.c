/* NR2003.exe @ 005b9970 FUN_005b9970 */

float * FUN_005b9970(float param_1)

{
  float *pfVar1;
  
  pfVar1 = (float *)((int)DAT_00ec02c4 + -4);
  while( true ) {
    if (pfVar1 < (float *)0xebf611) {
      DAT_00ec02c4 = (float *)((int)DAT_00ec02c4 + 4);
      *DAT_00ec02c4 = param_1;
      return DAT_00ec02c4;
    }
    if ((NAN(*pfVar1) || NAN(param_1)) != (*pfVar1 == param_1)) break;
    pfVar1 = pfVar1 + -1;
  }
  return pfVar1;
}

