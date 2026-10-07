/* NR2003.exe @ 00538560 FUN_00538560 */

undefined4 FUN_00538560(undefined4 param_1,undefined4 param_2)

{
  int iVar1;
  undefined local_6c [108];
  
  FUN_0056772e(local_6c,1,3);
  FUN_005676f0();
  iVar1 = FUN_00537390();
  if (iVar1 != 0) {
    iVar1 = FUN_00537680();
    if (iVar1 != 0) {
      iVar1 = FUN_00537d90();
      if (iVar1 != 0) {
        iVar1 = FUN_005380c0(param_1);
        if (iVar1 != 0) {
          iVar1 = FUN_005382a0(param_2);
          if (iVar1 != 0) {
            FUN_0050fbd0(s_track_ini_0074c6dc);
            FUN_00538440();
            FUN_0041c120();
            FUN_005676f0();
            FUN_0056775d(local_6c);
            return 1;
          }
        }
      }
    }
  }
  FUN_0056775d(local_6c);
  return 0;
}

