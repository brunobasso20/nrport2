/* NR2003.exe @ 0050f780 FUN_0050f780 */

undefined4 FUN_0050f780(undefined4 param_1)

{
  int iVar1;
  
  iVar1 = FUN_00510b70(param_1);
  if (iVar1 != 0) {
    DAT_00bcf730 = 1;
    iVar1 = FUN_005108f0(param_1);
    if (iVar1 != 0) {
      return 1;
    }
    FUN_00510b00();
  }
  DAT_00bcf730 = 0;
  return 0;
}

