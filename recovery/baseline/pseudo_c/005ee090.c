/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005ee090 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_005ee090(int *param_1)

{
  int iVar1;
  int iVar2;
  float fVar3;
  float *pfVar4;
  int iVar5;
  
  iVar5 = param_1[1];
  if (0 < iVar5) {
    pfVar4 = (float *)*param_1;
    fVar3 = _DAT_006ea454;
    do {
      fVar3 = fVar3 + *pfVar4;
      pfVar4 = pfVar4 + 1;
      iVar5 = iVar5 + -1;
    } while (iVar5 != 0);
    if (fVar3 != _DAT_006ea454) {
      fVar3 = _DAT_006e97d8 / fVar3;
      iVar5 = 0;
      do {
        iVar1 = iVar5 * 4;
        iVar2 = iVar5 * 4;
        iVar5 = iVar5 + 1;
        *(float *)(*param_1 + iVar2) = fVar3 * *(float *)(*param_1 + iVar1);
      } while (iVar5 < param_1[1]);
    }
  }
  return;
}


