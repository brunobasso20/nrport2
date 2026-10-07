/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004c2130 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004c2130(int *param_1_00,float param_1)

{
  int iVar1;
  float fVar2;
  
  if ((param_1_00[2] != 0) && (iVar1 = *(int *)(param_1_00[2] + 0x12), iVar1 != 0)) {
    fVar2 = _DAT_006ea454;
    if ((_DAT_006ea454 <= param_1) && (fVar2 = param_1, _DAT_006e97d8 < param_1)) {
      fVar2 = _DAT_006e97d8;
    }
    *(float *)(iVar1 + 0x32) = fVar2;
  }
  iVar1 = *param_1_00;
  if (iVar1 != 0) {
    if (param_1 < _DAT_006ea454) {
      *(float *)(iVar1 + 0x32) = _DAT_006ea454;
      return;
    }
    if (_DAT_006e97d8 < param_1) {
      *(float *)(iVar1 + 0x32) = _DAT_006e97d8;
      return;
    }
    *(float *)(iVar1 + 0x32) = param_1;
  }
  return;
}


