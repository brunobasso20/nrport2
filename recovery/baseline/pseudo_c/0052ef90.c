/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052ef90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052ef90(int param_1)

{
  float10 fVar1;
  undefined4 local_4;
  
  local_4 = (*(float *)(param_1 + 0x1cba) + *(float *)(param_1 + 0x1cb6) +
             *(float *)(param_1 + 0x1cb2) + *(float *)(param_1 + 0x1cae)) * _DAT_006ea50c;
  if (local_4 < _DAT_006ea454) {
    local_4 = 0.0;
  }
  fVar1 = (float10)FUN_0054ef10(local_4);
  *(float *)(param_1 + 0x1cfa) = (float)fVar1;
  *(float *)(param_1 + 0x1cfe) = *(float *)(param_1 + 0x1d62) * *(float *)(param_1 + 0x1d6a);
  *(float *)(param_1 + 0x1d02) = *(float *)(param_1 + 0x1d66) * *(float *)(param_1 + 0x1d6e);
  *(float *)(param_1 + 0x1d06) = *(float *)(param_1 + 0x1d6e) * *(float *)(param_1 + 0x1d6a);
  return;
}


