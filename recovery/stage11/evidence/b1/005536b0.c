/* NR2003.exe @ 005536b0 FUN_005536b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005536b0(void)

{
  float fVar1;
  int iVar2;
  undefined4 uVar3;
  float10 fVar4;
  
  fVar4 = (float10)FUN_00554f10();
  fVar1 = (float)fVar4;
  if (DAT_0074c97c == 0) {
    if (DAT_00bf6f0c == 0) {
      if (DAT_00bf6e20 != '\0') goto LAB_005536fe;
    }
    else if (((DAT_00bf6f0c == 1) && (DAT_00bf6e22 != '\0')) && (0 < DAT_00bf6e23))
    goto LAB_005536fe;
    if (DAT_00c086e0 != 0) {
LAB_005536fe:
      FUN_00552450();
      return;
    }
  }
  else if (DAT_0074c97c == 1) {
    if (DAT_00bf6f0c == 0) {
      if (DAT_00bf6e21 != '\0') {
LAB_00553780:
        FUN_00552480();
        return;
      }
    }
    else if (((DAT_00bf6f0c == 1) && (DAT_00bf6e22 != '\0')) && (DAT_00bf6e23 == 0))
    goto LAB_00553780;
    if ((DAT_00c53400 < fVar1) && (_DAT_006ea470 < DAT_00bf6ea4)) {
      if (DAT_00bf6f0c == 1) {
        DAT_00bf6e23 = 2;
      }
      FUN_00552450();
      return;
    }
  }
  else {
    iVar2 = FUN_005538a0(1);
    if ((((DAT_0074c97c == iVar2) && (fVar1 < _DAT_006f58f8 != (NAN(fVar1) || NAN(_DAT_006f58f8))))
        && (DAT_00bf6ea4 < _DAT_006e9824 != (NAN(DAT_00bf6ea4) || NAN(_DAT_006e9824)))) &&
       (DAT_00bf6eba == '\0')) {
      if (DAT_00bf6f0c == 1) {
        DAT_00bf6e23 = 1;
      }
      FUN_00552480();
      return;
    }
    uVar3 = FUN_0055ab00();
    iVar2 = FUN_00562f70(uVar3);
    uVar3 = *(undefined4 *)(iVar2 + 0x58a);
    fVar4 = (float10)FUN_00554f50();
    fVar4 = (float10)FUN_00553920((float)fVar4,uVar3,DAT_0074c97c);
    if ((float10)_DAT_00c08728 * (float10)*(float *)(&UNK_006f599c + DAT_0074c97c * 4) < fVar4) {
      if (DAT_00bf6f0c == 1) {
        DAT_00bf6e23 = DAT_0074c97c + 1;
      }
      FUN_00552450();
      return;
    }
    fVar1 = (float)(&DAT_00c533f8)[DAT_0074c97c];
    iVar2 = FUN_005538f0(DAT_0074c97c);
    if (iVar2 == 1) {
      fVar1 = _DAT_006ea454;
    }
    if ((float)fVar4 < fVar1 != ((float)fVar4 == fVar1)) {
      if (DAT_00bf6f0c == 1) {
        DAT_00bf6e23 = DAT_0074c97c + -1;
      }
      FUN_00552480();
      return;
    }
  }
  return;
}

