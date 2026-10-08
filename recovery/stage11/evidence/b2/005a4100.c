/* NR2003.exe @ 005a4100 FUN_005a4100 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_005a4100(int param_1_00,uint param_1,float param_2,undefined4 *param_3)

{
  float **ppfVar1;
  undefined4 *puVar2;
  uint uVar3;
  undefined4 uVar4;
  float *pfVar5;
  float10 fVar6;
  double dVar7;
  double local_8;
  
  uVar3 = param_1;
  param_1 = param_1 & 0xffffff01;
  FUN_005f5890(param_1_00 + 0x134);
  FUN_005a5820(&local_8,*(undefined4 *)(param_1_00 + 0x128),*(undefined4 *)(param_1_00 + 0x130),4);
  FUN_005f58a0(param_1_00 + 0x134);
  if (local_8._0_4_ != 1) {
    rndSeed((uVar3 & 0xfffffffe) + (int)param_2,*(uint *)(param_1_00 + 0x2b8));
    puVar2 = param_3;
    fVar6 = (float10)FUN_005a4670(*param_3,param_3[1],*(undefined4 *)(param_1_00 + 0x2b8));
    param_3 = (undefined4 *)(float)fVar6;
    ppfVar1 = (float **)(param_1_00 + 0x158);
    FUN_005f5890(param_1_00 + 0x164);
    FUN_00425e80(&param_2,*(undefined4 *)(param_1_00 + 0x15c),&DAT_00f72118,4);
    if (param_2 != **ppfVar1) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x3f) == 0) {
      FUN_004f68c0(*(undefined4 *)(param_1_00 + 0x160),4);
    }
    FUN_00425e80(*ppfVar1,&param_3,*(undefined4 *)(param_1_00 + 0x160),4);
    FUN_00425e80(*(undefined4 *)(param_1_00 + 0x15c),&DAT_00f72118,*ppfVar1,4);
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x3ff) == 0) {
      uVar4 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x160));
      *(undefined4 *)(param_1_00 + 0x160) = uVar4;
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x1ff) == 0) {
      pfVar5 = (float *)FUN_0051c5d0(*ppfVar1);
      *ppfVar1 = pfVar5;
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x7ff) == 0) {
      uVar4 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x15c));
      *(undefined4 *)(param_1_00 + 0x15c) = uVar4;
    }
    FUN_005f58a0(param_1_00 + 0x164);
    FUN_005f5890(param_1_00 + 0x164);
    FUN_00425e80(&param_2,*ppfVar1,*(undefined4 *)(param_1_00 + 0x160),4);
    FUN_005f58a0(param_1_00 + 0x164);
    local_8 = (double)param_2;
    fVar6 = (float10)FUN_005a4670(0,puVar2[1],*(undefined4 *)(param_1_00 + 0x2b8));
    ppfVar1 = (float **)(param_1_00 + 0x184);
    param_3 = (undefined4 *)(float)((float10)local_8 - ABS(fVar6));
    FUN_005f5890(param_1_00 + 400);
    FUN_00425e80(&param_2,*(undefined4 *)(param_1_00 + 0x188),&DAT_00f72118,4);
    if (param_2 != **ppfVar1) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x3f) == 0) {
      FUN_004f68c0(*(undefined4 *)(param_1_00 + 0x18c),4);
    }
    FUN_00425e80(*ppfVar1,&param_3,*(undefined4 *)(param_1_00 + 0x18c),4);
    FUN_00425e80(*(undefined4 *)(param_1_00 + 0x188),&DAT_00f72118,*ppfVar1,4);
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x3ff) == 0) {
      uVar4 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x18c));
      *(undefined4 *)(param_1_00 + 0x18c) = uVar4;
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x1ff) == 0) {
      pfVar5 = (float *)FUN_0051c5d0(*ppfVar1);
      *ppfVar1 = pfVar5;
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x7ff) == 0) {
      uVar4 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x188));
      *(undefined4 *)(param_1_00 + 0x188) = uVar4;
    }
    FUN_005f58a0(param_1_00 + 400);
    fVar6 = (float10)FUN_005a4670(puVar2[3],puVar2[4],*(undefined4 *)(param_1_00 + 0x2b8));
    ppfVar1 = (float **)(param_1_00 + 0x28c);
    param_3 = (undefined4 *)(float)ABS(fVar6);
    FUN_005f5890(param_1_00 + 0x298);
    FUN_00425e80(&param_2,*(undefined4 *)(param_1_00 + 0x290),&DAT_00f72118,4);
    if (param_2 != **ppfVar1) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x3f) == 0) {
      FUN_004f68c0(*(undefined4 *)(param_1_00 + 0x294),4);
    }
    FUN_00425e80(*ppfVar1,&param_3,*(undefined4 *)(param_1_00 + 0x294),4);
    FUN_00425e80(*(undefined4 *)(param_1_00 + 0x290),&DAT_00f72118,*ppfVar1,4);
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x3ff) == 0) {
      uVar4 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x294));
      *(undefined4 *)(param_1_00 + 0x294) = uVar4;
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x1ff) == 0) {
      pfVar5 = (float *)FUN_0051c5d0(*ppfVar1);
      *ppfVar1 = pfVar5;
    }
    uVar3 = FUN_005cfcfc();
    if ((uVar3 & 0x7ff) == 0) {
      uVar4 = FUN_0051c5d0(*(undefined4 *)(param_1_00 + 0x290));
      *(undefined4 *)(param_1_00 + 0x290) = uVar4;
    }
    FUN_005f58a0(param_1_00 + 0x298);
    FUN_005f5890(param_1_00 + 0x26c);
    FUN_00425e80(&param_2,*(undefined4 *)(param_1_00 + 0x260),*(undefined4 *)(param_1_00 + 0x268),4)
    ;
    FUN_005f58a0(param_1_00 + 0x26c);
    param_3 = (undefined4 *)(DAT_00bdbcf8 - param_2);
    FUN_0051c3f0(&param_3);
    dVar7 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
    param_2 = (float)dVar7 * (float)_DAT_006ee728;
    FUN_0051c3f0(&param_2);
    dVar7 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
    param_2 = (float)dVar7 * (float)_DAT_006ef808;
    FUN_0051c3f0(&param_2);
    dVar7 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
    param_2 = ((float)puVar2[3] * _DAT_006ef640 + _DAT_006ea62c) * (float)dVar7;
    FUN_0051c3f0(&param_2);
    dVar7 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
    if ((double)(float)puVar2[6] < dVar7 == (NAN((double)(float)puVar2[6]) || NAN(dVar7))) {
      param_2 = 0.0;
    }
    else {
      param_2 = 2.802597e-45;
    }
    FUN_005a5620(&param_2);
    if ((char)param_1 != '\0') {
      dVar7 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
      if (dVar7 < _DAT_006f6f88 != (NAN(dVar7) || NAN(_DAT_006f6f88))) {
        dVar7 = rndUniform(*(uint *)(param_1_00 + 0x2b8));
        if ((double)(float)puVar2[6] < dVar7 == (NAN((double)(float)puVar2[6]) || NAN(dVar7))) {
          param_1 = 0;
        }
        else {
          param_1 = 2;
        }
        FUN_005a5620(&param_1);
      }
    }
    FUN_005f5890(param_1_00 + 0xbc);
    FUN_005a5820(&param_1,*(undefined4 *)(param_1_00 + 0xb0),*(undefined4 *)(param_1_00 + 0xb8),4);
    FUN_005f58a0(param_1_00 + 0xbc);
    FUN_0051c3f0(&DAT_006f6f64 + param_1 * 4);
  }
  return;
}

