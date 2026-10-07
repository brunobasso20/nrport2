/* NR2003.exe @ 005a57f0 FUN_005a57f0 */

uint __fastcall FUN_005a57f0(uint **param_1)

{
  uint uVar1;
  uint uVar2;
  
  FUN_005f5890(param_1 + 3);
  uVar1 = **param_1;
  uVar2 = *param_1[2];
  FUN_005f58a0(param_1 + 3);
  return uVar1 ^ uVar2;
}

