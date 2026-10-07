/* Ghidra pseudo-C; NR2003.exe @ 0057d190 */

void FUN_0057d190(undefined4 param_1,undefined4 param_2)

{
  int iVar1;
  undefined4 *extraout_ECX;
  float10 fVar2;
  
  iVar1 = FUN_0057c890(param_2);
  if (iVar1 != 0) {
    fVar2 = (float10)fcos((float10)*(float *)*extraout_ECX);
    FUN_0057c990(param_1,(float)fVar2);
    return;
  }
  fVar2 = (float10)fcos((float10)*(float *)*extraout_ECX);
  FUN_0057ca60(param_1,(float)fVar2);
  return;
}

