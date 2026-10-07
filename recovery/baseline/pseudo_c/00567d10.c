/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00567d10 */

void __fastcall FUN_00567d10(undefined4 param_1)

{
  float10 fVar1;
  float fVar2;
  
  fVar1 = (float10)FUN_00411850(param_1);
  fVar2 = DAT_00c5736c;
  if ((fVar1 <= (float10)DAT_00c5736c) && (fVar2 = (float)fVar1, (float)fVar1 < DAT_00c5c27c)) {
    fVar2 = DAT_00c5c27c;
  }
  FUN_00411860(fVar2);
  FUN_00567e10();
  FUN_00567dc0();
  DAT_00c5c28d = 1;
  return;
}


