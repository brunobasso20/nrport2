/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00507e80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00507e80(int param_1)

{
  short *psVar1;
  float10 fVar2;
  
  psVar1 = *(short **)(param_1 + 4);
  if (*psVar1 == 0x16) {
    fVar2 = (float10)FUN_00507820(0x16,psVar1 + 2);
    if (fVar2 < (float10)_DAT_006ea454 != (fVar2 == (float10)_DAT_006ea454)) {
      _DAT_00b8e922 = 1.0;
      return;
    }
    fVar2 = (float10)*(float *)(param_1 + 8) / fVar2;
    if ((*(byte *)(psVar1 + 4) & 1) != 0) {
      fVar2 = (float10)_DAT_006e97d8 - fVar2;
    }
    _DAT_00b8e922 = (float)fVar2;
    if (_DAT_00b8e922 < _DAT_006ea454) {
      _DAT_00b8e922 = 0.0;
      return;
    }
    if (_DAT_006e97d8 < _DAT_00b8e922) {
      _DAT_00b8e922 = 1.0;
    }
  }
  else if (*psVar1 == 0x1c) {
    fVar2 = (float10)FUN_00507820(0x1c,psVar1 + 2);
    if (fVar2 < (float10)_DAT_006ea454 == (fVar2 == (float10)_DAT_006ea454)) {
      _DAT_00b8e926 =
           (float)(((float10)*(float *)(param_1 + 8) / fVar2) *
                   ((float10)*(float *)(psVar1 + 4) - (float10)*(float *)(psVar1 + 6)) +
                  (float10)*(float *)(psVar1 + 6));
    }
    else {
      _DAT_00b8e926 = *(float *)(psVar1 + 4);
    }
    if (_DAT_00b8e926 < _DAT_006ea454) {
      _DAT_00b8e926 = 0.0;
      return;
    }
    if (_DAT_006e97d8 < _DAT_00b8e926) {
      _DAT_00b8e926 = 1.0;
      return;
    }
  }
  return;
}


