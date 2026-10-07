/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055e9b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055e9b0(void)

{
  uint uVar1;
  int iVar2;
  int iVar3;
  uint uVar4;
  float fVar5;
  float fVar6;
  undefined4 uVar7;
  int iVar8;
  undefined4 *puVar9;
  float *pfVar10;
  int *piVar11;
  float *pfVar12;
  float *pfVar13;
  float **ppfVar14;
  uint *puVar15;
  uint *puVar16;
  int iVar17;
  undefined *puVar18;
  int iVar19;
  float10 fVar20;
  float fVar21;
  int *local_14;
  int local_10;
  float local_c;
  float *local_8 [2];
  
  uVar7 = FUN_0055ab00();
  iVar8 = FUN_00562f70(uVar7);
  iVar2 = *(int *)(iVar8 + 0x58a);
  puVar9 = (undefined4 *)FUN_00557d60(99);
  FUN_0057c990(&PTR_DAT_0074e788,*puVar9);
  puVar9 = (undefined4 *)FUN_00557d60(100);
  FUN_0057c990(&PTR_DAT_0074e78c,*puVar9);
  puVar9 = (undefined4 *)FUN_00557d60(0x9c);
  FUN_0057c990(&DAT_00c08490,*puVar9);
  puVar9 = (undefined4 *)FUN_00557d60(0x9b);
  FUN_0057c990(&DAT_00c081f0,*puVar9);
  puVar9 = (undefined4 *)FUN_00557d60(0x9d);
  FUN_0057c990(&DAT_00c08534,*puVar9);
  DAT_00c08378 = FUN_005b2b20(s_chassis_0074e884);
  DAT_00c084bc = FUN_005b2b20(s_ballast_0074e88c);
  DAT_00c08234 = FUN_005b2b20(&DAT_0074e894);
  DAT_00c084c0 = FUN_005b2b20(s_lfsusp_0074e89c);
  DAT_00c08310 = FUN_005b2b20(s_rfsusp_0074e8a4);
  DAT_00c084f0 = FUN_005b2b20(s_lfhub_0074e8ac);
  DAT_00c082e0 = FUN_005b2b20(s_rfhub_0074e8b4);
  DAT_00c084ac = FUN_005b2b20(s_lfwheel_0074e8bc);
  DAT_00c084b0 = FUN_005b2b20(s_rfwheel_0074e8c4);
  DAT_00c08254 = FUN_005b2b20(s_raxle_0074e8cc);
  DAT_00c084b4 = FUN_005b2b20(s_lrwheel_0074e8d4);
  DAT_00c084b8 = FUN_005b2b20(s_rrwheel_0074e8dc);
  DAT_00c08318 = FUN_005b2b20(s_engine_0074e8e4);
  DAT_00c08500 = FUN_005b2b20(s_clutch_0074e8ec);
  DAT_00c08394 = FUN_005b2b20(s_outshaft_0074e8f4);
  DAT_00c0866c = FUN_005b2b20(&DAT_0074e900);
  local_14 = (int *)&DAT_00bf3a90;
  iVar19 = 0;
  iVar17 = 0x14;
  do {
    uVar1 = iVar17 - 0x14;
    if ((uVar1 == 0) || (uVar1 == 1)) {
      fVar21 = 0.0;
    }
    else {
      pfVar10 = (float *)FUN_00557d60(iVar17 + 0x79);
      fVar21 = *(float *)((int)&DAT_006f5bd0 + iVar19) * *pfVar10;
    }
    FUN_0057c990(&DAT_00c0849c + iVar19,fVar21);
    if ((int)uVar1 < 2) {
      uVar7 = 0x29;
    }
    else {
      uVar7 = 0x2a;
    }
    pfVar10 = (float *)FUN_00557d60(uVar7);
    *(float *)((int)&DAT_00c086b0 + iVar19) = *pfVar10 * _DAT_006ea44c;
    puVar9 = (undefined4 *)FUN_00557d60(iVar17);
    *(undefined4 *)((int)&DAT_0074e0a0 + iVar19) = *puVar9;
    puVar9 = (undefined4 *)FUN_00557d60(iVar17 + 8);
    *(undefined4 *)((int)&DAT_0074e0c0 + iVar19) = *puVar9;
    puVar9 = (undefined4 *)FUN_00557d60(iVar17 + 0x6d);
    *(undefined4 *)((int)&DAT_0074e0e0 + iVar19) = *puVar9;
    puVar9 = (undefined4 *)FUN_00557d60(iVar17 + 0x71);
    *(undefined4 *)((int)&DAT_0074e0f0 + iVar19) = *puVar9;
    puVar9 = (undefined4 *)FUN_00557d70(iVar17 + -0xc);
    *(undefined4 *)((int)&DAT_00c086c0 + iVar19) = *puVar9;
    puVar9 = (undefined4 *)FUN_00557d70(iVar17 + -4);
    *(undefined4 *)((int)&DAT_00c086d0 + iVar19) = *puVar9;
    piVar11 = (int *)FUN_00557d60(uVar1);
    local_14[-0x1c] = *piVar11;
    puVar9 = (undefined4 *)FUN_00557d60(iVar17 + 0x75);
    *(undefined4 *)((int)&DAT_0074e0d0 + iVar19) = *puVar9;
    puVar9 = (undefined4 *)FUN_00557d60(iVar17 + 0x7d);
    *(undefined4 *)((int)&DAT_00c083b0 + iVar19) = *puVar9;
    puVar9 = (undefined4 *)FUN_00557d60(iVar17 + 0x99);
    *(undefined4 *)((int)&DAT_00c084c8 + iVar19) = *puVar9;
    pfVar10 = (float *)FUN_00557d60(iVar17 + 0x81);
    iVar3 = *local_14;
    *(float *)((int)&DAT_0074e0b0 + iVar19) =
         *pfVar10 * _DAT_006f5ce4 + *(float *)((int)&DAT_00c083b0 + iVar19);
    *(int *)((int)&PTR_DAT_0074e758 + iVar19) = iVar3 + 4;
    *(int *)((int)&PTR_DAT_0074e768 + iVar19) = iVar3 + 8;
    FUN_0057c990((int)&PTR_DAT_0074e778 + iVar19,*(undefined4 *)(iVar3 + 0x1c));
    if ((uVar1 & 1) != 0) {
      pfVar10 = (float *)FUN_00557d60(((int)uVar1 >> 1) + 0x41);
      **(float **)((int)&PTR_DAT_0074e778 + iVar19) =
           **(float **)((int)&PTR_DAT_0074e774 + iVar19) + *pfVar10;
    }
    FUN_0057ca60(&DAT_00c08290 + iVar19,*(undefined4 *)*local_14);
    local_14 = (int *)((int)local_14 + 0xa39);
    iVar19 = iVar19 + 4;
    iVar3 = iVar17 + -0x13;
    iVar17 = iVar17 + 1;
  } while (iVar3 < 4);
  puVar9 = (undefined4 *)FUN_00557d60(0xb1);
  _DAT_00c083c4 = *puVar9;
  *(undefined4 *)(DAT_00c08254 + 0x5d) = *(undefined4 *)(iVar2 + 0x20);
  *(float *)(DAT_00c08378 + 0x5d) =
       (((((((_DAT_006f5b38 + *(float *)(iVar2 + 8)) - _DAT_006ee380) - DAT_00bf3a90[4]) -
          DAT_00bf44c9[4]) - DAT_00bf4f02[4]) - *(float *)(DAT_00bf593b + 0x10)) -
       *(float *)(iVar2 + 0x1c)) - *(float *)(iVar2 + 0x20);
  *(float *)(DAT_00c08378 + 0x61) =
       (_DAT_006f5b38 + *(float *)(iVar2 + 8)) * *(float *)(iVar2 + 0x10);
  *(float *)(DAT_00c08378 + 0x65) =
       (_DAT_006f5b38 + *(float *)(iVar2 + 8)) * *(float *)(iVar2 + 0x14);
  *(float *)(DAT_00c08378 + 0x69) =
       (_DAT_006f5b38 + *(float *)(iVar2 + 8)) * *(float *)(iVar2 + 0x18);
  fVar6 = ((((((_DAT_006f5b38 + *(float *)(iVar2 + 8)) - _DAT_006ee380) * *(float *)(iVar2 + 0x48) -
             DAT_00bf4f02[4]) - *(float *)(DAT_00bf593b + 0x10)) - *(float *)(iVar2 + 0x20)) /
          *(float *)(DAT_00c08378 + 0x5d)) * *(float *)(iVar2 + 0x38);
  fVar21 = *(float *)(iVar2 + 0x38) - fVar6;
  *(float *)(DAT_00c084c0 + 0x44) = fVar6;
  *(float *)(DAT_00c08310 + 0x44) = fVar6;
  _DAT_00c0839c = *(float *)(iVar2 + 0x40) * _DAT_006ea44c;
  _DAT_00c08344 = 0x3ee8f5c3;
  *(float *)(DAT_00c08254 + 0x44) = -fVar21;
  *(float *)(DAT_00c084c0 + 0x48) = *(float *)(iVar2 + 0x3c) * _DAT_006ea44c;
  *(float *)(DAT_00c08310 + 0x48) = *(float *)(iVar2 + 0x3c) * _DAT_006ee368;
  *(float *)(DAT_00c084b4 + 0x48) = *(float *)(iVar2 + 0x40) * _DAT_006ea44c;
  *(float *)(DAT_00c084b8 + 0x48) = *(float *)(iVar2 + 0x40) * _DAT_006ee368;
  *(undefined4 *)(DAT_00c084bc + 0x5d) = 0x4308147b;
  fVar5 = _DAT_006f5b38 + *(float *)(iVar2 + 8);
  local_8[0] = (float *)(fVar6 - (((fVar5 - _DAT_006ee380) * *(float *)(iVar2 + 0x48) +
                                  ((fVar6 - *(float *)(iVar2 + 0x2c)) / *(float *)(iVar2 + 0x38)) *
                                  *(float *)(iVar2 + 0x24)) /
                                 ((fVar5 + *(float *)(iVar2 + 0x24)) - _DAT_006ee380)) *
                                 *(float *)(iVar2 + 0x38));
  pfVar10 = (float *)FUN_00557d60(0xa8);
  pfVar12 = (float *)FUN_00557d60(0xa7);
  *(float *)(DAT_00c084bc + 0x44) =
       (float)local_8[0] - (*pfVar10 + *pfVar12) * _DAT_006f5ce0 * *(float *)(iVar2 + 0x38);
  pfVar10 = (float *)FUN_00557d60(0xa7);
  pfVar12 = (float *)FUN_00557d60(0xa5);
  fVar5 = (*pfVar12 + *pfVar10) * _DAT_006f5ce0 *
          ((fVar6 / *(float *)(iVar2 + 0x38)) *
           (*(float *)(DAT_00c084b4 + 0x48) - *(float *)(DAT_00c084c0 + 0x48)) +
          *(float *)(DAT_00c084c0 + 0x48));
  *(float *)(DAT_00c084bc + 0x48) = fVar5 + fVar5;
  *(undefined4 *)(DAT_00c084bc + 0x4c) = 0xbe000000;
  *(float *)(DAT_00c084c0 + 0x4c) = -DAT_00c083b0;
  *(float *)(DAT_00c08310 + 0x4c) = -_DAT_00c083b4;
  FUN_0057c990(&DAT_00c08664,0);
  pfVar10 = (float *)FUN_00557d60(0x93);
  pfVar12 = (float *)FUN_00557d60(0x91);
  local_8[0] = (float *)FUN_00557d60(0x94);
  pfVar13 = (float *)FUN_00557d60(0x92);
  _DAT_00c083a8 = (*pfVar13 + *pfVar10) - (*pfVar12 + *local_8[0]);
  *(float *)(DAT_00c08254 + 0x4c) = (_DAT_00c083bc + _DAT_00c083b8) * _DAT_006ee368;
  _DAT_00c0869c = (_DAT_00c083bc - _DAT_00c083b8) / *(float *)(iVar2 + 0x40);
  *(float *)(DAT_00c08254 + 0x59) = _DAT_00c0869c * _DAT_006f5cdc;
  _DAT_00c0869c = _DAT_00c0869c * *(float *)(iVar2 + 0x40) * _DAT_006ea44c;
  *(undefined4 *)(DAT_00c084b4 + 0x4c) = 0;
  *(undefined4 *)(DAT_00c084b8 + 0x4c) = 0;
  local_8[0] = (float *)*DAT_00bf4f02;
  pfVar10 = (float *)FUN_00557d60(0x2e);
  pfVar12 = (float *)FUN_00557d60(0x2d);
  _DAT_00c085ac =
       ((float)local_8[0] - (*pfVar12 + *pfVar10) * _DAT_006ea44c) - *(float *)(iVar2 + 0x6c);
  *(float *)(DAT_00c08254 + 0x4c) = *(float *)(DAT_00c08254 + 0x4c) - _DAT_00c085ac;
  *(float *)(DAT_00c084b4 + 0x4c) = _DAT_00c085ac;
  *(float *)(DAT_00c084b8 + 0x4c) = _DAT_00c085ac;
  puVar9 = (undefined4 *)FUN_00557d60(0x99);
  FUN_0057c990(&DAT_00c0867c,*puVar9);
  puVar9 = (undefined4 *)FUN_00557d60(0x9a);
  FUN_0057c990(&DAT_00c08280,*puVar9);
  *(float *)(DAT_00c084f0 + 0x5d) = DAT_00bf3a90[4];
  *(float *)(DAT_00c082e0 + 0x5d) = DAT_00bf44c9[4];
  *(float *)(DAT_00c084b4 + 0x5d) = DAT_00bf4f02[4];
  *(undefined4 *)(DAT_00c084b8 + 0x5d) = *(undefined4 *)(DAT_00bf593b + 0x10);
  FUN_005f5890(iVar8 + 0x524);
  puVar16 = *(uint **)(iVar8 + 0x520);
  puVar15 = *(uint **)(iVar8 + 0x518);
  local_10 = 2;
  ppfVar14 = local_8;
  do {
    uVar1 = *puVar15;
    uVar4 = *puVar16;
    puVar15 = puVar15 + 1;
    puVar16 = puVar16 + 1;
    *ppfVar14 = (float *)(uVar1 ^ uVar4);
    local_10 = local_10 + -1;
    ppfVar14 = ppfVar14 + 1;
  } while (local_10 != 0);
  FUN_005f58a0(iVar8 + 0x524);
  *(float *)(DAT_00c08234 + 0x5d) = -(float)(double)CONCAT44(local_8[1],local_8[0]) - _DAT_006ea67c;
  FUN_005f5890(iVar8 + 0x524);
  puVar16 = *(uint **)(iVar8 + 0x520);
  puVar15 = *(uint **)(iVar8 + 0x518);
  local_10 = 2;
  ppfVar14 = local_8;
  do {
    uVar1 = *puVar15;
    uVar4 = *puVar16;
    puVar15 = puVar15 + 1;
    puVar16 = puVar16 + 1;
    *ppfVar14 = (float *)(uVar1 ^ uVar4);
    local_10 = local_10 + -1;
    ppfVar14 = ppfVar14 + 1;
  } while (local_10 != 0);
  FUN_005f58a0(iVar8 + 0x524);
  *(float *)(DAT_00c08234 + 0x61) =
       (float)(double)CONCAT44(local_8[1],local_8[0]) * *(float *)(iVar2 + 0x28);
  FUN_005f5890(iVar8 + 0x524);
  puVar16 = *(uint **)(iVar8 + 0x520);
  puVar15 = *(uint **)(iVar8 + 0x518);
  local_10 = 2;
  ppfVar14 = local_8;
  do {
    uVar1 = *puVar15;
    uVar4 = *puVar16;
    puVar15 = puVar15 + 1;
    puVar16 = puVar16 + 1;
    *ppfVar14 = (float *)(uVar1 ^ uVar4);
    local_10 = local_10 + -1;
    ppfVar14 = ppfVar14 + 1;
  } while (local_10 != 0);
  FUN_005f58a0(iVar8 + 0x524);
  *(float *)(DAT_00c08234 + 0x65) =
       (float)(double)CONCAT44(local_8[1],local_8[0]) * *(float *)(iVar2 + 0x28);
  FUN_005f5890(iVar8 + 0x524);
  puVar16 = *(uint **)(iVar8 + 0x520);
  puVar15 = *(uint **)(iVar8 + 0x518);
  local_10 = 2;
  ppfVar14 = local_8;
  do {
    uVar1 = *puVar15;
    uVar4 = *puVar16;
    puVar15 = puVar15 + 1;
    puVar16 = puVar16 + 1;
    *ppfVar14 = (float *)(uVar1 ^ uVar4);
    local_10 = local_10 + -1;
    ppfVar14 = ppfVar14 + 1;
  } while (local_10 != 0);
  FUN_005f58a0(iVar8 + 0x524);
  *(float *)(DAT_00c08234 + 0x69) =
       (float)(double)CONCAT44(local_8[1],local_8[0]) * *(float *)(iVar2 + 0x28);
  *(undefined4 *)(DAT_00c08234 + 0x44) = *(undefined4 *)(iVar2 + 0x2c);
  *(undefined4 *)(DAT_00c08234 + 0x48) = *(undefined4 *)(iVar2 + 0x30);
  *(undefined4 *)(DAT_00c08234 + 0x4c) = *(undefined4 *)(iVar2 + 0x34);
  _DAT_0074e860 = *(undefined4 *)(iVar2 + 0x94);
  pfVar10 = (float *)FUN_00557d60(0x28);
  fVar5 = *pfVar10;
  FUN_0057c990(&DAT_00c0850c,*(float *)(iVar8 + 0x582) * fVar5);
  FUN_0057c990(&DAT_00c08510,*(float *)(iVar8 + 0x582) * fVar5);
  fVar5 = _DAT_006e97d8 - fVar5;
  FUN_0057c990(&DAT_00c08514,*(float *)(iVar8 + 0x582) * fVar5);
  FUN_0057c990(&DAT_00c08518,*(float *)(iVar8 + 0x582) * fVar5);
  *(float *)(DAT_00c084b4 + 0x51) = _DAT_00c086b8 * _DAT_006f5cd8;
  *(float *)(DAT_00c084b8 + 0x51) = _DAT_00c086bc * _DAT_006f5cdc;
  pfVar10 = (float *)FUN_00557d60(0x43);
  fVar5 = *pfVar10;
  local_8[0] = (float *)FUN_00557d60(0x44);
  local_8[0] = (float *)*local_8[0];
  fVar20 = (float10)fpatan((float10)*(float *)(iVar2 + 0x70) * (float10)*(float *)(iVar2 + 0x5c),
                           (float10)fVar6);
  *(float *)(DAT_00c08310 + 0x55) = (float)(fVar20 * (float10)_DAT_006f5cdc);
  *(undefined4 *)(DAT_00c084c0 + 0x55) = *(undefined4 *)(DAT_00c08310 + 0x55);
  *(float *)(DAT_00c084f0 + 0x55) = -*(float *)(DAT_00c084c0 + 0x55) - _DAT_006f5b30 * fVar5;
  *(float *)(DAT_00c082e0 + 0x55) =
       -*(float *)(DAT_00c08310 + 0x55) - _DAT_006f5b30 * (float)local_8[0];
  fVar20 = (float10)fpatan((float10)*(float *)(iVar2 + 0x74) * (float10)*(float *)(iVar2 + 0x5c),
                           (float10)fVar21);
  *(float *)(DAT_00c08254 + 0x55) = (float)-(fVar20 * (float10)_DAT_006f5b30);
  fVar20 = (float10)fpatan((float10)*(float *)(iVar2 + 0x68),
                           (float10)*(float *)(iVar2 + 0x3c) * (float10)_DAT_006ea44c);
  *(float *)(DAT_00c084c0 + 0x59) = (float)-(fVar20 * (float10)_DAT_006f5b30);
  pfVar10 = (float *)FUN_00557d60(0x8d);
  *(float *)(DAT_00c084f0 + 0x59) =
       (_DAT_006f5b30 * *(float *)(iVar2 + 0x78) - *(float *)(DAT_00c084c0 + 0x59)) -
       _DAT_006f5b30 * *pfVar10;
  *(float *)(DAT_00c084ac + 0x59) = -(_DAT_006f5b30 * *(float *)(iVar2 + 0x78));
  fVar20 = (float10)fpatan((float10)*(float *)(iVar2 + 0x68),
                           (float10)*(float *)(iVar2 + 0x3c) * (float10)_DAT_006ea44c);
  *(float *)(DAT_00c08310 + 0x59) = (float)(fVar20 * (float10)_DAT_006f5b30);
  pfVar10 = (float *)FUN_00557d60(0x8e);
  *(float *)(DAT_00c082e0 + 0x59) =
       _DAT_006f5b30 * *pfVar10 -
       (_DAT_006f5b30 * *(float *)(iVar2 + 0x78) + *(float *)(DAT_00c08310 + 0x59));
  *(float *)(DAT_00c084b0 + 0x59) = _DAT_006f5b30 * *(float *)(iVar2 + 0x78);
  FUN_0055e880();
  FUN_0055e980();
  FUN_0057c990(&DAT_00c08520,_DAT_006f5bc0 * *(float *)(iVar2 + 0x88));
  FUN_0057c990(&DAT_00c08524,_DAT_006f5bc4 * *(float *)(iVar2 + 0x88));
  FUN_0057c990(&DAT_00c08528,_DAT_006f5bc8 * *(float *)(iVar2 + 0x8c));
  FUN_0057c990(&DAT_00c0852c,_DAT_006f5bcc * *(float *)(iVar2 + 0x8c));
  local_c = *(float *)(iVar2 + 0x80);
  if (DAT_00bddde0 < 0) {
    local_c = *(float *)(iVar2 + 0x7c);
  }
  FUN_0057c990(&DAT_00c08224,DAT_006f5bd0 * *(float *)(iVar2 + 0x80));
  FUN_0057c990(&DAT_00c08228,_DAT_006f5bd4 * local_c);
  FUN_0057c990(&DAT_00c0822c,_DAT_006f5bd8 * *(float *)(iVar2 + 0x84));
  FUN_0057c990(&DAT_00c08230,_DAT_006f5bdc * *(float *)(iVar2 + 0x84));
  fVar21 = *(float *)(iVar2 + 0x90);
  FUN_0057c990(&DAT_00c085a4,-fVar21);
  FUN_0057c990(&DAT_00c085a8,fVar21);
  puVar18 = &DAT_00c08238;
  _DAT_00c082d4 = -(*DAT_00bf3a90 * fVar5);
  _DAT_00c082d8 = -(*DAT_00bf44c9 * (float)local_8[0]);
  _DAT_00c08718 =
       _DAT_006e97d8 / (*(float *)(DAT_00c08500 + 0x61) + *(float *)(DAT_00c08318 + 0x61));
  _DAT_00c0871c =
       _DAT_006e97d8 / (*(float *)(DAT_00c084b8 + 0x65) + *(float *)(DAT_00c084b4 + 0x65));
  do {
    FUN_0057c990(puVar18,0);
    puVar18 = puVar18 + 4;
  } while ((int)puVar18 < 0xc08250);
  FUN_0057c990(&DAT_00c08628,0);
  FUN_0057c990(&DAT_00c0862c,0);
  FUN_0057c990(&DAT_00c08630,0x3f800000);
  FUN_0057c990(&DAT_00c08568,0x49742400);
  FUN_0057c990(&DAT_00c08304,0);
  FUN_0057c990(&DAT_00c08308,0);
  FUN_0057c990(&DAT_00c0830c,0);
  FUN_0057c990(&DAT_00c08538,0);
  FUN_0057c990(&DAT_00c0853c,0);
  FUN_0057c990(&DAT_00c08540,0);
  FUN_0057ca10(&DAT_00c085cc,0);
  FUN_0057ca10(&DAT_00c085d0,0);
  FUN_0057ca10(&DAT_00c085d4,0);
  FUN_0057ca10(&DAT_00c08554,0);
  FUN_0057ca10(&DAT_00c08558,0);
  FUN_0057ca10(&DAT_00c0855c,0);
  FUN_0057ca10(&DAT_00c082a0,0);
  FUN_0057ca10(&DAT_00c082a4,0);
  FUN_0057ca10(&DAT_00c082a8,0);
  FUN_0057ca10(&DAT_00c08594,0);
  FUN_0057ca10(&DAT_00c08598,0);
  FUN_0057ca10(&DAT_00c0859c,0);
  puVar9 = &DAT_00c081f4;
  do {
    FUN_0057c990(puVar9,0);
    puVar9 = puVar9 + 1;
  } while ((int)puVar9 < 0xc08204);
  FUN_0055e840();
  FUN_0055f880();
  DAT_0074e090 = 1;
  FUN_0057c990(&PTR_DAT_0074e094,DAT_00e0b840);
  FUN_0057c990(&PTR_DAT_0074e098,DAT_00e0b844);
  FUN_0057c990(&PTR_DAT_0074e09c,DAT_00e0b848);
  FUN_00410b30();
  return;
}


