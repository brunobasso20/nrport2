/* NR2003.exe @ 00567d10 FUN_00567d10 */

void __fastcall FUN_00567d10(undefined4 param_1)

{
  float fVar1;
  float10 fVar2;
  float fVar3;
  
  fVar2 = (float10)FUN_00411850(param_1);
  fVar1 = (float)fVar2;
  fVar3 = DAT_00c5736c;
  if ((fVar2 <= (float10)DAT_00c5736c) &&
     (fVar3 = fVar1, fVar1 < DAT_00c5c27c != (NAN(fVar1) || NAN(DAT_00c5c27c)))) {
    fVar3 = DAT_00c5c27c;
  }
  FUN_00411860(fVar3);
  FUN_00567e10();
  FUN_00567dc0();
  DAT_00c5c28d = 1;
  return;
}

