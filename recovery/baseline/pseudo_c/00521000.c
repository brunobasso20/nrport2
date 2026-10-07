/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00521000 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00521000(int param_1)

{
  float fVar1;
  float fVar2;
  float *pfVar3;
  int iVar4;
  float10 fVar5;
  float local_4;
  
  if (*(char *)(param_1 + 9) == '\0') {
    iVar4 = 0;
    pfVar3 = (float *)(param_1 + 0xf);
    do {
      fVar5 = (float10)FUN_00520910(iVar4,0);
      *pfVar3 = (float)fVar5;
      if ((float10)pfVar3[0x1b] < fVar5) {
        pfVar3[0x1b] = (float)fVar5;
        fVar5 = (float10)FUN_00547ec0();
        local_4 = (float)(((float10)_DAT_006e97d8 -
                          ((float10)_DAT_006e97d8 - (float10)(float)(&DAT_0071f1d8)[iVar4]) * fVar5)
                         * (float10)*pfVar3);
        fVar5 = (float10)FUN_00547ec0();
        fVar5 = (float10)_DAT_006e97d8 -
                ((float10)_DAT_006e97d8 - (float10)(float)(&DAT_0071f248)[iVar4]) * fVar5;
        if (fVar5 < (float10)local_4) {
          local_4 = (float)fVar5;
        }
        pfVar3[0x36] = *pfVar3 - local_4;
        if (iVar4 < 0xb) {
          fVar5 = (float10)FUN_00547ec0();
          fVar1 = (float)(fVar5 * (float10)_DAT_006ea50c);
          if (pfVar3[0x36] < fVar1) {
            fVar2 = *pfVar3;
            if (fVar1 < *pfVar3) {
              fVar2 = fVar1;
            }
            pfVar3[0x36] = fVar2;
          }
        }
      }
      iVar4 = iVar4 + 1;
      pfVar3 = pfVar3 + 1;
    } while (iVar4 < 0x1b);
  }
  return;
}


