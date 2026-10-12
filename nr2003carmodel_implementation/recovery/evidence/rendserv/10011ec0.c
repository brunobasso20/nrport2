/* NR2003.exe @ 10011ec0 FUN_10011ec0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int __fastcall FUN_10011ec0(int param_1)

{
  float *pfVar1;
  int iVar2;
  float fVar3;
  int iVar4;
  int iVar5;
  float *pfVar6;
  float10 fVar7;
  float local_4;
  
  local_4 = *(float *)(*(int *)(param_1 + 0x2c) + 0x38);
  if ((NAN(*(float *)(param_1 + 0x30)) || NAN(_DAT_100348d0)) ==
      (*(float *)(param_1 + 0x30) == _DAT_100348d0)) {
    fVar7 = (float10)FUN_10029b1a(local_4);
    local_4 = (float)fVar7;
  }
  pfVar1 = *(float **)(param_1 + 0x38);
  if ((local_4 < *pfVar1 != (NAN(local_4) || NAN(*pfVar1))) ||
     (iVar2 = *(int *)(param_1 + 0x34), pfVar1[iVar2] < local_4)) {
    *(undefined4 *)(&DAT_10042a74 + DAT_10042ab4 * 4) = 0x3f800000;
    DAT_10042ab4 = DAT_10042ab4 + 1;
    return -1;
  }
  iVar5 = 0;
  if (1 < iVar2) {
    iVar4 = 1;
    pfVar6 = pfVar1;
    do {
      pfVar6 = pfVar6 + 1;
      if (local_4 < *pfVar6) break;
      iVar5 = iVar5 + 1;
      iVar4 = iVar4 + 1;
    } while (iVar4 < iVar2);
  }
  fVar3 = (local_4 - pfVar1[iVar5]) / (pfVar1[iVar5 + 1] - pfVar1[iVar5]);
  if ((fVar3 < (float)_DAT_10034998 != (NAN(fVar3) || NAN((float)_DAT_10034998))) ||
     (_DAT_10034ce4 < fVar3)) {
    fVar3 = _DAT_100341f0;
  }
  *(float *)(&DAT_10042a74 + DAT_10042ab4 * 4) = fVar3;
  DAT_10042ab4 = DAT_10042ab4 + 1;
  return iVar5;
}

