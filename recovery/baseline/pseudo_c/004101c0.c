/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004101c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004101c0(int param_1,float *param_2,float *param_3)

{
  float fVar1;
  float *pfVar2;
  float *pfVar3;
  int iVar4;
  float *pfVar5;
  float *pfVar6;
  float *pfVar7;
  float10 fVar8;
  
  pfVar3 = param_3;
  pfVar2 = param_2;
  *param_2 = 0.0;
  *param_3 = 0.0;
  fVar8 = (float10)FUN_00547ec0();
  param_2 = (float *)(float)fVar8;
  if (fVar8 < (float10)_DAT_006ea44c) {
    param_2 = (float *)0x3f000000;
  }
  iVar4 = FUN_00567610(*(undefined4 *)(param_1 + 0x5b2));
  pfVar7 = (float *)(iVar4 + 0x10);
  param_3 = (float *)0xb;
  iVar4 = *(int *)(*(int *)(param_1 + 0x58a) + 0x138);
  pfVar5 = *(float **)(*(int *)(param_1 + 0x58a) + 0x13c);
  pfVar6 = (float *)(iVar4 + 4);
  iVar4 = iVar4 - (int)pfVar5;
  do {
    fVar1 = *pfVar7;
    if (fVar1 == _DAT_006ea4a0) {
      *pfVar2 = *pfVar6 + *pfVar2;
      fVar1 = pfVar5[1];
    }
    else {
      *pfVar2 = fVar1 * *(float *)(iVar4 + (int)pfVar5) + *pfVar2;
      fVar1 = fVar1 * *pfVar5;
    }
    pfVar7 = pfVar7 + 1;
    pfVar6 = pfVar6 + 2;
    pfVar5 = pfVar5 + 2;
    param_3 = (float *)((int)param_3 + -1);
    *pfVar3 = fVar1 + *pfVar3;
  } while (param_3 != (float *)0x0);
  *pfVar2 = (float)param_2 * *pfVar2;
  *pfVar3 = (float)param_2 * *pfVar3;
  return;
}


