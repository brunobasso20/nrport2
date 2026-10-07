/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573010 */

undefined4 FUN_00573010(undefined4 param_1,undefined4 param_2)

{
  int iVar1;
  
  iVar1 = FUN_0050c8d0(param_1);
  if (iVar1 != 0) {
    FUN_00579cd0();
    FUN_00573af0();
    FUN_005105c0(param_2);
    DAT_00c721d4 = param_1;
    FUN_005cff24(&LAB_00572fd0);
    iVar1 = FUN_00572760(param_1);
    if (iVar1 != 0) {
      iVar1 = FUN_00598820(param_2);
      if (iVar1 != 0) {
        iVar1 = FUN_00593150();
        if (iVar1 != 0) {
          FUN_00525510();
          FUN_00453080();
          iVar1 = FUN_00567d10();
          if (iVar1 != 0) {
            iVar1 = FUN_0043e9b0();
            if (iVar1 != 0) {
              iVar1 = FUN_005730e0(param_1,param_2);
              if (iVar1 != 0) {
                FUN_005cff24(0);
                return 1;
              }
              thunk_FUN_004531c0();
            }
            FUN_00567e00();
          }
          FUN_00525870();
        }
        FUN_00598560(0);
      }
    }
    FUN_005cff24(0);
    FUN_0050d050();
  }
  return 0;
}


