/* NR2003.exe @ 0054e9f0 FUN_0054e9f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0054e9f0(undefined4 *param_1,float param_2,float param_3)

{
  float **ppfVar1;
  float fVar2;
  undefined4 uVar3;
  int *piVar4;
  int iVar5;
  float *pfVar6;
  uint uVar7;
  float10 fVar8;
  double dVar9;
  float fStack_14;
  float fStack_10;
  undefined8 uStack_c;
  int iStack_4;
  
  uVar3 = FUN_0055ab00();
  piVar4 = (int *)FUN_00562f70(uVar3);
  iStack_4 = (**(code **)(*piVar4 + 8))();
  uVar7 = (*(ushort *)(iStack_4 + 2) & 0xfff) >> (*(char *)(param_1 + 0x1b) * '\x02' & 0x1fU) & 3;
  if ((uVar7 == 3) || (uVar7 == 2)) {
    ppfVar1 = (float **)(param_1 + 0x1d);
    *param_1 = 0;
    param_3 = 1.0;
    FUN_005f5890(param_1 + 0x20);
    FUN_00425e80(&param_2,param_1[0x1e],&DAT_00f72118,4);
    if (param_2 != **ppfVar1) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar7 = FUN_005cfcfc();
    if ((uVar7 & 0x3f) == 0) {
      FUN_004f68c0(param_1[0x1f],4);
    }
    FUN_00425e80(*ppfVar1,&param_3,param_1[0x1f],4);
    FUN_00425e80(param_1[0x1e],&DAT_00f72118,*ppfVar1,4);
    uVar7 = FUN_005cfcfc();
    if ((uVar7 & 0x3ff) == 0) {
      uVar3 = FUN_0051c5d0(param_1[0x1f]);
      param_1[0x1f] = uVar3;
    }
    uVar7 = FUN_005cfcfc();
    if ((uVar7 & 0x1ff) == 0) {
      pfVar6 = (float *)FUN_0051c5d0(*ppfVar1);
      *ppfVar1 = pfVar6;
    }
    uVar7 = FUN_005cfcfc();
    if ((uVar7 & 0x7ff) == 0) {
      uVar3 = FUN_0051c5d0(param_1[0x1e]);
      param_1[0x1e] = uVar3;
    }
    FUN_005f58a0(param_1 + 0x20);
    param_1[0x33] = 0x3f19999a;
  }
  else {
    iVar5 = FUN_00567280();
    fStack_10 = _DAT_006e97d8;
    if (iVar5 != 5) {
      iVar5 = FUN_0055a680();
      uStack_c = (double)(ulonglong)((*(uint *)(iVar5 + 0x50) & 3) + 1);
      fStack_10 = (float)(longlong)uStack_c;
    }
    fStack_10 = fStack_10 * (float)param_1[0x10];
    uStack_c = (double)CONCAT44(uStack_c._4_4_,
                                (float)param_1[0x15] -
                                ((float)param_1[0x16] - (float)param_1[0x15]) * _DAT_006ea680);
    fVar8 = (float10)FUN_0054fb50();
    fStack_14 = (float)fVar8;
    fVar8 = (float10)FUN_0054fb50();
    if ((float10)fStack_14 < fVar8) {
      fVar8 = (float10)FUN_0054fb50();
      fStack_14 = (float)fVar8;
    }
    fVar8 = (float10)FUN_0054fb50();
    if ((float10)fStack_14 < fVar8) {
      fVar8 = (float10)FUN_0054fb50();
      fStack_14 = (float)fVar8;
    }
    if ((float)uStack_c < fStack_14) {
      fVar2 = (fStack_14 - (float)uStack_c) * (float)param_1[0x11];
      fVar2 = fVar2 * fVar2 * fVar2;
      if ((float)param_1[0xb3] < _DAT_006ed67c != (NAN((float)param_1[0xb3]) || NAN(_DAT_006ed67c)))
      {
        fVar2 = ((_DAT_006e97d8 / ((float)param_1[0xb3] + _DAT_006e97d8)) * _DAT_006f5950 -
                _DAT_006e97d8) * fVar2;
      }
      fStack_10 = fVar2 + fStack_10;
    }
    fVar8 = (float10)FUN_00510080();
    fVar8 = fVar8 * (float10)fStack_10 * (float10)param_3 * (float10)_DAT_006f5948;
    param_3 = (float)fVar8;
    fVar8 = fVar8 * (float10)param_2;
    uStack_c = (double)CONCAT44(uStack_c._4_4_,(float)fVar8);
    if ((float10)_DAT_006ea454 < fVar8) {
      ppfVar1 = (float **)(param_1 + 0x1d);
      fVar8 = (float10)FUN_0054fb50();
      fStack_10 = (float)(fVar8 + (float10)(float)uStack_c);
      FUN_0051c3f0(&fStack_10);
      FUN_005f5890(param_1 + 0x20);
      FUN_00425e80(&uStack_c,*ppfVar1,param_1[0x1f],4);
      FUN_005f58a0(param_1 + 0x20);
      if (_DAT_006ef740 < (float)uStack_c) {
        FUN_005f5890(param_1 + 0x20);
        FUN_00425e80(&uStack_c,*ppfVar1,param_1[0x1f],4);
        FUN_005f58a0(param_1 + 0x20);
        if ((float)uStack_c < _DAT_006e97d8 != (NAN((float)uStack_c) || NAN(_DAT_006e97d8))) {
          fVar8 = (float10)FUN_006c5c40();
          uStack_c = (double)((float10)_DAT_006e9808 - fVar8);
          if (uVar7 == 1) {
            uStack_c = uStack_c + uStack_c;
          }
          dVar9 = rndUniform(0);
          if (dVar9 < uStack_c != (NAN(dVar9) || NAN(uStack_c))) {
            param_3 = 1.0;
            FUN_005f5890(param_1 + 0x20);
            FUN_00425e80(&param_2,param_1[0x1e],&DAT_00f72118,4);
            if (param_2 != **ppfVar1) {
              do {
                DAT_00f7212c = FUN_005cfcfc();
              } while (DAT_00f7212c == 0);
            }
            uVar7 = FUN_005cfcfc();
            if ((uVar7 & 0x3f) == 0) {
              FUN_004f68c0(param_1[0x1f],4);
            }
            FUN_00425e80(*ppfVar1,&param_3,param_1[0x1f],4);
            FUN_00425e80(param_1[0x1e],&DAT_00f72118,*ppfVar1,4);
            uVar7 = FUN_005cfcfc();
            if ((uVar7 & 0x3ff) == 0) {
              uVar3 = FUN_0051c5d0(param_1[0x1f]);
              param_1[0x1f] = uVar3;
            }
            uVar7 = FUN_005cfcfc();
            if ((uVar7 & 0x1ff) == 0) {
              pfVar6 = (float *)FUN_0051c5d0(*ppfVar1);
              *ppfVar1 = pfVar6;
            }
            uVar7 = FUN_005cfcfc();
            if ((uVar7 & 0x7ff) == 0) {
              uVar3 = FUN_0051c5d0(param_1[0x1e]);
              param_1[0x1e] = uVar3;
            }
            FUN_005f58a0(param_1 + 0x20);
          }
        }
      }
      FUN_005f5890(param_1 + 0x20);
      FUN_00425e80(&param_2,*ppfVar1,param_1[0x1f],4);
      FUN_005f58a0(param_1 + 0x20);
      if (param_2 < _DAT_006e97d8) {
        FUN_005f5890(param_1 + 0x20);
        FUN_00425e80(&param_2,*ppfVar1,param_1[0x1f],4);
        FUN_005f58a0(param_1 + 0x20);
        fVar8 = (float10)FUN_0054ef10(param_2);
        param_1[0x33] = (float)fVar8;
        return;
      }
      *param_1 = 0;
      FUN_0054b970(param_1[0x1b],2);
      param_2 = 1.0;
      FUN_0051c3f0(&param_2);
      param_1[0x33] = 0x3f19999a;
      return;
    }
  }
  return;
}

