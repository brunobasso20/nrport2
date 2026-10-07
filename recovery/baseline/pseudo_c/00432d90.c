/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00432d90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00432d90(int param_1,int param_2,int param_3,undefined4 param_4)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  undefined4 uVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  float fVar15;
  int iVar16;
  int iVar17;
  int iVar18;
  undefined4 *puVar19;
  undefined *puVar20;
  int iVar21;
  int *piVar22;
  float *pfVar23;
  int *piVar24;
  undefined *local_b4;
  int local_b0;
  int *local_ac;
  float local_9c;
  float local_98;
  float local_94;
  undefined4 local_90;
  float local_8c;
  undefined4 local_88;
  undefined4 local_84;
  undefined4 local_80;
  float local_7c;
  float local_78;
  int local_74 [10];
  float local_4c;
  float local_48;
  undefined4 local_44;
  undefined4 local_40;
  undefined4 local_3c;
  float local_38;
  float local_34;
  undefined4 local_30;
  undefined4 local_2c;
  undefined4 local_28;
  float local_24;
  float local_20;
  undefined4 local_1c;
  undefined4 local_18;
  undefined4 local_14;
  float local_10;
  float local_c;
  undefined4 local_8;
  undefined4 local_4;
  
  iVar16 = FUN_00433610(param_3);
  if (iVar16 == 0) {
    return 0;
  }
  puVar19 = (undefined4 *)(&DAT_00883500)[param_1];
  if (puVar19 != (undefined4 *)0x0) {
    iVar16 = puVar19[0xf];
    puVar19[0xf] = iVar16 + -1;
    if (iVar16 + -1 < 1) {
      (**(code **)*puVar19)(1);
    }
    (&DAT_00883500)[param_1] = 0;
    *(undefined4 *)(&DAT_008903c8 + param_1 * 4) = 0;
  }
  FUN_00432d30();
  puVar20 = (&PTR_DAT_00725ab8)[param_3 + param_2 * 6];
  fVar11 = *(float *)(puVar20 + 0x48) * *(float *)(puVar20 + 0x38);
  local_78 = *(float *)(puVar20 + 0x3c) * _DAT_006ea44c;
  iVar16 = FUN_0056ed60(0);
  fVar1 = **(float **)(PTR_PTR_00734368 + iVar16 * 4);
  fVar2 = *(float *)(puVar20 + 0x5c);
  iVar16 = FUN_0056ed60(1);
  fVar3 = **(float **)(PTR_PTR_00734368 + iVar16 * 4);
  fVar4 = *(float *)(puVar20 + 0x5c);
  local_7c = *(float *)(puVar20 + 0x38) - fVar11;
  fVar13 = *(float *)(puVar20 + 0x40) * _DAT_006ea44c;
  iVar16 = FUN_0056ed60(2);
  fVar5 = **(float **)(PTR_PTR_00734368 + iVar16 * 4);
  fVar6 = *(float *)(puVar20 + 0x5c);
  iVar16 = FUN_0056ed60(3);
  local_94 = **(float **)(PTR_PTR_00734368 + iVar16 * 4) - *(float *)(puVar20 + 0x5c);
  iVar16 = FUN_0056ed60(0);
  local_8c = *(float *)(*(int *)(PTR_PTR_00734368 + iVar16 * 4) + 0x10);
  iVar16 = FUN_0056ed60(2);
  fVar7 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar16 * 4) + 0x10);
  iVar16 = FUN_0056ed60(1);
  fVar8 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar16 * 4) + 0x10);
  iVar16 = FUN_0056ed60(3);
  fVar9 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar16 * 4) + 0x10);
  fVar13 = fVar13 * fVar13;
  fVar12 = local_7c * local_7c;
  fVar14 = local_78 * local_78;
  fVar11 = fVar11 * fVar11;
  fVar15 = *(float *)(puVar20 + 0x24) * _DAT_006ea44c + *(float *)(puVar20 + 8) + _DAT_006ee508;
  local_94 = local_94 * local_94;
  fVar5 = (fVar5 - fVar6) * (fVar5 - fVar6);
  fVar3 = (fVar3 - fVar4) * (fVar3 - fVar4);
  fVar1 = (fVar1 - fVar2) * (fVar1 - fVar2);
  FUN_005f5fa0(param_4,fVar15,
               fVar15 * *(float *)(puVar20 + 0x10) +
               (fVar13 + local_94) * fVar9 +
               (fVar13 + fVar5) * fVar7 + (fVar14 + fVar3) * fVar8 + (fVar14 + fVar1) * local_8c,
               fVar15 * *(float *)(puVar20 + 0x14) +
               (fVar12 + local_94) * fVar9 +
               (fVar12 + fVar5) * fVar7 + (fVar11 + fVar3) * fVar8 + (fVar1 + fVar11) * local_8c,
               fVar15 * *(float *)(puVar20 + 0x18) +
               (fVar8 + local_8c) * (fVar11 + fVar14) + (fVar9 + fVar7) * (fVar12 + fVar13));
  local_74[0] = 0;
  local_74[1] = 0;
  local_74[2] = 0;
  local_74[3] = 0;
  fVar1 = _DAT_006ee5e0 / _DAT_006ee4e4 - *(float *)(puVar20 + 0x5c);
  FUN_00433ae0(&local_90,&local_84,&local_88,&local_80,&local_9c,&local_98,&DAT_00725b30,0x10);
  local_98 = local_98 + fVar1;
  local_9c = local_9c + fVar1;
  iVar16 = FUN_00577520(local_84,local_90,local_80,local_88,local_98,local_9c,param_4);
  local_74[4] = 0;
  local_74[5] = 0;
  local_74[6] = 0;
  local_74[7] = 0;
  local_74[8] = 0;
  local_ac = &DAT_006ee520;
  local_b4 = &DAT_008842a0;
  pfVar23 = (float *)&DAT_00725b38;
  local_b0 = *(int *)(iVar16 + 0xc);
  do {
    if (local_b4 == (undefined *)0x0) {
      iVar17 = 0;
    }
    else {
      iVar17 = FUN_00575780(pfVar23[-2],pfVar23[-1],fVar1 + *pfVar23,pfVar23[1],pfVar23[2],param_4,
                            0x11);
    }
    fVar3 = _DAT_006ea454;
    fVar2 = pfVar23[2];
    *(int *)(iVar17 + 8) = local_b0;
    if ((fVar3 < fVar2) && (*local_ac != -1)) {
      local_74[*local_ac + 4] = iVar17;
    }
    pfVar23 = pfVar23 + 5;
    local_b4 = local_b4 + 0x41;
    local_ac = local_ac + 1;
    local_b0 = iVar17;
  } while ((int)pfVar23 < 0x725c78);
  *(int *)(iVar16 + 0xc) = iVar17;
  FUN_00433b40(&DAT_00725b30,param_2,param_3);
  local_74[9] = DAT_00725c70;
  local_4c = *(float *)(puVar20 + 0x3c) * _DAT_006ea44c - _DAT_006ee5dc;
  iVar17 = FUN_0056ed60(0);
  local_48 = **(float **)(PTR_PTR_00734368 + iVar17 * 4) - *(float *)(puVar20 + 0x5c);
  local_44 = DAT_00725cc0;
  local_40 = 0;
  local_3c = DAT_00725c84;
  local_38 = -(*(float *)(puVar20 + 0x3c) * _DAT_006ea44c - _DAT_006ee5dc);
  iVar17 = FUN_0056ed60(1);
  local_34 = **(float **)(PTR_PTR_00734368 + iVar17 * 4) - *(float *)(puVar20 + 0x5c);
  local_30 = DAT_00725cc4;
  local_2c = 0;
  local_28 = DAT_00725c98;
  local_24 = *(float *)(puVar20 + 0x40) * _DAT_006ea44c - _DAT_006ee5dc;
  iVar17 = FUN_0056ed60(2);
  local_20 = **(float **)(PTR_PTR_00734368 + iVar17 * 4) - *(float *)(puVar20 + 0x5c);
  local_1c = DAT_00725cc8;
  local_18 = 0;
  local_14 = DAT_00725cac;
  local_10 = -(*(float *)(puVar20 + 0x40) * _DAT_006ea44c - _DAT_006ee5dc);
  iVar17 = FUN_0056ed60(3);
  local_c = **(float **)(PTR_PTR_00734368 + iVar17 * 4) - *(float *)(puVar20 + 0x5c);
  local_8 = DAT_00725ccc;
  local_4 = 0;
  FUN_004339c0(&local_90,&local_84,&local_88,&local_80,&local_9c,&local_98,local_74 + 9,4);
  iVar17 = FUN_00577520(local_84,local_90,local_80,local_88,local_98,local_9c,param_4);
  iVar21 = 0;
  pfVar23 = &local_48;
  *(undefined4 *)(iVar16 + 8) = *(undefined4 *)(iVar17 + 0xc);
  *(int *)(iVar17 + 0xc) = iVar16;
  puVar20 = &DAT_008833e8;
  do {
    if (puVar20 == (undefined *)0x0) {
      iVar18 = 0;
    }
    else {
      iVar18 = FUN_00575810(pfVar23[-2],pfVar23[-1],*pfVar23,pfVar23[1],param_4,0x13,iVar21);
    }
    uVar10 = *(undefined4 *)(iVar17 + 0xc);
    local_74[iVar21] = iVar18;
    puVar20 = puVar20 + 0x45;
    iVar21 = iVar21 + 1;
    pfVar23 = pfVar23 + 5;
    *(undefined4 *)(iVar18 + 8) = uVar10;
    *(int *)(iVar17 + 0xc) = iVar18;
  } while ((int)puVar20 < 0x8834fc);
  iVar21 = FUN_00577c80(0x5b);
  if (iVar21 == 0) {
    DAT_00894790 = (undefined4 *)0x0;
    return 0;
  }
  puVar19 = (undefined4 *)FUN_00577b80(iVar17,0,0,0);
  iVar21 = local_74[1];
  iVar17 = local_74[0];
  if (puVar19 == (undefined4 *)0x0) {
    DAT_00894790 = puVar19;
    return 0;
  }
  DAT_00894790 = puVar19;
  puVar19[6] = local_74[0];
  puVar19[7] = local_74[1];
  puVar19[8] = local_74[2];
  puVar19[9] = local_74[3];
  piVar22 = local_74 + 4;
  piVar24 = puVar19 + 10;
  for (iVar18 = 5; iVar18 != 0; iVar18 = iVar18 + -1) {
    *piVar24 = *piVar22;
    piVar22 = piVar22 + 1;
    piVar24 = piVar24 + 1;
  }
  puVar19[0xf] = puVar19[0xf] + 1;
  iVar18 = FUN_00577c80(0x5b);
  if (iVar18 != 0) {
    DAT_0089478c = (undefined4 *)FUN_00577b80(iVar16,0,0,0);
    if (DAT_0089478c == (undefined4 *)0x0) goto LAB_0043359c;
    DAT_0089478c[0xf] = DAT_0089478c[0xf] + 1;
    iVar16 = FUN_00577c80(0x5b);
    if (iVar16 == 0) {
LAB_00433577:
      DAT_0089477c = (undefined4 *)0x0;
    }
    else {
      DAT_0089477c = (undefined4 *)FUN_00577b80(iVar17,0,local_74 + 9,0);
      if (DAT_0089477c != (undefined4 *)0x0) {
        DAT_0089477c[0xf] = DAT_0089477c[0xf] + 1;
        iVar16 = FUN_00577c80(0x5b);
        if (iVar16 == 0) {
LAB_00433558:
          DAT_00894780 = (undefined4 *)0x0;
        }
        else {
          DAT_00894780 = (undefined4 *)FUN_00577b80(iVar21,0,&local_3c,0);
          if (DAT_00894780 != (undefined4 *)0x0) {
            DAT_00894780[0xf] = DAT_00894780[0xf] + 1;
            iVar16 = FUN_00577c80(0x5b);
            if (iVar16 == 0) {
LAB_00433539:
              DAT_00894784 = (undefined4 *)0x0;
            }
            else {
              DAT_00894784 = (undefined4 *)FUN_00577b80(local_74[2],0,&local_28,0);
              if (DAT_00894784 != (undefined4 *)0x0) {
                DAT_00894784[0xf] = DAT_00894784[0xf] + 1;
                iVar16 = FUN_00577c80(0x5b);
                if (iVar16 == 0) {
                  _DAT_00894788 = 0;
                }
                else {
                  _DAT_00894788 = FUN_00577b80(local_74[3],0,&local_14,0);
                  if (_DAT_00894788 != 0) {
                    *(int *)(_DAT_00894788 + 0x3c) = *(int *)(_DAT_00894788 + 0x3c) + 1;
                    FUN_00578e80(param_1,DAT_00894790,&DAT_0089477c);
                    return 1;
                  }
                }
                puVar19 = DAT_00894784;
                iVar16 = DAT_00894784[0xf];
                DAT_00894784[0xf] = iVar16 + -1;
                if (iVar16 + -1 < 1) {
                  (**(code **)*puVar19)(1);
                }
                goto LAB_00433539;
              }
            }
            puVar19 = DAT_00894780;
            iVar16 = DAT_00894780[0xf];
            DAT_00894780[0xf] = iVar16 + -1;
            if (iVar16 + -1 < 1) {
              (**(code **)*puVar19)(1);
            }
            goto LAB_00433558;
          }
        }
        puVar19 = DAT_0089477c;
        iVar16 = DAT_0089477c[0xf];
        DAT_0089477c[0xf] = iVar16 + -1;
        if (iVar16 + -1 < 1) {
          (**(code **)*puVar19)(1);
        }
        goto LAB_00433577;
      }
    }
    puVar19 = DAT_0089478c;
    iVar16 = DAT_0089478c[0xf];
    DAT_0089478c[0xf] = iVar16 + -1;
    if (iVar16 + -1 < 1) {
      (**(code **)*puVar19)(1);
    }
  }
  DAT_0089478c = (undefined4 *)0x0;
LAB_0043359c:
  puVar19 = DAT_00894790;
  iVar16 = DAT_00894790[0xf];
  DAT_00894790[0xf] = iVar16 + -1;
  if (iVar16 + -1 < 1) {
    (**(code **)*puVar19)(1);
  }
  DAT_00894790 = (undefined4 *)0x0;
  return 0;
}


