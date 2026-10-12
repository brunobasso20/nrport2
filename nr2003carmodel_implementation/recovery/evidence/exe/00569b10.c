/* NR2003.exe @ 00569b10 FUN_00569b10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

float * __thiscall FUN_00569b10(int param_1_00,int *param_1)

{
  undefined4 *puVar1;
  float fVar2;
  float fVar3;
  float *pfVar4;
  undefined uVar5;
  char cVar6;
  int iVar7;
  int *piVar8;
  int iVar9;
  float *pfVar10;
  float10 fVar11;
  float10 fVar12;
  undefined4 uVar13;
  undefined4 uVar14;
  undefined4 uVar15;
  undefined4 uVar16;
  undefined4 uVar17;
  undefined4 uVar18;
  undefined4 uVar19;
  float local_74;
  float local_70;
  undefined4 local_6c;
  float local_68;
  float *local_64;
  float *local_60;
  float *local_5c;
  float *local_58;
  float local_54;
  float local_50;
  float local_4c;
  float local_48;
  float *local_44;
  float local_40;
  float local_3c;
  float local_38;
  float local_34;
  float local_28;
  undefined local_24 [36];
  
  local_64 = (float *)0x0;
  uVar5 = FUN_0056bac0(*param_1);
  *(undefined *)((int)param_1 + 0x15f) = uVar5;
  *(undefined *)((int)param_1 + 0x185) = 0;
  if (*param_1 == 0) {
    return local_64;
  }
  iVar7 = *(int *)(param_1_00 + 0x340) + -1;
  *(int *)(param_1_00 + 0x340) = iVar7;
  if (-1 < iVar7) {
    return local_64;
  }
  iVar7 = param_1[2];
  cVar6 = FUN_0056bae0(*param_1);
  if ((cVar6 != '\0') && ((iVar7 == 0 || (*(int *)(iVar7 + 4) == 0)))) {
    if (*(char *)((int)param_1 + 0x15e) != '\0') {
      return local_64;
    }
switchD_00569ba5_caseD_11:
    iVar7 = 0;
LAB_0056a553:
    piVar8 = param_1 + 3;
    thunk_FUN_005f58d0(piVar8,&DAT_00c57378 + iVar7 * 9);
    FUN_005f5a90(piVar8,(&DAT_00c57384)[iVar7 * 9],(&DAT_00c57388)[iVar7 * 9],
                 (&DAT_00c5738c)[iVar7 * 9]);
    FUN_005f5ac0(piVar8,&DAT_00c5c290,&DAT_00c5c290);
    param_1[0x29] = (&DAT_00c57390)[iVar7 * 9];
    param_1[0x2a] = (&DAT_00c57394)[iVar7 * 9];
    param_1[0x2b] = (&DAT_00c57398)[iVar7 * 9];
    FUN_0056a940(piVar8);
    goto LAB_0056a87e;
  }
  switch(*param_1) {
  case 1:
  case 2:
  case 3:
    local_60 = (float *)(iVar7 + 0x153c);
    local_5c = &local_48;
    FUN_005f6d20(&local_48,*(int *)(iVar7 + 0x5ae) + 0x58,&local_48);
    local_5c = *(float **)(iVar7 + 0x5ae);
    local_60 = &local_48;
    local_58 = &local_48;
    piVar8 = param_1 + 3;
    thunk_FUN_005f58d0(piVar8,&local_48);
    FUN_005f6f20(local_24,*(float *)(param_1_00 + 0x350) * *(float *)(param_1_00 + 0x34c) -
                          *(float *)(param_1_00 + 0x354) * _DAT_006f5f30,
                 *(float *)(iVar7 + 0x154c) - *(float *)(iVar7 + 0x1534),
                 *(float *)(iVar7 + 0x1550) - *(float *)(iVar7 + 0x1538));
    FUN_005f6b50(local_24,*(int *)(iVar7 + 0x5ae) + 0x58,local_24);
    FUN_005f74c0(&local_70,&local_74,&local_6c,local_24);
    FUN_005f5a90(piVar8,local_70,local_74,local_6c);
    FUN_005f5ac0(piVar8,*(int *)(iVar7 + 0x5ae) + 0xc,*(int *)(iVar7 + 0x5ae) + 0x8c);
    goto LAB_0056a01c;
  case 4:
  case 6:
    pfVar10 = (float *)&DAT_00c5c190;
    goto LAB_00569d08;
  case 5:
  case 7:
    local_54 = DAT_00c5856c;
    local_50 = (float)DAT_00c58570;
    local_4c = (float)DAT_00c58584;
    FUN_005f6d20(&local_48,*(int *)(iVar7 + 0x5ae) + 0x58,&local_54);
    local_58 = *(float **)(iVar7 + 0x5ae);
    local_5c = &local_48;
    local_60 = &local_48;
    piVar8 = param_1 + 3;
    thunk_FUN_005f58d0(piVar8,&local_48);
    FUN_005f6f20(local_24,DAT_00c58578,DAT_00c5857c,DAT_00c58580);
    FUN_005f6b50(local_24,*(int *)(iVar7 + 0x5ae) + 0x58,local_24);
    FUN_005f74c0(&local_70,&local_74,&local_6c,local_24);
    FUN_005f5a90(piVar8,local_70,local_74,local_6c);
    FUN_005f5ac0(piVar8,*(int *)(iVar7 + 0x5ae) + 0xc,*(int *)(iVar7 + 0x5ae) + 0x8c);
    goto LAB_00569ee4;
  case 8:
    pfVar10 = (float *)&DAT_00c5c168;
LAB_00569d08:
    local_54 = *pfVar10;
    local_50 = pfVar10[1];
    local_4c = 0.0;
    FUN_005f6d20(&local_48,*(int *)(iVar7 + 0x5ae) + 0x58,&local_54);
    local_58 = *(float **)(iVar7 + 0x5ae);
    local_5c = &local_48;
    local_60 = &local_48;
    piVar8 = param_1 + 3;
    local_40 = pfVar10[6] + pfVar10[2] + *(float *)(*(int *)(iVar7 + 0x5ae) + 0x20);
    thunk_FUN_005f58d0(piVar8,&local_48);
    FUN_005f5a90(piVar8,*(float *)(iVar7 + 0x1530) + pfVar10[3],pfVar10[4],pfVar10[5]);
    FUN_005f5ac0(piVar8,*(int *)(iVar7 + 0x5ae) + 0xc,*(int *)(iVar7 + 0x5ae) + 0x8c);
LAB_00569ee4:
    param_1[0x2c] = 0x3ecccccd;
    if ((float)param_1[5] - (float)param_1[0xb] < _DAT_006e97d8 !=
        (NAN((float)param_1[5] - (float)param_1[0xb]) || NAN(_DAT_006e97d8))) {
      param_1[5] = (int)((float)param_1[0xb] + _DAT_006e97d8);
    }
    goto LAB_0056a87e;
  default:
    goto switchD_00569ba5_caseD_9;
  case 10:
  case 0xb:
  case 0xc:
  case 0xd:
  case 0xe:
  case 0xf:
    iVar9 = *param_1 + -10 +
            (*(int *)(*(int *)(param_1_00 + 0xc) + 0x592) +
            *(int *)(*(int *)(param_1_00 + 0xc) + 0x596) * 4) * 6;
    FUN_005f6d20(&local_48,*(int *)(iVar7 + 0x5ae) + 0x58,&DAT_00c57450 + iVar9 * 9);
    local_58 = *(float **)(iVar7 + 0x5ae);
    local_5c = &local_48;
    local_60 = &local_48;
    piVar8 = param_1 + 3;
    thunk_FUN_005f58d0(piVar8,&local_48);
    FUN_005f6f20(local_24,(&DAT_00c5745c)[iVar9 * 9],(&DAT_00c57460)[iVar9 * 9],
                 (&DAT_00c57464)[iVar9 * 9]);
    FUN_005f6b50(local_24,*(int *)(iVar7 + 0x5ae) + 0x58,local_24);
    FUN_005f74c0(&local_70,&local_74,&local_6c,local_24);
    FUN_005f5a90(piVar8,local_70,local_74,local_6c);
    FUN_005f5ac0(piVar8,*(int *)(iVar7 + 0x5ae) + 0xc,*(int *)(iVar7 + 0x5ae) + 0x8c);
LAB_0056a01c:
    param_1[0x2c] = 0x3e4ccccd;
    if ((float)param_1[5] - (float)param_1[0xb] < _DAT_006ea4e0 !=
        (NAN((float)param_1[5] - (float)param_1[0xb]) || NAN(_DAT_006ea4e0))) {
      *(undefined *)((int)param_1 + 0x15e) = 0;
      return local_64;
    }
    goto LAB_0056a87e;
  case 0x10:
    iVar9 = *(int *)(iVar7 + 0x5ae);
    pfVar10 = (float *)((int)param_1 + 0x16d);
    local_48 = *pfVar10 - *(float *)(iVar9 + 0x18);
    pfVar4 = (float *)(*(float *)((int)param_1 + 0x171) - *(float *)(iVar9 + 0x1c));
    local_60 = (float *)(*(float *)((int)param_1 + 0x175) - *(float *)(iVar9 + 0x20));
    local_68 = local_48 * local_48 + (float)pfVar4 * (float)pfVar4;
    if (((_DAT_006f5f40 < local_68) || ((float)local_60 < DAT_00c5c1b8 * _DAT_006ea44c)) ||
       (DAT_00c5c1b8 * _DAT_006ea494 < (float)local_60 !=
        (NAN(DAT_00c5c1b8 * _DAT_006ea494) || NAN((float)local_60)))) {
      local_48 = 17.67768;
      local_44 = (float *)0x418d6be1;
      iVar9 = *(int *)(iVar7 + 0x5ae);
      local_58 = &local_48;
      local_5c = (float *)(iVar9 + 0x18);
      fVar2 = *(float *)(iVar9 + 0x1c);
      fVar3 = *(float *)(iVar9 + 0x20) + DAT_00c5c1b8;
      *pfVar10 = *local_5c + 17.67768;
      *(float *)((int)param_1 + 0x171) = fVar2 + 17.67768;
      *(float *)((int)param_1 + 0x175) = fVar3;
      local_60 = (float *)DAT_00c5c1b8;
      iVar9 = *(int *)(iVar7 + 0x5ae);
      *(undefined4 *)((int)param_1 + 0x179) = *(undefined4 *)(iVar9 + 0xc);
      *(undefined4 *)((int)param_1 + 0x17d) = *(undefined4 *)(iVar9 + 0x10);
      *(undefined4 *)((int)param_1 + 0x181) = *(undefined4 *)(iVar9 + 0x14);
      *(undefined4 *)((int)param_1 + 0x181) = 0;
      local_64 = pfVar10;
      local_3c = *(float *)((int)param_1 + 0x179);
      local_38 = *(float *)((int)param_1 + 0x17d);
    }
    else {
      local_44 = pfVar4;
      local_3c = _DAT_006ea454;
      local_38 = _DAT_006ea454;
      if (local_68 < _DAT_006f5f3c == (local_68 == _DAT_006f5f3c)) {
        local_64 = (float *)((local_68 - _DAT_006f5f3c) * _DAT_006f5f38 * _DAT_006f47d8);
        if (_DAT_006ea4a4 < local_68) {
          local_64 = (float *)-((float)local_64 / SQRT(local_68));
        }
        if ((float)((uint)local_48 & 0x7fffffff) < _DAT_006ee5b0 !=
            (NAN((float)((uint)local_48 & 0x7fffffff)) || NAN(_DAT_006ee5b0))) {
          local_48 = 0.0;
        }
        local_5c = (float *)((uint)pfVar4 & 0x7fffffff);
        if ((float)local_5c < _DAT_006ee5b0 != (NAN((float)local_5c) || NAN(_DAT_006ee5b0))) {
          local_44 = (float *)0x0;
        }
        local_58 = pfVar4;
        local_3c = (float)local_64 * local_48;
        local_38 = (float)local_64 * (float)local_44;
      }
    }
    local_40 = 0.0;
    local_28 = DAT_00c5c1b8 - (float)local_60;
    local_3c = local_3c - *(float *)((int)param_1 + 0x179);
    local_38 = local_38 - *(float *)((int)param_1 + 0x17d);
    local_34 = local_28 - *(float *)((int)param_1 + 0x181);
    fVar2 = SQRT(local_3c * local_3c + local_38 * local_38 + local_34 * local_34);
    if (_DAT_006f5f34 < fVar2) {
      fVar2 = _DAT_006f5f34 / fVar2;
      local_3c = local_3c * fVar2;
      local_38 = local_38 * fVar2;
      local_34 = local_34 * fVar2;
    }
    cVar6 = FUN_00502460();
    if (cVar6 == '\0') {
      iVar9 = taskGetRate();
      local_64 = (float *)(_DAT_006e97d8 / (float)iVar9);
    }
    else {
      fVar11 = (float10)FUN_00500860();
      local_58 = (float *)(float)fVar11;
      local_64 = (float *)((uint)local_58 & 0x7fffffff);
      local_5c = local_64;
      cVar6 = FUN_0057af40(0x62);
      if ((cVar6 != '\0') || (cVar6 = FUN_0057af40(0x5e), cVar6 != '\0')) {
        local_58 = (float *)taskGetRate();
        local_64 = (float *)(_DAT_006f1624 / (float)(int)local_58);
      }
      iVar9 = taskGetRate();
      local_64 = (float *)((float)local_64 / (float)iVar9);
    }
    local_3c = local_3c * (float)local_64;
    pfVar4 = (float *)((int)param_1 + 0x179);
    local_38 = local_38 * (float)local_64;
    local_34 = local_34 * (float)local_64;
    *pfVar4 = *pfVar4 + local_3c;
    *(float *)((int)param_1 + 0x17d) = *(float *)((int)param_1 + 0x17d) + local_38;
    *(float *)((int)param_1 + 0x181) = *(float *)((int)param_1 + 0x181) + local_34;
    local_58 = &local_54;
    *pfVar10 = *pfVar10 + (float)local_64 * *pfVar4;
    *(float *)((int)param_1 + 0x171) =
         *(float *)((int)param_1 + 0x171) + (float)local_64 * *(float *)((int)param_1 + 0x17d);
    *(float *)((int)param_1 + 0x175) =
         *(float *)((int)param_1 + 0x175) + (float)local_64 * *(float *)((int)param_1 + 0x181);
    pfVar4 = *(float **)(iVar7 + 0x5ae);
    local_54 = *pfVar4 - *pfVar10;
    local_50 = pfVar4[1] - *(float *)((int)param_1 + 0x171);
    local_4c = pfVar4[2] - *(float *)((int)param_1 + 0x175);
    piVar8 = param_1 + 3;
    fVar11 = (float10)fpatan((float10)local_50,(float10)local_54);
    local_70 = (float)fVar11;
    fVar11 = (float10)fpatan(-(float10)local_4c,
                             SQRT((float10)local_54 * (float10)local_54 +
                                  (float10)local_50 * (float10)local_50));
    local_74 = (float)fVar11;
    local_60 = pfVar10;
    local_5c = pfVar10;
    thunk_FUN_005f58d0(piVar8,pfVar10);
    FUN_005f5ac0(piVar8,(int)param_1 + 0x179,&DAT_00c5c290);
    FUN_005f5a90(piVar8,local_70,local_74,0);
    param_1[0x29] = DAT_00c5c1bc;
    param_1[0x2a] = DAT_00c5c1c0;
    iVar7 = DAT_00c5c1c4;
    param_1[0x2c] = 0x41200000;
    param_1[0x2b] = iVar7;
    if (((*(int *)((int)param_1 + 0x18e) == 0) ||
        (*(int *)(*(int *)((int)param_1 + 0x18e) + 8) == 0)) && (DAT_00d8c3f8 != 0)) {
      uVar19 = 0;
      uVar18 = 0;
      uVar17 = 0;
      uVar16 = 0;
      uVar15 = 6;
      uVar14 = 0x3f800000;
      uVar13 = 0;
      cVar6 = FUN_00502460(0,0x3f800000,6,0,0,0,0);
      piVar8 = (int *)FUN_004ed0d0(DAT_00d8c3f8,0,(cVar6 != '\0') + '\x01',uVar13,uVar14,uVar15,
                                   uVar16,uVar17,uVar18,uVar19);
      puVar1 = *(undefined4 **)((int)param_1 + 0x18e);
      if (puVar1 != (undefined4 *)*piVar8) {
        if ((puVar1 != (undefined4 *)0x0) &&
           (iVar7 = puVar1[1], puVar1[1] = iVar7 + -1, iVar7 + -1 == 0)) {
          (**(code **)*puVar1)(1);
        }
        iVar7 = *piVar8;
        *(int *)((int)param_1 + 0x18e) = iVar7;
        if (iVar7 != 0) {
          *(int *)(iVar7 + 4) = *(int *)(iVar7 + 4) + 1;
        }
      }
      FUN_004ed160();
    }
    goto LAB_0056a87e;
  case 0x11:
    goto switchD_00569ba5_caseD_11;
  case 0x12:
    iVar7 = 1;
    goto LAB_0056a553;
  case 0x13:
    iVar9 = 0;
    break;
  case 0x14:
    iVar9 = 1;
    break;
  case 0x15:
    iVar9 = 2;
  }
  pfVar10 = (float *)(param_1 + 3);
  local_60 = *(float **)(*(int *)(param_1[2] + 0x5ae) + 0x3c);
  local_58 = *(float **)((int)param_1 + iVar9 * 4 + 0x161);
  local_5c = (float *)(iVar9 * 0xe44);
  iVar9 = (int)local_5c + (int)local_58 * 0x26;
  puVar1 = (undefined4 *)((int)&DAT_00c585a4 + (int)local_58 * 0x13 + iVar9);
  *(undefined1 *)((int)param_1 + 0x185) = (&DAT_00c585dc)[(int)local_58 * 0x13 + iVar9];
  FUN_005f5a40(pfVar10,*puVar1,puVar1[1],puVar1[2]);
  FUN_005f5ac0(pfVar10,&DAT_00c5c290,&DAT_00c5c290);
  if (puVar1[4] == 1) {
    FUN_005f5a90(pfVar10,puVar1[8],puVar1[9],puVar1[10]);
    local_64 = (float *)0x1;
    param_1[0x29] = puVar1[0xb];
    param_1[0x2a] = puVar1[0xc];
    iVar7 = puVar1[0xd];
    *(undefined *)((int)param_1 + 0x15f) = 0;
    param_1[0x2b] = iVar7;
    FUN_0056a940(pfVar10);
  }
  else {
    pfVar4 = *(float **)(iVar7 + 0x5ae);
    local_54 = *pfVar4 - *pfVar10;
    local_50 = pfVar4[1] - (float)param_1[4];
    local_4c = pfVar4[2] - (float)param_1[5];
    fVar11 = (float10)fpatan((float10)local_50,(float10)local_54);
    local_58 = (float *)((int)&DAT_00c585a4 +
                        (int)local_5c +
                        (((int)local_58 + 1) % *(int *)((int)&DAT_00c585a0 + (int)local_5c)) * 0x39)
    ;
    local_70 = (float)fVar11;
    fVar11 = (float10)fpatan(-(float10)local_4c,
                             SQRT((float10)local_54 * (float10)local_54 +
                                  (float10)local_50 * (float10)local_50));
    local_74 = (float)fVar11;
    FUN_005f5a90(pfVar10,local_70,local_74,0);
    if (puVar1[4] == 2) {
      param_1[0x29] = puVar1[0xb];
      param_1[0x2a] = puVar1[0xc];
      param_1[0x2b] = puVar1[0xd];
    }
    else {
      fVar11 = (float10)FUN_00516d3a(local_60,*puVar1);
      pfVar4 = local_58;
      if (fVar11 <= (float10)_DAT_006ea454) {
        fVar11 = (float10)FUN_00516d3a(*puVar1,*local_58 + local_58[3]);
        local_64 = (float *)(float)fVar11;
        fVar11 = (float10)FUN_00516d3a(local_60,*pfVar4 + pfVar4[3]);
        param_1[0x29] = DAT_006f5f18;
        param_1[0x2a] = DAT_006f5f1c;
        param_1[0x2b] = DAT_006f5f20;
        fVar12 = (float10)fpatan((float10)_DAT_006e9830,
                                 SQRT((float10)local_4c * (float10)local_4c +
                                      (float10)local_54 * (float10)local_54 +
                                      (float10)local_50 * (float10)local_50));
        fVar11 = ((float10)(float)puVar1[7] - (float10)(float)puVar1[6]) *
                 (((float10)(float)local_64 - fVar11) / (float10)(float)local_64) +
                 (float10)(float)puVar1[6];
      }
      else {
        fVar2 = (float)puVar1[3];
        fVar3 = (float)puVar1[3];
        param_1[0x29] = DAT_006f5f18;
        param_1[0x2a] = DAT_006f5f1c;
        param_1[0x2b] = DAT_006f5f20;
        fVar12 = (float10)fpatan((float10)_DAT_006e9830,
                                 SQRT((float10)local_4c * (float10)local_4c +
                                      (float10)local_54 * (float10)local_54 +
                                      (float10)local_50 * (float10)local_50));
        fVar11 = ((float10)(float)puVar1[6] - (float10)(float)puVar1[5]) *
                 -((-(float10)fVar2 - fVar11) / (float10)fVar3) + (float10)(float)puVar1[5];
      }
      param_1[0x29] = (int)(float)(fVar12 / fVar11);
    }
    param_1[0x2a] = 0;
    param_1[0x2b] = 0;
    FUN_0056a940(pfVar10);
LAB_0056a87e:
    local_64 = (float *)0x1;
  }
  if ((float)param_1[0x29] < _DAT_006f5ee8 * _DAT_006ea50c) {
    param_1[0x29] = (int)(_DAT_006f5ee8 * _DAT_006ea50c);
    return local_64;
  }
  fVar2 = _DAT_006f5ee8 * _DAT_006ee574;
  if (fVar2 < (float)param_1[0x29] != (NAN(fVar2) || NAN((float)param_1[0x29]))) {
    param_1[0x29] = (int)fVar2;
    return local_64;
  }
switchD_00569ba5_caseD_9:
  return local_64;
}

