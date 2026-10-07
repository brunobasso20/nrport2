/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00549290 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_00549290(float param_1,float param_2,float param_3,undefined4 *param_4,float param_5)

{
  int iVar1;
  bool bVar2;
  int iVar3;
  uint uVar4;
  int iVar5;
  int iVar6;
  undefined4 uVar7;
  undefined3 uVar8;
  undefined3 extraout_var;
  int *piVar9;
  float10 fVar10;
  double dVar11;
  char local_9;
  int local_8;
  float local_4;
  
  local_9 = '\0';
  bVar2 = inBackground();
  iVar1 = (int)param_1;
  if (bVar2) {
    iVar3 = FUN_00562f70();
    local_8 = *(int *)(iVar3 + 0x5ae);
  }
  else {
    iVar3 = FUN_004f5970(param_1);
    local_8 = *(int *)(iVar3 + 0x5ae);
  }
  if (local_8 == 0) {
    return 0;
  }
  bVar2 = inServer();
  if ((bVar2) && (uVar4 = FUN_004f5970(iVar1), *(int *)(uVar4 + 0x596) == 0)) {
    return uVar4 & 0xffffff00;
  }
  bVar2 = inBackground();
  if ((bVar2) && (uVar4 = FUN_00562f70(iVar1), *(int *)(uVar4 + 0x596) == 0)) {
    return uVar4 & 0xffffff00;
  }
  iVar3 = (int)param_3;
  fVar10 = (float10)FUN_00579e50(*(undefined4 *)((int)param_3 + 0xc));
  param_1 = (float)fVar10;
  *(bool *)param_5 = _DAT_006f5854 < *(float *)(iVar3 + 4);
  iVar5 = FUN_0055ab00();
  if ((((iVar5 == iVar1) && (*(int *)(iVar3 + 0x54) != 0)) &&
      (iVar5 = FUN_00562f70(*(undefined4 *)(*(int *)(iVar3 + 0x54) + 0x1a4)), iVar5 != 0)) &&
     (iVar5 = FUN_00562f70(*(undefined4 *)(*(int *)(iVar3 + 0x54) + 0x1a4)),
     *(int *)(iVar5 + 0x596) == 0)) {
    DAT_00bf39f4 = 1;
  }
  if (_DAT_00bef700 == _DAT_006ea454) {
    return (uint)(ushort)((ushort)(_DAT_00bef700 < _DAT_006ea454) << 8 |
                          (ushort)(NAN(_DAT_00bef700) || NAN(_DAT_006ea454)) << 10 |
                         (ushort)(_DAT_00bef700 == _DAT_006ea454) << 0xe);
  }
  param_5 = _DAT_00bef700 * *(float *)(iVar3 + 4) * param_1 * _DAT_006ea44c;
  if (param_5 < _DAT_006f5854) {
    return (uint)(ushort)((ushort)(param_5 < _DAT_006f5854) << 8 |
                          (ushort)(NAN(param_5) || NAN(_DAT_006f5854)) << 10 |
                         (ushort)(param_5 == _DAT_006f5854) << 0xe);
  }
  iVar6 = FUN_0055ab00();
  iVar5 = (int)param_2;
  if (iVar1 == iVar6) {
    local_4 = (float)DAT_00c7e75c;
  }
  else {
    local_4 = (float)(&DAT_00883500)[iVar1];
  }
  iVar6 = -1;
  if (_DAT_006f5854 < param_5) {
    if ((*(int *)(iVar3 + 0x54) == 0) || (*(int *)(*(int *)(iVar3 + 0x54) + 0x1a4) != iVar1)) {
      iVar6 = FUN_0054a710(iVar1,iVar3 + 0x1c);
    }
    else {
      iVar6 = FUN_0054a710(iVar1,iVar3 + 0x28);
    }
    if (iVar6 == -1) {
      return 0xffffff00;
    }
    param_1 = (float)((uint)param_1 & 0xffffff00);
    param_2 = (float)iVar6;
    FUN_00549860(iVar1,iVar5,iVar3,local_4,local_8,iVar6,param_5,&local_9,&param_1);
    iVar3 = 0;
    piVar9 = (int *)(&DAT_006f5660 + iVar6 * 8);
    do {
      iVar6 = (int)param_2;
      if (*piVar9 == -1) break;
      FUN_00549860(iVar1,iVar5,param_3,local_4,local_8,*piVar9,param_5 * (float)piVar9[1],&local_9,
                   &param_1);
      iVar3 = iVar3 + 1;
      piVar9 = piVar9 + 2;
      iVar6 = (int)param_2;
    } while (iVar3 < 1);
  }
  local_4 = param_5;
  param_3 = param_5;
  if (iVar6 != -1) {
    local_4 = param_5 * *(float *)(&DAT_006f5518 + iVar6 * 0x20);
    param_3 = param_5 * *(float *)(&DAT_006f551c + iVar6 * 0x20);
  }
  param_2 = local_4;
  if (_DAT_006efb30 < local_4) {
    param_1 = *(float *)(iVar5 + 0x58);
    param_5 = (local_4 - _DAT_006efb30) * _DAT_006f5850;
    dVar11 = rndUniform(0);
    param_1 = param_5 * _DAT_006ed6c8 + (float)dVar11 * param_5 * _DAT_006ea44c + param_1;
    if (_DAT_006e97d8 < param_1) {
      param_1 = 1.0;
    }
    FUN_0054b5a0(param_1);
    local_9 = '\x01';
  }
  if (_DAT_006f584c < param_3) {
    param_1 = *(float *)(iVar5 + 0x54);
    param_5 = (param_3 - _DAT_006f584c) * _DAT_006f5848;
    dVar11 = rndUniform(0);
    if (dVar11 <= (double)param_5) {
      param_1 = param_5 + _DAT_006ea50c + param_1;
      if (_DAT_006e97d8 < param_1) {
        param_1 = 1.0;
      }
      FUN_0054b800(param_1);
      local_9 = '\x01';
    }
    if ((_DAT_006f5844 < param_3) &&
       (((*(byte *)(iVar5 + 0xf) & 1) == 0 || (*(float *)(iVar5 + 0x54) == _DAT_006ea454)))) {
      param_3 = (param_3 - _DAT_006f5844) * _DAT_006f5840;
      if (param_1 < _DAT_006ea454 != (param_1 == _DAT_006ea454)) {
        param_3 = param_3 * _DAT_006ea44c;
      }
      if (_DAT_006ed6c8 < param_3) {
        param_3 = 0.75;
      }
      dVar11 = rndUniform(0);
      if (dVar11 < (double)param_3) {
        dVar11 = rndUniform(0);
        param_1 = (float)dVar11;
        param_5 = (float)taskGetRate();
        uVar7 = FUN_006c5018();
        *param_4 = uVar7;
        FUN_0054b7d0(1);
        FUN_0054b800(0x3f800000);
        local_9 = '\x01';
      }
    }
  }
  dVar11 = rndUniform(0);
  if (_DAT_006ea668 <= dVar11) {
    uVar4 = (uint)(ushort)((ushort)(param_2 < _DAT_006f584c) << 8 |
                          (ushort)(param_2 == _DAT_006f584c) << 0xe);
    if (param_2 < _DAT_006f584c == 0 && (param_2 == _DAT_006f584c) == 0) {
      param_1 = *(float *)(iVar5 + 0x50);
      param_3 = (param_2 - _DAT_006f584c) * _DAT_006f5848;
      dVar11 = rndUniform(0);
      uVar4 = (uint)((double)param_3 < dVar11) << 8;
      if ((double)param_3 < dVar11 == 0) {
        param_1 = param_3 + _DAT_006ea50c + param_1;
        if (_DAT_006e97d8 < param_1) {
          param_1 = 1.0;
        }
        FUN_0054b900(param_1);
        local_9 = '\x01';
        goto LAB_00549849;
      }
    }
LAB_00549841:
    uVar8 = (undefined3)(uVar4 >> 8);
    if (local_9 == '\0') goto LAB_00549852;
  }
  else {
    uVar4 = (uint)(ushort)((ushort)(param_2 < _DAT_006f583c) << 8 |
                          (ushort)(param_2 == _DAT_006f583c) << 0xe);
    if (param_2 < _DAT_006f583c != 0 || (param_2 == _DAT_006f583c) != 0) goto LAB_00549841;
    param_1 = *(float *)(iVar5 + 0x4c);
    param_3 = (param_2 - _DAT_006f583c) * _DAT_006f5848;
    dVar11 = rndUniform(0);
    uVar4 = (uint)((double)param_3 < dVar11) << 8;
    if ((double)param_3 < dVar11 != 0) goto LAB_00549841;
    param_1 = param_3 + _DAT_006ea50c + param_1;
    if (_DAT_006e97d8 < param_1) {
      param_1 = 1.0;
    }
    FUN_0054b8c0(param_1);
    local_9 = '\x01';
  }
LAB_00549849:
  FUN_0054b4c0(1);
  uVar8 = extraout_var;
LAB_00549852:
  return CONCAT31(uVar8,local_9);
}


