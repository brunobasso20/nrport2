/* Ghidra pseudo-C; NR2003.exe @ 0057dc70 */

void FUN_0057dc70(undefined4 param_1,undefined4 *param_2)

{
  float fVar1;
  int iVar2;
  
  fVar1 = *(float *)*param_2;
  iVar2 = FUN_0057c890(param_2);
  if (iVar2 != 0) {
    FUN_0057c990(param_1,ABS(fVar1));
    FUN_005b9bd0(param_1,param_2);
    return;
  }
  FUN_0057ca60();
  return;
}

