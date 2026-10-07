/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00530110 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00530110(float *param_1_00,float param_1)

{
  float fVar1;
  float fVar2;
  int iVar3;
  char cVar4;
  float fVar5;
  int iVar6;
  float unaff_EBX;
  float unaff_EBP;
  float unaff_ESI;
  float unaff_EDI;
  float10 fVar7;
  float10 fVar8;
  float local_14;
  float local_10;
  float local_c;
  float fStack_8;
  float fStack_4;
  
  iVar3 = (int)param_1;
  fVar1 = param_1_00[4];
  *(undefined4 *)((int)param_1_00 + 0x4d) = 0;
  *(undefined4 *)((int)param_1_00 + 0x49) = 0;
  if (fVar1 == 0.0) {
    return;
  }
  fVar2 = param_1_00[7];
  if (*(int *)((int)fVar2 + 4) == 0) goto LAB_00530b76;
  fVar5 = param_1_00[5];
  local_14 = _DAT_0074b2d8 * *(float *)((int)param_1 + 0x1bee);
  if (fVar1 == 8.40779e-45) {
    if (((*(uint *)((int)fVar2 + 0x139f) & 0x200) == 0) ||
       ((*(uint *)((int)param_1 + 0x139f) & 0x200) != 0)) {
      local_14 = 2.5;
    }
    fVar5 = param_1_00[6];
  }
  switch(fVar5) {
  case 0.0:
  case 1.4013e-45:
    if ((((fVar1 == 8.40779e-45) || (fVar1 == 5.60519e-45)) &&
        ((*(uint *)((int)fVar2 + 0x139f) & 0x200) != 0)) &&
       ((*(uint *)((int)param_1 + 0x139f) & 0x200) == 0)) {
      cVar4 = FUN_004fffa0();
      if (cVar4 == '\0') {
        fVar1 = *param_1_00 - local_14;
        if (_DAT_006ea454 < *param_1_00 - local_14) {
          fVar1 = _DAT_006ea454;
        }
        fVar1 = -fVar1;
        goto LAB_005304e4;
      }
      fVar1 = local_14 + param_1_00[1];
      if (local_14 + param_1_00[1] < _DAT_006ea454) {
        fVar1 = _DAT_006ea454;
      }
      goto LAB_00530863;
    }
    break;
  case 2.8026e-45:
    iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar6 != *(int *)((int)fVar2 + 0x1bce)) {
      FUN_0052bf80(param_1);
    }
    fVar1 = *(float *)((int)fVar2 + 0x1bd2);
    *(float *)((int)param_1_00 + 0x49) = fVar1;
    if (fVar1 < *(float *)((int)param_1 + 0x1bad)) {
      fVar1 = *(float *)((int)param_1 + 0x1bad);
    }
    *(float *)((int)param_1 + 0x1bad) = fVar1;
    fVar1 = param_1_00[7];
    iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar6 != *(int *)((int)fVar1 + 0x1bce)) {
      FUN_0052bf80(param_1);
    }
    fVar1 = *(float *)((int)fVar1 + 0x1bd6);
    goto LAB_00530863;
  case 4.2039e-45:
    fVar5 = local_14 + local_14;
    fVar1 = *(float *)((int)fVar2 + 0x18f2);
    iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar6 != *(int *)((int)fVar2 + 0x1bce)) {
      FUN_0052bf80(param_1);
    }
    fVar1 = *(float *)((int)fVar2 + 0x1bd2) + fVar5 + fVar1;
    goto LAB_005304e4;
  case 5.60519e-45:
    fVar5 = local_14 + local_14;
    fVar1 = *(float *)((int)fVar2 + 0x18f2);
    iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar6 != *(int *)((int)fVar2 + 0x1bce)) {
      FUN_0052bf80(param_1);
    }
    fVar1 = *(float *)((int)fVar2 + 0x1bd6) + fVar5 + fVar1;
    goto LAB_00530863;
  case 7.00649e-45:
  case 9.80909e-45:
    fVar5 = *(float *)((int)fVar2 + 0x186e);
    fVar1 = (param_1_00[0xe] + _DAT_006e97d8) * *(float *)((int)fVar2 + 0x18f2) * _DAT_006ea44c;
    fVar7 = (float10)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x40))(param_1,fVar5);
    local_10 = (float)fVar7;
    local_c = *(float *)((int)param_1 + 0x16f6) * _DAT_006ea44c;
    fVar7 = (float10)FUN_00516d3a(*(undefined4 *)((int)param_1 + 0x186a),
                                  *(undefined4 *)((int)param_1_00[7] + 0x186a));
    fVar7 = fVar7 * (float10)_DAT_006f5270 + (float10)_DAT_006ea44c;
    if (fVar7 <= (float10)_DAT_006e97d8) {
      if (fVar7 < (float10)_DAT_006ea504) {
        fVar7 = (float10)_DAT_006ea504;
      }
    }
    else {
      fVar7 = (float10)_DAT_006e97d8;
    }
    fVar2 = param_1_00[7];
    fStack_4 = (float)(((float10)_DAT_006ed070 - (float10)local_c * (float10)_DAT_006ea44c) * fVar7
                       * (float10)unaff_EBP * (float10)_DAT_006ed070 + (float10)fStack_4);
    if (*(float *)((int)fVar2 + 0x188a) < *(float *)((int)param_1 + 0x188a)) {
      fVar8 = ((float10)*(float *)((int)fVar2 + 0x1886) - (float10)*(float *)((int)param_1 + 0x1886)
              ) - ((float10)*(float *)((int)fVar2 + 0x18f2) +
                  (float10)*(float *)((int)param_1 + 0x18f2)) * (float10)_DAT_006ea44c;
      if (fVar8 < (float10)_DAT_006e97d8) {
        fVar8 = (float10)_DAT_006e97d8;
      }
      fVar7 = ((float10)*(float *)((int)param_1 + 0x188a) - (float10)*(float *)((int)fVar2 + 0x188a)
              ) * ((float10)_DAT_006ea628 - (float10)local_c * (float10)_DAT_006e9804) *
                  ((float10)_DAT_006e97d8 / SQRT(fVar8)) * fVar7 * (float10)_DAT_006f410c;
      local_c = _DAT_006ea62c - local_c;
      if ((float10)local_c < fVar7) {
        fVar7 = (float10)local_c;
      }
      fStack_4 = (float)(fVar7 + (float10)fStack_4);
    }
    (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x48))
              (param_1,*(undefined4 *)((int)fVar2 + 0x186e),&local_14,&stack0xffffffe8);
    fVar7 = (float10)FUN_006c5c40();
    fVar2 = param_1_00[7];
    local_14 = (float)((float10)local_14 / (fVar7 * (float10)unaff_EDI - (float10)fVar5));
    iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar6 != *(int *)((int)fVar2 + 0x1bce)) {
      FUN_0052bf80(param_1);
    }
    fVar5 = param_1_00[7];
    *(float *)((int)param_1_00 + 0x49) = *(float *)((int)fVar2 + 0x1bd2) + unaff_EBX;
    iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar6 != *(int *)((int)fVar5 + 0x1bda)) {
      FUN_0052c010(param_1);
    }
    fVar2 = _DAT_006ea454;
    fVar1 = (fStack_8 - *(float *)((int)fVar5 + 0x1be2)) + fVar1;
    if (*(float *)((int)param_1_00 + 0x49) < fVar1) {
      fVar1 = *(float *)((int)param_1_00 + 0x49);
    }
    *(float *)((int)param_1_00 + 0x49) = fVar1;
    if (fVar1 <= fVar2) {
      fVar1 = _DAT_006ea454;
    }
