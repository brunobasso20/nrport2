/* NR2003.exe @ 00552d00 FUN_00552d00 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00552d00(undefined4 param_1)

{
  float fVar1;
  int iVar2;
  int iVar3;
  float10 fVar4;
  
  fVar4 = (float10)FUN_0057af30(param_1);
  fVar1 = (float)fVar4;
  switch(param_1) {
  case 5:
    iVar2 = 2;
    iVar3 = 1;
    break;
  case 6:
    iVar2 = 3;
    iVar3 = 2;
    break;
  case 7:
    iVar2 = 0;
    iVar3 = 0;
    break;
  case 8:
    iVar2 = 1;
    iVar3 = 0;
    break;
  default:
    return fVar4;
  }
  if (_DAT_006e97d8 <= (float)(&DAT_0074c990)[iVar3]) {
    return fVar4;
  }
  fVar4 = (float10)(float)(&DAT_0074c990)[iVar3];
  if (fVar1 < _DAT_006ee390 != (NAN(fVar1) || NAN(_DAT_006ee390))) {
    fVar4 = fVar4 * (float10)_DAT_0074c99c;
  }
  if (fVar1 <= *(float *)(&DAT_00bf639c + iVar2 * 4)) {
    fVar4 = (float10)*(float *)(&DAT_00bf639c + iVar2 * 4) - fVar4;
    if (fVar4 < (float10)fVar1 == (NAN(fVar4) || NAN((float10)fVar1))) goto LAB_00552dc3;
  }
  else {
    fVar4 = fVar4 + (float10)*(float *)(&DAT_00bf639c + iVar2 * 4);
    if (fVar4 <= (float10)fVar1) goto LAB_00552dc3;
  }
  fVar4 = (float10)fVar1;
LAB_00552dc3:
  *(float *)(&DAT_00bf639c + iVar2 * 4) = (float)fVar4;
  if (iVar3 == 0) {
    fVar4 = (float10)fsin(fVar4 * (float10)_DAT_006f5a00);
  }
  return fVar4;
}

