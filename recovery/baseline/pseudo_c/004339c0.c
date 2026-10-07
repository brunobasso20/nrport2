/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004339c0 */

void FUN_004339c0(float *param_1,float *param_2,float *param_3,float *param_4,float *param_5,
                 float *param_6,int param_7,float param_8)

{
  float fVar1;
  float fVar2;
  float *pfVar3;
  float *pfVar4;
  float *pfVar5;
  float *pfVar6;
  float *pfVar7;
  int iVar8;
  
  pfVar6 = param_5;
  pfVar5 = param_3;
  pfVar4 = param_2;
  pfVar3 = param_1;
  if (0 < (int)param_8) {
    fVar2 = *param_1;
    param_1 = (float *)*param_3;
    param_3 = (float *)*param_5;
    param_5 = (float *)*param_2;
    param_2 = (float *)*param_4;
    fVar1 = *param_6;
    pfVar7 = (float *)(param_7 + 0xc);
    iVar8 = (int)param_8;
    param_8 = fVar2;
    do {
      if (pfVar7[-3] - *pfVar7 < param_8) {
        param_8 = pfVar7[-3] - *pfVar7;
      }
      if (pfVar7[-2] - *pfVar7 < (float)param_1) {
        param_1 = (float *)(pfVar7[-2] - *pfVar7);
      }
      if (pfVar7[-1] - *pfVar7 < (float)param_3) {
        param_3 = (float *)(pfVar7[-1] - *pfVar7);
      }
      if ((float)param_5 < pfVar7[-3] + *pfVar7) {
        param_5 = (float *)(pfVar7[-3] + *pfVar7);
      }
      if ((float)param_2 < pfVar7[-2] + *pfVar7) {
        param_2 = (float *)(pfVar7[-2] + *pfVar7);
      }
      if (fVar1 < pfVar7[-1] + *pfVar7) {
        fVar1 = pfVar7[-1] + *pfVar7;
      }
      pfVar7 = pfVar7 + 5;
      iVar8 = iVar8 + -1;
    } while (iVar8 != 0);
    *pfVar3 = param_8;
    *pfVar5 = (float)param_1;
    *pfVar6 = (float)param_3;
    *pfVar4 = (float)param_5;
    *param_6 = fVar1;
    *param_4 = (float)param_2;
  }
  return;
}


