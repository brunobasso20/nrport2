/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056a9a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void FUN_0056a9a0(float *param_1,int param_2,int *param_3,int param_4,int param_5)

{
  int iVar1;
  undefined4 *puVar2;
  float fVar3;
  char cVar4;
  float *pfVar5;
  int iVar6;
  float fVar7;
  float *pfVar8;
  float10 fVar9;
  float10 fVar10;
  float *local_90;
  float fStack_8c;
  float fStack_88;
  float fStack_84;
  float *pfStack_80;
  float *pfStack_7c;
  float fStack_78;
  float fStack_74;
  float fStack_70;
  char local_69;
  int local_68;
  float *local_64;
  float fStack_60;
  float fStack_5c;
  float fStack_58;
  float fStack_54;
  float fStack_50;
  float fStack_4c;
  float fStack_48;
  float fStack_44;
  float fStack_40;
  float *local_3c;
  float *pfStack_38;
  float *pfStack_34;
  undefined1 auStack_30 [36];
  float fStack_c;
  float fStack_8;
  float fStack_4;
  
  pfVar8 = (float *)0x0;
  local_64 = (float *)0x0;
  local_90 = (float *)0x0;
  local_69 = '\x01';
  local_68 = 0;
  if (*(int *)(param_4 + 0xc) == 0) goto switchD_0056aab1_caseD_9;
  local_3c = (float *)FUN_0056b730();
  *(undefined1 *)(param_1 + 0x2a) = 0;
  if (param_2 != 0) {
    *(undefined1 *)(param_2 + 0xa8) = 0;
  }
  cVar4 = FUN_0056bae0(*(undefined4 *)(param_4 + 0xc));
  if (cVar4 != '\0') {
    if (param_3 != (int *)0x0) goto LAB_0056aa7b;
    if (((DAT_00c5c279 != '\0') && (DAT_00c5c271 == *(int *)(param_4 + 0xc))) &&
       ((DAT_00c5c275 == param_5 || (param_5 == -1)))) {
      local_68 = 1;
      pfVar8 = (float *)&DAT_00c5c1c8;
      pfVar5 = param_1;
      for (iVar6 = 0x2a; iVar6 != 0; iVar6 = iVar6 + -1) {
        *pfVar5 = *pfVar8;
        pfVar8 = pfVar8 + 1;
        pfVar5 = pfVar5 + 1;
      }
      *(undefined1 *)pfVar5 = *(undefined1 *)pfVar8;
      goto switchD_0056aab1_caseD_9;
    }
    local_69 = '\0';
switchD_0056aab1_caseD_11:
    iVar6 = 0;
LAB_0056b07b:
    thunk_FUN_005f58d0(param_1,&DAT_00c57378 + iVar6 * 9);
    FUN_005f5a90(param_1,(&DAT_00c57384)[iVar6 * 9],(&DAT_00c57388)[iVar6 * 9],
                 (&DAT_00c5738c)[iVar6 * 9]);
    FUN_005f5ac0(param_1,&DAT_00c5c290,&DAT_00c5c290);
    param_1[0x26] = (float)(&DAT_00c57390)[iVar6 * 9];
    param_1[0x27] = (float)(&DAT_00c57394)[iVar6 * 9];
    param_1[0x28] = (float)(&DAT_00c57398)[iVar6 * 9];
    FUN_0056a940(param_1);
    goto LAB_0056b380;
  }
  if (param_3 != (int *)0x0) {
LAB_0056aa7b:
    pfVar8 = (float *)(**(code **)(*param_3 + 0x14))();
    local_64 = pfVar8;
    local_90 = (float *)FUN_005ba130();
  }
  pfVar5 = local_3c;
  switch(*(int *)(param_4 + 0xc)) {
  case 1:
  case 2:
  case 3:
    pfStack_7c = &fStack_60;
    pfStack_80 = local_90 + 0x30;
    fStack_60 = *pfStack_80 + DAT_0074ebbc;
    fStack_5c = local_90[0x31] + DAT_0074ebc0;
    fStack_58 = local_90[0x32] + _DAT_0074ebc4;
    FUN_005f6d20(&fStack_60,pfVar8 + 0x16,&fStack_60);
    pfStack_80 = &fStack_60;
    pfStack_7c = &fStack_60;
    fStack_60 = fStack_60 + *local_64;
    fStack_5c = fStack_5c + local_64[1];
    fStack_58 = fStack_58 + local_64[2];
    thunk_FUN_005f58d0(param_1,&fStack_60);
    FUN_005f74c0(&fStack_8c,&fStack_88,&fStack_84,pfVar8 + 0x16);
    pfVar5 = local_3c;
    FUN_005f6f20(auStack_30,*local_3c - local_3c[7] * _DAT_006f5f30,local_90[0x34] - fStack_88,
                 local_90[0x35] - fStack_84);
    FUN_005f6b50(auStack_30,pfVar8 + 0x16,auStack_30);
    FUN_005f74c0(&fStack_8c,&fStack_88,&fStack_84,auStack_30);
    FUN_005f5a90(param_1,fStack_8c,fStack_88,fStack_84);
    FUN_005f5ac0(param_1,pfVar8 + 3,pfVar8 + 0x23);
    param_1[0x26] = DAT_006f5f18;
    param_1[0x27] = DAT_006f5f1c;
    param_1[0x28] = DAT_006f5f20;
    local_90 = (float *)(*pfVar5 - pfVar5[7] * _DAT_006f5f30);
    fVar9 = (float10)FUN_00411850();
    local_90 = (float *)(float)((float10)(float)local_90 * (float10)_DAT_006f5f48 *
                               ((float10)DAT_00c5736c - fVar9));
    fVar9 = (float10)FUN_00411850();
    param_1[0x29] = 0.2;
    param_1[0x26] = (float)(fVar9 + (float10)(float)local_90);
    break;
  case 4:
  case 6:
    pfVar5 = (float *)&DAT_00c5c190;
    local_90 = (float *)&DAT_00c5c190;
    goto LAB_0056ac7c;
  case 5:
  case 7:
    fStack_78 = DAT_00c5856c;
    fStack_74 = DAT_00c58570;
    fStack_70 = DAT_00c58584;
    FUN_005f6d20(&fStack_60,pfVar8 + 0x16,&fStack_78);
    local_90 = &fStack_60;
    pfStack_80 = &fStack_60;
    fStack_60 = fStack_60 + *local_64;
    fStack_5c = fStack_5c + local_64[1];
    fStack_58 = fStack_58 + local_64[2];
    thunk_FUN_005f58d0(param_1,&fStack_60);
    FUN_005f6f20(auStack_30,DAT_00c58578,DAT_00c5857c,DAT_00c58580);
    FUN_005f6b50(auStack_30,pfVar8 + 0x16,auStack_30);
    FUN_005f74c0(&fStack_8c,&fStack_88,&fStack_84,auStack_30);
    FUN_005f5a90(param_1,fStack_8c,fStack_88,fStack_84);
    FUN_005f5ac0(param_1,pfVar8 + 3,pfVar8 + 0x23);
    param_1[0x26] = DAT_00c58588;
    param_1[0x27] = DAT_00c5858c;
    fVar7 = DAT_00c58590;
    goto LAB_0056ae73;
  case 8:
    local_90 = (float *)&DAT_00c5c168;
    pfVar5 = (float *)&DAT_00c5c168;
LAB_0056ac7c:
    fStack_78 = *pfVar5;
    fStack_74 = pfVar5[1];
    fStack_70 = 0.0;
    FUN_005f6d20(&fStack_60,pfVar8 + 0x16,&fStack_78);
    pfVar5 = local_90;
    pfStack_80 = &fStack_60;
    pfStack_7c = &fStack_60;
    fStack_60 = fStack_60 + *local_64;
    fStack_5c = fStack_5c + local_64[1];
    fStack_58 = local_90[6] + local_90[2] + pfVar8[8];
    thunk_FUN_005f58d0(param_1,&fStack_60);
    FUN_005f74c0(&fStack_8c,&fStack_88,&fStack_84,pfVar8 + 0x16);
    FUN_005f5a90(param_1,fStack_8c + pfVar5[3],pfVar5[4],pfVar5[5]);
    FUN_005f5ac0(param_1,pfVar8 + 3,pfVar8 + 0x23);
    param_1[0x26] = pfVar5[7];
    param_1[0x27] = pfVar5[8];
    fVar7 = pfVar5[9];
LAB_0056ae73:
    param_1[0x28] = fVar7;
    param_1[0x29] = 0.4;
    if (param_1[2] - param_1[8] < _DAT_006e97d8) {
      param_1[2] = param_1[8] + _DAT_006e97d8;
    }
    break;
  default:
    goto switchD_0056aab1_caseD_9;
  case 10:
  case 0xb:
  case 0xc:
  case 0xd:
  case 0xe:
  case 0xf:
    pfStack_7c = (float *)(&DAT_00c57450 +
                          (*(int *)(param_4 + 0xc) + -10 +
                          (*(int *)(*(int *)(param_4 + 0x10) + 0x592) +
                          *(int *)(*(int *)(param_4 + 0x10) + 0x596) * 4) * 6) * 9);
    FUN_005f6d20(&fStack_60,pfVar8 + 0x16,pfStack_7c);
    local_90 = &fStack_60;
    pfStack_80 = &fStack_60;
    fStack_60 = fStack_60 + *local_64;
    fStack_5c = fStack_5c + local_64[1];
    fStack_58 = fStack_58 + local_64[2];
    thunk_FUN_005f58d0(param_1,&fStack_60);
    pfVar5 = pfStack_7c;
    FUN_005f6f20(auStack_30,pfStack_7c[3],pfStack_7c[4],pfStack_7c[5]);
    FUN_005f6b50(auStack_30,pfVar8 + 0x16,auStack_30);
    FUN_005f74c0(&fStack_8c,&fStack_88,&fStack_84,auStack_30);
    FUN_005f5a90(param_1,fStack_8c,fStack_88,fStack_84);
    FUN_005f5ac0(param_1,pfVar8 + 3,pfVar8 + 0x23);
    param_1[0x26] = pfVar5[6];
    param_1[0x27] = pfVar5[7];
    fVar7 = pfVar5[8];
    param_1[0x29] = 0.2;
    param_1[0x28] = fVar7;
    break;
  case 0x10:
    fStack_78 = *pfVar8 - local_3c[1];
    fStack_74 = pfVar8[1] - local_3c[2];
    fStack_70 = pfVar8[2] - local_3c[3];
    fVar9 = (float10)fpatan((float10)fStack_74,(float10)fStack_78);
    fStack_8c = (float)fVar9;
    fVar9 = (float10)fpatan(-(float10)fStack_70,
                            SQRT((float10)fStack_78 * (float10)fStack_78 +
                                 (float10)fStack_74 * (float10)fStack_74));
    fStack_88 = (float)fVar9;
    thunk_FUN_005f58d0(param_1,local_3c + 1);
    FUN_005f5ac0(param_1,pfVar5 + 4,&DAT_00c5c290);
    FUN_005f5a90(param_1,fStack_8c,fStack_88,0);
    param_1[0x26] = DAT_00c5c1bc;
    param_1[0x27] = DAT_00c5c1c0;
    fVar7 = DAT_00c5c1c4;
    param_1[0x29] = 10.0;
    param_1[0x28] = fVar7;
    break;
  case 0x11:
    goto switchD_0056aab1_caseD_11;
  case 0x12:
    iVar6 = 1;
    goto LAB_0056b07b;
  case 0x13:
    iVar6 = 0;
    goto LAB_0056b0f5;
  case 0x14:
    iVar6 = 1;
    goto LAB_0056b0f5;
  case 0x15:
    iVar6 = 2;
LAB_0056b0f5:
    pfStack_80 = (float *)pfVar8[0xf];
    local_90 = *(float **)(param_4 + 0x18);
    iVar1 = iVar6 * 0xe44 + (int)local_90 * 0x26;
    puVar2 = (undefined4 *)((int)&DAT_00c585a4 + iVar1 + (int)local_90 * 0x13);
    *(undefined1 *)(param_1 + 0x2a) = (&DAT_00c585dc)[iVar1 + (int)local_90 * 0x13];
    FUN_005f5a40(param_1,*puVar2,puVar2[1],puVar2[2]);
    FUN_005f5ac0(param_1,&DAT_00c5c290,&DAT_00c5c290);
    if (puVar2[4] != 1) {
      fStack_78 = *pfVar8 - *param_1;
      fStack_74 = pfVar8[1] - param_1[1];
      fStack_70 = pfVar8[2] - param_1[2];
      fVar9 = (float10)fpatan((float10)fStack_74,(float10)fStack_78);
      pfVar8 = (float *)((int)&DAT_00c585a4 +
                        iVar6 * 0xe44 +
                        (((int)local_90 + 1) % (int)(&DAT_00c585a0)[iVar6 * 0x391]) * 0x39);
      fStack_8c = (float)fVar9;
      fVar9 = (float10)fpatan(-(float10)fStack_70,
                              SQRT((float10)fStack_78 * (float10)fStack_78 +
                                   (float10)fStack_74 * (float10)fStack_74));
      fStack_88 = (float)fVar9;
      FUN_005f5a90(param_1,fStack_8c,fStack_88,0);
      pfVar5 = pfStack_80;
      if (puVar2[4] == 2) {
        param_1[0x26] = (float)puVar2[0xb];
        param_1[0x27] = (float)puVar2[0xc];
        param_1[0x28] = (float)puVar2[0xd];
      }
      else {
        fVar9 = (float10)FUN_00516d3a(pfStack_80,*puVar2);
        if (fVar9 <= (float10)_DAT_006ea454) {
          fVar9 = (float10)FUN_00516d3a(*puVar2,*pfVar8 + pfVar8[3]);
          local_90 = (float *)(float)fVar9;
          fVar9 = (float10)FUN_00516d3a(pfVar5,*pfVar8 + pfVar8[3]);
          param_1[0x26] = DAT_006f5f18;
          param_1[0x27] = DAT_006f5f1c;
          param_1[0x28] = DAT_006f5f20;
          fVar10 = (float10)fpatan((float10)_DAT_006e9830,
                                   SQRT((float10)fStack_70 * (float10)fStack_70 +
                                        (float10)fStack_78 * (float10)fStack_78 +
                                        (float10)fStack_74 * (float10)fStack_74));
          fVar9 = ((float10)(float)puVar2[7] - (float10)(float)puVar2[6]) *
                  (((float10)(float)local_90 - fVar9) / (float10)(float)local_90) +
                  (float10)(float)puVar2[6];
        }
        else {
          fVar7 = (float)puVar2[3];
          fVar3 = (float)puVar2[3];
          param_1[0x26] = DAT_006f5f18;
          param_1[0x27] = DAT_006f5f1c;
          param_1[0x28] = DAT_006f5f20;
          fVar10 = (float10)fpatan((float10)_DAT_006e9830,
                                   SQRT((float10)fStack_70 * (float10)fStack_70 +
                                        (float10)fStack_78 * (float10)fStack_78 +
                                        (float10)fStack_74 * (float10)fStack_74));
          fVar9 = ((float10)(float)puVar2[6] - (float10)(float)puVar2[5]) *
                  -((-(float10)fVar7 - fVar9) / (float10)fVar3) + (float10)(float)puVar2[5];
        }
        param_1[0x26] = (float)(fVar10 / fVar9);
      }
      param_1[0x27] = 0.0;
      param_1[0x28] = 0.0;
      FUN_0056a940(param_1);
      break;
    }
    FUN_005f5a90(param_1,puVar2[8],puVar2[9],puVar2[10]);
    local_68 = 1;
    param_1[0x26] = (float)puVar2[0xb];
    param_1[0x27] = (float)puVar2[0xc];
    param_1[0x28] = (float)puVar2[0xd];
    FUN_0056a940(param_1);
    goto LAB_0056b388;
  }
LAB_0056b380:
  local_68 = 1;
LAB_0056b388:
  pfVar8 = param_1 + 0x26;
  if (_DAT_006f5ee8 * _DAT_006ea50c <= *pfVar8) {
    if (_DAT_006f5ee8 * _DAT_006ee574 < *pfVar8) {
      *pfVar8 = _DAT_006f5ee8 * _DAT_006ee574;
    }
  }
  else {
    *pfVar8 = _DAT_006f5ee8 * _DAT_006ea50c;
  }
  if ((param_3 != (int *)0x0) && (param_2 != 0)) {
    local_64 = (float *)(**(code **)(*param_3 + 0x14))();
    iVar6 = FUN_005ba130();
    *(undefined4 *)(param_2 + 0x9c) = 0;
    *(undefined4 *)(param_2 + 0xa0) = 0;
    *(undefined4 *)(param_2 + 0x98) = 0x40060a92;
    *(undefined4 *)(param_2 + 0xa4) = 0x3e99999a;
    pfVar8 = (float *)FUN_00562f50();
    fStack_54 = *(float *)(iVar6 + 0xc0) - *pfVar8;
    fStack_50 = *(float *)(iVar6 + 0xc4) - pfVar8[1];
    fStack_4c = *(float *)(iVar6 + 200) - pfVar8[2];
    pfVar8 = (float *)FUN_00562f50();
    fStack_48 = DAT_006f5f0c - *pfVar8;
    fStack_44 = DAT_006f5f10 - pfVar8[1];
    fStack_40 = DAT_006f5f14 - pfVar8[2];
    FUN_005f6a70(&fStack_48);
    pfStack_34 = &fStack_54;
    pfStack_38 = &fStack_54;
    fStack_4 = fStack_44 * fStack_50 + fStack_40 * fStack_4c + fStack_48 * fStack_54;
    fStack_4 = fStack_4 + fStack_4;
    fStack_c = fStack_48 * fStack_4;
    fStack_8 = fStack_44 * fStack_4;
    fStack_4 = fStack_40 * fStack_4;
    fStack_54 = (DAT_006f5f0c + fStack_54) - fStack_c;
    fStack_50 = (DAT_006f5f10 + fStack_50) - fStack_8;
    fStack_4c = (DAT_006f5f14 + fStack_4c) - fStack_4;
    FUN_005f6d20(&fStack_54,local_64 + 0x16,&fStack_54);
    pfStack_38 = &fStack_54;
    pfStack_34 = &fStack_54;
    fStack_54 = fStack_54 + *local_64;
    fStack_50 = fStack_50 + local_64[1];
    fStack_4c = fStack_4c + local_64[2];
    thunk_FUN_005f58d0(param_2,&fStack_54);
    pfVar8 = local_64 + 0x16;
    FUN_005f74c0(&local_90,&pfStack_80,&pfStack_7c,pfVar8);
    FUN_005f6f20(auStack_30,0,*(float *)(iVar6 + 0xd0) - (float)pfStack_80,
                 *(float *)(iVar6 + 0xd4) - (float)pfStack_7c);
    FUN_005f6b50(auStack_30,pfVar8,auStack_30);
    FUN_005f74c0(&local_90,&pfStack_80,&pfStack_7c,auStack_30);
    pfStack_7c = (float *)(*local_3c * _DAT_006f5f44 + (float)pfStack_7c);
    *(float *)(param_2 + 0xa0) = *(float *)(param_2 + 0xa0) - *local_3c * _DAT_006e9824;
    FUN_005f5a90(param_2,(float)local_90 + (float)_DAT_006e97f8,-(float)pfStack_80,
                 -(float)pfStack_7c);
    FUN_005f5ac0(param_2,local_64 + 3,local_64 + 0x23);
  }
switchD_0056aab1_caseD_9:
  DAT_00c5c279 = '\0';
  if ((local_68 == 1) && (local_69 != '\0')) {
    pfVar8 = (float *)&DAT_00c5c1c8;
    for (iVar6 = 0x2a; iVar6 != 0; iVar6 = iVar6 + -1) {
      *pfVar8 = *param_1;
      param_1 = param_1 + 1;
      pfVar8 = pfVar8 + 1;
    }
    *(undefined1 *)pfVar8 = *(undefined1 *)param_1;
    DAT_00c5c271 = *(int *)(param_4 + 0xc);
    DAT_00c5c275 = param_5;
    DAT_00c5c279 = '\x01';
  }
  return;
}


