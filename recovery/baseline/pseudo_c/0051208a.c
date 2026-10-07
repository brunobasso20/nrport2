/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051208a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051208a(int param_1)

{
  char cVar1;
  int iVar2;
  int iVar3;
  uint uVar4;
  int *piVar5;
  float *pfVar6;
  undefined1 *puVar7;
  int iVar8;
  float fVar9;
  int iVar10;
  int iVar11;
  int *local_94;
  int local_90;
  int local_8c;
  undefined1 local_88 [68];
  undefined1 local_44 [68];
  
  iVar3 = param_1 + 1;
  if (DAT_00bad920 <= iVar3) {
    iVar3 = 0;
  }
  iVar11 = param_1 * 0x1550 + DAT_00bcf734;
  iVar10 = iVar3 * 0x1550 + DAT_00bcf734;
  uVar4 = *(uint *)(iVar11 + 0x18) & 0xfffffffc;
  *(uint *)(iVar11 + 0x18) = uVar4;
  iVar3 = *(int *)(iVar11 + 0x54);
  if (iVar3 == *(int *)(iVar10 + 0x54)) {
    iVar8 = 1;
    if (1 < iVar3) {
      pfVar6 = (float *)(iVar11 + 0xb0);
      do {
        if ((float)_DAT_006ed098 <
            ABS((pfVar6[1] + *pfVar6) - *(float *)((iVar10 - iVar11) + (int)pfVar6))) break;
        iVar8 = iVar8 + 1;
        pfVar6 = pfVar6 + 0x12;
      } while (iVar8 < iVar3);
    }
    if (iVar8 == iVar3) {
      *(uint *)(iVar11 + 0x18) = uVar4 | 1;
      *(uint *)(iVar10 + 0x18) = *(uint *)(iVar10 + 0x18) | 2;
    }
  }
  iVar3 = 0;
  if (0 < *(int *)(iVar11 + 0x54)) {
    pfVar6 = (float *)(iVar11 + 0x68);
    do {
      fVar9 = 0.0;
      if (0 < *(int *)(iVar10 + 0x54)) {
        piVar5 = (int *)(iVar10 + 0x7c);
        do {
          if ((ABS((*pfVar6 + pfVar6[1]) - (float)piVar5[-5]) < (float)_DAT_006ed098) &&
             (ABS((pfVar6[3] + pfVar6[2]) - (float)piVar5[-3]) < (float)_DAT_006ed098)) {
            pfVar6[4] = fVar9;
            *piVar5 = iVar3;
          }
          fVar9 = (float)((int)fVar9 + 1);
          piVar5 = piVar5 + 0x12;
        } while ((int)fVar9 < *(int *)(iVar10 + 0x54));
      }
      iVar3 = iVar3 + 1;
      pfVar6 = pfVar6 + 0x12;
    } while (iVar3 < *(int *)(iVar11 + 0x54));
  }
  iVar3 = 0;
  local_94 = (int *)0x0;
  if (0 < *(int *)(iVar10 + 0x5c)) {
    iVar3 = iVar10 + 0x8d8;
    *(undefined1 *)(iVar10 + 0x8e0) = 1;
  }
  local_90 = 0;
  if (0 < *(int *)(iVar11 + 0x5c)) {
    puVar7 = (undefined1 *)(iVar11 + 0x8e1);
    do {
      FUN_00512dea(puVar7 + -9,iVar11,iVar10);
      *puVar7 = 1;
      if (iVar3 != 0) {
        iVar8 = iVar10 + 0x8d8 + (int)local_94 * 0x108;
        while (fVar9 = *(float *)(puVar7 + 0x4b) - *(float *)(iVar3 + 0x50),
              (float)_DAT_006f4650 <= fVar9) {
          if (fVar9 < (float)_DAT_006ef4c8 != (fVar9 == (float)_DAT_006ef4c8)) {
            *puVar7 = 0;
            *(undefined1 *)(iVar3 + 8) = 0;
          }
          local_94 = (int *)((int)local_94 + 1);
          iVar3 = iVar8 + 0x108;
          if (*(int *)(iVar10 + 0x5c) <= (int)local_94) {
            iVar3 = 0;
            break;
          }
          *(undefined1 *)(iVar8 + 0x110) = 1;
          iVar8 = iVar3;
        }
      }
      local_90 = local_90 + 1;
      puVar7 = puVar7 + 0x108;
    } while (local_90 < *(int *)(iVar11 + 0x5c));
  }
  FUN_005125ba(iVar11,local_44);
  iVar3 = param_1 + 1;
  if (iVar3 < DAT_00bad920) {
    local_90 = iVar3 * 0x1550;
    iVar8 = iVar3 - param_1;
    iVar10 = DAT_00bad920;
    do {
      iVar2 = iVar8;
      if (iVar10 >> 1 < iVar8) {
        iVar2 = iVar10 - iVar8;
      }
      if (2 < iVar2) {
        local_8c = DAT_00bcf734 + local_90;
        FUN_005125ba(local_8c,local_88);
        cVar1 = FUN_0051236a(local_44,local_88);
        iVar10 = DAT_00bad920;
        if (cVar1 != '\0') {
          local_94 = (int *)0x0;
          iVar10 = FUN_005cfce4(&local_94,8);
          if (iVar10 != 0) {
            *local_94 = iVar3;
            local_94[1] = *(int *)(iVar11 + 0x1c);
            *(int **)(iVar11 + 0x1c) = local_94;
          }
          iVar2 = FUN_005cfce4(&local_94,8);
          iVar10 = DAT_00bad920;
          if (iVar2 != 0) {
            *local_94 = param_1;
            local_94[1] = *(int *)(local_8c + 0x1c);
            *(int **)(local_8c + 0x1c) = local_94;
            iVar10 = DAT_00bad920;
          }
        }
      }
      iVar3 = iVar3 + 1;
      iVar8 = iVar8 + 1;
      local_90 = local_90 + 0x1550;
    } while (iVar3 < iVar10);
  }
  return;
}


