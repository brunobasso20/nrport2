/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00520fb0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall FUN_00520fb0(int *param_1)

{
  float *pfVar1;
  int iVar2;
  float10 fVar3;
  
  fVar3 = (float10)_DAT_006ea454;
  if (*param_1 != 0) {
    pfVar1 = (float *)((int)param_1 + 0xf);
    iVar2 = 0;
    do {
      if ((pfVar1[0x36] < *pfVar1) &&
         (*pfVar1 < *(float *)((int)&DAT_0071f2b8 + iVar2) !=
          (*pfVar1 == *(float *)((int)&DAT_0071f2b8 + iVar2)))) {
        fVar3 = ((float10)*pfVar1 - (float10)pfVar1[0x36]) /
                (float10)*(float *)((int)&DAT_0071f168 + iVar2) + fVar3;
      }
      iVar2 = iVar2 + 4;
      pfVar1 = pfVar1 + 1;
    } while (iVar2 < 0x6c);
  }
  return fVar3;
}


