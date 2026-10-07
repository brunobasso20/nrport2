/* Ghidra pseudo-C; NR2003.exe @ 0057dab0 */

void FUN_0057dab0(undefined4 param_1,undefined4 *param_2)

{
  int iVar1;
  
  iVar1 = FUN_0057c890(param_2);
  if (iVar1 != 0) {
    FUN_0057c990(param_1,SQRT(*(float *)*param_2));
    FUN_005b9b50(param_1,param_2);
    return;
  }
  FUN_0057ca60(param_1,SQRT(*(float *)*param_2));
  return;
}

