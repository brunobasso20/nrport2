/* NR2003.exe @ 0054fb50 FUN_0054fb50 */

float10 __fastcall FUN_0054fb50(uint **param_1)

{
  uint uVar1;
  uint uVar2;
  
  FUN_005f5890(param_1 + 3);
  uVar1 = **param_1;
  uVar2 = *param_1[2];
  FUN_005f58a0(param_1 + 3);
  return (float10)(float)(uVar1 ^ uVar2);
}

