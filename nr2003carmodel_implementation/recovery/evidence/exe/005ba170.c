/* NR2003.exe @ 005ba170 recovered_005ba170 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void __thiscall recovered_005ba170(int param_1,float param_2)

{
  int iVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  char cVar8;
  int iVar9;
  float *pfVar10;
  int extraout_ECX;
  float *pfVar11;
  int iVar12;
  int iVar13;
  float *pfStack_20;
  int iStack_1c;
  
  cVar8 = FUN_005ba080();
  if (cVar8 != '\0') {
    iVar12 = extraout_ECX + DAT_00ebbd78 * -0xfc;
    iVar1 = DAT_00ebbd78 * 0xfc + 0xf4 + extraout_ECX;
    iVar13 = iVar12 + 0x1f0;
    FUN_005f5c10(extraout_ECX + 0x2ec,param_2,iVar13,iVar1);
    fVar2 = *(float *)(iVar1 + 0x9c);
    fVar3 = *(float *)(iVar12 + 0x28c);
    fVar4 = *(float *)(iVar1 + 0xa0);
    fVar5 = *(float *)(iVar12 + 0x290);
    fVar6 = *(float *)(iVar12 + 0x28c);
    fVar7 = *(float *)(iVar12 + 0x290);
    *(float *)(extraout_ECX + 900) =
         *(float *)(iVar12 + 0x288) +
         (*(float *)(iVar1 + 0x98) - *(float *)(iVar12 + 0x288)) * param_2;
    *(float *)(extraout_ECX + 0x388) = fVar6 + (fVar2 - fVar3) * param_2;
    *(float *)(extraout_ECX + 0x38c) = fVar7 + (fVar4 - fVar5) * param_2;
    *(float *)(extraout_ECX + 0x390) =
         (*(float *)(iVar1 + 0xa4) - *(float *)(iVar12 + 0x294)) * param_2 +
         *(float *)(iVar12 + 0x294);
    *(float *)(extraout_ECX + 0x394) =
         (*(float *)(iVar1 + 0xa8) - *(float *)(iVar12 + 0x298)) * param_2 +
         *(float *)(iVar12 + 0x298);
    *(float *)(extraout_ECX + 0x398) =
         (*(float *)(iVar1 + 0xac) - *(float *)(iVar12 + 0x29c)) * param_2 +
         *(float *)(iVar12 + 0x29c);
    *(float *)(extraout_ECX + 0x39c) =
         (*(float *)(iVar1 + 0xb0) - *(float *)(iVar12 + 0x2a0)) * param_2 +
         *(float *)(iVar12 + 0x2a0);
    fVar2 = (*(float *)(iVar1 + 0xb4) - *(float *)(iVar12 + 0x2a4)) * param_2 +
            *(float *)(iVar12 + 0x2a4);
    if (fVar2 <= (float)_DAT_006e97f8) {
      if (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638))) {
        do {
          fVar2 = fVar2 + _DAT_006ee484;
        } while (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638)));
      }
    }
    else {
      do {
        fVar2 = fVar2 - _DAT_006ee484;
      } while ((float)_DAT_006e97f8 < fVar2);
    }
    *(float *)(extraout_ECX + 0x3a0) = fVar2;
    fVar2 = (*(float *)(iVar1 + 0xb8) - *(float *)(iVar12 + 0x2a8)) * param_2 +
            *(float *)(iVar12 + 0x2a8);
    if (fVar2 <= (float)_DAT_006e97f8) {
      if (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638))) {
        do {
          fVar2 = fVar2 + _DAT_006ee484;
        } while (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638)));
      }
    }
    else {
      do {
        fVar2 = fVar2 - _DAT_006ee484;
      } while ((float)_DAT_006e97f8 < fVar2);
    }
    *(float *)(extraout_ECX + 0x3a4) = fVar2;
    fVar2 = (*(float *)(iVar1 + 0xbc) - *(float *)(iVar12 + 0x2ac)) * param_2 +
            *(float *)(iVar12 + 0x2ac);
    if (fVar2 <= (float)_DAT_006e97f8) {
      if (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638))) {
        do {
          fVar2 = fVar2 + _DAT_006ee484;
        } while (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638)));
      }
    }
    else {
      do {
        fVar2 = fVar2 - _DAT_006ee484;
      } while ((float)_DAT_006e97f8 < fVar2);
    }
    *(float *)(extraout_ECX + 0x3a8) = fVar2;
    fVar2 = *(float *)(iVar1 + 0xc4);
    fVar3 = *(float *)(iVar12 + 0x2b4);
    fVar4 = *(float *)(iVar1 + 200);
    fVar5 = *(float *)(iVar12 + 0x2b8);
    fVar6 = *(float *)(iVar12 + 0x2b4);
    fVar7 = *(float *)(iVar12 + 0x2b8);
    *(float *)(extraout_ECX + 0x3ac) =
         *(float *)(iVar12 + 0x2b0) +
         (*(float *)(iVar1 + 0xc0) - *(float *)(iVar12 + 0x2b0)) * param_2;
    *(float *)(extraout_ECX + 0x3b0) = fVar6 + (fVar2 - fVar3) * param_2;
    *(float *)(extraout_ECX + 0x3b4) = fVar7 + (fVar4 - fVar5) * param_2;
    fVar2 = (*(float *)(iVar1 + 0xcc) - *(float *)(iVar12 + 700)) * param_2 +
            *(float *)(iVar12 + 700);
    if (fVar2 <= (float)_DAT_006e97f8) {
      if (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638))) {
        do {
          fVar2 = fVar2 + _DAT_006ee484;
        } while (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638)));
      }
    }
    else {
      do {
        fVar2 = fVar2 - _DAT_006ee484;
      } while ((float)_DAT_006e97f8 < fVar2);
    }
    *(float *)(extraout_ECX + 0x3b8) = fVar2;
    fVar2 = (*(float *)(iVar1 + 0xd0) - *(float *)(iVar12 + 0x2c0)) * param_2 +
            *(float *)(iVar12 + 0x2c0);
    if (fVar2 <= (float)_DAT_006e97f8) {
      if (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638))) {
        do {
          fVar2 = fVar2 + _DAT_006ee484;
        } while (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638)));
      }
    }
    else {
      do {
        fVar2 = fVar2 - _DAT_006ee484;
      } while ((float)_DAT_006e97f8 < fVar2);
    }
    *(float *)(extraout_ECX + 0x3bc) = fVar2;
    fVar2 = *(float *)(iVar12 + 0x2c4);
    fVar3 = *(float *)(iVar1 + 0xd4);
    if (fVar2 < _DAT_006f59cc == (NAN(fVar2) || NAN(_DAT_006f59cc))) {
      if ((_DAT_006ee480 < fVar2) && (fVar3 < _DAT_006f59cc != (NAN(fVar3) || NAN(_DAT_006f59cc))))
      {
        do {
          fVar3 = fVar3 + _DAT_006ee484;
        } while (fVar3 < _DAT_006f59cc != (NAN(fVar3) || NAN(_DAT_006f59cc)));
      }
    }
    else {
      for (; _DAT_006ee480 < fVar3; fVar3 = fVar3 - _DAT_006ee484) {
      }
    }
    fVar2 = (fVar3 - fVar2) * param_2 + fVar2;
    if (fVar2 <= (float)_DAT_006e97f8) {
      if (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638))) {
        do {
          fVar2 = fVar2 + _DAT_006ee484;
        } while (fVar2 < (float)_DAT_006f4638 != (NAN(fVar2) || NAN((float)_DAT_006f4638)));
      }
    }
    else {
      do {
        fVar2 = fVar2 - _DAT_006ee484;
      } while ((float)_DAT_006e97f8 < fVar2);
    }
    *(float *)(extraout_ECX + 0x3c0) = fVar2;
    iVar9 = taskGetRate();
    pfStack_20 = (float *)(extraout_ECX + 0x3d4);
    pfVar11 = (float *)(param_1 + 0x50);
    fVar2 = _DAT_006e97d8 / (float)iVar9;
    pfVar10 = (float *)(iVar12 + 0x2c8);
    iStack_1c = 4;
    do {
      *(float *)(((extraout_ECX + 0x2ec) - iVar13) + (int)pfVar10) =
           (*(float *)((iVar1 - iVar13) + (int)pfVar10) - *pfVar10) * param_2 + *pfVar10;
      fVar3 = fVar2 * *pfVar11 * param_2 + pfVar10[4];
      if ((int)ROUND(fVar3 * (float)_DAT_006f7598) != 0) {
        fVar3 = fVar3 - (float)(int)ROUND(fVar3 * (float)_DAT_006f7598) * (float)_DAT_006efb78;
      }
      pfVar10 = pfVar10 + 1;
      pfVar11 = pfVar11 + 1;
      *pfStack_20 = fVar3;
      pfStack_20 = pfStack_20 + 1;
      iStack_1c = iStack_1c + -1;
    } while (iStack_1c != 0);
    *(float *)(extraout_ECX + 0x3e4) =
         (*(float *)(iVar1 + 0xf8) - *(float *)(iVar12 + 0x2e8)) * param_2 +
         *(float *)(iVar12 + 0x2e8);
  }
  return;
}

