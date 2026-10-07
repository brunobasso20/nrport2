/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050a230 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0050a230(int param_1_00,int param_1)

{
  int iVar1;
  undefined4 uVar2;
  float fVar3;
  char cVar4;
  int iVar5;
  undefined4 *puVar6;
  int iVar7;
  float *pfVar8;
  int iVar9;
  float *pfVar10;
  float *pfVar11;
  float10 fVar12;
  int local_180;
  undefined4 local_17c;
  int local_178;
  float local_174;
  int local_164;
  int local_160;
  float local_15c;
  float local_158;
  float local_154;
  float local_150;
  float local_14c;
  float local_148;
  undefined4 local_144;
  undefined4 local_140;
  undefined4 local_13c;
  undefined4 local_138;
  undefined4 local_134;
  undefined4 local_130;
  undefined4 local_12c;
  undefined4 local_128;
  undefined4 local_124;
  undefined4 local_120;
  undefined4 local_11c;
  undefined4 local_118;
  undefined4 local_114;
  float local_110 [22];
  float local_b8 [22];
  float local_60 [23];
  
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -1) * _DAT_006f4098);
  FUN_005f5960(local_110,(float)fVar12,*(undefined4 *)(param_1_00 + -8 + DAT_00b8faa0 * 0x1c),0);
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -3) * _DAT_006f4098);
  FUN_005f5960(local_b8,(float)fVar12,*(undefined4 *)(param_1_00 + -0x40 + DAT_00b8faa0 * 0x1c),0);
  local_15c = local_110[0] - local_b8[0];
  local_158 = local_110[1] - local_b8[1];
  local_154 = local_110[2] - local_b8[2];
  FUN_005f6a70(&local_15c);
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -2) * _DAT_006f4098);
  FUN_005f5960(local_110,(float)fVar12,*(undefined4 *)(param_1_00 + -0x24 + DAT_00b8faa0 * 0x1c),0);
  iVar5 = DAT_00b8faa0 + -3;
  if (0 < iVar5) {
    local_178 = DAT_00b8faa0 + -4;
    pfVar10 = (float *)(param_1_00 + 8 + iVar5 * 0x1c);
    do {
      fVar12 = (float10)FUN_0051700a((float)local_178 * _DAT_006f4098);
      FUN_005f5960(local_60,(float)fVar12,pfVar10[-4],0);
      fVar12 = (float10)FUN_0050b200(param_1,local_60,local_b8,local_110,&local_15c,pfVar10,iVar5,
                                     &local_150);
      if (param_1 != 0xb) {
        *pfVar10 = (float)fVar12;
      }
      local_154 = local_148;
      local_158 = local_14c;
      iVar5 = iVar5 + -1;
      pfVar8 = local_b8;
      pfVar11 = local_110;
      for (iVar7 = 0x16; iVar7 != 0; iVar7 = iVar7 + -1) {
        *pfVar11 = *pfVar8;
        pfVar8 = pfVar8 + 1;
        pfVar11 = pfVar11 + 1;
      }
      pfVar10 = pfVar10 + -7;
      pfVar8 = local_60;
      pfVar11 = local_b8;
      for (iVar7 = 0x16; iVar7 != 0; iVar7 = iVar7 + -1) {
        *pfVar11 = *pfVar8;
        pfVar8 = pfVar8 + 1;
        pfVar11 = pfVar11 + 1;
      }
      local_15c = local_150;
      local_178 = local_178 + -1;
    } while (0 < iVar5);
  }
  *(undefined4 *)(DAT_00b8fac0 + -8 + DAT_00b8faa0 * 4) =
       *(undefined4 *)(DAT_00b8fac0 + -0xc + DAT_00b8faa0 * 4);
  *(undefined4 *)(DAT_00b8fac0 + -4 + DAT_00b8faa0 * 4) =
       *(undefined4 *)(DAT_00b8fac0 + -0xc + DAT_00b8faa0 * 4);
  *(undefined4 *)(DAT_00b8fabc + -8 + DAT_00b8faa0 * 4) =
       *(undefined4 *)(DAT_00b8fabc + -0xc + DAT_00b8faa0 * 4);
  *(undefined4 *)(DAT_00b8fabc + -4 + DAT_00b8faa0 * 4) =
       *(undefined4 *)(DAT_00b8fabc + -0xc + DAT_00b8faa0 * 4);
  if ((param_1 != 0xb) && (iVar5 = DAT_00b8faa0 + -3, 0 < iVar5)) {
    local_160 = 4;
    iVar7 = param_1_00 + -0xbc;
    iVar9 = -7;
    do {
      if (0 < iVar9 + -1) {
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9) {
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9 + 1) {
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9 + 2) {
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9 + 3) {
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9 + 4) {
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9 + 5) {
        local_120 = *(undefined4 *)(iVar7 + 0x8c);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9 + 6) {
        local_114 = *(undefined4 *)(iVar7 + 0xa8);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9 + 7) {
        local_124 = *(undefined4 *)(iVar7 + 0xc4);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (0 < iVar9 + 8) {
        local_140 = *(undefined4 *)(iVar7 + 0xe0);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 9 <= iVar5) {
        local_138 = *(undefined4 *)(iVar7 + 0xfc);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 10 <= iVar5) {
        local_130 = *(undefined4 *)(iVar7 + 0x118);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 0xb <= iVar5) {
        local_128 = *(undefined4 *)(iVar7 + 0x134);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 0xc <= iVar5) {
        local_144 = *(undefined4 *)(iVar7 + 0x150);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 0xd <= iVar5) {
        local_13c = *(undefined4 *)(iVar7 + 0x16c);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 0xe <= iVar5) {
        local_118 = *(undefined4 *)(iVar7 + 0x188);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 0xf <= iVar5) {
        local_134 = *(undefined4 *)(iVar7 + 0x1a4);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 0x10 <= iVar5) {
        local_11c = *(undefined4 *)(iVar7 + 0x1c0);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      if (iVar9 + 0x11 <= iVar5) {
        local_12c = *(undefined4 *)(iVar7 + 0x1dc);
        FUN_006c5c40();
        FUN_006c5c40();
      }
      fVar12 = (float10)FUN_006c5c40();
      *(float *)(local_160 + DAT_00b8faa4) = (float)fVar12;
      local_160 = local_160 + 4;
      iVar7 = iVar7 + 0x1c;
      iVar1 = iVar9 + 9;
      iVar9 = iVar9 + 1;
    } while (iVar1 <= iVar5);
  }
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -1) * _DAT_006f4098);
  FUN_005f5960(local_110,(float)fVar12,*(undefined4 *)(param_1_00 + -8 + DAT_00b8faa0 * 0x1c),0);
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -3) * _DAT_006f4098);
  FUN_005f5960(local_b8,(float)fVar12,*(undefined4 *)(param_1_00 + -0x40 + DAT_00b8faa0 * 0x1c),0);
  local_15c = local_110[0] - local_b8[0];
  local_158 = local_110[1] - local_b8[1];
  local_154 = local_110[2] - local_b8[2];
  FUN_005f6a70(&local_15c);
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -2) * _DAT_006f4098);
  FUN_005f5960(local_110,(float)fVar12,*(undefined4 *)(param_1_00 + -0x24 + DAT_00b8faa0 * 0x1c),0);
  local_178 = 0;
  local_17c = 0;
  if (DAT_00bdbdd3 != '\0') {
    if (((param_1 == 3) || (param_1 == 4)) || (param_1 == 5)) {
      local_178 = DAT_00bdbdd8;
      local_17c = DAT_00bdbddc;
    }
    else if (((param_1 == 6) || (param_1 == 7)) || (param_1 == 8)) {
      local_178 = DAT_00bdbde0;
      local_17c = DAT_00bdbde4;
    }
  }
  local_174 = -1.0;
  iVar5 = DAT_00b8faa0 + -3;
  if (0 < iVar5) {
    local_164 = DAT_00b8faa0 + -4;
    local_180 = param_1_00 + 8 + iVar5 * 0x1c;
    do {
      fVar12 = (float10)FUN_0051700a((float)local_164 * _DAT_006f4098);
      FUN_005f5960(local_60,(float)fVar12,*(undefined4 *)(local_180 + -0x10),0);
      cVar4 = FUN_0052f2c0((float)fVar12,local_178,local_17c);
      if (cVar4 != '\0') {
        local_174 = -1.0;
      }
      fVar12 = (float10)FUN_0050b530(param_1,local_60,local_b8,local_110,&local_15c,local_180,iVar5,
                                     &local_150,*(undefined4 *)(DAT_00b8faa4 + iVar5 * 4),local_174)
      ;
      local_158 = local_14c;
      local_15c = local_150;
      pfVar10 = local_b8;
      pfVar8 = local_110;
      for (iVar7 = 0x16; iVar7 != 0; iVar7 = iVar7 + -1) {
        *pfVar8 = *pfVar10;
        pfVar10 = pfVar10 + 1;
        pfVar8 = pfVar8 + 1;
      }
      local_174 = (float)fVar12;
      iVar5 = iVar5 + -1;
      pfVar10 = local_60;
      pfVar8 = local_b8;
      for (iVar7 = 0x16; iVar7 != 0; iVar7 = iVar7 + -1) {
        *pfVar8 = *pfVar10;
        pfVar10 = pfVar10 + 1;
        pfVar8 = pfVar8 + 1;
      }
      local_154 = local_148;
      local_164 = local_164 + -1;
      local_180 = local_180 + -0x1c;
    } while (0 < iVar5);
  }
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -1) * _DAT_006f4098);
  FUN_005f5960(local_110,(float)fVar12,*(undefined4 *)(param_1_00 + -8 + DAT_00b8faa0 * 0x1c),0);
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -3) * _DAT_006f4098);
  FUN_005f5960(local_b8,(float)fVar12,*(undefined4 *)(param_1_00 + -0x40 + DAT_00b8faa0 * 0x1c),0);
  local_15c = local_110[0] - local_b8[0];
  local_158 = local_110[1] - local_b8[1];
  local_154 = local_110[2] - local_b8[2];
  FUN_005f6a70(&local_15c);
  fVar12 = (float10)FUN_0051700a((float)(DAT_00b8faa0 + -2) * _DAT_006f4098);
  FUN_005f5960(local_110,(float)fVar12,*(undefined4 *)(param_1_00 + -0x24 + DAT_00b8faa0 * 0x1c),0);
  iVar5 = DAT_00b8faa0 + -3;
  if (0 < iVar5) {
    local_164 = DAT_00b8faa0 + -4;
    local_180 = param_1_00 + 8 + iVar5 * 0x1c;
    fVar3 = local_174;
    do {
      if (fVar3 < local_174 == (fVar3 == local_174)) break;
      fVar12 = (float10)FUN_0051700a((float)local_164 * _DAT_006f4098);
      uVar2 = *(undefined4 *)(local_180 + -0x10);
      cVar4 = FUN_0052f2c0((float)fVar12,local_178,local_17c);
      if (cVar4 != '\0') break;
      FUN_005f5960(local_60,(float)fVar12,uVar2,0);
      fVar12 = (float10)FUN_0050b530(param_1,local_60,local_b8,local_110,&local_15c,local_180,iVar5,
                                     &local_150,*(undefined4 *)(DAT_00b8faa4 + iVar5 * 4),local_174)
      ;
      local_15c = local_150;
      local_154 = local_148;
      pfVar10 = local_b8;
      pfVar8 = local_110;
      for (iVar7 = 0x16; iVar7 != 0; iVar7 = iVar7 + -1) {
        *pfVar8 = *pfVar10;
        pfVar10 = pfVar10 + 1;
        pfVar8 = pfVar8 + 1;
      }
      iVar5 = iVar5 + -1;
      pfVar10 = local_60;
      pfVar8 = local_b8;
      for (iVar7 = 0x16; iVar7 != 0; iVar7 = iVar7 + -1) {
        *pfVar8 = *pfVar10;
        pfVar10 = pfVar10 + 1;
        pfVar8 = pfVar8 + 1;
      }
      local_158 = local_14c;
      local_164 = local_164 + -1;
      local_180 = local_180 + -0x1c;
      fVar3 = local_174;
      local_174 = (float)fVar12;
    } while (0 < iVar5);
  }
  *(undefined4 *)(param_1_00 + 8) = *(undefined4 *)(param_1_00 + 0x24);
  *(undefined4 *)(param_1_00 + 0x10) = *(undefined4 *)(param_1_00 + 0x2c);
  *(undefined4 *)(param_1_00 + 0xc) = *(undefined4 *)(param_1_00 + 0x28);
  iVar5 = DAT_00b8faa0 + -3;
  if (iVar5 < DAT_00b8faa0 + -1) {
    puVar6 = (undefined4 *)(param_1_00 + 0x24 + iVar5 * 0x1c);
    do {
      iVar5 = iVar5 + 1;
      *puVar6 = puVar6[-7];
      puVar6[1] = puVar6[-6];
      puVar6[2] = puVar6[-5];
      puVar6 = puVar6 + 7;
    } while (iVar5 < DAT_00b8faa0 + -1);
  }
  iVar5 = 0;
  puVar6 = (undefined4 *)(param_1_00 + 0xc);
  do {
    *(undefined4 *)(param_1_00 + 8 + (DAT_00b8faa0 + iVar5) * 0x1c) = puVar6[-1];
    *(undefined4 *)(param_1_00 + 0xc + (DAT_00b8faa0 + iVar5) * 0x1c) = *puVar6;
    iVar7 = DAT_00b8faa0 + iVar5;
    iVar5 = iVar5 + 1;
    *(undefined4 *)(param_1_00 + 0x10 + iVar7 * 0x1c) = puVar6[1];
    puVar6 = puVar6 + 7;
  } while (iVar5 < 2);
  return;
}


