/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052a960 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_0052a960(float param_1,int param_2)

{
  float fVar1;
  int *piVar2;
  uint uVar3;
  float fVar4;
  ushort uVar5;
  float10 fVar6;
  float10 fVar7;
  
  fVar6 = (float10)FUN_00516d3a(*(undefined4 *)((int)param_1 + 0x186a),
                                *(undefined4 *)(param_2 + 0x186a));
  fVar1 = (float)(((float10)*(float *)((int)param_1 + 0x1ac2) +
                  (float10)*(float *)(param_2 + 0x1ac2)) * fVar6 * (float10)_DAT_006ea44c -
                 (float10)_DAT_006ea448);
  if (*(char *)((int)param_1 + 0x59b) == '\0') {
    fVar6 = (float10)FUN_00527560(param_1,*(undefined4 *)(param_2 + 0x186e));
    fVar7 = (float10)FUN_00527970(param_1);
    fVar7 = fVar7 * (float10)(float)fVar6;
  }
  else {
    piVar2 = *(int **)((int)param_1 + 0x13b3);
    (**(code **)(*piVar2 + 0x20))(param_1,*(undefined4 *)(param_2 + 0x186e));
    fVar7 = (float10)(**(code **)(*piVar2 + 0x34))(param_1);
    fVar7 = fVar7 * (float10)param_1;
  }
  if (_DAT_006ea448 <= fVar1) {
    if (_DAT_006f516c <= *(float *)((int)param_1 + 0x1872)) {
      fVar6 = (float10)_DAT_006ea470 / (float10)*(float *)((int)param_1 + 0x1872);
    }
    else {
      fVar6 = (float10)_DAT_006f5168;
    }
    fVar6 = ((float10)fVar1 - (float10)_DAT_006ea448) * fVar6;
    if ((float10)_DAT_006e97d8 < fVar6) {
      fVar6 = (float10)_DAT_006e97d8;
    }
  }
  else {
    fVar6 = (float10)_DAT_006ea454;
  }
  fVar6 = (fVar6 * fVar7 +
          ((float10)_DAT_006e97d8 - fVar6) * (float10)*(float *)((int)param_1 + 0x1872)) -
          (float10)*(float *)(param_2 + 0x1872);
  if ((float10)_DAT_006ea454 <= fVar6) {
    if (fVar6 < (float10)_DAT_006f517c) {
      fVar6 = (float10)_DAT_006f517c;
    }
  }
  else if ((float10)_DAT_006f5180 < fVar6) {
    fVar6 = (float10)_DAT_006f5180;
  }
  fVar1 = (float)(((float10)_DAT_006f5178 / fVar6) * (float10)fVar1);
  uVar3 = (uint)(ushort)((ushort)(fVar1 < _DAT_006ea454) << 8 |
                        (ushort)(fVar1 == _DAT_006ea454) << 0xe);
  if (fVar1 >= _DAT_006ea454 && (fVar1 == _DAT_006ea454) == 0) {
    uVar3 = (uint)(ushort)((ushort)(fVar1 < _DAT_006e97d8) << 8 |
                           (ushort)(NAN(fVar1) || NAN(_DAT_006e97d8)) << 10 |
                          (ushort)(fVar1 == _DAT_006e97d8) << 0xe);
    if (fVar1 < _DAT_006e97d8) {
      fVar4 = ABS(*(float *)((int)param_1 + 0x1886) - *(float *)(param_2 + 0x1886));
      fVar1 = (_DAT_006e97d8 - fVar1) * _DAT_006ef678;
      uVar5 = (ushort)(fVar1 < fVar4) << 8 | (ushort)(fVar1 == fVar4) << 0xe;
      uVar3 = (uint)uVar5;
      if (fVar1 >= fVar4 && (fVar1 == fVar4) == 0) {
        return CONCAT31((uint3)(byte)(uVar5 >> 8),1);
      }
    }
  }
  return uVar3;
}


