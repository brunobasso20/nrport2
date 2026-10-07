/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052f020 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052f020(int param_1)

{
  float fVar1;
  float fVar2;
  
  fVar1 = *(float *)(param_1 + 0x1d72) * *(float *)(param_1 + 0x1d7a);
  *(float *)(param_1 + 0x1d1a) = fVar1;
  *(float *)(param_1 + 0x1d1e) = *(float *)(param_1 + 0x1d76) * *(float *)(param_1 + 0x1d7e);
  *(float *)(param_1 + 0x1d26) = *(float *)(param_1 + 0x1d7e) * *(float *)(param_1 + 0x1d7a);
  fVar2 = *(float *)(param_1 + 0x1d76) * *(float *)(param_1 + 0x1d72);
  *(float *)(param_1 + 0x1d22) = fVar2;
  *(float *)(param_1 + 0x18e6) = (_DAT_006e97d8 - fVar2) * _DAT_0074ad20;
  *(float *)(param_1 + 0x18ea) = (_DAT_006e97d8 - fVar1) * _DAT_0074ad38;
  return;
}


