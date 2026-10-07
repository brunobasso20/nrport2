/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00424860 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00424860(int param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  byte bVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  byte bVar14;
  int iVar15;
  int iVar16;
  float *pfVar17;
  float *pfVar18;
  float *pfVar19;
  float *pfVar20;
  undefined4 *puVar21;
  float *pfVar22;
  int *piVar23;
  int iVar24;
  uint uVar25;
  float10 fVar26;
  float10 fVar27;
  undefined8 uVar28;
  float local_44;
  float local_40;
  float local_24;
  float local_20 [4];
  float local_10 [4];
  
  iVar15 = FUN_00432cf0(param_1 + 0xef1);
  FUN_00557d70(0x65);
  uVar28 = FUN_00424210(iVar15,1);
  fVar3 = *(float *)(iVar15 + 0x20);
  *(undefined4 *)((ulonglong)uVar28 >> 0x20) =
       *(undefined4 *)(*(int *)(PTR_PTR_00727280 + (int)uVar28 * 4) + 0x44);
  fVar4 = *(float *)(iVar15 + 0x1c);
  iVar16 = FUN_0056ed60(0);
  fVar5 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar16 * 4) + 0x10);
  iVar16 = FUN_0056ed60(1);
  fVar6 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar16 * 4) + 0x10);
  iVar16 = FUN_0056ed60(2);
  fVar7 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar16 * 4) + 0x10);
  iVar16 = FUN_0056ed60(3);
  fVar4 = fVar6 + fVar5 + fVar4;
  fVar3 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar16 * 4) + 0x10) + fVar7 + fVar3;
  fVar5 = (_DAT_006ed7c8 + *(float *)(iVar15 + 8)) - _DAT_006ee380;
  fVar7 = fVar5 - (fVar3 + fVar4);
  fVar1 = fVar5 * *(float *)(iVar15 + 0x48) - fVar3;
  pfVar17 = (float *)FUN_00557d60(0x9e);
  fVar5 = _DAT_006e97d8 / *(float *)(iVar15 + 0x3c);
  fVar2 = (*(float *)(iVar15 + 0x5c) - *(float *)(iVar15 + 0x68)) * fVar5 * *pfVar17 * fVar5 *
          (fVar7 - fVar1);
  pfVar17 = (float *)FUN_00557d60(0x2e);
  pfVar18 = (float *)FUN_00557d60(0x2d);
  fVar6 = (*pfVar17 + *pfVar18) * _DAT_006ea44c;
  fVar5 = *(float *)(iVar15 + 0x5c);
  pfVar17 = (float *)FUN_00557d60(0x9e);
  fVar8 = _DAT_006e97d8 / *(float *)(iVar15 + 0x40);
  fVar10 = fVar8 * *pfVar17 * (fVar5 - fVar6) * fVar8 * fVar1;
  fVar8 = ((fVar1 / fVar7) * *(float *)(iVar15 + 0x38) - *(float *)(iVar15 + 0x2c)) /
          *(float *)(iVar15 + 0x38);
  fVar5 = *(float *)(iVar15 + 0x24);
  fVar6 = fVar5 * fVar8 + fVar1;
  fVar8 = (_DAT_006e97d8 - fVar8) * fVar5 + (fVar7 - fVar1) + fVar6;
  fVar1 = (fVar5 * _DAT_006ea44c + fVar7 * _DAT_006ea44c) * (_DAT_006e97d8 / fVar8);
  fVar6 = (_DAT_006e97d8 / fVar8) * fVar6;
  pfVar17 = (float *)FUN_00557d60(0x40);
  fVar5 = *pfVar17;
  fVar7 = fVar8 - fVar5;
  fVar11 = _DAT_006e97d8 - fVar6;
  pfVar17 = (float *)FUN_00557d60(0xa9);
  *pfVar17 = fVar11 * fVar7 * fVar1;
  fVar5 = fVar5 + fVar8;
  fVar8 = _DAT_006e97d8 - fVar1;
  pfVar17 = (float *)FUN_00557d60(0xaa);
  *pfVar17 = fVar8 * fVar5 * fVar11;
  pfVar17 = (float *)FUN_00557d60(0xab);
  *pfVar17 = fVar5 * fVar6 * fVar1;
  pfVar17 = (float *)FUN_00557d60(0xac);
  *pfVar17 = fVar8 * fVar7 * fVar6;
  pfVar17 = (float *)FUN_00557d60(0x5e);
  pfVar18 = (float *)FUN_00557d60(0xa9);
  fVar5 = fVar4 * _DAT_006ea44c;
  *pfVar17 = fVar5 + *pfVar18;
  pfVar17 = (float *)FUN_00557d60(0x5f);
  pfVar18 = (float *)FUN_00557d60(0xaa);
  *pfVar17 = fVar5 + *pfVar18;
  pfVar17 = (float *)FUN_00557d60(0x60);
  pfVar18 = (float *)FUN_00557d60(0xab);
  fVar5 = fVar3 * _DAT_006ea44c;
  *pfVar17 = fVar5 + *pfVar18;
  pfVar17 = (float *)FUN_00557d60(0x61);
  pfVar18 = (float *)FUN_00557d60(0xac);
  *pfVar17 = fVar5 + *pfVar18;
  pfVar17 = (float *)FUN_00557d60(0x5f);
  pfVar18 = (float *)FUN_00557d60(0x60);
  pfVar19 = (float *)FUN_00557d60(0x61);
  pfVar20 = (float *)FUN_00557d60(0x5e);
  fVar5 = *pfVar17;
  fVar6 = *pfVar19;
  fVar7 = *pfVar20;
  fVar1 = *pfVar18;
  pfVar17 = (float *)FUN_00557d60(0x60);
  pfVar18 = (float *)FUN_00557d60(0x5e);
  fVar1 = _DAT_006e97d8 / (fVar5 + fVar6 + fVar7 + fVar1);
  fVar7 = (*pfVar17 + *pfVar18) * fVar1;
  pfVar17 = (float *)FUN_00557d60(0x61);
  pfVar18 = (float *)FUN_00557d60(0x60);
  fVar1 = (*pfVar17 + *pfVar18) * fVar1;
  pfVar17 = (float *)FUN_00557d60(0x3e);
  fVar5 = *pfVar17;
  pfVar17 = (float *)FUN_00557d60(0x3f);
  fVar11 = _DAT_006e97d8 - fVar1;
  fVar6 = *pfVar17;
  fVar12 = fVar11 * fVar5;
  fVar8 = fVar6 * fVar7;
  pfVar17 = (float *)FUN_00557d60(0xa5);
  *pfVar17 = fVar12 - fVar8;
  fVar13 = _DAT_006e97d8 - fVar7;
  fVar6 = fVar13 * fVar6;
  pfVar17 = (float *)FUN_00557d60(0xa6);
  *pfVar17 = -(fVar6 + fVar12);
  fVar5 = fVar5 * fVar1;
  pfVar17 = (float *)FUN_00557d60(0xa7);
  *pfVar17 = fVar5 + fVar8;
  pfVar17 = (float *)FUN_00557d60(0xa8);
  *pfVar17 = fVar6 - fVar5;
  local_20[0] = fVar11 * fVar7 * _DAT_006ee380;
  local_20[1] = fVar13 * fVar11 * _DAT_006ee380;
  local_20[2] = fVar1 * fVar7 * _DAT_006ee380;
  local_20[3] = fVar13 * fVar1 * _DAT_006ee380;
  pfVar17 = (float *)FUN_00557d60(0x5e);
  pfVar18 = (float *)FUN_00557d60(0xa5);
  *pfVar17 = *pfVar18 + *pfVar17 + local_20[0];
  pfVar17 = (float *)FUN_00557d60(0x5f);
  pfVar18 = (float *)FUN_00557d60(0xa6);
  *pfVar17 = local_20[1] + *pfVar18 + *pfVar17;
  pfVar17 = (float *)FUN_00557d60(0x60);
  pfVar18 = (float *)FUN_00557d60(0xa7);
  *pfVar17 = local_20[2] + *pfVar17 + *pfVar18;
  pfVar17 = (float *)FUN_00557d60(0x61);
  pfVar18 = (float *)FUN_00557d60(0xa8);
  *pfVar17 = *pfVar17 + *pfVar18 + local_20[3];
  pfVar17 = (float *)FUN_00557d60(0xa5);
  *pfVar17 = *pfVar17 - fVar2;
  pfVar17 = (float *)FUN_00557d60(0xa6);
  *pfVar17 = fVar2 + *pfVar17;
  pfVar17 = (float *)FUN_00557d60(0xa7);
  *pfVar17 = *pfVar17 - fVar10;
  pfVar17 = (float *)FUN_00557d60(0xa8);
  *pfVar17 = fVar10 + *pfVar17;
  pfVar17 = (float *)FUN_00557d60(0xa9);
  pfVar18 = (float *)FUN_00557d60(0xa5);
  *pfVar17 = local_20[0] + *pfVar17 + *pfVar18;
  pfVar17 = (float *)FUN_00557d60(0xaa);
  pfVar18 = (float *)FUN_00557d60(0xa6);
  *pfVar17 = *pfVar17 + *pfVar18 + local_20[1];
  pfVar17 = (float *)FUN_00557d60(0xab);
  pfVar18 = (float *)FUN_00557d60(0xa7);
  *pfVar17 = local_20[2] + *pfVar18 + *pfVar17;
  pfVar17 = (float *)FUN_00557d60(0xac);
  pfVar18 = (float *)FUN_00557d60(0xa8);
  bVar14 = DAT_00871a54;
  bVar9 = DAT_00871a54 & 1;
  *pfVar17 = *pfVar17 + *pfVar18 + local_20[3];
  if (bVar9 == 0) {
    _DAT_00871a68 = _DAT_006ed7b0 * _DAT_006ed7a4;
    DAT_00871a54 = bVar14 | 1;
  }
  iVar16 = 0;
  do {
    pfVar17 = (float *)FUN_00557d60(iVar16 + 0xa9);
    iVar24 = iVar16 + 1;
    local_20[iVar16 + 4] = _DAT_00871a68 * *pfVar17;
    iVar16 = iVar24;
  } while (iVar24 < 4);
  pfVar17 = (float *)FUN_00557d60(0x14);
  local_20[0] = local_10[0] / *pfVar17;
  pfVar17 = (float *)FUN_00557d60(0x15);
  local_20[1] = local_10[1] / *pfVar17;
  pfVar17 = (float *)FUN_00557d60(0x99);
  *pfVar17 = local_20[1] - local_20[0];
  pfVar17 = (float *)FUN_00557d60(0x16);
  fVar5 = (local_10[3] + local_10[2]) * _DAT_006ea44c;
  local_20[2] = ((local_10[2] - local_10[3]) * *(float *)(iVar15 + 0x40) * _DAT_006ee37c + fVar5) /
                *pfVar17;
  pfVar17 = (float *)FUN_00557d60(0x17);
  local_20[3] = ((local_10[3] - local_10[2]) * *(float *)(iVar15 + 0x40) * _DAT_006ee37c + fVar5) /
                *pfVar17;
  fVar5 = local_20[3] - local_20[2];
  pfVar17 = (float *)FUN_00557d60(0x9a);
  *pfVar17 = fVar5 * _DAT_006ee378;
  fVar7 = (local_20[3] + local_20[2]) * _DAT_006ea44c;
  local_20[3] = fVar5 * *(float *)(iVar15 + 0x40) * _DAT_006ee37c;
  local_20[2] = fVar7 - local_20[3];
  local_20[3] = local_20[3] + fVar7;
  iVar16 = FUN_0056ed60(1);
  fVar5 = **(float **)(PTR_PTR_00734368 + iVar16 * 4);
  iVar16 = FUN_0056ed60(0);
  fVar6 = **(float **)(PTR_PTR_00734368 + iVar16 * 4);
  pfVar17 = (float *)FUN_00557d60(0x41);
  *pfVar17 = fVar5 - fVar6;
  iVar16 = FUN_0056ed60(3);
  fVar5 = **(float **)(PTR_PTR_00734368 + iVar16 * 4);
  iVar16 = FUN_0056ed60(2);
  fVar6 = **(float **)(PTR_PTR_00734368 + iVar16 * 4);
  pfVar17 = (float *)FUN_00557d60(0x42);
  uVar25 = 0;
  *pfVar17 = fVar5 - fVar6;
  do {
    if ((int)uVar25 < 2) {
      local_24 = *(float *)(iVar15 + 0x60);
      pfVar17 = (float *)FUN_00557d60(uVar25 + 0x24);
      local_40 = *pfVar17;
      if (uVar25 == 0) {
        local_44 = *(float *)(iVar15 + 0x7c);
      }
      else {
        local_44 = *(float *)(iVar15 + 0x80);
      }
    }
    else {
      local_24 = *(float *)(iVar15 + 100);
      pfVar17 = (float *)FUN_00557d60(uVar25 + 0x24);
      local_40 = *pfVar17;
      local_44 = *(float *)(iVar15 + 0x84);
    }
    iVar16 = uVar25 + 0x20;
    pfVar17 = (float *)FUN_00557d60(iVar16);
    fVar26 = (float10)fcos((float10)*pfVar17);
    fVar5 = (float)fVar26;
    pfVar17 = (float *)FUN_00557d60(iVar16);
    fVar26 = (float10)fsin((float10)*pfVar17);
    iVar24 = FUN_0056ed60(uVar25);
    fVar8 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar24 * 4) + 4);
    iVar24 = FUN_0056ed60(uVar25);
    fVar6 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar24 * 4) + 8);
    iVar24 = FUN_0056ed60(uVar25);
    fVar1 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar24 * 4) + 0x1c);
    if ((uVar25 & 1) != 0) {
      iVar24 = FUN_0056ed60(uVar25 - 1);
      fVar1 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar24 * 4) + 0x1c);
      pfVar17 = (float *)FUN_00557d60(((int)uVar25 >> 1) + 0x41);
      fVar1 = fVar1 + *pfVar17;
    }
    puVar21 = (undefined4 *)FUN_00557d60(uVar25);
    fVar2 = fVar3;
    if ((int)uVar25 < 2) {
      fVar2 = fVar4;
    }
    fVar27 = (float10)FUN_00558780(fVar2 * _DAT_00871a68 * _DAT_006ea44c + local_20[uVar25 + 4],
                                   *puVar21,uVar25);
    pfVar17 = (float *)FUN_00557d60(uVar25 + 0x91);
    *pfVar17 = ((local_40 + local_24) - local_20[uVar25]) -
               (float)((float10)(fVar1 * fVar5 * fVar5 + fVar8 * fVar5 + fVar6 * (float)ABS(fVar26))
                      - fVar27);
    if ((*(byte *)(iVar15 + 0x9c) & 1) == 0) {
      pfVar17 = (float *)FUN_00557d60(uVar25 + 0xad);
      local_40 = (&DAT_00721fac)[uVar25];
    }
    else {
      pfVar17 = (float *)FUN_00557d60(uVar25 + 0xad);
    }
    *pfVar17 = local_40 - local_20[uVar25];
    pfVar17 = (float *)FUN_00557d60(uVar25 + 0xb2);
    *pfVar17 = local_20[uVar25];
    pfVar17 = (float *)FUN_00557d60(uVar25 + 0x8d);
    pfVar18 = (float *)FUN_00557d60(iVar16);
    *pfVar17 = *pfVar18 - -(local_44 * local_20[uVar25]);
    pfVar17 = (float *)FUN_00557d60(0x9e);
    fVar5 = -(*pfVar17 / *(float *)(iVar15 + 0x40));
    if (uVar25 == 0) {
      pfVar17 = (float *)FUN_00557d60(0x8d);
      fVar5 = fVar5 + *pfVar17;
LAB_0042525e:
      *pfVar17 = fVar5;
    }
    else if (uVar25 == 1) {
      pfVar17 = (float *)FUN_00557d60(0x8e);
      fVar5 = *pfVar17 - fVar5;
      goto LAB_0042525e;
    }
    uVar25 = uVar25 + 1;
    if (3 < (int)uVar25) {
      if ((*(byte *)(iVar15 + 0x9c) & 1) == 0) {
        pfVar17 = (float *)FUN_00557d60(0x25);
        pfVar18 = (float *)FUN_00557d60(0x26);
        pfVar19 = (float *)FUN_00557d60(0x27);
        pfVar20 = (float *)FUN_00557d60(0xb1);
        pfVar22 = (float *)FUN_00557d60(0x24);
        fVar26 = (float10)fpatan(((((float10)DAT_00721fac - (float10)*pfVar22) +
                                  ((float10)_DAT_00721fb0 - (float10)*pfVar17)) *
                                  (float10)_DAT_006ea44c -
                                 (((float10)_DAT_00721fb8 - (float10)*pfVar19) +
                                 ((float10)_DAT_00721fb4 - (float10)*pfVar18)) *
                                 (float10)_DAT_006ea44c) / (float10)*(float *)(iVar15 + 0x38),
                                 (float10)1);
        *pfVar20 = (float)fVar26;
      }
      else {
        puVar21 = (undefined4 *)FUN_00557d60(0xb1);
        *puVar21 = 0;
      }
      piVar23 = (int *)FUN_00557d70(0x3a);
      iVar15 = *piVar23;
      pfVar17 = (float *)FUN_00557d60(0x9f);
      fVar26 = (float10)fcos((float10)*(int *)(&DAT_006ed7e0 + iVar15 * 8) * (float10)_DAT_006ed7b4)
      ;
      *pfVar17 = (float)fVar26;
      pfVar17 = (float *)FUN_00557d60(0xa1);
      *pfVar17 = _DAT_006ed7dc * _DAT_006e9804;
      pfVar17 = (float *)FUN_00557d60(0xa1);
      pfVar18 = (float *)FUN_00557d60(0xa3);
      pfVar19 = (float *)FUN_00557d60(0x9f);
      *pfVar18 = *pfVar17 * *pfVar19;
      pfVar17 = (float *)FUN_00557d60(0xa0);
      fVar26 = (float10)fcos((float10)*(int *)(&DAT_006ed7e4 + iVar15 * 8) * (float10)_DAT_006ed7b4)
      ;
      *pfVar17 = (float)fVar26;
      pfVar17 = (float *)FUN_00557d60(0xa2);
      *pfVar17 = _DAT_006ed7dc * _DAT_006e9804;
      pfVar17 = (float *)FUN_00557d60(0xa2);
      pfVar18 = (float *)FUN_00557d60(0xa4);
      pfVar19 = (float *)FUN_00557d60(0xa0);
      *pfVar18 = *pfVar17 * *pfVar19;
      pfVar17 = (float *)FUN_00557d60(0x2d);
      pfVar18 = (float *)FUN_00557d60(0x2e);
      fVar5 = (*pfVar18 - *pfVar17) / (_DAT_006ed798 * _DAT_006ee374);
      fVar6 = ((((_DAT_006ed798 * _DAT_006ee370 - _DAT_006ed798 * _DAT_006ea630) * _DAT_006ea44c) /
               (_DAT_006ed798 * _DAT_006ee36c)) * _DAT_006ed740) / (_DAT_006ed798 * _DAT_006ee370);
      pfVar17 = (float *)FUN_00557d60(0x9b);
      *pfVar17 = _DAT_006ed798 * _DAT_006ee374 * fVar6 * fVar5 * _DAT_006ee368;
      pfVar17 = (float *)FUN_00557d60(0x9c);
      *pfVar17 = -(fVar6 * fVar5);
      pfVar17 = (float *)FUN_00557d60(0x9a);
      pfVar18 = (float *)FUN_00557d60(0x9b);
      pfVar19 = (float *)FUN_00557d60(0x9d);
      pfVar20 = (float *)FUN_00557d60(0x9c);
      *pfVar19 = *pfVar17 * *pfVar18 + fVar7 * *pfVar20;
      return;
    }
  } while( true );
}


