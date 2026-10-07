/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005677d1 */

float10 FUN_005677d1(float *param_1,float param_2)

{
  float fVar1;
  float10 fVar2;
  float10 fVar3;
  
  fVar2 = ((float10)param_2 - (float10)*param_1) * (float10)param_1[1];
  fVar1 = (float)(int)ROUND(fVar2);
  if ((int)fVar1 < 0) {
    fVar3 = (float10)0;
    fVar1 = 0.0;
  }
  else if ((int)param_1[2] < (int)fVar1) {
    fVar3 = (float10)(int)param_1[2];
    fVar1 = param_1[2];
  }
  else {
    fVar3 = (float10)(int)fVar1;
  }
  return ((float10)param_1[(int)fVar1 + 4] - (float10)param_1[(int)fVar1 + 3]) * (fVar2 - fVar3) +
         (float10)param_1[(int)fVar1 + 3];
}


