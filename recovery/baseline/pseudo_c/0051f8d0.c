/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051f8d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0051f8d0(int param_1)

{
  float fVar1;
  float10 fVar2;
  
  fVar1 = *(float *)(param_1 + 0x197e) * (float)_DAT_006f49e8;
  *(undefined4 *)(param_1 + 0x1d56) = 0x3f800000;
  if (*(int *)(param_1 + 0x1d1a) != 0x3f800000) {
    *(float *)(param_1 + 0x1d56) = _DAT_0074ad08 * fVar1 + *(float *)(param_1 + 0x1d1a);
  }
  if (*(int *)(param_1 + 0x1d1e) != 0x3f800000) {
    *(float *)(param_1 + 0x1d56) =
         (*(float *)(param_1 + 0x1d1e) - _DAT_0074ad08 * fVar1) * *(float *)(param_1 + 0x1d56);
  }
  if (*(int *)(param_1 + 0x1cfe) != 0x3f800000) {
    *(float *)(param_1 + 0x1d56) =
         (_DAT_0074ad68 * fVar1 + *(float *)(param_1 + 0x1cfe)) * *(float *)(param_1 + 0x1d56);
  }
  if (*(int *)(param_1 + 0x1d02) != 0x3f800000) {
    *(float *)(param_1 + 0x1d56) =
         (*(float *)(param_1 + 0x1d02) - _DAT_0074ad68 * fVar1) * *(float *)(param_1 + 0x1d56);
  }
  fVar2 = (float10)*(float *)(param_1 + 0x1cfa) * (float10)*(float *)(param_1 + 0x1a86) *
          (float10)*(float *)(param_1 + 0x1d56);
  if (fVar2 < (float10)_DAT_006ea50c) {
    fVar2 = (float10)_DAT_006ea50c;
  }
  return fVar2;
}


