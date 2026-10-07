/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005eea20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005eea20(int *param_1,undefined4 param_2_00,undefined4 param_2,double param_4)

{
  int iVar1;
  int iVar2;
  float10 fVar3;
  float10 fVar4;
  double local_10;
  
  iVar1 = param_1[1];
  iVar2 = 0;
  if (0 < iVar1) {
    do {
      fVar3 = ((float10)iVar2 + (float10)-(float)(iVar1 / 2) + (float10)_DAT_006ea44c) *
              (float10)(float)param_4;
      if (fVar3 == (float10)_DAT_006ea4b0) {
        local_10 = 1.0;
      }
      else {
        fVar4 = (float10)fsin(fVar3 * (float10)_DAT_006e97f8);
        local_10 = (double)(fVar4 / (fVar3 * (float10)_DAT_006e97f8));
      }
      fVar3 = fVar3 / (float10)(iVar1 / 2);
      fVar3 = (float10)FUN_005eeb10((double)(SQRT((float10)_DAT_006e9808 - fVar3 * fVar3) *
                                            (float10)(double)CONCAT44(param_2,param_2_00)));
      fVar4 = (float10)FUN_005eeb10(param_2_00,param_2);
      iVar2 = iVar2 + 1;
      *(float *)(*param_1 + -4 + iVar2 * 4) =
           (float)(((float10)(double)fVar3 / fVar4) * (float10)local_10);
    } while (iVar2 < iVar1);
  }
  FUN_005ee090();
  return;
}


