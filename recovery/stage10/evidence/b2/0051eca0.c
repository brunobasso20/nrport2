/* NR2003.exe @ 0051eca0 FUN_0051eca0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051eca0(float param_1)

{
  int iVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  float *pfVar5;
  int iVar6;
  float10 fVar7;
  float local_14;
  float local_8;
  undefined local_4 [4];
  
  iVar4 = (int)param_1;
  iVar1 = *(int *)((int)param_1 + 0x1a76);
  FUN_0051f860(param_1,&local_8,local_4);
  fVar3 = *(float *)((int)param_1 + 0x5aa) - local_8 * _DAT_006ea44c;
  fVar3 = fVar3 * fVar3 * _DAT_00e0bb5c * _DAT_006ea44c;
  if ((DAT_00bebd9c & 1) == 0) {
    pfVar5 = (float *)FUN_00557d60(0x3d);
    local_14 = *pfVar5;
    pfVar5 = (float *)FUN_00557d60(0x3b);
    param_1 = *pfVar5;
    iVar6 = FUN_005099b0();
    if (iVar6 == 5) {
      param_1 = 1.0;
    }
  }
  else {
    pfVar5 = (float *)FUN_00557d60(0x3d);
    local_14 = *pfVar5;
    pfVar5 = (float *)FUN_00557d60(0x3b);
    param_1 = *pfVar5;
  }
  iVar6 = FUN_00567610(*(undefined4 *)(iVar4 + 0x5b2));
  if (_DAT_006e97d8 < *(float *)(iVar6 + 0x14)) {
    param_1 = 0.0;
  }
  iVar6 = *(int *)(iVar4 + 0x58a);
  fVar2 = *(float *)(iVar4 + 0x17ea);
  fVar7 = (float10)FUN_00410a90(iVar6,*(undefined4 *)(iVar6 + 0xe4));
  fVar2 = (float)(((float10)fVar3 / (float10)*(float *)(iVar4 + 0x190e)) *
                  ((((float10)param_1 * (float10)*(float *)(iVar6 + 0xb8) +
                    (float10)*(float *)(iVar6 + 0xc4) * (float10)*(float *)(iVar4 + 0x5a6) *
                    (float10)local_14) - (float10)*(float *)(iVar6 + 0xa8)) + fVar7 +
                  (float10)*(float *)(iVar4 + 0x1d5a)) * (float10)*(float *)(iVar6 + 0xa0) *
                  (float10)*(float *)(iVar4 + 0x59e) * (float10)fVar2 * (float10)_DAT_0074bc10);
  if ((DAT_00bebd9c & 1) == 0) {
    pfVar5 = (float *)FUN_00557d60(0x3d);
    local_14 = *pfVar5;
    pfVar5 = (float *)FUN_00557d60(0x3b);
    param_1 = *pfVar5;
    iVar6 = FUN_005099b0();
    if (iVar6 == 5) {
      param_1 = 1.0;
    }
  }
  else {
    pfVar5 = (float *)FUN_00557d60(0x3d);
    local_14 = *pfVar5;
    pfVar5 = (float *)FUN_00557d60(0x3b);
    param_1 = *pfVar5;
  }
  iVar6 = *(int *)(iVar4 + 0x58a);
  fVar7 = (float10)FUN_00410ae0(iVar6,*(undefined4 *)(iVar6 + 0xe8));
  *(float *)(iVar4 + 0x1ad6) =
       (float)((float10)*(float *)(iVar1 + 0x2c) * (float10)_DAT_006e9814 +
              ((float10)fVar3 / (float10)*(float *)(iVar4 + 0x190e)) *
              ((float10)*(float *)(iVar6 + 200) * (float10)*(float *)(iVar4 + 0x5a6) *
               (float10)local_14 +
               (float10)*(float *)(iVar4 + 0x5a2) * (float10)*(float *)(iVar6 + 0xbc) *
               (float10)param_1 +
               ((float10)_DAT_006e97d8 - (float10)*(float *)(iVar4 + 0x59e)) *
               (float10)*(float *)(iVar6 + 0xd8) + fVar7 + (float10)*(float *)(iVar4 + 0x1d5e) +
              (float10)*(float *)(iVar6 + 0xac)) * (float10)*(float *)(iVar6 + 0xa0));
  FUN_0051ef60(iVar4);
  fVar3 = *(float *)(iVar4 + 0x18be) - *(float *)(iVar4 + 0x1ad6);
  *(float *)(iVar4 + 0x1ad2) = fVar3;
  if (fVar3 <= _DAT_006ea454) {
    fVar3 = _DAT_006ea454;
  }
  *(float *)(iVar4 + 0x1ad2) = fVar3;
  fVar3 = *(float *)(iVar4 + 0x1aba) * _DAT_006e9814;
  *(float *)(iVar4 + 0x1afa) = fVar2;
  *(float *)(iVar4 + 0x1ace) = fVar3;
  *(float *)(iVar4 + 0x1aca) = *(float *)(iVar4 + 0x1aae) * _DAT_006e9814 + fVar2;
  if (*(float *)(iVar4 + 0x1862) < _DAT_006ea61c !=
      (NAN(*(float *)(iVar4 + 0x1862)) || NAN(_DAT_006ea61c))) {
    *(undefined4 *)(iVar4 + 0x1ace) = 0;
    *(undefined4 *)(iVar4 + 0x1aca) = 0;
  }
  return;
}