LAB_005304e4:
    *(float *)((int)param_1_00 + 0x49) = fVar1;
    if (*(float *)((int)param_1 + 0x1bad) <= fVar1) {
LAB_005305ea:
      *(float *)(iVar3 + 0x1bad) = fVar1;
    }
    else {
      *(float *)((int)param_1 + 0x1bad) = *(float *)((int)param_1 + 0x1bad);
    }
    break;
  case 8.40779e-45:
  case 1.12104e-44:
    fVar5 = *(float *)((int)fVar2 + 0x186e);
    fVar1 = (param_1_00[0xe] + _DAT_006e97d8) * *(float *)((int)fVar2 + 0x18f2) * _DAT_006ea44c;
    fVar7 = (float10)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x40))(param_1,fVar5);
    local_10 = (float)fVar7;
    local_c = *(float *)((int)param_1 + 0x16f6) * _DAT_006ea44c;
    fVar7 = (float10)FUN_00516d3a(*(undefined4 *)((int)param_1 + 0x186a),
                                  *(undefined4 *)((int)param_1_00[7] + 0x186a));
    fVar7 = fVar7 * (float10)_DAT_006f5270 + (float10)_DAT_006ea44c;
    if (fVar7 <= (float10)_DAT_006e97d8) {
      if (fVar7 < (float10)_DAT_006ea504) {
        fVar7 = (float10)_DAT_006ea504;
      }
    }
    else {
      fVar7 = (float10)_DAT_006e97d8;
    }
    fVar2 = param_1_00[7];
    fStack_4 = (float)(((float10)_DAT_006ed070 - (float10)local_c * (float10)_DAT_006ea44c) * fVar7
                       * (float10)unaff_EBP * (float10)_DAT_006ed070 + (float10)fStack_4);
    if (*(float *)((int)param_1 + 0x188a) < *(float *)((int)fVar2 + 0x188a)) {
      fVar8 = ((float10)*(float *)((int)param_1 + 0x1886) - (float10)*(float *)((int)fVar2 + 0x1886)
              ) - ((float10)*(float *)((int)fVar2 + 0x18f2) +
                  (float10)*(float *)((int)param_1 + 0x18f2)) * (float10)_DAT_006ea44c;
      if (fVar8 < (float10)_DAT_006e97d8) {
        fVar8 = (float10)_DAT_006e97d8;
      }
      fVar7 = ((float10)*(float *)((int)param_1 + 0x188a) - (float10)*(float *)((int)fVar2 + 0x188a)
              ) * ((float10)_DAT_006ea628 - (float10)local_c * (float10)_DAT_006e9804) *
                  ((float10)_DAT_006e97d8 / SQRT(fVar8)) * fVar7 * (float10)_DAT_006f4168;
      local_c = _DAT_006ea62c - local_c;
      if ((float10)local_c < fVar7) {
        fVar7 = (float10)local_c;
      }
      fStack_4 = (float)(fVar7 + (float10)fStack_4);
    }
    (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x48))
              (param_1,*(undefined4 *)((int)fVar2 + 0x186e),&local_14,&stack0xffffffe8);
    fVar7 = (float10)FUN_006c5c40();
    fVar2 = param_1_00[7];
    local_14 = (float)((float10)local_14 / ((float10)unaff_EDI - fVar7 * (float10)fVar5));
    iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar6 != *(int *)((int)fVar2 + 0x1bce)) {
      FUN_0052bf80(param_1);
    }
    fVar5 = param_1_00[7];
    *(float *)((int)param_1_00 + 0x4d) = *(float *)((int)fVar2 + 0x1bd6) + unaff_EBX;
    iVar6 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar6 != *(int *)((int)fVar5 + 0x1bda)) {
      FUN_0052c010(param_1);
    }
    fVar2 = _DAT_006ea454;
    fVar1 = (fStack_8 - *(float *)((int)fVar5 + 0x1bde)) + fVar1;
    if (*(float *)((int)param_1_00 + 0x4d) < fVar1) {
      fVar1 = *(float *)((int)param_1_00 + 0x4d);
    }
    *(float *)((int)param_1_00 + 0x4d) = fVar1;
    if (fVar1 <= fVar2) {
      fVar1 = _DAT_006ea454;
    }
