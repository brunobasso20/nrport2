/* Ghidra pseudo-C; NR2003.exe @ 0057db00 */

void FUN_0057db00(undefined4 param_1,undefined4 *param_2)

{
  int iVar1;
  float10 fVar2;
  
  iVar1 = FUN_0057c890(param_2);
  if (iVar1 != 0) {
    fVar2 = (float10)fsin((float10)*(float *)*param_2);
    FUN_0057c990(param_1,(float)fVar2);
    FUN_005b9b70(param_1,param_2);
    return;
  }
  fVar2 = (float10)fsin((float10)*(float *)*param_2);
  FUN_0057ca60(param_1,(float)fVar2);
  return;
}

