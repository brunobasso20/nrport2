/* NR2003.exe @ 005235b0 FUN_005235b0 */

void __thiscall FUN_005235b0(int param_1_00,int param_1,float param_2)

{
  float10 fVar1;
  
  if (*(char *)(param_1_00 + 0xfc) != '\0') {
    fVar1 = (float10)FUN_00557d80(0);
    if ((float10)param_2 < fVar1 != (NAN((float10)param_2) || NAN(fVar1))) {
      param_2 = (float)fVar1;
    }
    fVar1 = (float10)FUN_00557dc0(0);
    if (fVar1 < (float10)param_2) {
      param_2 = (float)fVar1;
    }
    *(float *)(param_1_00 + 0xda + param_1 * 4) = param_2;
    fVar1 = (float10)FUN_00557e40(param_1);
    if ((NAN(fVar1) || NAN((float10)param_2)) == (fVar1 == (float10)param_2)) {
      if ((param_1 != 0) && (param_1 != 2)) {
        FUN_00523520(1,0);
        return;
      }
      FUN_005234b0(1,0);
    }
  }
  return;
}

