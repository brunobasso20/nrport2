/* NR2003.exe @ 10012810 FUN_10012810 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_10012810(int param_1)

{
  float fVar1;
  float *pfVar2;
  float fVar3;
  int iVar4;
  float *pfVar5;
  int iVar6;
  float local_18;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  local_18 = 0.0;
  pfVar2 = *(float **)(param_1 + 0x7c);
  fVar3 = *(float *)(*(int *)(param_1 + 0x74) + 0x38);
  iVar6 = 1;
  if (*pfVar2 < fVar3) {
    iVar4 = *(int *)(param_1 + 0x78);
    pfVar5 = pfVar2;
    if (1 < iVar4) {
      do {
        fVar1 = pfVar5[8];
        if (fVar3 < fVar1 != (NAN(fVar3) || NAN(fVar1))) {
          local_18 = (fVar3 - pfVar2[iVar6 * 8 + -8]) / (pfVar2[iVar6 * 8] - pfVar2[iVar6 * 8 + -8])
          ;
          goto LAB_1001286f;
        }
        iVar6 = iVar6 + 1;
        pfVar5 = pfVar5 + 8;
      } while (iVar6 < iVar4);
    }
    local_18 = 1.0;
    iVar6 = iVar4 + -1;
  }
LAB_1001286f:
  iVar4 = iVar6 + -1;
  *(float *)(param_1 + 0x44) =
       (pfVar2[iVar6 * 8 + 5] - pfVar2[iVar4 * 8 + 5]) * local_18 + pfVar2[iVar4 * 8 + 5];
  *(float *)(param_1 + 0x48) =
       (pfVar2[iVar6 * 8 + 6] - pfVar2[iVar4 * 8 + 6]) * local_18 + pfVar2[iVar4 * 8 + 6];
  *(float *)(param_1 + 0x4c) =
       (pfVar2[iVar6 * 8 + 7] - pfVar2[iVar4 * 8 + 7]) * local_18 + pfVar2[iVar4 * 8 + 7];
  if (local_18 < _DAT_100348d0 == (local_18 == _DAT_100348d0)) {
    if (local_18 < _DAT_100341f0) {
      FUN_10012970(pfVar2 + iVar4 * 8 + 1,pfVar2 + iVar6 * 8 + 1,local_18,&local_10);
    }
    else {
      local_10 = pfVar2[iVar6 * 8 + 1];
      local_c = pfVar2[iVar6 * 8 + 2];
      local_8 = pfVar2[iVar6 * 8 + 3];
      local_4 = pfVar2[iVar6 * 8 + 4];
    }
  }
  else {
    local_10 = pfVar2[iVar4 * 8 + 1];
    local_c = pfVar2[iVar4 * 8 + 2];
    local_8 = pfVar2[iVar4 * 8 + 3];
    local_4 = pfVar2[iVar4 * 8 + 4];
  }
  FUN_10028290((float *)(param_1 + 0x50),&local_10);
  return;
}

