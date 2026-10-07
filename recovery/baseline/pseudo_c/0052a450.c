/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052a450 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_0052a450(int param_1,float param_2,float *param_3,float *param_4)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  int *piVar7;
  float fVar8;
  float fVar9;
  int iVar10;
  int iVar11;
  float10 fVar12;
  float10 fVar13;
  float10 extraout_ST1;
  
  fVar5 = param_2;
  if (param_3 == (float *)0x0) {
    fVar12 = (float10)FUN_00516d3a(*(undefined4 *)((int)param_2 + 0x186a),
                                   *(undefined4 *)(param_1 + 0x186a));
  }
  else {
    fVar12 = (float10)*param_3;
  }
  fVar1 = (float)(fVar12 - (float10)_DAT_006f5170);
  if (*(char *)((int)param_2 + 0x59b) == '\0') {
    fVar12 = (float10)FUN_00527560(param_2,*(undefined4 *)(param_1 + 0x186e));
    fVar13 = (float10)FUN_00527970(param_2);
    iVar11 = *(int *)((int)param_2 + 0x186e);
    iVar10 = FUN_00527b10(param_2);
    param_2 = (float)(fVar13 * (float10)(float)fVar12);
  }
  else {
    piVar7 = *(int **)((int)param_2 + 0x13b3);
    (**(code **)(*piVar7 + 0x20))();
    (**(code **)(*piVar7 + 0x34))(param_2);
    iVar11 = *(int *)((int)param_2 + 0x186e);
    iVar10 = (**(code **)(**(int **)((int)param_2 + 0x13b3) + 0x4c))(param_2);
  }
  fVar2 = *(float *)(*(int *)(iVar10 + 0xc) + 0x10 + iVar11 * 0x1c);
  fVar3 = *(float *)((int)fVar5 + 0x1872);
  fVar4 = *(float *)((int)fVar5 + 0x1872);
  fVar8 = _DAT_006ea454;
  if (_DAT_006ea448 <= fVar1) {
    fVar8 = _DAT_006f5168;
    if (_DAT_006f516c <= *(float *)((int)fVar5 + 0x1872)) {
      fVar8 = _DAT_006ea470 / *(float *)((int)fVar5 + 0x1872);
    }
    fVar8 = (fVar1 - _DAT_006ea448) * fVar8;
    if (_DAT_006e97d8 < fVar8) {
      fVar8 = _DAT_006e97d8;
    }
  }
  fVar9 = _DAT_006e97d8 - fVar8;
  fVar5 = *(float *)((int)fVar5 + 0x1872);
  fVar6 = *(float *)(param_1 + 0x1872);
  FUN_006c5c40();
  fVar12 = (float10)FUN_006c5c40();
  fVar12 = ((float10)fVar1 /
           (((float10)ABS(fVar2 * fVar3 * fVar4) * (float10)_DAT_006f5158 + (float10)_DAT_006e97d8)
            * fVar12 * extraout_ST1 * (float10)_DAT_006ea50c)) * (float10)_DAT_006f5154;
  if (param_4 != (float *)0x0) {
    *param_4 = (float)fVar12;
  }
  if ((_DAT_006ea454 <= (fVar8 * param_2 + fVar9 * fVar5) - fVar6) &&
     (fVar12 <= (float10)_DAT_006e97d8)) {
    return 0;
  }
  return 1;
}


