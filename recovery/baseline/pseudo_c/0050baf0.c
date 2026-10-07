/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050baf0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0050baf0(int param_1,int param_2,float param_3)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  int iVar5;
  float10 fVar6;
  float10 fVar7;
  float local_f0;
  undefined4 local_c8;
  undefined4 local_c4;
  float local_c0;
  undefined1 local_bc [8];
  float local_b4;
  float local_b0;
  float local_ac;
  float local_a8;
  undefined1 local_8c [8];
  float local_84;
  undefined4 local_7c;
  undefined4 local_78;
  undefined4 local_64;
  float local_58;
  float local_54;
  float local_50;
  
  fVar4 = _DAT_0074947c * param_3 * param_3;
  FUN_005f5960(&local_b0,(float)param_2 * _DAT_006f4098,
               *(undefined4 *)(param_1 + 0x14 + param_2 * 0x1c),0);
  local_c8 = local_7c;
  local_c4 = local_78;
  FUN_005f5ce0(&local_c8,local_bc,local_8c);
  fVar1 = *(float *)(DAT_00b8fac0 + param_2 * 4);
  fVar2 = *(float *)(DAT_00b8fabc + param_2 * 4) * param_3 * param_3;
  fVar6 = (float10)FUN_0050b4c0((fVar2 - _DAT_006f40b0 * local_84) -
                                _DAT_00749478 * param_3 * param_3,param_3);
  fVar7 = (float10)FUN_005100c0(local_64);
  fVar2 = (fVar2 - _DAT_006f40b0 * local_84) - _DAT_00749478 * param_3 * param_3;
  if (_DAT_00b8f258 < fVar2) {
    _DAT_00b8f258 = fVar2;
  }
  fVar3 = fVar2 * (float)(fVar7 * (float10)(float)fVar6);
  fVar1 = ABS(fVar1 * param_3 * param_3 - _DAT_006f40b0 * local_b4);
  local_f0 = _DAT_006f411c * fVar1;
  if (fVar1 < fVar3) {
    local_f0 = SQRT(_DAT_006e97d8 - (fVar1 / fVar3) * (fVar1 / fVar3)) * _DAT_0074946c * fVar3 +
               local_f0;
    local_f0 = local_f0 - (fVar4 + local_f0) * _DAT_0074ab70;
    fVar6 = (float10)FUN_0050a170((float)(fVar7 * (float10)(float)fVar6));
    if (fVar6 * (float10)fVar3 < (float10)local_f0) {
      local_f0 = (float)(fVar6 * (float10)fVar3);
    }
    fVar1 = -_DAT_006f40b0 * (_DAT_00b8f808 / param_3);
    if (fVar1 < local_f0) goto LAB_0050bd23;
  }
  fVar1 = local_f0;
LAB_0050bd23:
  local_f0 = fVar1;
  iVar5 = (param_2 + 1) % DAT_00b8faa0;
  FUN_005f5960(&local_58,(float)iVar5 * _DAT_006f4098,*(undefined4 *)(param_1 + 0x14 + iVar5 * 0x1c)
               ,0);
  fVar1 = (local_c0 + _DAT_006f4118) * _DAT_006f40b0;
  fVar6 = (float10)FUN_00579ef0(local_64);
  fVar7 = (float10)FUN_00579ee0(local_64);
  return (SQRT((float10)(local_58 - local_b0) * (float10)(local_58 - local_b0) +
               (float10)(local_54 - local_ac) * (float10)(local_54 - local_ac) +
               (float10)(local_50 - local_a8) * (float10)(local_50 - local_a8)) / (float10)param_3)
         * (((float10)(fVar1 + fVar4) -
            ((fVar7 + (float10)(float)(fVar6 * (float10)param_3 * (float10)param_3)) /
            (float10)_DAT_00749488) * (float10)fVar2) + (float10)local_f0) * (float10)_DAT_006efe48;
}


