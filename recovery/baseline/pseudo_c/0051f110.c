/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051f110 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0051f110(float param_1)

{
  float fVar1;
  float fVar2;
  int iVar3;
  float fVar4;
  float fVar5;
  float unaff_ESI;
  float10 fVar6;
  float10 fVar7;
  float10 fVar8;
  float10 extraout_ST1;
  float local_14 [2];
  float fStack_c;
  undefined1 local_8 [8];
  
  (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x28))();
  fVar1 = *(float *)((int)param_1 + 0x1872);
  fVar4 = *(float *)((int)param_1 + 0x1872) * *(float *)((int)param_1 + 0x1872) * (float)local_14;
  local_14[0] = unaff_ESI - *(float *)((int)param_1 + 0x1886);
  fStack_c = local_14[0];
  if (param_1 == DAT_00760b38) {
    fVar6 = (float10)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x44))();
  }
  else {
    (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x44))(param_1);
    fVar6 = (float10)FUN_006c5c40();
    fVar6 = ((float10)fVar4 * (float10)_DAT_006f49c0 + fVar6) * extraout_ST1;
  }
  iVar3 = *(int *)(*(int *)((int)param_1 + 0x13b3) + 8);
  fVar2 = (float)((float10)_DAT_006e97d8 / fVar6);
  fVar6 = (float10)_DAT_00bcf854 * (float10)fVar2 * (float10)fVar2;
  fVar7 = (float10)_DAT_00bcf850 * (float10)fVar2;
  if ((iVar3 == 0) || (iVar3 == 1)) {
    if (((_DAT_006ea454 < *(float *)((int)param_1 + 0x188a)) && (unaff_ESI < _DAT_006ea454)) ||
       ((*(float *)((int)param_1 + 0x188a) < _DAT_006ea454 && (_DAT_006ea454 < unaff_ESI)))) {
      fVar7 = fVar7 + fVar7;
    }
    if (param_1 != DAT_00760b38) {
      fVar2 = ABS(param_1 - *(float *)((int)param_1 + 0x188a));
      fVar5 = fVar4 * _DAT_006e9804 + _DAT_006ea488 * fVar2;
      if (fVar5 <= _DAT_006ea514) {
        fVar8 = (float10)fVar5;
        if (fVar5 < _DAT_006e97d8) {
          fVar8 = (float10)_DAT_006e97d8;
        }
      }
      else {
        fVar8 = (float10)_DAT_006ea514;
      }
      fVar6 = fVar8 * fVar6;
      fVar4 = (_DAT_006ea4a0 - fVar4) + (_DAT_006ea4a0 - fVar4) + _DAT_006e97d8;
      if (fVar4 < _DAT_006e97d8) {
        fVar4 = _DAT_006e97d8;
      }
      fVar4 = fVar2 * fVar4 * _DAT_006ea488;
      if (fVar4 <= _DAT_006ea478) {
        fVar8 = (float10)fVar4;
        if (fVar4 < _DAT_006e97d8) {
          fVar8 = (float10)_DAT_006e97d8;
        }
      }
      else {
        fVar8 = (float10)_DAT_006ea478;
      }
      fVar7 = fVar8 * fVar7;
    }
  }
  fVar6 = fVar6 * (float10)unaff_ESI +
          ((float10)param_1 - (float10)*(float *)((int)param_1 + 0x188a)) * fVar7;
  *(float *)((int)param_1 + 0x1892) = (float)fVar6;
  return fVar6 + (float10)((float)local_8 * fVar1);
}


