/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054ba90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall FUN_0054ba90(int param_1)

{
  float fVar1;
  float *pfVar2;
  int iVar3;
  float10 fVar4;
  
  fVar4 = (float10)_DAT_006ea454;
  pfVar2 = (float *)(param_1 + 0x10);
  iVar3 = 0xb;
  do {
    fVar1 = *pfVar2;
    pfVar2 = pfVar2 + 1;
    iVar3 = iVar3 + -1;
    fVar4 = (float10)fVar1 * (float10)_DAT_006f587c + fVar4;
  } while (iVar3 != 0);
  fVar1 = _DAT_006ea454;
  if ((*(byte *)(param_1 + 0xf) & 1) != 0) {
    fVar1 = *(float *)(param_1 + 0x54);
  }
  iVar3 = 0;
  fVar4 = (float10)fVar1 * (float10)_DAT_006ea44c +
          (float10)*(float *)(param_1 + 0x58) * (float10)_DAT_006ea44c + fVar4;
  do {
    if (((*(ushort *)(param_1 + 2) & 0xfff) >> ((char)iVar3 * '\x02' & 0x1fU) & 3) != 0) {
      fVar4 = fVar4 + (float10)_DAT_006ea50c;
    }
    iVar3 = iVar3 + 1;
  } while (iVar3 < 4);
  return fVar4;
}


