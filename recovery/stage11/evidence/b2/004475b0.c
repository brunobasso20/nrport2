/* NR2003.exe @ 004475b0 FUN_004475b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004475b0(int param_1_00,int *param_1)

{
  double dVar1;
  float fVar2;
  float fVar3;
  double dVar4;
  char cVar5;
  int iVar6;
  int iVar7;
  int *piVar8;
  int *piVar9;
  int *piVar10;
  bool bVar11;
  float10 fVar12;
  
  piVar10 = (int *)(param_1_00 + 0x19);
  iVar7 = 0x1a;
  bVar11 = true;
  piVar8 = piVar10;
  piVar9 = param_1;
  do {
    if (iVar7 == 0) break;
    iVar7 = iVar7 + -1;
    bVar11 = *piVar8 == *piVar9;
    piVar8 = piVar8 + 1;
    piVar9 = piVar9 + 1;
  } while (bVar11);
  if (bVar11) {
    return;
  }
  if (DAT_00898f21 != '\0') goto LAB_00447897;
  fVar12 = (float10)thunk_FUN_0055a760();
  fVar2 = *(float *)(param_1_00 + 0x71);
  fVar3 = (float)param_1[0x16];
  dVar1 = (double)fVar12;
  if ((*(char *)(param_1_00 + 0x81) != '\0') && (((byte)param_1[3] & 0x3f) != 0x3f)) {
    *(undefined *)(param_1_00 + 0x81) = 0;
  }
  if ((*(char *)(param_1_00 + 0x81) == '\0') && (((byte)param_1[3] & 0x3f) == 0x3f)) {
    *(undefined *)(param_1_00 + 0x81) = 1;
    *(undefined4 *)(param_1_00 + 0x82) = 0x41;
    *(undefined4 *)(param_1_00 + 0x86) = 0x4d;
LAB_004476b2:
    *(double *)(param_1_00 + 0x8a) = dVar1 + _DAT_006ecfe0;
  }
  else {
    if ((fVar2 < _DAT_006e9824 != (fVar2 == _DAT_006e9824)) && (_DAT_006e9824 < fVar3)) {
      *(undefined4 *)(param_1_00 + 0x82) = 0x44;
LAB_004476ac:
      *(undefined4 *)(param_1_00 + 0x86) = 0xffffffff;
      goto LAB_004476b2;
    }
    if ((fVar2 < _DAT_006ea508 != (fVar2 == _DAT_006ea508)) && (_DAT_006ea508 < fVar3)) {
      *(undefined4 *)(param_1_00 + 0x82) = 0x43;
      goto LAB_004476ac;
    }
  }
  cVar5 = FUN_004471e0(param_1,6);
  if ((cVar5 == '\0') && (cVar5 = FUN_004471e0(param_1,1), cVar5 == '\0')) {
    cVar5 = FUN_004471e0(param_1,7);
    if ((cVar5 != '\0') || (cVar5 = FUN_004471e0(param_1,0), cVar5 != '\0')) {
      *(undefined4 *)(param_1_00 + 0x92) = 0x49;
      goto LAB_00447780;
    }
    cVar5 = FUN_004471e0(param_1,5);
    if (cVar5 != '\0') {
      *(undefined4 *)(param_1_00 + 0x92) = 0x45;
      goto LAB_00447780;
    }
    cVar5 = FUN_004471e0(param_1,3);
    if (cVar5 != '\0') {
      *(undefined4 *)(param_1_00 + 0x92) = 0x4a;
      goto LAB_00447780;
    }
    cVar5 = FUN_004471e0(param_1,2);
    if (cVar5 != '\0') {
      *(undefined4 *)(param_1_00 + 0x92) = 0x47;
      goto LAB_00447780;
    }
    cVar5 = FUN_004471e0(param_1,4);
    if (cVar5 != '\0') {
      *(undefined4 *)(param_1_00 + 0x92) = 0x48;
      goto LAB_00447780;
    }
  }
  else {
    *(undefined4 *)(param_1_00 + 0x92) = 0x46;
LAB_00447780:
    dVar4 = dVar1 + _DAT_006ecfe0;
    *(undefined4 *)(param_1_00 + 0x96) = 0xffffffff;
    *(double *)(param_1_00 + 0x9a) = dVar4;
  }
  iVar7 = 0;
  do {
    iVar6 = FUN_00447310(param_1,iVar7);
    if (iVar6 == 1) {
      dVar4 = dVar1 + _DAT_006ecfe0;
      *(undefined4 *)(param_1_00 + 0xa2) = 0x53;
      *(undefined4 *)(param_1_00 + 0xa6) = 0xffffffff;
      *(double *)(param_1_00 + 0xaa) = dVar4;
    }
    else if ((1 < iVar6) && (iVar6 < 4)) {
      dVar4 = dVar1 + _DAT_006ecfe0;
      *(undefined4 *)(param_1_00 + 0xb2) = 0x42;
      *(undefined4 *)(param_1_00 + 0xb6) = 0x4b;
      *(double *)(param_1_00 + 0xba) = dVar4;
    }
    iVar7 = iVar7 + 1;
  } while (iVar7 < 4);
  cVar5 = FUN_00447280(param_1);
  if (cVar5 != '\0') {
    dVar4 = dVar1 + _DAT_006ecfe0;
    *(undefined4 *)(param_1_00 + 0xc2) = 0x4c;
    *(undefined4 *)(param_1_00 + 0xc6) = 0xffffffff;
    *(double *)(param_1_00 + 0xca) = dVar4;
  }
  fVar12 = (float10)FUN_00563530(DAT_0089e3d8,piVar10);
  if (((NAN(fVar12) || NAN((float10)_DAT_006ea454)) != (fVar12 == (float10)_DAT_006ea454)) &&
     (fVar12 = (float10)FUN_00563530(DAT_0089e3d8,param_1), (float10)_DAT_006ea454 < fVar12)) {
    dVar1 = dVar1 + _DAT_006ecfe0;
    *(undefined4 *)(param_1_00 + 0xd2) = 0x4f;
    *(undefined4 *)(param_1_00 + 0xd6) = 0xffffffff;
    *(double *)(param_1_00 + 0xda) = dVar1;
  }
LAB_00447897:
  for (iVar7 = 0x1a; iVar7 != 0; iVar7 = iVar7 + -1) {
    *piVar10 = *param_1;
    param_1 = param_1 + 1;
    piVar10 = piVar10 + 1;
  }
  return;
}

