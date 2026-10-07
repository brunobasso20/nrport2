/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050be30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0050be30(int param_1_00,int param_1)

{
  float fVar1;
  undefined4 uVar2;
  float fVar3;
  float *pfVar4;
  undefined4 *puVar5;
  float *pfVar6;
  int iVar7;
  int iVar8;
  float10 fVar9;
  float local_4;
  
  local_4 = *(float *)(param_1_00 + 8);
  pfVar6 = (float *)(param_1_00 + 8);
  if (param_1 != 0xb) {
    iVar8 = 0;
    if (0 < DAT_00b8faa0) {
      do {
        if (*pfVar6 < local_4) {
          local_4 = *pfVar6;
        }
        fVar9 = (float10)FUN_0050baf0(param_1_00,iVar8,local_4 * _DAT_006f410c);
        pfVar6[4] = local_4;
        iVar8 = iVar8 + 1;
        pfVar6 = pfVar6 + 7;
        local_4 = (float)(fVar9 + (float10)local_4);
      } while (iVar8 < DAT_00b8faa0);
    }
    iVar8 = 0;
    if (0 < DAT_00b8faa0) {
      pfVar6 = (float *)(param_1_00 + 0x18);
      do {
        if (*pfVar6 <= local_4) break;
        fVar9 = (float10)FUN_0050baf0(param_1_00,iVar8,local_4 * _DAT_006f410c);
        *pfVar6 = local_4;
        iVar8 = iVar8 + 1;
        pfVar6 = pfVar6 + 7;
        local_4 = (float)(fVar9 + (float10)local_4);
      } while (iVar8 < DAT_00b8faa0);
    }
    fVar3 = (float)_DAT_006ea4b0;
    pfVar6 = (float *)(param_1_00 + 0x18);
    iVar7 = 6;
    iVar8 = 6;
    pfVar4 = pfVar6;
    do {
      fVar3 = fVar3 + *pfVar4;
      pfVar4 = pfVar4 + 7;
      iVar7 = iVar7 + -1;
    } while (iVar7 != 0);
    if (6 < DAT_00b8faa0) {
      pfVar4 = (float *)(param_1_00 + 0x6c);
      do {
        iVar8 = iVar8 + 1;
        *pfVar4 = (float)_DAT_006f4120 * (fVar3 + pfVar4[0x15]);
        fVar3 = (fVar3 + pfVar4[0x15]) - pfVar4[-0x15];
        pfVar4 = pfVar4 + 7;
      } while (iVar8 < DAT_00b8faa0);
    }
    iVar8 = -6;
    do {
      iVar7 = iVar8 + 3;
      if (iVar7 < 0) {
        iVar7 = iVar7 + DAT_00b8faa0;
      }
      fVar1 = *pfVar6;
      *(float *)(param_1_00 + 0x18 + iVar7 * 0x1c) = (float)_DAT_006f4120 * (fVar3 + fVar1);
      iVar7 = iVar8;
      if (iVar8 < 0) {
        iVar7 = iVar8 + DAT_00b8faa0;
      }
      pfVar6 = pfVar6 + 7;
      fVar3 = (fVar3 + fVar1) - *(float *)(param_1_00 + 0x18 + iVar7 * 0x1c);
      iVar7 = iVar8 + 7;
      iVar8 = iVar8 + 1;
    } while (iVar7 < 6);
    if ((param_1 != 1) && (param_1 != 2)) {
      return;
    }
  }
  if (param_1 == 0xb) {
    param_1 = 0;
    iVar8 = 0;
    if (0 < DAT_00b8faa0) {
      puVar5 = (undefined4 *)(param_1_00 + 0x18);
      do {
        iVar8 = iVar8 + 1;
        *puVar5 = puVar5[-4];
        puVar5 = puVar5 + 7;
      } while (iVar8 < DAT_00b8faa0);
    }
  }
  iVar8 = 0;
  if (0 < DAT_00b8faa0) {
    puVar5 = (undefined4 *)(param_1_00 + 0x18);
    do {
      uVar2 = *puVar5;
      puVar5 = puVar5 + 7;
      *(undefined4 *)((&DAT_00b8fab0)[param_1] + iVar8 * 4) = uVar2;
      iVar8 = iVar8 + 1;
    } while (iVar8 < DAT_00b8faa0);
  }
  return;
}


