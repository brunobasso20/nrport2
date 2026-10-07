/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052eea0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052eea0(int param_1)

{
  float fVar1;
  
  FUN_0052ef90();
  FUN_0052f020();
  FUN_0052f0a0();
  fVar1 = _DAT_006ea454;
  if (*(char *)(param_1 + 0x1d9a) == '\0') {
    fVar1 = (_DAT_006e97d8 - *(float *)(param_1 + 0x1d82)) *
            (_DAT_006e97d8 - *(float *)(param_1 + 0x1d86));
  }
  *(float *)(param_1 + 0x1d36) = fVar1;
  fVar1 = _DAT_006e97d8 - *(float *)(param_1 + 0x1d96);
  *(float *)(param_1 + 0x1d4a) =
       _DAT_006e97d8 -
       (_DAT_006e97d8 - *(float *)(param_1 + 0x1d82)) * *(float *)(param_1 + 0x1d1e) *
       *(float *)(param_1 + 0x1d1a) * *(float *)(param_1 + 0x1d02) * *(float *)(param_1 + 0x1cfe) *
       fVar1;
  *(float *)(param_1 + 0x1d3e) =
       ((*(float *)(param_1 + 0x1d22) - _DAT_006e97d8) * _DAT_0074adf8 + _DAT_006e97d8) *
       ((*(float *)(param_1 + 0x1d02) * *(float *)(param_1 + 0x1cfe) - _DAT_006e97d8) *
        _DAT_0074ade0 + _DAT_006e97d8) * fVar1;
  FUN_004101c0(param_1,param_1 + 0x1d5a,param_1 + 0x1d5e);
  return;
}


