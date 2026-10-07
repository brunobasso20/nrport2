/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00433d80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_00433d80(int param_1,int param_2,int param_3,undefined4 param_4,int *param_5)

{
  float fVar1;
  undefined4 uVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  int iVar6;
  undefined4 *puVar7;
  int iVar8;
  undefined4 *puVar9;
  undefined *puVar10;
  float fVar11;
  undefined4 *puVar12;
  int *piVar13;
  float *pfVar14;
  int *piVar15;
  int *local_120;
  float local_118;
  float local_114;
  undefined4 *local_110;
  float local_10c;
  float local_108;
  float local_104;
  float local_100;
  float local_fc;
  float local_f8;
  float local_f4;
  float local_f0;
  float local_ec;
  float local_e8;
  int local_e4 [9];
  undefined4 local_c0;
  undefined4 local_bc;
  undefined4 local_b8;
  float local_b4;
  undefined4 local_b0;
  undefined4 local_ac;
  undefined4 local_a8;
  float local_a4;
  undefined4 local_a0;
  undefined4 local_9c;
  undefined4 local_98;
  float local_94;
  undefined4 local_90;
  undefined4 local_8c;
  undefined4 local_88;
  float local_84;
  float local_80;
  undefined4 local_7c;
  float local_78;
  float local_74;
  undefined4 local_70;
  undefined4 local_6c;
  undefined4 local_68;
  float local_64;
  float local_60;
  undefined4 local_5c;
  float local_58;
  float local_54;
  undefined4 local_50;
  undefined4 local_4c;
  undefined4 local_48;
  float local_44;
  float local_40;
  float local_3c;
  undefined4 local_38;
  float local_34;
  float local_30 [8];
  float local_10;
  float local_c;
  undefined4 local_8;
  float local_4;
  
  puVar10 = (&PTR_DAT_00725ab8)[param_3 + param_2 * 6];
  fVar3 = *(float *)(puVar10 + 0x48) * *(float *)(puVar10 + 0x38);
  local_108 = *(float *)(puVar10 + 0x3c) * _DAT_006ea44c;
  iVar6 = FUN_0056ed60(0);
  local_118 = **(float **)(PTR_PTR_00734368 + iVar6 * 4) - *(float *)(puVar10 + 0x5c);
  iVar6 = FUN_0056ed60(1);
  local_104 = **(float **)(PTR_PTR_00734368 + iVar6 * 4) - *(float *)(puVar10 + 0x5c);
  local_f8 = *(float *)(puVar10 + 0x38) - fVar3;
  local_110 = (undefined4 *)(*(float *)(puVar10 + 0x40) * _DAT_006ea44c);
  iVar6 = FUN_0056ed60(2);
  local_fc = **(float **)(PTR_PTR_00734368 + iVar6 * 4) - *(float *)(puVar10 + 0x5c);
  iVar6 = FUN_0056ed60(3);
  local_10c = **(float **)(PTR_PTR_00734368 + iVar6 * 4) - *(float *)(puVar10 + 0x5c);
  iVar6 = FUN_0056ed60(0);
  local_f4 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar6 * 4) + 0x10);
  iVar6 = FUN_0056ed60(2);
  fVar11 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar6 * 4) + 0x10);
  iVar6 = FUN_0056ed60(1);
  local_114 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar6 * 4) + 0x10);
  iVar6 = FUN_0056ed60(3);
  fVar1 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar6 * 4) + 0x10);
  fVar5 = (float)local_110 * (float)local_110;
  fVar4 = local_f8 * local_f8;
  local_108 = local_108 * local_108;
  fVar3 = fVar3 * fVar3;
  local_100 = *(float *)(puVar10 + 0x24) * _DAT_006ea44c + *(float *)(puVar10 + 8) + _DAT_006ee508;
  local_10c = local_10c * local_10c;
  local_f8 = local_104 * local_104;
  local_110 = (undefined4 *)(local_118 * local_118);
  FUN_005f5fa0(param_4,local_100,
               local_100 * *(float *)(puVar10 + 0x10) +
               (local_10c + fVar5) * fVar1 +
               (local_fc * local_fc + fVar5) * fVar11 +
               (local_f8 + local_108) * local_114 + ((float)local_110 + local_108) * local_f4,
               local_100 * *(float *)(puVar10 + 0x14) +
               (local_10c + fVar4) * fVar1 +
               (local_fc * local_fc + fVar4) * fVar11 +
               (local_f8 + fVar3) * local_114 + ((float)local_110 + fVar3) * local_f4,
               local_100 * *(float *)(puVar10 + 0x18) +
               (fVar1 + fVar11) * (fVar4 + fVar5) + (local_114 + local_f4) * (local_108 + fVar3));
  fVar11 = _DAT_006ee5e0 / _DAT_006ee4e4 - *(float *)(puVar10 + 0x5c);
  FUN_00433ae0(&local_10c,&local_104,&local_100,&local_108,&local_fc,&local_118,&DAT_00725b30,0x10);
  local_fc = local_fc + fVar11;
  local_118 = local_118 + fVar11;
  if (param_1 * 0x44 == -0x8835c8) {
    local_114 = 0.0;
  }
  else {
    local_114 = (float)FUN_00577520(local_104,local_10c,local_108,local_100,local_118,local_fc,
                                    param_4);
  }
  local_e4[0] = 0;
  local_e4[1] = 0;
  local_e4[2] = 0;
  local_e4[3] = 0;
  local_e4[4] = 0;
  local_120 = &DAT_006ee520;
  pfVar14 = &DAT_00725b38;
  puVar10 = &DAT_008770e8 + param_1 * 0x410;
  local_110 = (undefined4 *)*(int *)((int)local_114 + 0xc);
  do {
    if (puVar10 == (undefined *)0x0) {
      iVar6 = 0;
    }
    else {
      iVar6 = FUN_00575780(pfVar14[-2],pfVar14[-1],fVar11 + *pfVar14,pfVar14[1],pfVar14[2],param_4,
                           0x11);
    }
    fVar3 = _DAT_006ea454;
    fVar1 = pfVar14[2];
    *(undefined4 **)(iVar6 + 8) = local_110;
    if ((fVar3 < fVar1) && (*local_120 != -1)) {
      local_e4[*local_120] = iVar6;
    }
    pfVar14 = pfVar14 + 5;
    puVar10 = puVar10 + 0x41;
    local_120 = local_120 + 1;
    local_110 = (undefined4 *)iVar6;
  } while ((int)pfVar14 < 0x725c78);
  *(int *)((int)local_114 + 0xc) = iVar6;
  FUN_00433b40(&DAT_00725b30,param_2,param_3);
  local_f0 = local_fc;
  FUN_004339c0(&local_10c,&local_104,&local_100,&local_108,&local_fc,&local_118,&DAT_00725c70,4);
  fVar3 = local_108;
  fVar1 = local_118;
  if (param_1 * 0x44 == -0x8938b0) {
    local_f8 = 0.0;
  }
  else {
    local_f8 = (float)FUN_00577520(local_104,local_10c,local_108,local_100,local_118,local_fc,
                                   param_4);
  }
  fVar4 = local_f8;
  FUN_00577580(local_104,local_10c,fVar3,local_100,fVar1,local_f0);
  uVar2 = *(undefined4 *)((int)fVar4 + 0xc);
  *param_5 = (int)fVar4;
  iVar6 = param_1 * 0x14;
  local_110 = (undefined4 *)(&DAT_00876d28 + iVar6);
  *(undefined4 *)((int)local_114 + 8) = uVar2;
  *(float *)((int)fVar4 + 0xc) = local_114;
  if (local_110 == (undefined4 *)0x0) {
    local_110 = (undefined4 *)0x0;
  }
  else {
    *(undefined4 *)(&DAT_00876d30 + iVar6) = 0;
    *(undefined4 *)(&DAT_00876d2c + iVar6) = param_4;
    *(undefined4 *)(&DAT_00876d34 + iVar6) = 0;
    *(undefined4 *)(&DAT_00876d38 + iVar6) = 0;
    *local_110 = &PTR_LAB_006ee608;
  }
  local_c0 = 0x3f800000;
  local_bc = 0;
  local_b8 = 0;
  local_b0 = 0xbf800000;
  local_ac = 0;
  local_a8 = 0;
  fVar1 = local_118 - (DAT_00725b38 + DAT_00725b3c + fVar11);
  fVar11 = local_118 - (_DAT_00725c64 + _DAT_00725c68 + fVar11);
  local_ec = _DAT_006e97d8 / SQRT(local_104 * local_104 + fVar1 * fVar1);
  local_e8 = local_ec * local_104;
  fVar4 = local_10c - _DAT_00725c20;
  fVar3 = _DAT_006e97d8 / SQRT(fVar11 * fVar11 + fVar4 * fVar4);
  local_60 = -(fVar3 * fVar11);
  local_58 = -(fVar3 * fVar4);
  local_40 = _DAT_006ea514 * (_DAT_006e97d8 / SQRT((float)_DAT_006ee600));
  local_3c = (_DAT_006e97d8 / SQRT((float)_DAT_006ee600)) * _DAT_006e9804;
  fVar11 = _DAT_00725bbc - _DAT_00725c48;
  fVar3 = (_DAT_00725bc0 + _DAT_00725bc8) - (_DAT_00725c4c + _DAT_00725c54);
  local_30[5] = _DAT_006e97d8 / SQRT(fVar11 * fVar11 + fVar3 * fVar3);
  local_f4 = -(local_30[5] * fVar3);
  local_30[5] = local_30[5] * fVar11;
  local_b4 = -local_104;
  local_94 = -local_108;
  local_a4 = local_10c;
  local_80 = local_ec * fVar1;
  local_84 = local_100;
  local_78 = local_e8;
  local_74 = -(local_e8 * local_118);
  local_64 = -local_118;
  local_44 = local_fc;
  local_a0 = 0;
  local_9c = 0x3f800000;
  local_98 = 0;
  local_90 = 0;
  local_8c = 0xbf800000;
  local_88 = 0;
  local_54 = -(local_58 * local_118 + local_60 * _DAT_00725c20);
  local_7c = 0;
  local_70 = 0;
  local_6c = 0;
  local_68 = 0x3f800000;
  local_5c = 0;
  local_50 = 0;
  local_4c = 0;
  local_48 = 0xbf800000;
  local_38 = 0;
  local_30[0] = local_40;
  local_30[2] = 0.0;
  local_34 = -(_DAT_00725b44 * local_40 + _DAT_00725b48 * local_3c + _DAT_00725b50);
  local_30[1] = -local_3c;
  local_30[3] = -((_DAT_00725b58 * local_40 - _DAT_00725b5c * local_3c) + _DAT_00725b64);
  local_30[4] = local_f4;
  local_10 = local_f4;
  local_30[7] = -(_DAT_00725c48 * local_f4 + _DAT_00725c4c * local_30[5] + _DAT_00725c54);
  local_c = -local_30[5];
  local_30[6] = 0.0;
  local_8 = 0;
  puVar12 = &local_8;
  puVar7 = (undefined4 *)(&DAT_00884aac + param_1 * 0x3f0);
  local_f0 = 1.68156e-44;
  local_4 = -((_DAT_00725c5c * local_f4 - _DAT_00725c60 * local_30[5]) + _DAT_00725c68);
  do {
    if (puVar7 == (undefined4 *)0x50) {
      puVar9 = (undefined4 *)0x0;
    }
    else {
      *puVar7 = 0;
      puVar9 = puVar7 + -0x14;
      puVar7[-0x13] = 0x80000011;
      *puVar9 = &PTR_LAB_006ee5ec;
      if (puVar12 != (undefined4 *)&DAT_00000008) {
        puVar7[-4] = puVar12[-2];
        puVar7[-3] = puVar12[-1];
        puVar7[-2] = *puVar12;
        puVar7[-1] = puVar12[1];
      }
    }
    uVar2 = local_110[4];
    local_110[4] = puVar9;
    puVar9[6] = uVar2;
    puVar7 = puVar7 + -0x15;
    puVar12 = puVar12 + -4;
    local_f0 = (float)((int)local_f0 + -1);
  } while (local_f0 != 0.0);
  iVar6 = 0;
  puVar12 = &DAT_00725c78;
  puVar10 = &DAT_008904a8 + param_1 * 0x114;
  local_f0 = 0.0;
  fVar11 = local_114;
  local_114 = local_40;
  do {
    if (puVar10 == (undefined *)0x0) {
      iVar8 = 0;
    }
    else {
      iVar8 = FUN_00575850(puVar12[-2],puVar12[-1],*puVar12,puVar12[1],param_4,0x12,iVar6);
    }
    fVar1 = local_f8;
    local_e4[iVar6 + 5] = iVar8;
    puVar12 = puVar12 + 5;
    iVar6 = iVar6 + 1;
    puVar10 = puVar10 + 0x45;
    *(float *)(iVar8 + 8) = fVar11;
    fVar11 = (float)iVar8;
  } while ((int)puVar12 < 0x725cc8);
  *(int *)((int)local_f8 + 0xc) = iVar8;
  iVar6 = FUN_00577c80(0x5b);
  if (iVar6 == 0) {
    return 0;
  }
  iVar6 = FUN_00577b80(fVar1,local_110,0,0);
  if (iVar6 != 0) {
    *(int *)(iVar6 + 0x18) = local_e4[5];
    *(int *)(iVar6 + 0x1c) = local_e4[6];
    *(int *)(iVar6 + 0x20) = local_e4[7];
    *(int *)(iVar6 + 0x24) = local_e4[8];
    piVar13 = local_e4;
    piVar15 = (int *)(iVar6 + 0x28);
    for (iVar8 = 5; iVar8 != 0; iVar8 = iVar8 + -1) {
      *piVar15 = *piVar13;
      piVar13 = piVar13 + 1;
      piVar15 = piVar15 + 1;
    }
  }
  return iVar6;
}


