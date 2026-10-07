/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005afd80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005afd80(int param_1)

{
  float fVar1;
  undefined4 uVar2;
  float fVar3;
  int iVar4;
  int iVar5;
  bool bVar6;
  float fVar7;
  int iVar8;
  float10 fVar9;
  float10 fVar10;
  float local_18;
  float local_14;
  float local_10;
  
  if (*(int *)(param_1 + 4) != 0) {
    iVar8 = *(int *)(param_1 + 4) + -4;
    uVar2 = *(undefined4 *)(*(int *)(param_1 + 0x5ae) + 0x3c);
    fVar3 = *(float *)(*(int *)(param_1 + 0x5ae) + 0x40);
    local_14 = 1.0;
    local_10 = 1.0;
    local_18 = 1.0;
    while (((iVar8 != param_1 && (_DAT_006ea4a4 < local_18)) &&
           (fVar9 = (float10)FUN_00516daa(uVar2,*(undefined4 *)(*(int *)(iVar8 + 0x5ae) + 0x3c)),
           fVar9 < (float10)_DAT_006f734c))) {
      iVar4 = *(int *)(iVar8 + 0x5ae);
      iVar5 = *(int *)(iVar8 + 0x58a);
      fVar10 = SQRT((float10)*(float *)(iVar4 + 0x14) * (float10)*(float *)(iVar4 + 0x14) +
                    (float10)*(float *)(iVar4 + 0x10) * (float10)*(float *)(iVar4 + 0x10) +
                    (float10)*(float *)(iVar4 + 0xc) * (float10)*(float *)(iVar4 + 0xc)) *
               (float10)*(float *)(iVar5 + 0xd4);
      if (fVar10 < (float10)_DAT_006ea514) {
        fVar10 = (float10)_DAT_006ea514;
      }
      fVar9 = ((float10)_DAT_006f7348 / fVar10) * fVar9;
      fVar1 = (float)fVar9;
      if ((float10)_DAT_006f734c < fVar9) break;
      fVar7 = ABS(fVar3 - *(float *)(iVar4 + 0x40));
      if (fVar7 < _DAT_006f5a64) {
        fVar9 = (float10)FUN_005b0230(fVar1,fVar7);
        fVar9 = fVar9 * (float10)*(float *)(iVar5 + 0xd0) * (float10)local_18;
        local_14 = (float)(((float10)_DAT_006e97d8 + fVar9) * (float10)local_14);
        fVar10 = SQRT((float10)fVar7 * (float10)fVar7 + (float10)fVar1 * (float10)fVar1);
        if ((float10)_DAT_006ea4cc < fVar10) {
          *(float *)(param_1 + 0x5a2) =
               (float)(((fVar9 * (float10)fVar1) /
                        (((float10)fVar1 * (float10)fVar1 * (float10)_DAT_006f688c +
                         (float10)_DAT_006e97d8) * fVar10) + (float10)_DAT_006e97d8) *
                      (float10)*(float *)(param_1 + 0x5a2));
        }
        local_18 = (fVar7 * _DAT_006f7344 + _DAT_006f4658) * local_18;
      }
      if (*(int *)(iVar8 + 4) == 0) {
        iVar8 = 0;
      }
      else {
        iVar8 = *(int *)(iVar8 + 4) + -4;
      }
    }
    local_18 = 1.0;
    if (*(int *)(param_1 + 8) == 0) {
      iVar8 = 0;
    }
    else {
      iVar8 = *(int *)(param_1 + 8) + -4;
    }
    while (((iVar8 != param_1 && (_DAT_006ea4a4 < local_18)) &&
           (fVar9 = (float10)FUN_00516daa(*(undefined4 *)(*(int *)(iVar8 + 0x5ae) + 0x3c),uVar2),
           fVar9 < (float10)_DAT_006f7340))) {
      iVar4 = *(int *)(iVar8 + 0x5ae);
      iVar5 = *(int *)(iVar8 + 0x58a);
      fVar10 = SQRT((float10)*(float *)(iVar4 + 0x14) * (float10)*(float *)(iVar4 + 0x14) +
                    (float10)*(float *)(iVar4 + 0x10) * (float10)*(float *)(iVar4 + 0x10) +
                    (float10)*(float *)(iVar4 + 0xc) * (float10)*(float *)(iVar4 + 0xc)) *
               (float10)*(float *)(iVar5 + 0xd4);
      if (fVar10 < (float10)_DAT_006ea514) {
        fVar10 = (float10)_DAT_006ea514;
      }
      fVar9 = ((float10)_DAT_006f7348 / fVar10) * fVar9;
      fVar1 = (float)fVar9;
      if ((float10)_DAT_006f7340 < fVar9) break;
      fVar7 = ABS(fVar3 - *(float *)(iVar4 + 0x40));
      if (fVar7 < _DAT_006f5a64) {
        fVar9 = (float10)FUN_005b0230(-fVar1,fVar7);
        fVar9 = fVar9 * (float10)*(float *)(iVar5 + 0xd0) * (float10)local_18;
        local_10 = (float)(((float10)_DAT_006e97d8 + fVar9) * (float10)local_10);
        fVar10 = SQRT((float10)fVar7 * (float10)fVar7 + (float10)fVar1 * (float10)fVar1);
        if ((float10)_DAT_006ea4cc < fVar10) {
          *(float *)(param_1 + 0x5a6) =
               (float)(((fVar9 * (float10)fVar1) /
                        (((float10)fVar1 * (float10)fVar1 * (float10)_DAT_006ea67c +
                         (float10)_DAT_006e97d8) * fVar10) + (float10)_DAT_006e97d8) *
                      (float10)*(float *)(param_1 + 0x5a6));
        }
        local_18 = (fVar7 * _DAT_006f7344 + _DAT_006f4658) * local_18;
      }
      if (*(int *)(iVar8 + 8) == 0) {
        iVar8 = 0;
      }
      else {
        iVar8 = *(int *)(iVar8 + 8) + -4;
      }
    }
    fVar3 = local_10;
    if (local_14 < local_10) {
      fVar3 = local_14;
    }
    if (local_10 < local_14) {
      local_10 = local_14;
    }
    fVar3 = (_DAT_006e97d8 - (_DAT_006e97d8 - local_10) * _DAT_006ef640) * fVar3;
    bVar6 = _DAT_006ea44c <= fVar3;
    *(float *)(param_1 + 0x59e) = fVar3;
    fVar1 = _DAT_006ea44c;
    if ((bVar6) && (fVar1 = fVar3, _DAT_006f4164 < fVar3)) {
      fVar1 = _DAT_006f4164;
    }
    *(float *)(param_1 + 0x59e) = fVar1;
    fVar3 = _DAT_006ea44c;
    if ((_DAT_006ea44c <= *(float *)(param_1 + 0x5a2)) &&
       (fVar3 = _DAT_006f4164, *(float *)(param_1 + 0x5a2) <= _DAT_006f4164)) {
      fVar3 = *(float *)(param_1 + 0x5a2);
    }
    *(float *)(param_1 + 0x5a2) = fVar3;
    if (*(float *)(param_1 + 0x5a6) < _DAT_006ea44c) {
      *(float *)(param_1 + 0x5a6) = _DAT_006ea44c;
      return;
    }
    if (_DAT_006f4164 < *(float *)(param_1 + 0x5a6)) {
      *(float *)(param_1 + 0x5a6) = _DAT_006f4164;
      return;
    }
    *(undefined4 *)(param_1 + 0x5a6) = *(undefined4 *)(param_1 + 0x5a6);
  }
  return;
}


