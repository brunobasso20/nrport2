/* NR2003.exe @ 0055e8f0 FUN_0055e8f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055e8f0(int param_1,float param_2,float param_3)

{
  float10 fVar1;
  float *pfVar2;
  int iVar3;
  float10 fVar4;
  float10 fVar5;
  float10 fVar6;
  float10 fVar7;
  float10 fVar8;
  
  fVar1 = (float10)_DAT_006f5cd4;
  iVar3 = 0x29;
  fVar4 = (float10)_DAT_006ea668;
  fVar5 = (float10)_DAT_006e97d8;
  fVar6 = (float10)_DAT_006f5838;
  pfVar2 = (float *)(param_1 + 0xc);
  do {
    iVar3 = iVar3 + -1;
    fVar8 = (float10)1.442695040888963 *
            -(fVar6 * fVar6 *
             -(((float10)0.6931471805599453 * fVar4) /
              ((float10)param_3 * fVar1 * (float10)param_3 * fVar1)));
    fVar7 = ROUND(fVar8);
    fVar8 = (float10)f2xm1(fVar8 - fVar7);
    fVar7 = (float10)fscale((float10)1 + fVar8,fVar7);
    *pfVar2 = (float)((fVar5 - (float10)param_2) * fVar7 + (float10)param_2);
    fVar6 = fVar6 + (float10)_DAT_006ea4a4;
    pfVar2 = pfVar2 + 1;
  } while (iVar3 != 0);
  *(float *)(param_1 + 0xc) = *(float *)(param_1 + 0x10);
  *(undefined4 *)(param_1 + 0xac) = *(undefined4 *)(param_1 + 0xa8);
  return;
}

