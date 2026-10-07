/* NR2003.exe @ 005b2f20 FUN_005b2f20 */

void FUN_005b2f20(undefined4 param_1,undefined4 param_2)

{
  undefined4 *puVar1;
  
  FUN_0057dcd0(0);
  FUN_0057c930();
  FUN_0055e9b0();
  puVar1 = &DAT_00e84474;
  do {
    FUN_0057c990(puVar1,0);
    puVar1 = puVar1 + 1;
  } while ((int)puVar1 < 0xe84498);
  FUN_005b4060(param_1);
  DAT_00e84664 = &DAT_00e84474;
  DAT_00e847c8 = param_2;
  FUN_005b4560(param_1);
  DAT_00e84664 = &DAT_00e84474;
  FUN_005b3f50(param_1);
  FUN_005b2fb0(param_1);
  FUN_005b9ce0();
  FUN_0057dcd0(2);
  FUN_005b3090(param_1);
  FUN_0057dcd0(1);
  return;
}

