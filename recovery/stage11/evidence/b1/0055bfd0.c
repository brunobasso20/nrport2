/* NR2003.exe @ 0055bfd0 FUN_0055bfd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055bfd0(void)

{
  int **ppiVar1;
  int *piVar2;
  float fVar3;
  char cVar4;
  uint uVar5;
  undefined4 uVar6;
  int iVar7;
  int iVar8;
  undefined4 uVar9;
  int iVar10;
  int iVar11;
  int *piVar12;
  float10 fVar13;
  undefined *puVar14;
  int local_c;
  int local_8;
  undefined4 local_4;
  
  local_8 = taskGetRate();
  _DAT_00c067e4 = _DAT_006e9808 / (double)local_8 + _DAT_00c067e4;
  uVar5 = getBGCount();
  uVar6 = FUN_0055ab00();
  iVar7 = FUN_00562f70(uVar6);
  if (((((DAT_00b8fac4 == '\0') || (iVar8 = FUN_0055a5c0(), iVar8 == 2)) ||
       (cVar4 = FUN_00502460(), cVar4 != '\0')) ||
      ((cVar4 = FUN_00502460(), cVar4 == '\0' &&
       (iVar8 = FUN_0055a610(), *(int *)(iVar8 + 0xc) != iVar7)))) || (*(int *)(iVar7 + 4) == 0)) {
    FUN_0050d1d0();
  }
  else {
    FUN_0050d990(iVar7);
  }
  if (DAT_00b8fac4 != '\0') {
    FUN_0050d6d0();
  }
  puVar14 = &DAT_00c07170;
  fVar13 = (float10)thunk_FUN_0055a760(&DAT_00c07170);
  FUN_005a4cc0(DAT_00c067d8,(double)fVar13,puVar14);
  iVar7 = getBGCount();
  iVar8 = 0x30;
  do {
    FUN_005a0b60(iVar7,DAT_00c087a0);
    iVar8 = iVar8 + -1;
  } while (iVar8 != 0);
  local_c = 0;
  cVar4 = FUN_00566a20(&local_c);
  while (cVar4 != '\0') {
    FUN_0051bf10();
    cVar4 = FUN_005a13f0(&local_4);
    if (cVar4 == '\0') {
      if (*(int *)(local_c + 4) != 0) {
        FUN_00563730(local_c);
      }
      *(undefined4 *)(local_c + 0x5ae) = 0;
    }
    else {
      *(undefined4 *)(local_c + 0x5ae) = local_4;
      if (*(int *)(local_c + 4) == 0) {
        FUN_00563620(local_c);
      }
      FUN_005637e0(local_c,0);
      if ((uVar5 & 0x1f) == 0) {
        FUN_005acdd0(local_c + 0x1493);
      }
    }
    cVar4 = FUN_00566a20(&local_c);
  }
  local_c = 0;
  cVar4 = FUN_005669f0(&local_c);
  while (cVar4 != '\0') {
    iVar7 = FUN_0055ab00();
    if ((*(int *)(local_c + 0x5b2) != iVar7) &&
       ((iVar7 = FUN_005c2d20(DAT_00c08194), iVar7 != 1 || (*(char *)(local_c + 0x59b) == '\0')))) {
      if (*(char *)(local_c + 0x59a) == '\0') {
        uVar6 = *(undefined4 *)(local_c + 0x5b2);
        uVar9 = 0xff;
      }
      else {
        uVar6 = *(undefined4 *)(local_c + 0x5b2);
        uVar9 = uVar6;
        FUN_00538b20(uVar6);
        uVar9 = FUN_00540450(uVar9);
      }
      FUN_00524af0(uVar6,uVar9);
    }
    cVar4 = FUN_005669f0(&local_c);
  }
  if (1 < DAT_00c0876c) {
    fVar3 = *(float *)(*(int *)(DAT_00c08768 + 0x5ae) + 0x3c);
    iVar7 = DAT_00c08768;
    if (*(int *)(DAT_00c08768 + 4) == 0) {
      iVar8 = 0;
    }
    else {
      iVar8 = *(int *)(DAT_00c08768 + 4) + -4;
    }
    do {
      if (*(float *)(*(int *)(iVar8 + 0x5ae) + 0x3c) < fVar3) {
        fVar3 = *(float *)(*(int *)(iVar8 + 0x5ae) + 0x3c);
        iVar7 = iVar8;
      }
      if (*(int *)(iVar8 + 4) == 0) {
        iVar8 = 0;
      }
      else {
        iVar8 = *(int *)(iVar8 + 4) + -4;
      }
    } while (iVar8 != DAT_00c08768);
    if (*(int *)(iVar7 + 4) == 0) {
      iVar8 = 0;
    }
    else {
      iVar8 = *(int *)(iVar7 + 4) + -4;
    }
    if (*(int *)(iVar8 + 4) == 0) {
      iVar8 = 0;
    }
    else {
      iVar8 = *(int *)(iVar8 + 4) + -4;
    }
    DAT_00c08768 = iVar7;
    if (iVar8 != iVar7) {
      do {
        ppiVar1 = (int **)(iVar8 + 4);
        if (*(int *)(iVar8 + 4) == 0) {
          local_8 = 0;
        }
        else {
          local_8 = *(int *)(iVar8 + 4) + -4;
        }
        while( true ) {
          iVar7 = *(int *)(iVar8 + 8);
          if (iVar7 == 0) {
            iVar10 = 0;
          }
          else {
            iVar10 = iVar7 + -4;
          }
          if (*(float *)(*(int *)(iVar10 + 0x5ae) + 0x3c) <=
              *(float *)(*(int *)(iVar8 + 0x5ae) + 0x3c)) break;
          if (*ppiVar1 == (int *)0x0) {
            piVar12 = (int *)0x0;
          }
          else {
            piVar12 = *ppiVar1 + -1;
          }
          if (iVar7 == 0) {
            iVar7 = 0;
          }
          else {
            iVar7 = iVar7 + -4;
          }
          if (*(int *)(iVar7 + 8) == 0) {
            iVar10 = 0;
          }
          else {
            iVar10 = *(int *)(iVar7 + 8) + -4;
          }
          piVar2 = (int *)(iVar7 + 4);
          piVar12[2] = (int)piVar2;
          *ppiVar1 = piVar2;
          if (iVar10 == 0) {
            iVar11 = 0;
          }
          else {
            iVar11 = iVar10 + 4;
          }
          *(int *)(iVar8 + 8) = iVar11;
          *piVar2 = (int)(piVar12 + 1);
          *(int ***)(iVar7 + 8) = ppiVar1;
          *(int ***)(iVar10 + 4) = ppiVar1;
        }
        iVar8 = local_8;
      } while (local_8 != DAT_00c08768);
    }
  }
  iVar7 = FUN_005c2d20(DAT_00c08194);
  if (iVar7 != 1) {
    FUN_005b2190(FUN_00562f70,FUN_00566a20);
  }
  FUN_00549c40();
  cVar4 = FUN_00501480();
  if (cVar4 != '\0') {
    FUN_00579830();
    FUN_005797f0();
    FUN_00560650();
    FUN_00524e10();
  }
  if ((DAT_00c081ab != '\0') && (cVar4 = FUN_005b75a0(), cVar4 != '\0')) {
    FUN_0055cd70();
  }
  cVar4 = FUN_00502460();
  if (cVar4 == '\0') {
    FUN_0055a610();
    FUN_005697e0();
  }
  FUN_005503f0();
  FUN_00583b30();
  FUN_00585b50();
  FUN_005992a0();
  FUN_005b5920();
  FUN_00539390();
  FUN_00593510(0);
  if ((DAT_00c72160 != (int *)0x0) && (cVar4 = FUN_00502460(), cVar4 == '\0')) {
    iVar7 = *DAT_00c72160;
    fVar13 = (float10)thunk_FUN_0055a760();
    (**(code **)(iVar7 + 0xb8))((double)fVar13);
    iVar7 = *DAT_00c72160;
    fVar13 = (float10)thunk_FUN_0055a760();
    (**(code **)(iVar7 + 0xc0))((double)fVar13);
  }
  FUN_005ae660();
  FUN_0043e9e0();
  return;
}

