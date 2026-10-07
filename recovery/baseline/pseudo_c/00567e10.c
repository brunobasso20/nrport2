/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00567e10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00567e10(void)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  undefined4 *puVar6;
  float *pfVar7;
  float *pfVar8;
  int *piVar9;
  int iVar10;
  undefined4 *puVar11;
  float10 fVar12;
  float10 fVar13;
  float10 fVar14;
  undefined1 local_20 [4];
  int local_1c;
  float local_18;
  float local_14;
  float *local_10;
  float local_c;
  float local_8;
  float local_4;
  
  puVar6 = (undefined4 *)FUN_004116f0(4);
  DAT_00c5c190 = *puVar6;
  DAT_00c5c194 = puVar6[1];
  _DAT_00c5c198 = puVar6[2];
  puVar6 = (undefined4 *)FUN_00411730(4);
  _DAT_00c5c19c = *puVar6;
  _DAT_00c5c1a0 = puVar6[1];
  _DAT_00c5c1a4 = puVar6[2];
  fVar12 = (float10)FUN_00411770(4);
  _DAT_00c5c1a8 = (float)fVar12;
  puVar6 = (undefined4 *)FUN_004117b0(4);
  _DAT_00c5c1ac = *puVar6;
  _DAT_00c5c1b0 = puVar6[1];
  _DAT_00c5c1b4 = puVar6[2];
  puVar6 = (undefined4 *)FUN_004116f0(5);
  DAT_00c5856c = *puVar6;
  DAT_00c58570 = puVar6[1];
  _DAT_00c58574 = puVar6[2];
  puVar6 = (undefined4 *)FUN_00411730(5);
  DAT_00c58578 = *puVar6;
  DAT_00c5857c = puVar6[1];
  DAT_00c58580 = puVar6[2];
  fVar12 = (float10)FUN_00411770(5);
  DAT_00c58584 = (float)fVar12;
  puVar6 = (undefined4 *)FUN_004117b0(5);
  DAT_00c58588 = *puVar6;
  DAT_00c5858c = puVar6[1];
  DAT_00c58590 = puVar6[2];
  puVar6 = (undefined4 *)FUN_004116f0(8);
  DAT_00c5c168 = *puVar6;
  DAT_00c5c16c = puVar6[1];
  DAT_00c5c170 = puVar6[2];
  puVar6 = (undefined4 *)FUN_00411730(8);
  DAT_00c5c174 = *puVar6;
  DAT_00c5c178 = puVar6[1];
  DAT_00c5c17c = puVar6[2];
  fVar12 = (float10)FUN_00411770(8);
  DAT_00c5c180 = (float)fVar12;
  puVar6 = (undefined4 *)FUN_004117b0(8);
  fVar5 = DAT_00c5c298;
  fVar4 = DAT_00c5c294;
  fVar3 = DAT_00c5c290;
  DAT_00c5c184 = *puVar6;
  DAT_00c5c188 = puVar6[1];
  DAT_00c5c18c = puVar6[2];
  pfVar7 = (float *)&DAT_00c5745c;
  do {
    local_14 = 5.60519e-45;
    do {
      iVar10 = 6;
      pfVar8 = pfVar7;
      do {
        fVar1 = DAT_006f5f18;
        pfVar8[-3] = fVar3;
        pfVar8[-2] = fVar4;
        pfVar8[-1] = fVar5;
        *pfVar8 = fVar3;
        pfVar8[1] = fVar4;
        pfVar8[2] = fVar5;
        pfVar7 = pfVar8 + 9;
        iVar10 = iVar10 + -1;
        pfVar8[3] = fVar1;
        pfVar8[4] = DAT_006f5f1c;
        pfVar8[5] = DAT_006f5f20;
        DAT_00c5c1c4 = DAT_00c5c2a4;
        DAT_00c5c1bc = DAT_00c5c29c;
        pfVar8 = pfVar7;
      } while (iVar10 != 0);
      local_14 = (float)((int)local_14 + -1);
    } while (local_14 != 0.0);
  } while ((int)pfVar7 < 0xc5853c);
  DAT_00c5c1b8 = 0x42c80000;
  puVar6 = &DAT_00c57450;
  puVar11 = &DAT_00c5b070;
  for (iVar10 = 0x438; iVar10 != 0; iVar10 = iVar10 + -1) {
    *puVar11 = *puVar6;
    puVar6 = puVar6 + 1;
    puVar11 = puVar11 + 1;
  }
  DAT_00c57440 = DAT_00c5c1b8;
  DAT_00c5c1c0 = DAT_00c5c2a0;
  DAT_00c57444 = DAT_00c5c1bc;
  DAT_00c57448 = DAT_00c5c2a0;
  DAT_00c5744c = DAT_00c5c1c4;
  local_1c = 0;
  local_14 = 0.0;
  pfVar7 = (float *)&DAT_00c57380;
  do {
    FUN_005150fa(pfVar7 + -2,pfVar7 + -1,pfVar7,local_20,local_20,local_20,local_20,local_20,
                 local_20,local_20,local_20,(float)local_1c * _DAT_006ecfc8 + _DAT_006ed00c,
                 0x41200000,0);
    *pfVar7 = *pfVar7 + _DAT_006ea514;
    FUN_005150fa(&local_c,&local_8,&local_4,local_20,local_20,local_20,local_20,local_20,local_20,
                 local_20,local_20,0,0,0);
    fVar12 = (float10)local_c - (float10)pfVar7[-2];
    fVar13 = (float10)local_8 - (float10)pfVar7[-1];
    pfVar7[3] = 0.0;
    fVar14 = (float10)fpatan(fVar13,fVar12);
    pfVar7[1] = (float)fVar14;
    fVar12 = (float10)fpatan(-((float10)local_4 - (float10)*pfVar7),
                             SQRT(fVar12 * fVar12 + fVar13 * fVar13));
    pfVar7[2] = (float)fVar12;
    fVar3 = DAT_006f5f1c;
    pfVar8 = pfVar7 + 9;
    pfVar7[4] = DAT_006f5f18;
    fVar4 = DAT_006f5f20;
    pfVar7[5] = fVar3;
    pfVar7[6] = fVar4;
    local_1c = local_1c + 1;
    pfVar7 = pfVar8;
  } while ((int)pfVar8 < 0xc573c8);
  fVar12 = (float10)FUN_00516e1a();
  if ((float10)_DAT_006f5f28 <= fVar12) {
    local_18 = 500.0;
  }
  else {
    fVar12 = (float10)FUN_00516e1a();
    local_18 = (float)(fVar12 * (float10)_DAT_006f5e34);
  }
  local_1c = 0;
  local_14 = 0.0;
  local_10 = (float *)&DAT_00c585a4;
  do {
    pfVar7 = local_10;
    fVar12 = (float10)FUN_00516e1a();
    fVar5 = DAT_00c5c298;
    fVar4 = DAT_00c5c294;
    fVar3 = DAT_00c5c290;
    if (fVar12 - (float10)local_18 <= (float10)local_14) break;
    fVar1 = local_18 * _DAT_006ee488;
    iVar10 = 3;
    do {
      pfVar7[4] = 0.0;
      *pfVar7 = local_14;
      fVar2 = DAT_006f5f18;
      pfVar7[1] = -15.0;
      pfVar7[8] = fVar3;
      pfVar7[2] = 18.0;
      pfVar7[3] = fVar1;
      pfVar7[9] = fVar4;
      pfVar7[5] = 0.1;
      pfVar7[6] = 0.3;
      pfVar7[7] = 0.07;
      pfVar7[10] = fVar5;
      pfVar7[0xb] = fVar2;
      pfVar7[0xc] = DAT_006f5f1c;
      pfVar7[0xd] = DAT_006f5f20;
      *(undefined1 *)(pfVar7 + 0xe) = 0;
      iVar10 = iVar10 + -1;
      pfVar7 = pfVar7 + 0x391;
    } while (iVar10 != 0);
    local_14 = local_14 + local_18;
    local_10 = (float *)((int)local_10 + 0x39);
    local_1c = local_1c + 1;
  } while ((int)local_10 < 0xc593e4);
  piVar9 = &DAT_00c585a0;
  do {
    *piVar9 = local_1c;
    piVar9 = piVar9 + 0x391;
  } while ((int)piVar9 < 0xc5b06c);
  puVar6 = &DAT_00c585a0;
  puVar11 = &DAT_00c548a0;
  for (iVar10 = 0xab3; iVar10 != 0; iVar10 = iVar10 + -1) {
    *puVar11 = *puVar6;
    puVar6 = puVar6 + 1;
    puVar11 = puVar11 + 1;
  }
  return;
}


