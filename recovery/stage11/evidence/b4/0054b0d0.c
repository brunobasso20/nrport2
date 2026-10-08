/* NR2003.exe @ 0054b0d0 FUN_0054b0d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0054b0d0(int param_1,int param_2,char param_3)

{
  int iVar1;
  float fVar2;
  
  *(bool *)(*(int *)(param_2 + 0x18) + 0x40) = (*(byte *)(param_1 + 2) & 3) == 3;
  *(bool *)(*(int *)(param_2 + 0x1c) + 0x40) = (*(byte *)(param_1 + 2) & 0xc) == 0xc;
  *(bool *)(*(int *)(param_2 + 0x20) + 0x40) = (*(byte *)(param_1 + 2) & 0x30) == 0x30;
  *(bool *)(*(int *)(param_2 + 0x24) + 0x40) = (*(byte *)(param_1 + 2) & 0xc0) == 0xc0;
  if (param_3 != '\0') {
    fVar2 = *(float *)(param_1 + 0x14);
    if (_DAT_006e97d8 < *(float *)(param_1 + 0x14)) {
      fVar2 = _DAT_006e97d8;
    }
    iVar1 = *(int *)(param_2 + 0x38);
    *(float *)(iVar1 + 0x3c) = fVar2;
    fVar2 = _DAT_006e97d8 - *(float *)(iVar1 + 0x38) * *(float *)(iVar1 + 0x20) * fVar2;
    *(float *)(iVar1 + 0x24) = fVar2 * *(float *)(iVar1 + 0x14);
    *(float *)(iVar1 + 0x28) = fVar2 * *(float *)(iVar1 + 0x18);
    *(float *)(iVar1 + 0x2c) = fVar2 * *(float *)(iVar1 + 0x1c);
    fVar2 = *(float *)(param_1 + 0x18);
    if (_DAT_006e97d8 < *(float *)(param_1 + 0x18)) {
      fVar2 = _DAT_006e97d8;
    }
    iVar1 = *(int *)(param_2 + 0x28);
    *(float *)(iVar1 + 0x3c) = fVar2;
    fVar2 = _DAT_006e97d8 - *(float *)(iVar1 + 0x38) * *(float *)(iVar1 + 0x20) * fVar2;
    *(float *)(iVar1 + 0x24) = fVar2 * *(float *)(iVar1 + 0x14);
    *(float *)(iVar1 + 0x28) = fVar2 * *(float *)(iVar1 + 0x18);
    *(float *)(iVar1 + 0x2c) = fVar2 * *(float *)(iVar1 + 0x1c);
    fVar2 = *(float *)(param_1 + 0x1c);
    if (_DAT_006e97d8 < *(float *)(param_1 + 0x1c)) {
      fVar2 = _DAT_006e97d8;
    }
    iVar1 = *(int *)(param_2 + 0x2c);
    *(float *)(iVar1 + 0x3c) = fVar2;
    fVar2 = _DAT_006e97d8 - *(float *)(iVar1 + 0x38) * *(float *)(iVar1 + 0x20) * fVar2;
    *(float *)(iVar1 + 0x24) = fVar2 * *(float *)(iVar1 + 0x14);
    *(float *)(iVar1 + 0x28) = fVar2 * *(float *)(iVar1 + 0x18);
    *(float *)(iVar1 + 0x2c) = fVar2 * *(float *)(iVar1 + 0x1c);
    fVar2 = *(float *)(param_1 + 0x20);
    if (_DAT_006e97d8 < *(float *)(param_1 + 0x20)) {
      fVar2 = _DAT_006e97d8;
    }
    iVar1 = *(int *)(param_2 + 0x30);
    *(float *)(iVar1 + 0x3c) = fVar2;
    fVar2 = _DAT_006e97d8 - *(float *)(iVar1 + 0x38) * *(float *)(iVar1 + 0x20) * fVar2;
    *(float *)(iVar1 + 0x24) = fVar2 * *(float *)(iVar1 + 0x14);
    *(float *)(iVar1 + 0x28) = fVar2 * *(float *)(iVar1 + 0x18);
    *(float *)(iVar1 + 0x2c) = fVar2 * *(float *)(iVar1 + 0x1c);
    fVar2 = *(float *)(param_1 + 0x24);
    if (_DAT_006e97d8 < *(float *)(param_1 + 0x24)) {
      fVar2 = _DAT_006e97d8;
    }
    iVar1 = *(int *)(param_2 + 0x34);
    *(float *)(iVar1 + 0x3c) = fVar2;
    fVar2 = _DAT_006e97d8 - *(float *)(iVar1 + 0x38) * *(float *)(iVar1 + 0x20) * fVar2;
    *(float *)(iVar1 + 0x24) = fVar2 * *(float *)(iVar1 + 0x14);
    *(float *)(iVar1 + 0x28) = fVar2 * *(float *)(iVar1 + 0x18);
    *(float *)(iVar1 + 0x2c) = fVar2 * *(float *)(iVar1 + 0x1c);
    FUN_00577cb0();
    return;
  }
  return;
}

