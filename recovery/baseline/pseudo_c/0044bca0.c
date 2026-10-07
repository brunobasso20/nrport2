/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0044bca0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_0044bca0(int param_1)

{
  float fVar1;
  double dVar2;
  char cVar3;
  ushort uVar4;
  ushort uVar5;
  uint uVar6;
  int iVar7;
  int *piVar8;
  undefined4 uVar9;
  float10 fVar10;
  char local_29;
  float fStack_28;
  float afStack_20 [2];
  undefined4 auStack_18 [2];
  undefined8 local_10;
  
  uVar6 = DAT_0089e3cc;
  if ((((DAT_0089e3cc != 7) || (uVar6 = DAT_0089e3e0, DAT_0089e3e0 == 0)) ||
      (*(int *)(DAT_0089e3e0 + 0x5ae) == 0)) || (uVar6 = thunk_FUN_0055a730(), 4 < (int)uVar6))
  goto LAB_0044bfd3;
  cVar3 = *(char *)(param_1 + 0x19);
  iVar7 = *(int *)(*(int *)(DAT_0089e3e0 + 0x5ae) + 0x50);
  if (((iVar7 == 5) || (iVar7 == 2)) || (local_29 = '\0', iVar7 == 4)) {
    local_29 = '\x01';
  }
  *(char *)(param_1 + 0x19) = local_29;
  fVar10 = (float10)thunk_FUN_0055a760();
  local_10 = (double)fVar10;
  fVar1 = *(float *)(*(int *)(DAT_0089e3e0 + 0x5ae) + 0x44);
  uVar4 = (ushort)(fVar1 < (float)_DAT_006ef738);
  uVar5 = (ushort)(fVar1 == (float)_DAT_006ef738);
  uVar6 = (uint)(ushort)(uVar4 << 8 | uVar5 << 0xe);
  if (uVar4 != 0 || uVar5 != 0) goto LAB_0044bfd3;
  if (cVar3 == '\0') {
    if (local_29 != '\0') {
      iVar7 = FUN_00538b30();
      if ((*(byte *)(iVar7 + 0x2d) & 2) != 0) {
        uVar6 = FUN_00450ec0(0xc,0xac,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
        return uVar6 & 0xffffff00;
      }
      goto LAB_0044bd79;
    }
LAB_0044bd81:
    if (_DAT_006ecfd0 < local_10 - *(double *)(param_1 + 0x1a)) {
      if (DAT_0089e3dc == 0) {
LAB_0044bdc2:
        iVar7 = FUN_00538b30();
        if ((*(byte *)(iVar7 + 0x2d) & 2) == 0) goto LAB_0044becb;
      }
      else {
        uVar9 = *(undefined4 *)(DAT_0089e3dc + 0x5b2);
        piVar8 = (int *)FUN_00538b00();
        (**(code **)(*piVar8 + 0x30))(uVar9);
        iVar7 = FUN_005443c0(uVar9);
        if (-1 < iVar7) goto LAB_0044bdc2;
      }
      fVar10 = (float10)FUN_00516e1a();
      afStack_20[0] = (float)fVar10;
      auStack_18[0] = 0;
      uVar9 = FUN_00536180(0x7fffffff,auStack_18);
      iVar7 = FUN_00536260(uVar9);
      fStack_28 = *(float *)(iVar7 + 0xb);
      if (*(float *)(iVar7 + 0xb) < *(float *)(iVar7 + 0xf)) {
        fStack_28 = afStack_20[0] - _DAT_006e97d8;
      }
      fVar1 = *(float *)(*(int *)(DAT_0089e3e0 + 0x5ae) + 0x3c);
      fVar10 = (float10)FUN_00450930(DAT_0089e3e0,0x41000000);
      fVar10 = fVar10 + (float10)fVar1;
      if ((float10)afStack_20[0] < fVar10) {
        fVar10 = fVar10 - (float10)afStack_20[0];
      }
      if (fVar10 <= (float10)fVar1) {
        if (fVar1 < fStack_28) goto LAB_0044be9d;
      }
      else if (fStack_28 <= fVar1) goto LAB_0044becb;
      if ((float10)fStack_28 < fVar10) {
LAB_0044be9d:
        FUN_00450ec0(0xc,0xd,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
        *(uint *)(param_1 + 0x1e) = local_10._4_4_;
        *(undefined4 *)(param_1 + 0x1a) = (undefined4)local_10;
        return local_10._4_4_ & 0xffffff00;
      }
    }
  }
  else {
LAB_0044bd79:
    if (local_29 == '\0') goto LAB_0044bd81;
  }
LAB_0044becb:
  iVar7 = FUN_004507f0(DAT_0089e3d8);
  if ((((char)iVar7 != '\0') && (local_29 == '\0')) &&
     ((iVar7 = thunk_FUN_0055a730(), iVar7 != 3 &&
      ((iVar7 = FUN_00450e40((double)*(float *)(*(int *)(DAT_0089e3e0 + 0x5ae) + 0x3c),afStack_20,
                             auStack_18), iVar7 != -2 && (iVar7 != *(int *)(param_1 + 0x22))))))) {
    *(int *)(param_1 + 0x22) = iVar7;
    uVar6 = FUN_00450ec0(0xc,0xad,iVar7,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
    return uVar6 & 0xffffff00;
  }
  if (DAT_00bf39f4 == '\0') {
    uVar6 = CONCAT31((int3)((uint)iVar7 >> 8),*(char *)(param_1 + 0x36));
    if ((*(char *)(param_1 + 0x36) != '\0') &&
       (uVar4 = (ushort)(local_10 < *(double *)(param_1 + 0x2e)),
       uVar5 = (ushort)(local_10 == *(double *)(param_1 + 0x2e)),
       uVar6 = (uint)(ushort)(uVar4 << 8 | uVar5 << 0xe), uVar4 == 0 && uVar5 == 0)) {
      iVar7 = FUN_00450140(0xf);
      if (iVar7 == 1) {
        iVar7 = 0;
      }
      uVar6 = FUN_00450ec0(0xc,iVar7 + 0x83,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
      DAT_00d8c304 = 1;
      *(undefined1 *)(param_1 + 0x36) = 0;
    }
  }
  else {
    dVar2 = *(double *)(param_1 + 0x26);
    DAT_00bf39f4 = '\0';
    uVar6 = (uint)(ushort)((ushort)(local_10 < dVar2) << 8 | (ushort)(local_10 == dVar2) << 0xe);
    if (local_10 >= dVar2 && (local_10 == dVar2) == 0) {
      dVar2 = local_10 + _DAT_006ed6b8;
      *(undefined1 *)(param_1 + 0x36) = 1;
      *(double *)(param_1 + 0x26) = dVar2;
      *(double *)(param_1 + 0x2e) = local_10 + _DAT_006e9830;
      return uVar6;
    }
  }
LAB_0044bfd3:
  return uVar6 & 0xffffff00;
}


