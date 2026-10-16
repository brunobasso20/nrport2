/* NR2003.exe @ 004ecde0 recovered_004ecde0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall recovered_004ecde0(int param_1)

{
  int iVar1;
  float10 fVar2;
  float10 fVar3;
  
  iVar1 = *(int *)(param_1 + 0x28);
  fVar2 = ((float10)*(float *)(iVar1 + 0x1878) - (float10)*(float *)(iVar1 + 0x1874)) *
          (float10)*(float *)(param_1 + 0x1c) + (float10)*(float *)(iVar1 + 0x1874);
  if ((*(int *)(param_1 + 0x14) != 0) && (*(int *)(*(int *)(param_1 + 0x14) + 0x1c) == 0)) {
    fVar3 = (float10)FUN_004f03d0();
    if ((float10)_DAT_006ed6c8 < fVar3) {
      return (fVar3 - (float10)_DAT_006ed6c8) * (float10)(float)fVar2 * (float10)_DAT_006e9804;
    }
    fVar2 = (float10)_DAT_006ea454;
  }
  return fVar2;
}

