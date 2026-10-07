/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054e9f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0054e9f0(undefined4 *param_1,float param_2,float param_3)

{
  undefined4 *puVar1;
  float fVar2;
  undefined4 uVar3;
  int *piVar4;
  int iVar5;
  uint uVar6;
  float10 fVar7;
  double dVar8;
  float fStack_14;
  float fStack_10;
  double dStack_c;
  int iStack_4;
  
  uVar3 = FUN_0055ab00();
  piVar4 = (int *)FUN_00562f70(uVar3);
  iStack_4 = (**(code **)(*piVar4 + 8))();
  uVar6 = (*(ushort *)(iStack_4 + 2) & 0xfff) >> (*(char *)(param_1 + 0x1b) * '\x02' & 0x1fU) & 3;
  if ((uVar6 == 3) || (uVar6 == 2)) {
    puVar1 = param_1 + 0x1d;
    *param_1 = 0;
    param_3 = 1.0;
    FUN_005f5890(param_1 + 0x20);
    FUN_00425e80(&param_2,param_1[0x1e],&DAT_00f72118,4);
    if (param_2 != *(float *)*puVar1) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar6 = FUN_005cfcfc();
    if ((uVar6 & 0x3f) == 0) {
      FUN_004f68c0(param_1[0x1f],4);
    }
    FUN_00425e80(*puVar1,&param_3,param_1[0x1f],4);
    FUN_00425e80(param_1[0x1e],&DAT_00f72118,*puVar1,4);
    uVar6 = FUN_005cfcfc();
    if ((uVar6 & 0x3ff) == 0) {
      uVar3 = FUN_0051c5d0(param_1[0x1f]);
      param_1[0x1f] = uVar3;
    }
    uVar6 = FUN_005cfcfc();
    if ((uVar6 & 0x1ff) == 0) {
      uVar3 = FUN_0051c5d0(*puVar1);
      *puVar1 = uVar3;
    }
    uVar6 = FUN_005cfcfc();
    if ((uVar6 & 0x7ff) == 0) {
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
      dStack_c = (double)(ulonglong)((*(uint *)(iVar5 + 0x50) & 3) + 1);
      fStack_10 = (float)(longlong)dStack_c;
    }
    fStack_10 = fStack_10 * (float)param_1[0x10];
    dStack_c = (double)CONCAT44(dStack_c._4_4_,
                                (float)param_1[0x15] -
                                ((float)param_1[0x16] - (float)param_1[0x15]) * _DAT_006ea680);
    fVar7 = (float10)FUN_0054fb50();
    fStack_14 = (float)fVar7;
    fVar7 = (float10)FUN_0054fb50();
    if ((float10)fStack_14 < fVar7) {
      fVar7 = (float10)FUN_0054fb50();
      fStack_14 = (float)fVar7;
    }
    fVar7 = (float10)FUN_0054fb50();
    if ((float10)fStack_14 < fVar7) {
      fVar7 = (float10)FUN_0054fb50();
      fStack_14 = (float)fVar7;
    }
    if (dStack_c._0_4_ < fStack_14) {
      fVar2 = (fStack_14 - dStack_c._0_4_) * (float)param_1[0x11];
      fVar2 = fVar2 * fVar2 * fVar2;
      if ((float)param_1[0xb3] < _DAT_006ed67c) {
        fVar2 = ((_DAT_006e97d8 / ((float)param_1[0xb3] + _DAT_006e97d8)) * _DAT_006f5950 -
                _DAT_006e97d8) * fVar2;
      }
      fStack_10 = fVar2 + fStack_10;
    }
    fVar7 = (float10)FUN_00510080();
    fVar7 = fVar7 * (float10)fStack_10 * (float10)param_3 * (float10)_DAT_006f5948;
    param_3 = (float)fVar7;
    fVar7 = fVar7 * (float10)param_2;
    dStack_c = (double)CONCAT44(dStack_c._4_4_,(float)fVar7);
    if ((float10)_DAT_006ea454 < fVar7) {
      puVar1 = param_1 + 0x1d;
      fVar7 = (float10)FUN_0054fb50();
      fStack_10 = (float)(fVar7 + (float10)dStack_c._0_4_);
      FUN_0051c3f0(&fStack_10);
      FUN_005f5890(param_1 + 0x20);
      FUN_00425e80(&dStack_c,*puVar1,param_1[0x1f],4);
      FUN_005f58a0(param_1 + 0x20);
      if (_DAT_006ef740 < dStack_c._0_4_) {
        FUN_005f5890(param_1 + 0x20);
        FUN_00425e80(&dStack_c,*puVar1,param_1[0x1f],4);
        FUN_005f58a0(param_1 + 0x20);
        if (dStack_c._0_4_ < _DAT_006e97d8) {
          fVar7 = (float10)FUN_006c5c40();
          dStack_c = (double)((float10)_DAT_006e9808 - fVar7);
          if (uVar6 == 1) {
            dStack_c = dStack_c + dStack_c;
          }
          dVar8 = rndUniform(0);
          if (dVar8 < dStack_c) {
            param_3 = 1.0;
            FUN_005f5890(param_1 + 0x20);
            FUN_00425e80(&param_2,param_1[0x1e],&DAT_00f72118,4);
            if (param_2 != *(float *)*puVar1) {
              do {
                DAT_00f7212c = FUN_005cfcfc();
              } while (DAT_00f7212c == 0);
            }
            uVar6 = FUN_005cfcfc();
            if ((uVar6 & 0x3f) == 0) {
              FUN_004f68c0(param_1[0x1f],4);
            }
            FUN_00425e80(*puVar1,&param_3,param_1[0x1f],4);
            FUN_00425e80(param_1[0x1e],&DAT_00f72118,*puVar1,4);
            uVar6 = FUN_005cfcfc();
            if ((uVar6 & 0x3ff) == 0) {
              uVar3 = FUN_0051c5d0(param_1[0x1f]);
              param_1[0x1f] = uVar3;
            }
            uVar6 = FUN_005cfcfc();
            if ((uVar6 & 0x1ff) == 0) {
              uVar3 = FUN_0051c5d0(*puVar1);
              *puVar1 = uVar3;
            }
            uVar6 = FUN_005cfcfc();
            if ((uVar6 & 0x7ff) == 0) {
              uVar3 = FUN_0051c5d0(param_1[0x1e]);
              param_1[0x1e] = uVar3;
            }
            FUN_005f58a0(param_1 + 0x20);
          }
        }
      }
      FUN_005f5890(param_1 + 0x20);
      FUN_00425e80(&param_2,*puVar1,param_1[0x1f],4);
      FUN_005f58a0(param_1 + 0x20);
      if (param_2 < _DAT_006e97d8) {
        FUN_005f5890(param_1 + 0x20);
        FUN_00425e80(&param_2,*puVar1,param_1[0x1f],4);
        FUN_005f58a0(param_1 + 0x20);
        fVar7 = (float10)FUN_0054ef10(param_2);
        param_1[0x33] = (float)fVar7;
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


