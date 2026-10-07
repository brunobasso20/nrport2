/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0044cb60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0044cb60(int param_1)

{
  float fVar1;
  float fVar2;
  char cVar3;
  int iVar4;
  undefined4 uVar5;
  float10 fVar6;
  undefined4 *puVar7;
  undefined4 local_c [2];
  
  iVar4 = thunk_FUN_0055a730();
  if (iVar4 != 4) {
    return;
  }
  puVar7 = local_c;
  fVar2 = *(float *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x3c);
  local_c[0] = 0;
  FUN_00538b20(puVar7);
  uVar5 = FUN_00540440();
  uVar5 = FUN_00536180(uVar5,puVar7);
  switch(*(undefined4 *)(param_1 + 0x68)) {
  case 1:
    cVar3 = FUN_00450830();
    if (cVar3 == '\0') {
      cVar3 = FUN_00536470(fVar2,uVar5);
      if (cVar3 != '\0') {
        *(undefined4 *)(param_1 + 0x68) = 2;
        return;
      }
      *(undefined4 *)(param_1 + 0x68) = 3;
      fVar6 = (float10)thunk_FUN_0055a760();
      *(double *)(param_1 + 0x6c) = (double)(fVar6 + (float10)_DAT_006ecfe8);
      return;
    }
    break;
  case 2:
    cVar3 = FUN_00536470(fVar2,uVar5);
    if (cVar3 != '\0') {
      cVar3 = FUN_005354b0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
      if (cVar3 != '\0') {
        return;
      }
      cVar3 = FUN_005354d0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
      if (cVar3 != '\0') {
        return;
      }
      cVar3 = FUN_005354f0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
      if (cVar3 != '\0') {
        return;
      }
      *(undefined4 *)(param_1 + 0x68) = 4;
      fVar6 = (float10)thunk_FUN_0055a760();
      *(double *)(param_1 + 0x6c) = (double)(fVar6 + (float10)_DAT_006ea668);
      return;
    }
    cVar3 = FUN_00450830();
    if (cVar3 != '\0') {
      *(undefined4 *)(param_1 + 0x68) = 1;
      return;
    }
    cVar3 = FUN_005354b0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
    if (cVar3 != '\0') {
      *(undefined4 *)(param_1 + 0x68) = 7;
      fVar6 = (float10)thunk_FUN_0055a760();
      *(double *)(param_1 + 0x6c) = (double)(fVar6 + (float10)_DAT_006ea668);
      return;
    }
    goto LAB_0044cf66;
  case 3:
    fVar6 = (float10)thunk_FUN_0055a760();
    if ((float10)*(double *)(param_1 + 0x6c) < fVar6) goto LAB_0044cf66;
  case 0:
    cVar3 = FUN_00450830();
    if (cVar3 != '\0') {
      *(undefined4 *)(param_1 + 0x68) = 1;
      return;
    }
    break;
  case 4:
    fVar6 = (float10)thunk_FUN_0055a760();
    if ((float10)*(double *)(param_1 + 0x6c) < fVar6) {
      if ((_DAT_006ea454 < *(float *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x44)) &&
         (fVar1 = *(float *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x44),
         cVar3 = FUN_00536470(fVar1 + fVar1 + fVar2,uVar5), cVar3 != '\0')) {
        *(undefined4 *)(param_1 + 0x68) = 5;
        return;
      }
LAB_0044ce00:
      *(undefined4 *)(param_1 + 0x68) = 2;
      return;
    }
    cVar3 = FUN_005354b0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
    if (cVar3 != '\0') {
      *(undefined4 *)(param_1 + 0x68) = 2;
      return;
    }
    break;
  case 5:
    cVar3 = FUN_00451080(10);
    if (cVar3 != '\0') {
      iVar4 = FUN_00567280();
      if (iVar4 != 2) {
        FUN_00450ec0(10,0xd7,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
      }
      *(undefined4 *)(param_1 + 0x68) = 6;
      *(undefined4 *)(param_1 + 0x6c) = 0;
      *(undefined4 *)(param_1 + 0x70) = 0xbff00000;
      return;
    }
    break;
  case 6:
    cVar3 = FUN_00536470(fVar2,uVar5);
    if (cVar3 == '\0') goto LAB_0044ce00;
    cVar3 = FUN_005354b0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
    if (((cVar3 == '\0') &&
        (cVar3 = FUN_005354d0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae)), cVar3 == '\0')) &&
       (cVar3 = FUN_005354f0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae)), cVar3 == '\0')) {
      *(undefined4 *)(param_1 + 0x6c) = 0;
      *(undefined4 *)(param_1 + 0x70) = 0xbff00000;
      return;
    }
    if (*(double *)(param_1 + 0x6c) < _DAT_006ea4b0) {
      fVar6 = (float10)thunk_FUN_0055a760();
      *(double *)(param_1 + 0x6c) = (double)(fVar6 + (float10)_DAT_006e9808);
      return;
    }
    fVar6 = (float10)thunk_FUN_0055a760();
    if ((float10)*(double *)(param_1 + 0x6c) < fVar6) {
      *(undefined4 *)(param_1 + 0x68) = 2;
      return;
    }
    break;
  case 7:
    fVar6 = (float10)thunk_FUN_0055a760();
    if ((float10)*(double *)(param_1 + 0x6c) < fVar6) {
      *(undefined4 *)(param_1 + 0x68) = 8;
      fVar6 = (float10)thunk_FUN_0055a760();
      *(double *)(param_1 + 0x6c) = (double)(fVar6 + (float10)_DAT_006ea668);
      return;
    }
    cVar3 = FUN_00536470(fVar2,uVar5);
    if (cVar3 != '\0') {
      *(undefined4 *)(param_1 + 0x68) = 2;
      return;
    }
    break;
  case 8:
    fVar6 = (float10)thunk_FUN_0055a760();
    if ((float10)*(double *)(param_1 + 0x6c) < fVar6) {
      cVar3 = FUN_005354b0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
      *(uint *)(param_1 + 0x68) = -(uint)(cVar3 != '\0') & 9;
      return;
    }
    break;
  case 9:
    cVar3 = FUN_00451080(10);
    if (cVar3 == '\0') {
      return;
    }
    iVar4 = FUN_00567280();
    if (iVar4 != 2) {
      FUN_00450ec0(10,0xd6,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
    }
LAB_0044cf66:
    *(undefined4 *)(param_1 + 0x68) = 0;
  }
  return;
}


