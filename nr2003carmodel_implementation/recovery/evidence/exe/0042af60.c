/* NR2003.exe @ 0042af60 FUN_0042af60 */

void FUN_0042af60(void)

{
  int iVar1;
  int iVar2;
  
  iVar2 = 0;
  iVar1 = DAT_00876d0c;
  if (0 < DAT_00876d0c) {
    do {
      if ((&DAT_008726c0)[iVar2] != 0) {
        FUN_005d3e60((&DAT_008726c0)[iVar2]);
        iVar1 = DAT_00876d0c;
      }
      (&DAT_008726c0)[iVar2] = 0;
      iVar2 = iVar2 + 1;
    } while (iVar2 < iVar1);
  }
  iVar2 = 0;
  if (0 < iVar1) {
    do {
      if ((&DAT_00872688)[iVar2] != 0) {
        FUN_005d3e60((&DAT_00872688)[iVar2]);
        iVar1 = DAT_00876d0c;
      }
      (&DAT_00872688)[iVar2] = 0;
      iVar2 = iVar2 + 1;
    } while (iVar2 < iVar1);
  }
  DAT_00876d0c = 0;
  if (DAT_00876d10 != 0) {
    FUN_005d3e90(DAT_00876d10);
  }
  DAT_00876d10 = 0;
  if (DAT_00876d18 != 0) {
    FUN_005d3e90(DAT_00876d18);
  }
  DAT_00876d18 = 0;
  if (DAT_00876d14 != 0) {
    FUN_005d3e90(DAT_00876d14);
  }
  DAT_00876d14 = 0;
  if (DAT_00876d1c != 0) {
    FUN_005d3e90(DAT_00876d1c);
  }
  DAT_00876d1c = 0;
  return;
}

