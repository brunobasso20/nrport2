/* NR2003.exe @ 005afd80 FUN_005afd80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005afd80(int param_1)

{
  float fVar1;
  undefined4 uVar2;
  float fVar3;
  int iVar4;
  int iVar5;
  bool bVar6;
  bool bVar7;
  float fVar8;
  int iVar9;
  float10 fVar10;
  float10 fVar11;
  float local_18;
  float local_14;
  float local_10;
  
  if (*(int *)(param_1 + 4) != 0) {
    iVar9 = *(int *)(param_1 + 4) + -4;
    uVar2 = *(undefined4 *)(*(int *)(param_1 + 0x5ae) + 0x3c);
    fVar3 = *(float *)(*(int *)(param_1 + 0x5ae) + 0x40);
    local_14 = 1.0;
    local_10 = 1.0;
    local_18 = 1.0;
    while (((iVar9 != param_1 && (_DAT_006ea4a4 < local_18)) &&
           (fVar10 = (float10)FUN_00516daa(uVar2,*(undefined4 *)(*(int *)(iVar9 + 0x5ae) + 0x3c)),
           fVar10 < (float10)_DAT_006f734c != (NAN(fVar10) || NAN((float10)_DAT_006f734c))))) {
      iVar4 = *(int *)(iVar9 + 0x5ae);
      iVar5 = *(int *)(iVar9 + 0x58a);
      fVar11 = SQRT((float10)*(float *)(iVar4 + 0x14) * (float10)*(float *)(iVar4 + 0x14) +
                    (float10)*(float *)(iVar4 + 0x10) * (float10)*(float *)(iVar4 + 0x10) +
                    (float10)*(float *)(iVar4 + 0xc) * (float10)*(float *)(iVar4 + 0xc)) *
               (float10)*(float *)(iVar5 + 0xd4);
      if (fVar11 < (float10)_DAT_006ea514 != (NAN(fVar11) || NAN((float10)_DAT_006ea514))) {
        fVar11 = (float10)_DAT_006ea514;
      }
      fVar10 = ((float10)_DAT_006f7348 / fVar11) * fVar10;
      fVar1 = (float)fVar10;
      if ((float10)_DAT_006f734c < fVar10) break;
      fVar8 = (float)((uint)(fVar3 - *(float *)(iVar4 + 0x40)) & 0x7fffffff);
      if (fVar8 < _DAT_006f5a64 != (NAN(fVar8) || NAN(_DAT_006f5a64))) {
        fVar10 = (float10)FUN_005b0230(fVar1,fVar8);
        fVar10 = fVar10 * (float10)*(float *)(iVar5 + 0xd0) * (float10)local_18;
        local_14 = (float)(((float10)_DAT_006e97d8 + fVar10) * (float10)local_14);
        fVar11 = SQRT((float10)fVar8 * (float10)fVar8 + (float10)fVar1 * (float10)fVar1);
        if ((float10)_DAT_006ea4cc < fVar11) {
          *(float *)(param_1 + 0x5a2) =
               (float)(((fVar10 * (float10)fVar1) /
                        (((float10)fVar1 * (float10)fVar1 * (float10)_DAT_006f688c +
                         (float10)_DAT_006e97d8) * fVar11) + (float10)_DAT_006e97d8) *
                      (float10)*(float *)(param_1 + 0x5a2));
        }
        local_18 = (fVar8 * _DAT_006f7344 + _DAT_006f4658) * local_18;
      }
      if (*(int *)(iVar9 + 4) == 0) {
        iVar9 = 0;
      }
      else {
        iVar9 = *(int *)(iVar9 + 4) + -4;
      }
    }
    local_18 = 1.0;
    if (*(int *)(param_1 + 8) == 0) {
      iVar9 = 0;
    }
    else {
      iVar9 = *(int *)(param_1 + 8) + -4;
    }
    while (((iVar9 != param_1 && (_DAT_006ea4a4 < local_18)) &&
           (fVar10 = (float10)FUN_00516daa(*(undefined4 *)(*(int *)(iVar9 + 0x5ae) + 0x3c),uVar2),
           fVar10 < (float10)_DAT_006f7340 != (NAN(fVar10) || NAN((float10)_DAT_006f7340))))) {
      iVar4 = *(int *)(iVar9 + 0x5ae);
      iVar5 = *(int *)(iVar9 + 0x58a);
      fVar11 = SQRT((float10)*(float *)(iVar4 + 0x14) * (float10)*(float *)(iVar4 + 0x14) +
                    (float10)*(float *)(iVar4 + 0x10) * (float10)*(float *)(iVar4 + 0x10) +
                    (float10)*(float *)(iVar4 + 0xc) * (float10)*(float *)(iVar4 + 0xc)) *
               (float10)*(float *)(iVar5 + 0xd4);
      if (fVar11 < (float10)_DAT_006ea514 != (NAN(fVar11) || NAN((float10)_DAT_006ea514))) {
        fVar11 = (float10)_DAT_006ea514;
      }
      fVar10 = ((float10)_DAT_006f7348 / fVar11) * fVar10;
      fVar1 = (float)fVar10;
      if ((float10)_DAT_006f7340 < fVar10) break;
      fVar8 = (float)((uint)(fVar3 - *(float *)(iVar4 + 0x40)) & 0x7fffffff);
      if (fVar8 < _DAT_006f5a64 != (NAN(fVar8) || NAN(_DAT_006f5a64))) {
        fVar10 = (float10)FUN_005b0230(-fVar1,fVar8);
        fVar10 = fVar10 * (float10)*(float *)(iVar5 + 0xd0) * (float10)local_18;
        local_10 = (float)(((float10)_DAT_006e97d8 + fVar10) * (float10)local_10);
        fVar11 = SQRT((float10)fVar8 * (float10)fVar8 + (float10)fVar1 * (float10)fVar1);
        if ((float10)_DAT_006ea4cc < fVar11) {
          *(float *)(param_1 + 0x5a6) =
               (float)(((fVar10 * (float10)fVar1) /
                        (((float10)fVar1 * (float10)fVar1 * (float10)_DAT_006ea67c +
                         (float10)_DAT_006e97d8) * fVar11) + (float10)_DAT_006e97d8) *
                      (float10)*(float *)(param_1 + 0x5a6));
        }
        local_18 = (fVar8 * _DAT_006f7344 + _DAT_006f4658) * local_18;
      }
      if (*(int *)(iVar9 + 8) == 0) {
        iVar9 = 0;
      }
      else {
        iVar9 = *(int *)(iVar9 + 8) + -4;
      }
    }
    fVar3 = local_10;
    if (local_14 < local_10 != (NAN(local_14) || NAN(local_10))) {
      fVar3 = local_14;
    }
    if (local_10 < local_14) {
      local_10 = local_14;
    }
    fVar3 = (_DAT_006e97d8 - (_DAT_006e97d8 - local_10) * _DAT_006ef640) * fVar3;
    bVar6 = NAN(_DAT_006ea44c);
    bVar7 = fVar3 < _DAT_006ea44c;
    *(float *)(param_1 + 0x59e) = fVar3;
    fVar1 = _DAT_006ea44c;
    if ((bVar7 == (NAN(fVar3) || bVar6)) && (fVar1 = fVar3, _DAT_006f4164 < fVar3)) {
      fVar1 = _DAT_006f4164;
    }
    *(float *)(param_1 + 0x59e) = fVar1;
    fVar3 = _DAT_006ea44c;
    if ((*(float *)(param_1 + 0x5a2) < _DAT_006ea44c ==
         (NAN(*(float *)(param_1 + 0x5a2)) || NAN(_DAT_006ea44c))) &&
       (fVar3 = _DAT_006f4164, *(float *)(param_1 + 0x5a2) <= _DAT_006f4164)) {
      fVar3 = *(float *)(param_1 + 0x5a2);
    }
    *(float *)(param_1 + 0x5a2) = fVar3;
    if (*(float *)(param_1 + 0x5a6) < _DAT_006ea44c !=
        (NAN(*(float *)(param_1 + 0x5a6)) || NAN(_DAT_006ea44c))) {
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