LAB_00530863:
    *(float *)((int)param_1_00 + 0x4d) = fVar1;
    param_1 = *(float *)((int)param_1 + 0x1bb1);
    if (fVar1 < param_1) {
LAB_00530954:
      fVar1 = param_1;
    }
LAB_0053095a:
    *(float *)(iVar3 + 0x1bb1) = fVar1;
    break;
  case 1.26117e-44:
    param_1 = *param_1_00 - local_14;
    if (param_1 <= _DAT_006ea454) {
      if ((_DAT_006ea488 < param_1_00[8]) &&
         (param_1 = (_DAT_006f5264 - param_1_00[8]) * param_1 * _DAT_006f5260,
         _DAT_006ea454 < param_1)) {
        param_1 = 0.0;
      }
      (**(code **)(**(int **)(iVar3 + 0x13b3) + 0x48))(iVar3,param_1_00[10],&local_c,&local_10);
      local_c = local_c / unaff_ESI;
      fVar7 = (float10)(**(code **)(**(int **)(iVar3 + 0x13b3) + 0x40))
                                 (iVar3,*(undefined4 *)((int)param_1_00[7] + 0x186e));
      if (fVar7 < (float10)param_1) {
        param_1 = (float)fVar7;
      }
    }
    else {
      param_1 = 0.0;
    }
    *(float *)((int)param_1_00 + 0x49) = param_1;
    fVar1 = *(float *)(iVar3 + 0x1bad);
    if (*(float *)(iVar3 + 0x1bad) <= param_1) {
      fVar1 = param_1;
    }
    goto LAB_005305ea;
  case 1.4013e-44:
    param_1 = local_14 + param_1_00[1];
    if (_DAT_006ea454 <= param_1) {
      if ((_DAT_006ea488 < param_1_00[8]) &&
         (param_1 = (_DAT_006f5264 - param_1_00[8]) * param_1 * _DAT_006f5260,
         param_1 < _DAT_006ea454)) {
        param_1 = 0.0;
      }
      (**(code **)(**(int **)(iVar3 + 0x13b3) + 0x48))(iVar3,param_1_00[0xb],&local_c,&local_10);
      local_c = local_c / unaff_EBP;
      fVar7 = (float10)(**(code **)(**(int **)(iVar3 + 0x13b3) + 0x40))
                                 (iVar3,*(undefined4 *)((int)param_1_00[7] + 0x186e));
      if (fVar7 < (float10)param_1) {
        param_1 = (float)fVar7;
      }
    }
    else {
      param_1 = 0.0;
    }
    *(float *)((int)param_1_00 + 0x4d) = param_1;
    fVar1 = *(float *)(iVar3 + 0x1bb1);
    if (*(float *)(iVar3 + 0x1bb1) <= param_1) goto LAB_00530954;
    goto LAB_0053095a;
  }
  switch(param_1_00[4]) {
  case 1.4013e-45:
  case 2.8026e-45:
    if ((((uint)param_1_00[0x12] & 0x10) != 0) &&
       (fVar7 = (float10)FUN_0052b290(iVar3,param_1_00[7],_DAT_0074b260 * _DAT_006ea448),
       fVar7 < (float10)*(float *)(iVar3 + 0x1b75))) {
      *(float *)(iVar3 + 0x1b75) = (float)fVar7;
      return;
    }
    break;
  case 4.2039e-45:
    fVar1 = param_1_00[5];
    if (((fVar1 != 0.0) && (fVar1 != 1.4013e-45)) && (fVar1 != 2.8026e-45)) {
      return;
    }
    fVar7 = (float10)FUN_0052ac80(iVar3,param_1_00[7],_DAT_0074b290 * _DAT_006ea448);
    goto LAB_00530a79;
  case 5.60519e-45:
  case 8.40779e-45:
    if ((((((uint)param_1_00[0x12] & 0x10) != 0) || (fVar1 = param_1_00[5], fVar1 == 0.0)) ||
        (fVar1 == 1.4013e-45)) ||
       ((fVar1 == 2.8026e-45 || (cVar4 = FUN_0052a960(iVar3,param_1_00[7]), cVar4 != '\0')))) {
      param_1 = *(float *)(iVar3 + 0x1be6);
      if (param_1_00[5] == 1.4013e-45) {
        fVar1 = _DAT_006e97d8 - *(float *)((int)param_1_00 + 0x51);
        param_1 = (_DAT_006e97d8 - fVar1 * fVar1) * param_1;
      }
      fVar7 = (float10)FUN_0052b290(iVar3,param_1_00[7],param_1);
      if (fVar7 < (float10)*(float *)(iVar3 + 0x1b75)) {
        *(float *)(iVar3 + 0x1b75) = (float)fVar7;
        return;
      }
    }
    break;
  case 7.00649e-45:
    if ((((uint)param_1_00[0x12] & 0x10) != 0) ||
       ((cVar4 = (**(code **)(**(int **)(iVar3 + 0x13a7) + 0x44))(), cVar4 != '\0' &&
        (fVar7 = (float10)FUN_004fff80(), fVar7 < (float10)*(float *)(iVar3 + 0x1872))))) {
      fVar7 = (float10)FUN_0052b3d0(iVar3,param_1_00[7],_DAT_0074b260 * _DAT_006ea448);
    }
    else if ((param_1_00[5] != 0.0) || (*(float *)(iVar3 + 0x1872) <= _DAT_0074b080 * _DAT_006e9810)
            ) {
      fVar7 = (float10)FUN_0052b120(iVar3,param_1_00[7],_DAT_0074b260 * _DAT_006ea448);
    }
    else {
      fVar7 = (float10)FUN_0052b290(iVar3,param_1_00[7],*(undefined4 *)(iVar3 + 0x1be6));
    }
LAB_00530a79:
    if (fVar7 < (float10)*(float *)(iVar3 + 0x1b75)) {
      *(float *)(iVar3 + 0x1b75) = (float)fVar7;
    }
    if (fVar7 < (float10)*(float *)(iVar3 + 0x1b79)) {
      *(float *)(iVar3 + 0x1b79) = (float)fVar7;
      return;
    }
    break;
  case 9.80909e-45:
    fVar7 = (float10)FUN_0052b120(iVar3,param_1_00[7],param_1_00[3]);
    param_1 = (float)fVar7;
    if (((param_1_00[5] == 0.0) && (param_1_00[7] != DAT_00760b38)) &&
       ((fVar7 = (float10)FUN_00516daa(*(undefined4 *)(iVar3 + 0x186a),
                                       *(undefined4 *)((int)param_1_00[7] + 0x186a)),
        fVar7 < (float10)_DAT_006f1624 &&
        (((_DAT_0074b080 + _DAT_006ea478) * _DAT_006e9810 < *(float *)(iVar3 + 0x1872) &&
         (fVar7 = (float10)FUN_0052ac80(iVar3,param_1_00[7],0x40b27f1c), fVar7 < (float10)param_1)))
        ))) {
      param_1 = (float)fVar7;
    }
    if (param_1 < *(float *)(iVar3 + 0x1b75)) {
      *(float *)(iVar3 + 0x1b75) = param_1;
    }
    if (param_1 < *(float *)(iVar3 + 0x1b79)) {
      *(float *)(iVar3 + 0x1b79) = param_1;
    }
LAB_00530b76:
    param_1_00[2] = 0.0;
    param_1_00[1] = 0.0;
    *param_1_00 = 0.0;
    param_1_00[3] = 0.0;
    param_1_00[4] = 0.0;
    param_1_00[5] = 0.0;
    param_1_00[6] = 0.0;
    param_1_00[7] = 0.0;
    param_1_00[8] = 0.0;
    param_1_00[9] = 0.0;
    *(byte *)(param_1_00 + 0x12) = *(byte *)(param_1_00 + 0x12) & 0xef;
    return;
  }
  return;
}


