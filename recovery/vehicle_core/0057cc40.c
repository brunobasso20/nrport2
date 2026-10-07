/* Ghidra pseudo-C; NR2003.exe @ 0057cc40 */

void FUN_0057cc40(undefined4 param_1,undefined4 param_2,undefined4 *param_3)

{
  int iVar1;
  float10 fVar2;
  
  iVar1 = FUN_0057c890(param_3);
  if (iVar1 == 0) {
    fVar2 = (float10)FUN_005677d1(param_2,*(undefined4 *)*param_3);
    FUN_0057ca60(param_1,(float)fVar2);
  }
  else {
    fVar2 = (float10)FUN_005677d1(param_2,*(undefined4 *)*param_3);
    FUN_0057c990(param_1,(float)fVar2);
    if (DAT_00d47d6c == 2) {
      FUN_005b9c50(param_1,param_2,param_3);
      return;
    }
  }
  return;
}

