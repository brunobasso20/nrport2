/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00530ca0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00530ca0(float *param_1_00,float param_1)

{
  float fVar1;
  float fVar2;
  char cVar3;
  float fVar4;
  int iVar5;
  int *piVar6;
  float fVar7;
  int iVar8;
  float unaff_EBP;
  float unaff_ESI;
  float10 fVar9;
  undefined1 auStack_4c [4];
  float fStack_48;
  float fStack_44;
  float fStack_40;
  float fStack_3c;
  float fStack_38;
  float fStack_34;
  float fStack_30;
  float fStack_2c;
  
  if (param_1_00[4] == 0.0) {
    return;
  }
  fStack_2c = param_1_00[7];
  if (*(int *)((int)fStack_2c + 4) == 0) {
LAB_00531689:
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
  fStack_30 = 7.626937e-39;
  cVar3 = FUN_0052bee0();
  if (cVar3 == '\0') goto LAB_00531689;
  fStack_2c = *(float *)((int)param_1_00[7] + 0x186a);
  fStack_30 = param_1;
  fStack_34 = 7.626979e-39;
  fVar9 = (float10)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x3c))();
  param_1_00[0xc] = (float)fVar9;
  fStack_34 = *(float *)((int)param_1_00[7] + 0x186a);
  fStack_38 = *(float *)((int)param_1 + 0x186a);
  fStack_3c = 7.627014e-39;
  fVar9 = (float10)FUN_00516d3a();
  fVar1 = _DAT_006f527c;
  fVar4 = ABS((float)fVar9);
  fVar7 = _DAT_006ea454;
  if ((_DAT_006ecfc8 <= fVar4) && (fVar7 = _DAT_006e97d8, fVar4 < _DAT_006f51a4)) {
    fVar7 = (fVar4 - _DAT_006ecfc8) * _DAT_006f51a0;
  }
  fVar4 = param_1_00[7];
  fVar7 = fVar7 * param_1_00[0xc] +
          (_DAT_006e97d8 - fVar7) *
          (*(float *)((int)fVar4 + 0x1ac2) + *(float *)((int)param_1 + 0x1ac2)) * (float)fVar9 *
          _DAT_006ea44c;
  param_1_00[0xc] = fVar7;
  if (fVar7 <= fVar1) {
    if (_DAT_006f5274 <= fVar7) {
      param_1_00[8] = 0.0;
      param_1_00[9] = *(float *)((int)param_1 + 0x186a);
    }
    else {
      fVar1 = (*(float *)((int)param_1 + 0x1872) - *(float *)((int)fVar4 + 0x1872)) - _DAT_006f4988;
      if (_DAT_006ea454 <= fVar1) {
        param_1_00[8] = DAT_006f5254;
        fStack_34 = DAT_006f5254 * *(float *)((int)fVar4 + 0x1872) + *(float *)((int)fVar4 + 0x186a)
        ;
        fStack_38 = 7.628002e-39;
        fVar9 = (float10)FUN_0051700a();
        param_1_00[9] = (float)fVar9;
        fVar7 = *(float *)((int)param_1_00[7] + 0x1872);
        if (fVar7 < _DAT_006ea454) {
          fVar7 = _DAT_006ea454;
        }
        fStack_34 = fVar7 * (param_1_00[8] - _DAT_006f5150) +
                    *(float *)((int)param_1_00[7] + 0x186a);
      }
      else {
        fVar1 = (fVar7 + _DAT_006f527c) / fVar1;
        param_1_00[8] = fVar1;
        if (DAT_006f5254 < fVar1) {
          param_1_00[8] = DAT_006f5254;
        }
        fStack_34 = param_1_00[8] * *(float *)((int)param_1 + 0x1872) +
                    *(float *)((int)param_1 + 0x186a);
        fStack_38 = 7.627822e-39;
        fVar9 = (float10)FUN_0051700a();
        param_1_00[9] = (float)fVar9;
        fVar7 = param_1_00[8] - _DAT_006f5150;
        if (param_1_00[8] - _DAT_006f5150 < _DAT_006ea454) {
          fVar7 = _DAT_006ea454;
        }
        fVar1 = *(float *)((int)param_1 + 0x1872);
        if (*(float *)((int)param_1 + 0x1872) < _DAT_006ea454) {
          fVar1 = _DAT_006ea454;
        }
        fStack_34 = fVar1 * fVar7 + *(float *)((int)param_1 + 0x186a);
      }
      fStack_38 = 7.627937e-39;
      FUN_0051700a();
    }
  }
  else {
    fVar1 = (*(float *)((int)param_1 + 0x1872) - *(float *)((int)fVar4 + 0x1872)) + _DAT_006efe48;
    if (fVar1 <= _DAT_006ea454) {
      param_1_00[8] = DAT_006f5254;
      fStack_34 = *(float *)((int)param_1 + 0x1872) * _DAT_006ee5e0 +
                  *(float *)((int)param_1 + 0x186a);
      fStack_38 = 7.627618e-39;
      fVar9 = (float10)FUN_0051700a();
      param_1_00[9] = (float)fVar9;
      fStack_38 = *(float *)((int)param_1 + 0x186a);
      fStack_3c = 7.627639e-39;
      FUN_0051700a();
    }
    else {
      fVar7 = (fVar7 - _DAT_006f527c) / fVar1;
      param_1_00[8] = fVar7;
      if (DAT_006f5254 < fVar7) {
        param_1_00[8] = DAT_006f5254;
      }
      fVar7 = fVar1 * _DAT_006f5278 + _DAT_006ee5e0;
      if (param_1_00[8] < fVar7) {
        fVar7 = param_1_00[8];
      }
      fStack_34 = fVar7 * *(float *)((int)fVar4 + 0x1872) + *(float *)((int)fVar4 + 0x186a);
      fStack_38 = 7.62743e-39;
      fVar9 = (float10)FUN_0051700a();
      param_1_00[9] = (float)fVar9;
      fVar7 = param_1_00[8] - _DAT_006f5150;
      fVar1 = _DAT_006f5150;
      if ((fVar7 <= _DAT_006f5150) && (fVar1 = fVar7, fVar7 < _DAT_006ea454)) {
        fVar1 = _DAT_006ea454;
      }
      fStack_34 = fVar1 * *(float *)((int)param_1_00[7] + 0x1872) +
                  *(float *)((int)param_1_00[7] + 0x186a);
      fStack_38 = 7.627549e-39;
      FUN_0051700a();
    }
  }
  fVar7 = param_1_00[7];
  fStack_34 = param_1;
  fVar1 = (*(float *)((int)fVar7 + 0x18f2) + _DAT_006ef678) * _DAT_006ea44c;
  fStack_38 = 7.628191e-39;
  iVar5 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))();
  if (iVar5 != *(int *)((int)fVar7 + 0x1bce)) {
    fStack_38 = param_1;
    fStack_3c = 7.628213e-39;
    FUN_0052bf80();
  }
  fVar7 = param_1_00[7];
  fStack_38 = param_1;
  fStack_3c = 7.628248e-39;
  iVar5 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))();
  if (iVar5 != *(int *)((int)fVar7 + 0x1bce)) {
    fStack_3c = param_1;
    fStack_40 = 7.628271e-39;
    FUN_0052bf80();
  }
  fStack_3c = param_1;
  fStack_40 = 7.628302e-39;
  piVar6 = (int *)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))();
  fStack_40 = param_1;
  fStack_44 = 7.628321e-39;
  (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))();
  fStack_48 = fVar1;
  fStack_44 = unaff_ESI;
  fVar9 = (float10)(**(code **)(*piVar6 + 0x18))(param_1_00[7]);
  fVar9 = fVar9 - (float10)fStack_30;
  param_1_00[0xb] = unaff_EBP;
  param_1_00[10] = unaff_EBP;
  param_1_00[1] = (float)((float10)fStack_3c + fVar9);
  *param_1_00 = (float)(fVar9 - (float10)fStack_3c);
  param_1_00[2] = (float)fVar9;
  if (_DAT_006e97d8 <= ABS(fStack_38 - param_1_00[9])) {
    fStack_2c = _DAT_00bdaf68 * fStack_38;
    fStack_30 = (float)(int)ROUND(fStack_2c);
    fVar7 = param_1_00[7];
    iVar5 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar5 != *(int *)((int)fVar7 + 0x1bce)) {
      FUN_0052bf80(param_1);
    }
    fStack_30 = *(float *)((int)fVar7 + 0x1bd6);
    fVar7 = param_1_00[7];
    iVar5 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    if (iVar5 != *(int *)((int)fVar7 + 0x1bce)) {
      FUN_0052bf80(param_1);
    }
    fStack_3c = *(float *)((int)fVar7 + 0x1bd2);
    piVar6 = (int *)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    iVar5 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
    fVar7 = fStack_40;
    fStack_40 = *(float *)(*(int *)(iVar5 + 0xc) + 0x14 + (int)fStack_40 * 0x1c);
    fVar9 = (float10)(**(code **)(*piVar6 + 0x18))(param_1_00[7],fVar7,fStack_44,fStack_3c);
    fVar9 = fVar9 - (float10)fStack_30;
    if ((float10)param_1_00[1] < (float10)fStack_3c + fVar9) {
      param_1_00[1] = (float)((float10)fStack_3c + fVar9);
      param_1_00[0xb] = fVar7;
    }
    if (fVar9 - (float10)fStack_3c < (float10)*param_1_00) {
      *param_1_00 = (float)(fVar9 - (float10)fStack_3c);
      param_1_00[10] = fVar7;
    }
    param_1_00[2] = (float)fVar9;
  }
  fVar7 = param_1_00[5];
  if (param_1_00[4] == 8.40779e-45) {
    fVar7 = param_1_00[6];
  }
  switch(fVar7) {
  case 4.2039e-45:
  case 1.26117e-44:
    if (param_1_00[8] <= _DAT_006e97d8) goto switchD_00531217_caseD_5;
    break;
  case 5.60519e-45:
  case 1.4013e-44:
    if (param_1_00[8] <= _DAT_006e97d8) goto switchD_00531217_caseD_6;
    break;
  case 7.00649e-45:
switchD_00531217_caseD_5:
    piVar6 = *(int **)((int)param_1 + 0x13b3);
    fStack_3c = *(float *)((int)param_1_00[7] + 0x18f2);
    iVar5 = (**(code **)(*piVar6 + 0x4c))(param_1);
    fVar7 = param_1_00[7];
    fStack_30 = *(float *)(*(int *)(iVar5 + 0xc) + 0x14 + *(int *)((int)param_1 + 0x186e) * 0x1c);
    fVar9 = (float10)(**(code **)(*piVar6 + 0x1c))(param_1,*(undefined4 *)((int)fVar7 + 0x186e));
    fVar9 = ((float10)*(float *)((int)fVar7 + 0x188a) - fVar9) * (float10)_DAT_006ee5e0 +
            (float10)*(float *)((int)param_1_00[7] + 0x1886);
    goto LAB_00531290;
  case 8.40779e-45:
switchD_00531217_caseD_6:
    piVar6 = *(int **)((int)param_1 + 0x13b3);
    fStack_3c = *(float *)((int)param_1_00[7] + 0x18f2);
    iVar5 = (**(code **)(*piVar6 + 0x4c))(param_1);
    fVar7 = param_1_00[7];
    fStack_30 = *(float *)(*(int *)(iVar5 + 0xc) + 0x14 + *(int *)((int)param_1 + 0x186e) * 0x1c);
    fVar9 = (float10)(**(code **)(*piVar6 + 0x1c))(param_1,*(undefined4 *)((int)fVar7 + 0x186e));
    fVar9 = ((float10)*(float *)((int)fVar7 + 0x188a) - fVar9) * (float10)_DAT_006ee5e0 +
            (float10)*(float *)((int)param_1_00[7] + 0x1886);
    goto LAB_005313f9;
  case 9.80909e-45:
    piVar6 = *(int **)((int)param_1 + 0x13b3);
    fStack_3c = *(float *)((int)param_1_00[7] + 0x18f2);
    iVar8 = (**(code **)(*piVar6 + 0x4c))(param_1);
    fVar7 = param_1_00[7];
    iVar5 = *(int *)((int)fVar7 + 0x186e);
    fStack_30 = *(float *)(*(int *)(iVar8 + 0xc) + 0x14 + iVar5 * 0x1c);
    fVar9 = (float10)(**(code **)(*piVar6 + 0x1c))(param_1,iVar5);
    fVar9 = ((float10)*(float *)((int)fVar7 + 0x188a) - fVar9) * (float10)_DAT_006ee5e0 +
            (float10)*(float *)((int)param_1_00[7] + 0x1886);
LAB_00531290:
    fVar9 = (fVar9 - (float10)fStack_38) - (float10)fStack_48;
    if (fVar9 < (float10)*(float *)((int)param_1 + 0x1bc1) !=
        (fVar9 == (float10)*(float *)((int)param_1 + 0x1bc1))) {
      *(float *)((int)param_1 + 0x1bc1) = (float)fVar9;
      *(byte *)((int)param_1 + 0x1bcd) = *(byte *)((int)param_1 + 0x1bcd) | 2;
    }
    (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0xc))
              (param_1,auStack_4c,&fStack_30,*(undefined4 *)((int)param_1_00[7] + 0x186e),
               *(float *)((int)param_1_00[7] + 0x1886) - fStack_48);
    fVar7 = *(float *)((int)param_1 + 0x1bb9);
    if (*(float *)((int)param_1 + 0x1bb9) <= fStack_40) {
      fVar7 = fStack_40;
    }
    *(float *)((int)param_1 + 0x1bb9) = fVar7;
    fVar7 = *(float *)((int)param_1 + 0x1bc9);
    if (unaff_ESI <= *(float *)((int)param_1 + 0x1bc9)) {
      fVar7 = unaff_ESI;
    }
    *(float *)((int)param_1 + 0x1bc9) = fVar7;
    break;
  case 1.12104e-44:
    piVar6 = *(int **)((int)param_1 + 0x13b3);
    fStack_3c = *(float *)((int)param_1_00[7] + 0x18f2);
    iVar8 = (**(code **)(*piVar6 + 0x4c))(param_1);
    fVar7 = param_1_00[7];
    iVar5 = *(int *)((int)fVar7 + 0x186e);
    fStack_30 = *(float *)(*(int *)(iVar8 + 0xc) + 0x14 + iVar5 * 0x1c);
    fVar9 = (float10)(**(code **)(*piVar6 + 0x1c))(param_1,iVar5);
    fVar9 = ((float10)*(float *)((int)fVar7 + 0x188a) - fVar9) * (float10)_DAT_006ee5e0 +
            (float10)*(float *)((int)param_1_00[7] + 0x1886);
