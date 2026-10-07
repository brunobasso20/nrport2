/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00569450 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00569450(int param_1)

{
  longlong lVar1;
  char cVar2;
  int iVar3;
  float10 fVar4;
  float10 fVar5;
  longlong lVar6;
  __uint64 _Var7;
  undefined8 uVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  undefined4 uVar11;
  float local_14;
  
  iVar3 = FUN_0055a5a0();
  if (iVar3 == 4) {
    iVar3 = FUN_0055a5c0();
    if (iVar3 == 1) {
      return;
    }
    iVar3 = FUN_0055a5c0();
    if (iVar3 == 2) {
      return;
    }
  }
  cVar2 = FUN_0057af60(0x54);
  if (cVar2 == '\0') {
    fVar5 = (float10)FUN_0057af30(0x55);
    fVar4 = (float10)FUN_0057af30(0x54);
    local_14 = (float)((float10)(float)fVar5 - fVar4);
    if ((DAT_0074eb98 < _DAT_006e97d8) && (_DAT_006ea454 < DAT_0074eb98)) {
      if (-DAT_0074eb98 <= local_14) {
        if (local_14 <= DAT_0074eb98) {
          local_14 = 0.0;
          goto LAB_005695d9;
        }
        local_14 = local_14 - DAT_0074eb98;
      }
      else {
        local_14 = DAT_0074eb98 + local_14;
      }
      local_14 = local_14 / (_DAT_006e97d8 - DAT_0074eb98);
    }
LAB_005695d9:
    if (*(int *)(param_1 + 0x18a) == 0 && *(int *)(param_1 + 0x18e) == 0) {
      uVar8 = FUN_005cfcfc();
      *(undefined8 *)(param_1 + 0x18a) = uVar8;
      *(float *)(param_1 + 0x354) = local_14;
    }
    else {
      lVar6 = FUN_005cfcfc();
      lVar1 = *(longlong *)(param_1 + 0x18a);
      _Var7 = taskGetCPURate();
      *(longlong *)(param_1 + 0x18a) = lVar6;
      if (_DAT_006ea454 <
          (float)((float10)(lVar6 - lVar1) /
                 (-(float10)(longlong)((_Var7 >> 0x20 & 0x80000000) << 0x20) +
                 (float10)(_Var7 & 0x7fffffffffffffff)))) {
        fVar5 = (float10)FUN_006c5c40();
        *(float *)(param_1 + 0x354) =
             (float)(fVar5 * (float10)*(float *)(param_1 + 0x354) +
                    ((float10)_DAT_006e97d8 - fVar5) * (float10)local_14);
      }
    }
  }
  else {
    *(undefined4 *)(param_1 + 0x354) = 0;
    cVar2 = FUN_0057af40(0x54);
    if (cVar2 == '\0') {
      if (*(int *)(param_1 + 4) == 2) {
        uVar9 = 1;
        goto LAB_005694d7;
      }
    }
    else if ((*(int *)(param_1 + 4) == 1) && (*(float *)(param_1 + 0x344) == _DAT_006ea454)) {
      uVar9 = 2;
LAB_005694d7:
      FUN_00568d10(uVar9,0,0);
    }
    cVar2 = FUN_0057af40(0x55);
    if (cVar2 == '\0') {
      if (*(int *)(param_1 + 4) == 3) {
        FUN_00568d10(1,0,0);
      }
    }
    else if ((*(int *)(param_1 + 4) == 1) && (*(float *)(param_1 + 0x344) == _DAT_006ea454)) {
      FUN_00568d10(3,0,0);
    }
  }
  cVar2 = FUN_0057af40(0x56);
  if (cVar2 == '\0') {
    cVar2 = FUN_0057af40(0x57);
    if (cVar2 == '\0') goto LAB_00569706;
    uVar11 = 0;
    uVar10 = 0;
    uVar9 = FUN_00411550(*(undefined4 *)(param_1 + 4),0,0);
  }
  else {
    uVar11 = 0;
    uVar10 = 0;
    uVar9 = FUN_00411530(*(undefined4 *)(param_1 + 4),0,0);
  }
  FUN_00568d10(uVar9,uVar10,uVar11);
LAB_00569706:
  cVar2 = FUN_0057af40(0x71);
  if (cVar2 != '\0') {
    thunk_FUN_00441cd0();
  }
  cVar2 = FUN_0057af40(0x72);
  if (cVar2 != '\0') {
    thunk_FUN_00441c90();
  }
  cVar2 = FUN_0057af40(0x6d);
  if (cVar2 != '\0') {
    fVar5 = (float10)FUN_00411850();
    local_14 = (float)(fVar5 + (float10)_DAT_006e97f0);
    if ((float10)DAT_00c5736c < fVar5 + (float10)_DAT_006e97f0) {
      local_14 = DAT_00c5736c;
    }
    FUN_00411860(local_14);
  }
  cVar2 = FUN_0057af40(0x6e);
  if (cVar2 != '\0') {
    fVar5 = (float10)FUN_00411850();
    local_14 = (float)(fVar5 - (float10)_DAT_006e97f0);
    if (fVar5 - (float10)_DAT_006e97f0 < (float10)DAT_00c5c27c) {
      local_14 = DAT_00c5c27c;
    }
    FUN_00411860(local_14);
  }
  iVar3 = *DAT_00c5c280;
  cVar2 = FUN_0056ba70(*(undefined4 *)(param_1 + 4));
  (**(code **)(iVar3 + 0xb4))(cVar2 == '\0');
  return;
}


