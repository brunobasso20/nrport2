/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055e8f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055e8f0(int param_1,float param_2,float param_3)

{
  float10 fVar1;
  float10 fVar2;
  float *pfVar3;
  int iVar4;
  float10 fVar5;
  float10 fVar6;
  float10 fVar7;
  float10 fVar8;
  
  fVar1 = (float10)_DAT_006f5cd4;
  iVar4 = 0x29;
  fVar2 = (float10)log2((float10)_DAT_006ea668);
  fVar5 = (float10)_DAT_006e97d8;
  fVar6 = (float10)_DAT_006f5838;
  pfVar3 = (float *)(param_1 + 0xc);
  do {
    iVar4 = iVar4 + -1;
    fVar8 = (float10)1.4426950408889634 *
            -(fVar6 * fVar6 *
             -(((float10)0.6931471805599453 * fVar2) /
              ((float10)param_3 * fVar1 * (float10)param_3 * fVar1)));
    fVar7 = ROUND(fVar8);
    fVar8 = (float10)f2xm1(fVar8 - fVar7);
    fVar7 = (float10)fscale((float10)1 + fVar8,fVar7);
    *pfVar3 = (float)((fVar5 - (float10)param_2) * fVar7 + (float10)param_2);
    fVar6 = fVar6 + (float10)_DAT_006ea4a4;
    pfVar3 = pfVar3 + 1;
  } while (iVar4 != 0);
  *(float *)(param_1 + 0xc) = *(float *)(param_1 + 0x10);
  *(undefined4 *)(param_1 + 0xac) = *(undefined4 *)(param_1 + 0xa8);
  return;
}


