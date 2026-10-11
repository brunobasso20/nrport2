/* NR2003.exe @ 005b2190 FUN_005b2190 */

void FUN_005b2190(undefined4 param_1,undefined4 param_2)

{
  int iVar1;
  
  FUN_005789c0(param_1,param_2);
  FUN_00578a60();
  FUN_00578e20(&LAB_005b22b0);
  FUN_00551e80();
  DAT_00e8441c = 0;
  iVar1 = FUN_00555140();
  if (DAT_00e8441c < iVar1) {
    do {
      DAT_00e843fc = 1;
      FUN_00578e20(&LAB_005b23f0);
      FUN_005539c0();
      FUN_00578da0();
      FUN_00578e20(&LAB_005b2430);
      FUN_005544d0();
      DAT_00e843fc = 0;
      FUN_00578e20(&LAB_005b2410);
      FUN_005544e0();
      FUN_00578de0();
      FUN_00578e20(&LAB_005b2430);
      FUN_005544d0();
      FUN_00578e20(FUN_005f6020);
      FUN_00554510();
      FUN_005548d0(param_1,param_2);
      DAT_00e8441c = DAT_00e8441c + 1;
      iVar1 = FUN_00555140();
    } while (DAT_00e8441c < iVar1);
  }
  FUN_00578e20(FUN_005b25a0);
  FUN_00554520();
  return;
}

