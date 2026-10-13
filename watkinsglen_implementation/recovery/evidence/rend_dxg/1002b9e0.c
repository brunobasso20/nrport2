/* rend_dxg.dll @ 1002b9e0 FUN_1002b9e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_1002b9e0(int param_1,undefined4 param_2,char param_3)

{
  double dVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  uint uVar4;
  undefined *puVar5;
  float fVar6;
  float fVar7;
  byte bVar8;
  char cVar9;
  success sVar10;
  int iVar11;
  int iVar12;
  undefined4 *puVar13;
  undefined4 *puVar14;
  undefined4 *puVar15;
  int *piVar16;
  uint uVar17;
  bool bVar18;
  int local_2c;
  undefined4 *local_24;
  undefined4 local_20;
  void *local_1c;
  undefined4 *local_18;
  undefined4 uStack_14;
  undefined4 *local_c [2];

  local_18 = *(undefined4 **)(double *)(param_1 + 0x70);
  uStack_14 = *(undefined4 *)(param_1 + 0x74);
  dVar1 = *(double *)(param_1 + 0x70);
  if ((((*(byte *)(param_1 + 0x88) & 2) != 0) && (*(int *)(param_1 + 0x1c) == 0)) &&
     ((NAN(dVar1) || NAN(_DAT_10097460)) == (dVar1 == _DAT_10097460))) {
    local_18 = (undefined4 *)0x0;
    uStack_14 = 0;
  }
  sVar10 = _memAlloc(&local_1c,0x61);
  if (sVar10 == 0) {
    return 0;
  }
  if (local_1c == (void *)0x0) {
    return 0;
  }
  iVar11 = FUN_100330a0();
  if (iVar11 == 0) {
    return 0;
  }
  sVar10 = _memAlloc(&local_24,0x100);
  if ((sVar10 == 0) || (local_24 == (undefined4 *)0x0)) goto LAB_1002c00e;
  local_24[0x3d] = 0x3f800000;
  local_24[0x3e] = 0x3f800000;
  local_24[1] = 1;
  local_24[7] = 0;
  local_24[8] = 0;
  local_24[0x3a] = 0;
  local_24[0x3b] = 0;
  local_24[0x3c] = 0xffffffff;
  *(undefined *)(local_24 + 0x3f) = 0;
  *local_24 = &PTR_FUN_10099f70;
  local_24[2] = 0;
  *(undefined4 **)(iVar11 + 0x5c) = local_24;
  iVar12 = *(int *)(param_1 + 8);
  local_24[3] = 0;
  local_24[4] = 0;
  local_24[5] = 0;
  local_24[6] = 0;
  if ((iVar12 != 0) && (iVar12 = FUN_100264a0(iVar12,iVar11 + 0x2c), iVar12 != 1))
  goto LAB_1002c00e;
  fVar7 = (float)_DAT_10099f68;
  iVar12 = *(int *)(iVar11 + 0x5c);
  bVar18 = true;
  fVar6 = (float)_DAT_10097488;
  *(undefined4 *)(iVar12 + 0xe8) = *(undefined4 *)(param_1 + 0x88);
  *(float *)(iVar12 + 0xe4) = (float)(double)CONCAT44(uStack_14,local_18) * fVar7 + fVar6;
  *(float *)(iVar12 + 0xe0) = (float)*(double *)(param_1 + 0x80);
  *(float *)(iVar12 + 0xb0) = (float)*(double *)(param_1 + 0x28);
  *(float *)(iVar12 + 0xb4) = (float)*(double *)(param_1 + 0x30);
  *(float *)(iVar12 + 0xb8) = (float)*(double *)(param_1 + 0x38);
  dVar1 = *(double *)(param_1 + 0x40);
  *(undefined4 *)(iVar12 + 0xbc) = *(undefined4 *)(iVar12 + 0xe0);
  uVar2 = *(undefined4 *)(param_1 + 0x8c);
  *(float *)(iVar12 + 0xc0) = (float)dVar1;
  *(float *)(iVar12 + 0xc4) = (float)*(double *)(param_1 + 0x48);
  *(float *)(iVar12 + 200) = (float)*(double *)(param_1 + 0x50);
  dVar1 = *(double *)(param_1 + 0x58);
  *(undefined4 *)(iVar12 + 0xcc) = *(undefined4 *)(iVar12 + 0xe0);
  uVar3 = *(undefined4 *)(param_1 + 0x94);
  *(float *)(iVar12 + 0xd0) = (float)dVar1;
  *(float *)(iVar12 + 0xd4) = (float)*(double *)(param_1 + 0x60);
  *(float *)(iVar12 + 0xd8) = (float)*(double *)(param_1 + 0x68);
  *(undefined4 *)(iVar12 + 0xdc) = 0x3f800000;
  *(undefined4 *)(iVar12 + 0xf0) = uVar2;
  uVar2 = *(undefined4 *)(param_1 + 0x98);
  *(undefined4 *)(iVar12 + 0xf4) = uVar3;
  *(undefined4 *)(iVar12 + 0xf8) = uVar2;
  if (*(int *)(param_1 + 0xc) != 0) {
    iVar12 = FUN_10007060(*(int *)(param_1 + 0xc),param_2,0);
    *(int *)(iVar11 + 0x40) = iVar12;
    if (iVar12 == 0) {
      bVar18 = false;
    }
  }
  if ((*(int *)(param_1 + 0x10) != 0) && (bVar18)) {
    iVar12 = FUN_10007060(*(int *)(param_1 + 0x10),param_2,0);
    *(int *)(iVar11 + 0x44) = iVar12;
    if (iVar12 == 0) {
      bVar18 = false;
    }
  }
  if ((*(int *)(param_1 + 0x14) != 0) && (bVar18)) {
    iVar12 = FUN_10007060(*(int *)(param_1 + 0x14),param_2,0);
    *(int *)(iVar11 + 0x48) = iVar12;
    if (iVar12 == 0) {
      bVar18 = false;
    }
  }
  if ((*(int *)(param_1 + 0x18) != 0) && (bVar18)) {
    iVar12 = FUN_10007060(*(int *)(param_1 + 0x18),param_2,0);
    *(int *)(iVar11 + 0x38) = iVar12;
    if (iVar12 == 0) {
      bVar18 = false;
    }
  }
  if ((*(int *)(param_1 + 0x1c) != 0) && (bVar18)) {
    iVar12 = FUN_10007060(*(int *)(param_1 + 0x1c),param_2,0);
    *(int *)(iVar11 + 0x50) = iVar12;
    if (iVar12 == 0) {
      bVar18 = false;
    }
  }
  if ((*(int *)(param_1 + 0x20) != 0) && (bVar18)) {
    iVar12 = FUN_10007060(*(int *)(param_1 + 0x20),param_2,0);
    *(int *)(iVar11 + 0x4c) = iVar12;
    if (iVar12 == 0) {
      bVar18 = false;
    }
  }
  if (*(int *)(param_1 + 0x24) != 0) {
    if (!bVar18) goto LAB_1002c00e;
    iVar12 = FUN_10007060(*(int *)(param_1 + 0x24),param_2,0);
    *(int *)(iVar11 + 0x54) = iVar12;
    if (iVar12 == 0) goto LAB_1002c00e;
  }
  if (!bVar18) goto LAB_1002c00e;
  puVar14 = *(undefined4 **)(iVar11 + 0x5c);
  iVar12 = 0;
  piVar16 = (int *)(iVar11 + 0x38);
  puVar14[8] = 0;
  do {
    if (*piVar16 != 0) {
      puVar14[8] = puVar14[8] | 1 << ((char)iVar12 + 1U & 0x1f);
    }
    iVar12 = iVar12 + 1;
    piVar16 = piVar16 + 1;
  } while (iVar12 < 9);
  puVar14[7] = 0;
  puVar14[0x3b] = 0;
  if ((puVar14[0x3a] & 1) == 0) {
    iVar12 = *(int *)(iVar11 + 0x40);
    if (iVar12 != 0) {
      if (*(char *)(iVar12 + 0x89) == '\0') {
        if (*(char *)(iVar12 + 0x88) == '\0') {
          if (_DAT_10099f64 < (float)puVar14[0x38]) {
            puVar14[0x3a] = puVar14[0x3a] | 1;
          }
          puVar14[0x3b] = 0;
        }
        else {
          puVar14[0x3b] = 2;
        }
      }
      else {
        puVar14[0x3b] = 1;
      }
    }
    if ((float)puVar14[0x38] < _DAT_10095230 != (NAN((float)puVar14[0x38]) || NAN(_DAT_10095230))) {
      puVar14[0x3b] = 2;
    }
  }
  if (puVar14[0x3b] == 2) {
    uVar17 = *(uint *)(iVar11 + 0xc) | 0x10;
  }
  else {
    uVar17 = *(uint *)(iVar11 + 0xc) | 8;
  }
  *(uint *)(iVar11 + 0xc) = uVar17;
  uVar17 = *(uint *)(param_1 + 0x88);
  if ((uVar17 & 2) != 0) {
    uVar4 = *(uint *)(iVar11 + 0xc);
    *(uint *)(iVar11 + 0xc) = uVar4 | 2;
    if ((uVar17 & 0x10) != 0) {
      *(uint *)(iVar11 + 0xc) = uVar4 | 6;
    }
  }
  if (*(int *)(param_1 + 0x14) != 0) {
    *(uint *)(iVar11 + 0xc) = *(uint *)(iVar11 + 0xc) | 0x40;
  }
  if (param_3 != '\0') {
    *(uint *)(iVar11 + 0xc) = *(uint *)(iVar11 + 0xc) | 0x80;
  }
  local_2c = 1;
  if (DAT_100b6b5c != 0) {
    local_20 = DAT_100b6b68[5];
    local_24 = puVar14;
    puVar13 = (undefined4 *)FUN_10033880(local_c,&local_24);
    puVar5 = (undefined *)*puVar13;
    if (puVar5 != &DAT_100b6b60) {
      (**(code **)(**(int **)(iVar11 + 0x5c) + 4))();
      puVar14 = *(undefined4 **)(puVar5 + 0x14);
      *(undefined4 *)(iVar11 + 0x5c) = 0;
      (**(code **)*puVar14)();
      *(undefined4 **)(iVar11 + 0x5c) = puVar14;
      return iVar11;
    }
  }
  if ((*(uint *)(param_1 + 0x88) & 4) == 0) {
    if ((DAT_100b5c1c < 2) || ((*(uint *)(param_1 + 0x88) & 8) != 0)) {
      local_2c = FUN_1002c520(local_18,uStack_14);
    }
    else {
      local_2c = FUN_1002c6e0(local_18,uStack_14);
    }
    if (local_2c != 0) {
      if (((*(int *)(iVar11 + 0x38) != 0) && (1 < DAT_100b5c1c)) && (DAT_100b5c46 != 0)) {
        local_2c = FUN_1002c990();
      }
      if (local_2c != 0) goto LAB_1002bf0c;
    }
  }
  else {
    bVar8 = 1;
    if ((DAT_100b5c1c < 2) || (DAT_100b5c46 == 0)) {
      bVar8 = 0;
    }
    FUN_1002c4d0(local_18,uStack_14,bVar8 & *(int *)(iVar11 + 0x38) != 0);
LAB_1002bf0c:
    uStack_14 = *(undefined4 *)(iVar11 + 0x5c);
    local_18 = puVar14;
    puVar14 = (undefined4 *)FUN_100338e0(local_c,&local_18);
    if ((undefined *)*puVar14 == &DAT_100b6b60) {
      local_2c = 0;
    }
    if ((*(byte *)(param_1 + 0x88) & 8) != 0) {
      if (DAT_100b6b68 == (undefined4 *)0x0) {
        puVar14 = (undefined4 *)&DAT_100b6b60;
      }
      else {
        puVar13 = (undefined4 *)DAT_100b6b68[2];
        puVar14 = DAT_100b6b68;
        while (puVar15 = puVar13, puVar15 != (undefined4 *)0x0) {
          puVar14 = puVar15;
          puVar13 = (undefined4 *)puVar15[2];
        }
      }
      if (puVar14 != (undefined4 *)&DAT_100b6b60) {
        do {
          puVar13 = (undefined4 *)puVar14[3];
          if (puVar13 == (undefined4 *)0x0) {
            puVar13 = (undefined4 *)puVar14[1];
            puVar15 = puVar13;
            if (puVar14 == (undefined4 *)puVar13[3]) {
              do {
                puVar13 = (undefined4 *)puVar15[1];
                bVar18 = puVar15 == (undefined4 *)puVar13[3];
                puVar15 = puVar13;
              } while (bVar18);
            }
          }
          else {
            for (puVar15 = (undefined4 *)puVar13[2]; puVar15 != (undefined4 *)0x0;
                puVar15 = (undefined4 *)puVar15[2]) {
              puVar13 = puVar15;
            }
          }
          local_c[0] = (undefined4 *)puVar14[5];
          local_24 = puVar13;
          if ((local_c[0] != *(undefined4 **)(iVar11 + 0x5c)) &&
             (local_18 = local_c[0], cVar9 = FUN_1002dd00(&local_18), cVar9 != '\0')) {
            (**(code **)(**(int **)(*(int *)(iVar11 + 0x5c) + 8) + 4))();
            *(undefined4 *)(*(int *)(iVar11 + 0x5c) + 8) = local_c[0][2];
            (***(code ***)local_c[0][2])();
            break;
          }
          puVar14 = puVar13;
        } while (puVar13 != (undefined4 *)&DAT_100b6b60);
      }
    }
  }
  if (local_2c == 1) {
    return iVar11;
  }
LAB_1002c00e:
  FUN_100073d0(iVar11);
  return 0;
}
