/* NR2003.exe @ 005697e0 FUN_005697e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_005697e0(float *param_1)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  undefined4 uVar4;
  int iVar5;
  float10 fVar6;
  
  FUN_00569450();
  if ((param_1[0xce] < _DAT_006e97d8 != (NAN(param_1[0xce]) || NAN(_DAT_006e97d8))) &&
     (fVar2 = param_1[0xce], param_1[0xce] = param_1[0xcf] + fVar2,
     _DAT_006e97d8 <= param_1[0xcf] + fVar2)) {
    FUN_00568c60((int)param_1 + 0x196);
    param_1[0xce] = 1.0;
  }
  fVar2 = param_1[1];
  pfVar1 = param_1 + 1;
  if ((((0x12 < (int)fVar2) && ((int)fVar2 < 0x16)) && (fVar3 = param_1[3], fVar3 != 0.0)) &&
     (*(int *)((int)fVar3 + 4) != 0)) {
    uVar4 = FUN_00569a60(&DAT_00c585a0 + ((int)fVar2 + -0x13) * 0x391,
                         *(undefined4 *)(*(int *)((int)fVar3 + 0x5ae) + 0x3c));
    *(undefined4 *)((int)param_1 + ((int)fVar2 + -0x13) * 4 + 0x165) = uVar4;
  }
  iVar5 = FUN_00569b10(pfVar1);
  if (iVar5 != 0) {
    *(undefined *)((int)param_1 + 0x162) = 1;
  }
  if (param_1[0xce] < _DAT_006e97d8 != (NAN(param_1[0xce]) || NAN(_DAT_006e97d8))) {
    iVar5 = FUN_00569b10((int)param_1 + 0x196);
    if (iVar5 != 0) {
      *(undefined *)(param_1 + 0xbd) = 1;
    }
  }
  FUN_00569280(pfVar1,*param_1 * param_1[0xce]);
  if (param_1[0xce] < _DAT_006e97d8 != (NAN(param_1[0xce]) || NAN(_DAT_006e97d8))) {
    FUN_00569280((int)param_1 + 0x196,(_DAT_006e97d8 - param_1[0xce]) * *param_1);
  }
  if ((0 < (int)*pfVar1) && ((int)*pfVar1 < 4)) {
    if (param_1[0xd1] < param_1[0xd2] == (NAN(param_1[0xd1]) || NAN(param_1[0xd2]))) {
      if (param_1[0xd2] < param_1[0xd1]) {
        iVar5 = taskGetRate();
        fVar2 = param_1[0xd1] - _DAT_006e97d8 / ((float)iVar5 * _DAT_006ea4cc);
        param_1[0xd1] = fVar2;
        if (fVar2 < param_1[0xd2] != (NAN(fVar2) || NAN(param_1[0xd2]))) {
          param_1[0xd1] = param_1[0xd2];
        }
      }
    }
    else {
      iVar5 = taskGetRate();
      fVar2 = _DAT_006e97d8 / ((float)iVar5 * _DAT_006ea4cc) + param_1[0xd1];
      param_1[0xd1] = fVar2;
      if (param_1[0xd2] < fVar2) {
        param_1[0xd1] = param_1[0xd2];
      }
    }
    if (param_1[0xd1] < _DAT_006ea454 != (param_1[0xd1] == _DAT_006ea454)) {
      param_1[0xd3] = 0.0;
      return;
    }
    if (param_1[0xd1] < _DAT_006e97d8 != (NAN(param_1[0xd1]) || NAN(_DAT_006e97d8))) {
      if ((NAN(param_1[0xd2]) || NAN(_DAT_006ea454)) != (param_1[0xd2] == _DAT_006ea454)) {
        fVar6 = (float10)FUN_00569250(param_1[0xd1]);
        param_1[0xd3] = (float)(fVar6 * (float10)_DAT_006f5f30);
        return;
      }
      fVar6 = (float10)FUN_00569210(param_1[0xd1]);
      param_1[0xd3] = (float)(fVar6 * (float10)_DAT_006f5f30);
      return;
    }
    param_1[0xd3] = 0.7853982;
  }
  return;
}

