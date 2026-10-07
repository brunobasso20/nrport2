/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0041d2c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0041d2c0(int param_1)

{
  int iVar1;
  float10 fVar2;
  
  iVar1 = FUN_00567630((&DAT_00accfe2)[param_1 * 0x885]);
  fVar2 = (float10)*(float *)(iVar1 + 0x58) + (float10)*(float *)(iVar1 + 0x4c);
  if ((float10)_DAT_006e97d8 < fVar2) {
    return (float10)_DAT_006e97d8 * (float10)_DAT_006ed6c8;
  }
  if ((float10)_DAT_006ea470 < fVar2) {
    return fVar2 * (float10)_DAT_006ed6c8;
  }
  return (float10)_DAT_006ea454;
}


