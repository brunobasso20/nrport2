/* NR2003.exe @ 0051c1e0 FUN_0051c1e0 */

void __thiscall FUN_0051c1e0(float *param_1_00,uint param_1)

{
  float fVar1;
  
  fVar1 = (float)(param_1 & 0x7fffffff);
  *param_1_00 = fVar1;
  if (param_1_00[1] < fVar1) {
    param_1_00[1] = fVar1;
    return;
  }
  return;
}

