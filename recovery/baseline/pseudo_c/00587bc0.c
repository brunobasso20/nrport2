/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00587bc0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00587bc0(float param_1)

{
  float fVar1;
  float fVar2;
  float10 fVar3;
  float10 fVar4;
  
  DAT_0075018c = param_1;
  fVar3 = (float10)FUN_005170aa();
  fVar1 = _DAT_006f696c + _DAT_006f696c;
  if (fVar3 < (float10)fVar1) {
    fVar3 = (float10)fVar1;
  }
  if ((float10)(_DAT_006f6974 + _DAT_006f696c) < fVar3) {
    fVar3 = (float10)(_DAT_006f6974 + _DAT_006f696c);
  }
  fVar2 = _DAT_006f696c * _DAT_006ea44c;
  fVar4 = (fVar3 - (float10)fVar1) * (float10)_DAT_006ea4cc + (float10)fVar2;
  if (fVar4 < (float10)fVar2) {
    fVar4 = (float10)fVar2;
  }
  if ((float10)_DAT_006f696c < fVar4) {
    fVar4 = (float10)_DAT_006f696c;
  }
  _DAT_00750184 = (float)((fVar3 - fVar4) * (float10)param_1 + fVar4);
  return;
}


