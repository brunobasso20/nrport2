/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004503d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004503d0(void)

{
  int iVar1;
  float10 fVar2;
  
  if ((DAT_0089e3d8 != 0) && (iVar1 = *(int *)(DAT_0089e3d8 + 0x5ae), iVar1 != 0)) {
    if ((_DAT_006e97d8 <=
         *(float *)(iVar1 + 0x14) * *(float *)(iVar1 + 0x14) +
         *(float *)(iVar1 + 0x10) * *(float *)(iVar1 + 0x10) +
         *(float *)(iVar1 + 0xc) * *(float *)(iVar1 + 0xc)) &&
       ((*(float *)(iVar1 + 0xc) * *(float *)(iVar1 + 0x58) +
        *(float *)(iVar1 + 100) * *(float *)(iVar1 + 0x10) +
        *(float *)(iVar1 + 0x70) * *(float *)(iVar1 + 0x14)) /
        SQRT(*(float *)(iVar1 + 0x14) * *(float *)(iVar1 + 0x14) +
             *(float *)(iVar1 + 0x10) * *(float *)(iVar1 + 0x10) +
             *(float *)(iVar1 + 0xc) * *(float *)(iVar1 + 0xc)) <= _DAT_006ea44c)) {
      DAT_007325f0 = 0;
      DAT_007325f1 = 0;
      return;
    }
    if (DAT_007325f0 != '\0') {
      return;
    }
    if (DAT_007325f1 == '\0') {
      fVar2 = (float10)thunk_FUN_0055a760();
      _DAT_0089e3f0 = (double)fVar2;
      DAT_007325f1 = 1;
      return;
    }
    fVar2 = (float10)thunk_FUN_0055a760();
    if (fVar2 - (float10)_DAT_0089e3f0 <= (float10)_DAT_006ed050) {
      return;
    }
  }
  DAT_007325f0 = 1;
  return;
}


