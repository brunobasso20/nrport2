/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054c1c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0054c1c0(undefined4 *param_1_00,float param_1,float param_2)

{
  short sVar1;
  uint uVar2;
  undefined4 uVar3;
  int iVar4;
  float *pfVar5;
  undefined4 *puVar6;
  undefined4 *puVar7;
  float10 fVar8;
  float10 fVar9;
  undefined8 local_8;
  
  param_1_00[0x1b] = param_1;
  param_1_00[0x1c] = *(undefined4 *)(PTR_PTR_00734368 + (int)param_2 * 4);
  puVar6 = (undefined4 *)(*(int *)(PTR_PTR_00734368 + (int)param_2 * 4) + 0x24);
  puVar7 = param_1_00;
  for (iVar4 = 0x1b; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar7 = *puVar6;
    puVar6 = puVar6 + 1;
    puVar7 = puVar7 + 1;
  }
  param_2 = 0.0;
  sVar1 = FUN_0055a690();
  if (sVar1 == 7) {
    iVar4 = FUN_0055a730();
    if (iVar4 < 4) {
      param_2 = DAT_00e0b834 + _DAT_006ee580;
      goto LAB_0054c22b;
    }
  }
  param_2 = DAT_00e0b834 + _DAT_006ea68c;
LAB_0054c22b:
  param_2 = param_2 + _DAT_006ee350;
  puVar6 = param_1_00 + 0x1d;
  local_8 = (double)((ulonglong)local_8._4_4_ << 0x20);
  FUN_005f5890(param_1_00 + 0x20);
  param_1 = (float)(*(uint *)param_1_00[0x1e] ^ DAT_00f72118);
  if (param_1 != (float)*(uint *)*puVar6) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3f) == 0) {
    puVar7 = (undefined4 *)param_1_00[0x1f];
    uVar3 = FUN_005cfcfc();
    *puVar7 = uVar3;
  }
  FUN_00425e80(*puVar6,&local_8,param_1_00[0x1f],4);
  FUN_00425e80(param_1_00[0x1e],&DAT_00f72118,*puVar6,4);
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x1f]);
    param_1_00[0x1f] = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    uVar3 = FUN_0051c5d0(*puVar6);
    *puVar6 = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x1e]);
    param_1_00[0x1e] = uVar3;
  }
  FUN_005f58a0(param_1_00 + 0x20);
  puVar6 = param_1_00 + 0x28;
  local_8 = (double)((ulonglong)local_8 & 0xffffffff00000000);
  FUN_005f5890(param_1_00 + 0x2b);
  param_1 = (float)(*(uint *)param_1_00[0x29] ^ DAT_00f72118);
  if (param_1 != (float)*(uint *)*puVar6) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3f) == 0) {
    FUN_004f68c0(param_1_00[0x2a],4);
  }
  FUN_00425e80(*puVar6,&local_8,param_1_00[0x2a],4);
  FUN_00425e80(param_1_00[0x29],&DAT_00f72118,*puVar6,4);
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x2a]);
    param_1_00[0x2a] = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    uVar3 = FUN_0051c5d0(*puVar6);
    *puVar6 = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x29]);
    param_1_00[0x29] = uVar3;
  }
  FUN_005f58a0(param_1_00 + 0x2b);
  puVar6 = param_1_00 + 0x58;
  param_1_00[0x33] = 0x3f800000;
  param_1_00[0x34] = 0x3f800000;
  FUN_005f5890(param_1_00 + 0x5b);
  param_1 = (float)(*(uint *)param_1_00[0x59] ^ DAT_00f72118);
  if (param_1 != (float)*(uint *)*puVar6) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3f) == 0) {
    FUN_004f68c0(param_1_00[0x5a],4);
  }
  FUN_00425e80(*puVar6,&param_2,param_1_00[0x5a],4);
  FUN_00425e80(param_1_00[0x59],&DAT_00f72118,*puVar6,4);
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x5a]);
    param_1_00[0x5a] = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    uVar3 = FUN_0051c5d0(*puVar6);
    *puVar6 = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x59]);
    param_1_00[0x59] = uVar3;
  }
  FUN_005f58a0(param_1_00 + 0x5b);
  puVar6 = param_1_00 + 99;
  FUN_005f5890(param_1_00 + 0x66);
  FUN_00425e80(&param_1,param_1_00[100],&DAT_00f72118,4);
  if (param_1 != (float)*(uint *)*puVar6) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3f) == 0) {
    puVar7 = (undefined4 *)param_1_00[0x65];
    uVar3 = FUN_005cfcfc();
    *puVar7 = uVar3;
  }
  FUN_00425e80(*puVar6,&param_2,param_1_00[0x65],4);
  FUN_00425e80(param_1_00[100],&DAT_00f72118,*puVar6,4);
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x65]);
    param_1_00[0x65] = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    uVar3 = FUN_0051c5d0(*puVar6);
    *puVar6 = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[100]);
    param_1_00[100] = uVar3;
  }
  FUN_005f58a0(param_1_00 + 0x66);
  puVar6 = param_1_00 + 0x6e;
  FUN_005f5890(param_1_00 + 0x71);
  FUN_00425e80(&param_1,param_1_00[0x6f],&DAT_00f72118,4);
  if (param_1 != (float)*(uint *)*puVar6) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3f) == 0) {
    FUN_004f68c0(param_1_00[0x70],4);
  }
  FUN_00425e80(*puVar6,&param_2,param_1_00[0x70],4);
  FUN_00425e80(param_1_00[0x6f],&DAT_00f72118,*puVar6,4);
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x70]);
    param_1_00[0x70] = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    uVar3 = FUN_0051c5d0(*puVar6);
    *puVar6 = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x6f]);
    param_1_00[0x6f] = uVar3;
  }
  FUN_005f58a0(param_1_00 + 0x71);
  puVar6 = param_1_00 + 0x79;
  FUN_005f5890(param_1_00 + 0x7c);
  FUN_00425e80(&param_1,param_1_00[0x7a],&DAT_00f72118,4);
  if (param_1 != (float)*(uint *)*puVar6) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3f) == 0) {
    FUN_004f68c0(param_1_00[0x7b],4);
  }
  FUN_00425e80(*puVar6,&param_2,param_1_00[0x7b],4);
  FUN_00425e80(param_1_00[0x7a],&DAT_00f72118,*puVar6,4);
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x7b]);
    param_1_00[0x7b] = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    uVar3 = FUN_0051c5d0(*puVar6);
    *puVar6 = uVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    uVar3 = FUN_0051c5d0(param_1_00[0x7a]);
    param_1_00[0x7a] = uVar3;
  }
  FUN_005f58a0(param_1_00 + 0x7c);
  FUN_0051c3f0(&param_2);
  FUN_0051c3f0(&param_2);
  *(undefined1 *)(param_1_00 + 0x28e) = 0;
  param_1 = 295.0;
  FUN_0051c3f0(&param_1);
  param_1_00[0xbd] = 0xc1fb3333;
  param_1_00[0xbe] = 0x40a00000;
  param_1_00[0xbf] = 0x139;
  param_1 = 0.0;
  pfVar5 = (float *)(param_1_00 + 0xc0);
  do {
    iVar4 = (int)param_1;
    fVar8 = (float10)FUN_006c5c40();
    param_1 = (float)(iVar4 + 1);
    *pfVar5 = (float)((float10)_DAT_006e97d8 / (fVar8 + (float10)_DAT_006e97d8));
    pfVar5 = pfVar5 + 1;
  } while ((int)param_1 < 0x13b);
  param_1_00[0xc0] = param_1_00[0xc1];
  param_1_00[0x1f9] = param_1_00[0x1fa];
  param_1_00[0x1fb] = 0;
  param_1_00[0x1fc] = 0x3e800000;
  param_1_00[0x1fd] = 0x1b;
  param_1 = 0.0;
  pfVar5 = (float *)(param_1_00 + 0x1fe);
  do {
    fVar8 = (float10)(int)param_1;
    param_1 = (float)((int)param_1 + 1);
    fVar8 = (float10)log2(fVar8 * (float10)_DAT_006e9804 + (float10)_DAT_006e97d8);
    *pfVar5 = (float)((float10)0.3010299956639812 * fVar8 * (float10)(float)param_1_00[10] +
                     (float10)_DAT_006e97d8);
    pfVar5 = pfVar5 + 1;
  } while ((int)param_1 < 0x1d);
  param_1_00[0x21b] = 0;
  param_1_00[0x219] = param_1_00[0x21a];
  param_1_00[0x21c] = 0x3e800000;
  param_1_00[0x21d] = 0x1b;
  param_1 = 0.0;
  pfVar5 = (float *)(param_1_00 + 0x21e);
  do {
    fVar8 = (float10)(int)param_1;
    param_1 = (float)((int)param_1 + 1);
    fVar9 = (float10)1.4426950408889634 *
            ((float10)_DAT_006ea4a8 / (float10)(float)param_1_00[9]) *
            fVar8 * (float10)_DAT_006e9804;
    fVar8 = ROUND(fVar9);
    fVar9 = (float10)f2xm1(fVar9 - fVar8);
    fVar8 = (float10)fscale((float10)1 + fVar9,fVar8);
    *pfVar5 = (float)fVar8;
    pfVar5 = pfVar5 + 1;
  } while ((int)param_1 < 0x1d);
  param_1_00[0x239] = param_1_00[0x23a];
  param_1_00[0x23b] = 0;
  param_1_00[0x23c] = 0x41000000;
  param_1_00[0x23d] = 0x1b;
  param_1 = 0.0;
  pfVar5 = (float *)(param_1_00 + 0x23e);
  do {
    fVar8 = (float10)(int)param_1;
    param_1 = (float)((int)param_1 + 1);
    fVar9 = (float10)1.4426950408889634 * ((float10)_DAT_006e97d8 - fVar8 * (float10)_DAT_006f4614);
    fVar8 = ROUND(fVar9);
    fVar9 = (float10)f2xm1(fVar9 - fVar8);
    fVar8 = (float10)fscale((float10)1 + fVar9,fVar8);
    *pfVar5 = (float)((float10)_DAT_006f58a0 * (float10)(float)param_1_00[0xe] *
                      (float10)_DAT_006f58e4 * fVar8);
    pfVar5 = pfVar5 + 1;
  } while ((int)param_1 < 0x1d);
  param_1_00[0x25b] = 0;
  param_1_00[0x259] = param_1_00[0x25a];
  param_1_00[0x25c] = 0x3a83126f;
  param_1_00[0x25d] = 0x1b;
  fVar8 = (float10)FUN_006c5c40();
  local_8 = (double)fVar8;
  fVar8 = (float10)FUN_006c5c40();
  fVar8 = fVar8 * (float10)(float)param_1_00[0xc];
  pfVar5 = (float *)(param_1_00 + 0x261);
  param_1 = 4.2039e-45;
  param_1_00[0x25e] = (float)((float10)local_8 - (float10)_DAT_006ecfe8 * fVar8);
  param_1_00[0x25f] = (float)((float10)local_8 - (float10)_DAT_006ea668 * fVar8);
  param_1_00[0x260] = (float)((float10)local_8 - fVar8 * (float10)_DAT_006ef6d0);
  do {
    iVar4 = (int)param_1;
    fVar8 = (float10)FUN_006c5c40();
    *pfVar5 = (float)fVar8;
    param_1 = (float)(iVar4 + 1);
    pfVar5 = pfVar5 + 1;
  } while ((int)param_1 < 0x1d);
  param_1_00[0x279] = param_1_00[0x27a];
  param_1 = _DAT_0074fd74 / (float)param_1_00[0xb];
  FUN_0051c3f0(&param_1);
  param_1 = _DAT_006e97d8 / (float)param_1_00[0xf];
  FUN_0051c3f0(&param_1);
  return;
}


