/* rend_dxg.dll @ 10048b40 FUN_10048b40 */

undefined4 __thiscall FUN_10048b40(undefined4 *param_1_00,undefined4 param_1,undefined4 param_2)

{
  float *pfVar1;
  int iVar2;
  int iVar3;
  success sVar4;
  undefined4 uVar5;
  int iVar6;
  int iVar7;
  undefined4 uStack_48;
  undefined4 uStack_44;
  int iStack_40;
  undefined4 *puStack_3c;
  float fStack_38;
  float fStack_34;
  void *pvStack_30;
  undefined4 uStack_2c;
  undefined8 uStack_28;
  undefined8 uStack_20;
  double dStack_18;
  double dStack_10;

  iVar3 = (**(code **)(**(int **)(param_1_00[0x1c] + 0x18) + 0x20))();
  dStack_10 = 0.0;
  dStack_18 = 0.0;
  uStack_20 = 0.0;
  uStack_28 = 0.0;
  puStack_3c = (undefined4 *)0x0;
  switch(param_1_00[0x1f]) {
  case 0:
    uStack_20 = *(double *)(iVar3 + 0x15);
    uStack_28 = *(double *)(iVar3 + 0x1d);
    dStack_10 = -*(double *)(iVar3 + 0x25);
    dStack_18 = -*(double *)(iVar3 + 0x2d);
    uStack_44 = 0;
    if (((*(int *)(iVar3 + 0x4d) != 0) && (iVar7 = *(int *)(*(int *)(iVar3 + 0x4d) + 4), iVar7 != 0)
        ) && ((iVar6 = param_1_00[0x23], -2 < iVar6 && (iVar6 < iVar7)))) {
      if (*(int *)(*(int *)(iVar3 + 0x5d) + 0x14 + param_1_00[0x15] * 0x53a) != 0) {
        puStack_3c = param_1_00 + 0x26;
      }
      if (((-1 < iVar6) && (param_1_00[0x21] != 0)) && (param_1_00[0x22] != 0)) {
        uStack_48 = 0;
        pfVar1 = (float *)(param_1_00[0x20] + iVar6 * 0xc);
        dStack_10 = (double)(*(float *)(param_1_00[0x20] + iVar6 * 0xc) + (float)dStack_10);
        dStack_18 = (double)(*pfVar1 + (float)dStack_18);
        uStack_20 = (double)(pfVar1[1] + (float)uStack_20);
        uStack_28 = (double)(pfVar1[1] + (float)uStack_28);
        break;
      }
    }
    uStack_48 = 1;
    break;
  case 1:
    dStack_10 = *(double *)(iVar3 + 0x25);
    dStack_18 = *(double *)(iVar3 + 0x2d);
    uStack_20 = *(double *)(iVar3 + 0x15);
    uStack_28 = *(double *)(iVar3 + 0x1d);
    uStack_44 = 1;
    uStack_48 = 2;
    break;
  case 2:
    dStack_10 = *(double *)(iVar3 + 0x25);
    dStack_18 = *(double *)(iVar3 + 0x2d);
    uStack_48 = 2;
    uStack_44 = 2;
    uStack_20 = 0.0;
    uStack_28 = 0.0;
    if ((((*(int *)(iVar3 + 0x4d) != 0) &&
         (iVar7 = *(int *)(*(int *)(iVar3 + 0x4d) + 4), iVar7 != 0)) &&
        (iVar6 = param_1_00[0x23], -2 < iVar6)) && (iVar6 < iVar7)) {
      uStack_20 = *(double *)(iVar3 + 0x15);
      uStack_28 = *(double *)(iVar3 + 0x1d);
      if (*(int *)(*(int *)(iVar3 + 0x5d) + 0x1c + param_1_00[0x15] * 0x53a) != 0) {
        puStack_3c = param_1_00 + 0x26;
      }
      if (((-1 < iVar6) && (param_1_00[0x21] != 0)) && (param_1_00[0x22] != 0)) {
        pfVar1 = (float *)(param_1_00[0x20] + iVar6 * 0xc);
        dStack_10 = (double)(*(float *)(param_1_00[0x20] + iVar6 * 0xc) + (float)dStack_10);
        dStack_18 = (double)(*pfVar1 + (float)dStack_18);
        uStack_20 = (double)(pfVar1[1] + (float)uStack_20);
        uStack_28 = (double)(pfVar1[1] + (float)uStack_28);
      }
    }
    break;
  default:
    uStack_48 = 1;
    uStack_44 = 1;
    break;
  case 5:
    dStack_10 = -*(double *)(iVar3 + 0x25);
    dStack_18 = -*(double *)(iVar3 + 0x2d);
    uStack_20 = 0.0;
    uStack_28 = 0.0;
    uStack_48 = 0;
    uStack_44 = 0;
  }
  uStack_2c = param_1_00[0x23];
  iVar7 = param_1_00[0x1f];
  iStack_40 = FUN_10049430(&uStack_2c);
  if (iVar7 == 0) {
    if (iStack_40 == 2) {
      uStack_44 = 0;
      uStack_48 = 2;
      goto LAB_10048e74;
    }
  }
  else if (iVar7 == 5) {
    iVar7 = iStack_40;
  }
  if (iStack_40 == 5) {
    iStack_40 = iVar7;
  }
LAB_10048e74:
  iVar6 = param_1_00[0x16];
  fStack_34 = 0.0;
  fStack_38 = 1.0;
  if (1 < iVar6) {
    iVar2 = param_1_00[0x15];
    fStack_34 = (float)*(double *)(*(int *)(iVar3 + 0x5d) + 0x28 + iVar2 * 0x53a);
    pvStack_30 = (void *)(*(int *)(iVar3 + 0x5d) + iVar2 * 0x53a);
    iVar6 = param_1_00[0x16];
    if (iVar2 < iVar6 + -1) {
      fStack_38 = (float)*(double *)((int)pvStack_30 + 0x562);
    }
    else {
      fStack_38 = 1.0;
    }
  }
  if ((iVar7 != 5) && (iStack_40 != 5)) {
    if (iVar6 < 2) {
      if (*(int *)(iVar3 + 0x45) == 0) {
        sVar4 = _memAlloc(&pvStack_30,0x219);
        if ((sVar4 != 0) && (pvStack_30 != (void *)0x0)) {
          uVar5 = *(undefined4 *)
                   (*(int *)(iVar3 + 0x5d) + 0x14 + iVar7 * 4 + param_1_00[0x15] * 0x53a);
          uVar5 = FUN_10043b50(CONCAT31((int3)((uint)uVar5 >> 8),*(undefined *)(iVar3 + 0x14)),
                               (double)(*(float *)(iVar3 + 0xc) + (float)dStack_10),
                               (double)(*(float *)(iVar3 + 0x10) + (float)dStack_18),*param_1_00,
                               param_1_00[0x28],uVar5,
                               *(undefined4 *)
                                (*(int *)(iVar3 + 0x5d) + 0x14 + iStack_40 * 4 +
                                param_1_00[0x15] * 0x53a),param_1,param_2,uStack_48,uStack_44,
                               (undefined4)uStack_20,uStack_20._4_4_,(undefined4)uStack_28,
                               uStack_28._4_4_,puStack_3c);
          return uVar5;
        }
      }
      else {
        sVar4 = _memAlloc(&pvStack_30,0x1eb);
        if ((sVar4 != 0) && (pvStack_30 != (void *)0x0)) {
          uVar5 = *(undefined4 *)
                   (*(int *)(iVar3 + 0x5d) + 0x14 + iVar7 * 4 + param_1_00[0x15] * 0x53a);
          uVar5 = FUN_100437f0(CONCAT31((int3)((uint)uVar5 >> 8),*(undefined *)(iVar3 + 0x14)),
                               (double)(*(float *)(iVar3 + 0xc) + (float)dStack_10),
                               (double)(*(float *)(iVar3 + 0x10) + (float)dStack_18),*param_1_00,
                               param_1_00[0x28],uVar5,
                               *(undefined4 *)
                                (*(int *)(iVar3 + 0x5d) + 0x14 + iStack_40 * 4 +
                                param_1_00[0x15] * 0x53a),param_1,param_2,uStack_48,uStack_44,
                               (undefined4)uStack_20,uStack_20._4_4_,(undefined4)uStack_28,
                               uStack_28._4_4_,puStack_3c);
          return uVar5;
        }
      }
    }
    else if (*(int *)(iVar3 + 0x45) == 0) {
      sVar4 = _memAlloc(&pvStack_30,0x221);
      if ((sVar4 != 0) && (pvStack_30 != (void *)0x0)) {
        uVar5 = *(undefined4 *)
                 (*(int *)(iVar3 + 0x5d) + 0x14 + iVar7 * 4 + param_1_00[0x15] * 0x53a);
        uVar5 = FUN_10044210((double)fStack_34,(double)fStack_38,
                             CONCAT31((int3)((uint)uVar5 >> 8),*(undefined *)(iVar3 + 0x14)),
                             (double)(*(float *)(iVar3 + 0xc) + (float)dStack_10),
                             (double)(*(float *)(iVar3 + 0x10) + (float)dStack_18),*param_1_00,
                             param_1_00[0x28],uVar5,
                             *(undefined4 *)
                              (*(int *)(iVar3 + 0x5d) + 0x14 + iStack_40 * 4 +
                              param_1_00[0x15] * 0x53a),param_1,param_2,uStack_48,uStack_44,
                             (undefined4)uStack_20,uStack_20._4_4_,(undefined4)uStack_28,
                             uStack_28._4_4_,puStack_3c);
        return uVar5;
      }
    }
    else {
      sVar4 = _memAlloc(&pvStack_30,499);
      if ((sVar4 != 0) && (pvStack_30 != (void *)0x0)) {
        uVar5 = *(undefined4 *)
                 (*(int *)(iVar3 + 0x5d) + 0x14 + iVar7 * 4 + param_1_00[0x15] * 0x53a);
        uVar5 = FUN_100442a0((double)fStack_34,(double)fStack_38,
                             CONCAT31((int3)((uint)uVar5 >> 8),*(undefined *)(iVar3 + 0x14)),
                             (double)(*(float *)(iVar3 + 0xc) + (float)dStack_10),
                             (double)(*(float *)(iVar3 + 0x10) + (float)dStack_18),*param_1_00,
                             param_1_00[0x28],uVar5,
                             *(undefined4 *)
                              (*(int *)(iVar3 + 0x5d) + 0x14 + iStack_40 * 4 +
                              param_1_00[0x15] * 0x53a),param_1,param_2,uStack_48,uStack_44,
                             (undefined4)uStack_20,uStack_20._4_4_,(undefined4)uStack_28,
                             uStack_28._4_4_,puStack_3c);
        return uVar5;
      }
    }
  }
  return 0;
}