LAB_005313f9:
    fVar9 = (fVar9 - (float10)fStack_38) + (float10)fStack_48;
    if ((float10)*(float *)((int)param_1 + 0x1bb5) <= fVar9) {
      *(float *)((int)param_1 + 0x1bb5) = (float)fVar9;
      *(byte *)((int)param_1 + 0x1bcd) = *(byte *)((int)param_1 + 0x1bcd) | 1;
    }
    (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0xc))
              (param_1,auStack_4c,&fStack_30,*(undefined4 *)((int)param_1_00[7] + 0x186e),
               fStack_48 + *(float *)((int)param_1_00[7] + 0x1886));
    fVar7 = *(float *)((int)param_1 + 0x1bbd);
    if (*(float *)((int)param_1 + 0x1bbd) <= unaff_ESI) {
      fVar7 = unaff_ESI;
    }
    *(float *)((int)param_1 + 0x1bbd) = fVar7;
    fVar7 = *(float *)((int)param_1 + 0x1bc5);
    if (fStack_40 <= *(float *)((int)param_1 + 0x1bc5)) {
      fVar7 = fStack_40;
    }
    *(float *)((int)param_1 + 0x1bc5) = fVar7;
  }
  fVar7 = param_1_00[4];
  if (((fVar7 != 5.60519e-45) && (fVar7 != 8.40779e-45)) ||
     ((fVar1 = param_1_00[5], (int)fVar1 < 9 && (2 < (int)fVar1)))) {
    return;
  }
  fVar4 = param_1_00[7];
  if (((*(uint *)((int)fVar4 + 0x139f) & 0x200) == 0) ||
     ((*(uint *)((int)param_1 + 0x139f) & 0x200) != 0)) {
    if ((fVar1 == 0.0) || (fVar1 == 1.4013e-45)) {
      if (_DAT_006ea4a4 < *(float *)((int)fVar4 + 0x1862)) {
        fVar7 = *(float *)((int)fVar4 + 0x1862) - *(float *)((int)param_1 + 0x1862);
        if (_DAT_006ea61c < fVar7) {
          fVar7 = _DAT_006f49d8 - fVar7;
        }
        fVar1 = (_DAT_006f410c / *(float *)((int)param_1 + 0x185e)) *
                *(float *)((int)fVar4 + 0x1862);
        fVar2 = fVar1 * fVar1;
        fStack_38 = (fVar2 * fVar7 * _DAT_006e9804 + _DAT_006e97d8) *
                    (_DAT_006e97d8 -
                    param_1_00[0xc] /
                    (fVar2 * *(float *)((int)fVar4 + 0x1862) * fVar1 * _DAT_006f5150)) *
                    *(float *)((int)param_1 + 0x1afa) * fVar2 * fVar2 * fVar2 * fVar2 * fVar2 *
                    _DAT_006ed740;
        if (_DAT_006ea454 <= fStack_38) goto LAB_00531626;
      }
    }
    else if (fVar7 == 8.40779e-45) {
      fStack_38 = -0.015124;
      goto LAB_00531626;
    }
    fStack_38 = 0.0;
  }
  else {
    fStack_38 = -0.075619996;
    cVar3 = FUN_004fffa0();
    if (cVar3 == '\0') {
      param_1_00[1] = 10000.0;
    }
    else {
      *param_1_00 = -10000.0;
    }
  }
LAB_00531626:
  if (param_1_00[4] == 5.60519e-45) {
    fStack_3c = 5.02524;
    param_1_00[1] = *(float *)((int)param_1 + 0x1bea) + param_1_00[1];
    *param_1_00 = *param_1_00 - *(float *)((int)param_1 + 0x1bea);
  }
  else {
    fStack_3c = _DAT_0074b290 * _DAT_006ea448;
  }
  fVar7 = fStack_38;
  fVar9 = (float10)FUN_0052ac80(param_1,param_1_00[7],fStack_3c,fStack_38);
  FUN_00533ea0(param_1,(float)fVar9,fVar7);
  return;
}


