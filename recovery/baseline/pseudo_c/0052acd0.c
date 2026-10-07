/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052acd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0052acd0(float param_1,float param_2,float param_3,float param_4,float param_5,
                    float param_6,float param_7,float param_8,float param_9,undefined4 param_10,
                    undefined4 param_11_00,char param_11)

{
  float fVar1;
  float fVar2;
  float fVar3;
  char cVar4;
  float fVar5;
  float10 fVar6;
  float10 fVar7;
  float unaff_retaddr;
  
  fVar3 = param_1;
  if ((*(uint *)((int)param_1 + 0x139f) & 0x400) != 0) {
    fVar6 = (float10)FUN_00516e1a();
    fVar1 = (float)((float10)*(float *)((int)param_1 + 0x186a) / fVar6);
    cVar4 = FUN_00535490(param_1);
    param_1 = fVar1;
    if (cVar4 != '\0') {
      param_3 = (fVar1 * _DAT_006ea44c + _DAT_006e97d8) * param_3;
    }
  }
  if (param_11 == '\0') {
    fVar1 = *(float *)((int)fVar3 + 0x1872) - *(float *)((int)param_2 + 0x1872);
  }
  else {
    fVar6 = (float10)FUN_00516f1a(*(undefined4 *)((int)param_2 + 0x1866));
    fVar1 = (float)fVar6;
    fVar2 = _DAT_006e97d8;
    if ((fVar6 != (float10)_DAT_006ea454) &&
       (fVar5 = fVar1 - *(float *)((int)fVar3 + 0x1886), fVar2 = _DAT_006ea478,
       _DAT_006ea4cc < fVar5 / fVar1)) {
      fVar2 = fVar1 / fVar5;
    }
    fVar2 = *(float *)((int)param_2 + 0x1abe) / fVar2;
    param_4 = param_4 * fVar2;
    fVar1 = *(float *)((int)fVar3 + 0x1872) - fVar2 * *(float *)((int)param_2 + 0x1872);
  }
  fVar6 = (float10)(**(code **)(**(int **)((int)fVar3 + 0x13b3) + 0x3c))
                             (fVar3,*(undefined4 *)((int)param_2 + 0x186a));
  fVar7 = (float10)FUN_00516d3a(*(undefined4 *)((int)fVar3 + 0x186a),
                                *(undefined4 *)((int)param_2 + 0x186a));
  fVar5 = ABS((float)fVar7);
  fVar2 = _DAT_006ea454;
  if ((_DAT_006ecfc8 <= fVar5) && (fVar2 = _DAT_006e97d8, fVar5 < _DAT_006f51a4)) {
    fVar2 = (fVar5 - _DAT_006ecfc8) * _DAT_006f51a0;
  }
  fVar2 = (fVar2 * (float)fVar6 +
          (_DAT_006e97d8 - fVar2) *
          (*(float *)((int)fVar3 + 0x1ac2) + *(float *)((int)param_2 + 0x1ac2)) * (float)fVar7 *
          _DAT_006ea44c) - param_1;
  if (_DAT_006ea454 <= fVar2) {
    if (fVar2 < _DAT_006ea478) {
      fVar6 = ((float10)fVar1 / (float10)param_4) * ((float10)param_4 - (float10)fVar2) +
              ((float10)param_5 * (float10)_DAT_006e9818 * (float10)fVar2 -
              (float10)param_6 * (float10)_DAT_006f519c * (float10)unaff_retaddr);
    }
    else {
      if (unaff_retaddr < _DAT_006ea454) {
        fVar6 = (float10)_DAT_006ea498;
        goto LAB_0052b047;
      }
      fVar6 = -(((float10)unaff_retaddr * (float10)unaff_retaddr) /
               ((float10)fVar2 + (float10)fVar2));
      if (fVar2 < param_4) {
        fVar6 = ((float10)fVar1 / (float10)param_4) * ((float10)param_4 - (float10)fVar2) + fVar6;
      }
      if ((float10)param_3 < fVar6) {
        if ((float10)param_3 + (float10)_DAT_006f5198 < fVar6) {
          fVar6 = (float10)_DAT_006ea498;
          goto LAB_0052b047;
        }
        fVar6 = (fVar6 - ((float10)param_3 + (float10)_DAT_006f5198)) * (float10)param_3 *
                (float10)_DAT_006f5194;
      }
    }
  }
  else {
    fVar6 = (float10)_DAT_006ea448 - (float10)param_1;
    if ((float10)_DAT_006e9820 < fVar6) {
      fVar6 = (float10)_DAT_006e9820;
    }
    fVar6 = (float10)fVar2 / fVar6;
    if (fVar6 <= (float10)_DAT_006e97d8) {
      param_2 = (float)(fVar6 * (float10)*(float *)((int)param_2 + 0x1876) +
                       ((float10)_DAT_006e97d8 - fVar6) * (float10)fVar1);
    }
    else {
      param_2 = *(float *)((int)param_2 + 0x1876);
      fVar6 = (float10)_DAT_006e97d8;
    }
    if (param_2 < _DAT_006ea454) {
      fVar6 = ((float10)_DAT_006e97d8 - (float10)param_2 * (float10)_DAT_006f49b0) * fVar6;
    }
    fVar6 = fVar6 * fVar6 + (float10)_DAT_006e97d8;
    fVar6 = (float10)param_2 * (float10)param_9 +
            ((float10)param_7 * fVar6 * (float10)_DAT_006e9818 * (float10)fVar2 -
            fVar6 * (float10)param_8 * (float10)_DAT_006f519c * (float10)unaff_retaddr);
  }
  if (fVar6 < (float10)_DAT_006f5190) {
    fVar6 = (float10)FUN_006c5c40();
    fVar6 = fVar6 * (float10)_DAT_006f518c - (float10)_DAT_006f5188;
  }
LAB_0052b047:
  if (fVar6 + (float10)*(float *)((int)fVar3 + 0x1872) < (float10)_DAT_006ea454) {
    fVar6 = -(float10)*(float *)((int)fVar3 + 0x1872);
  }
  return fVar6;
}


