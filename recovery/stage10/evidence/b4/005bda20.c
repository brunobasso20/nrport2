/* NR2003.exe @ 005bda20 FUN_005bda20 */

int FUN_005bda20(int param_1)

{
  int iVar1;
  int iVar2;
  int extraout_EDX;
  int iVar3;
  
  iVar1 = 0;
  while ((param_1 - (&DAT_00ebfc68)[iVar1] < -0x20 || (0x1f < param_1 - (&DAT_00ebfc68)[iVar1]))) {
    iVar1 = iVar1 + 1;
    if (4 < iVar1) {
      iVar1 = 0;
      iVar2 = 1;
      iVar3 = DAT_00ebfc54;
      do {
        if ((&DAT_00ebfc54)[iVar2] < iVar3) {
          iVar1 = iVar2;
          iVar3 = (&DAT_00ebfc54)[iVar2];
        }
        iVar2 = iVar2 + 1;
      } while (iVar2 < 5);
      (&DAT_00ebfc68)[iVar1] = param_1;
      (&DAT_00ebfc54)[iVar1] = DAT_00ec02c0;
      DAT_00ec02c0 = DAT_00ec02c0 + 1;
      FUN_005bd360(*(int *)(&DAT_00752f08 + iVar1 * 4) + 0xb8);
      FUN_005bd910(&DAT_00ebbf60 + param_1 * 4);
      return extraout_EDX;
    }
  }
  (&DAT_00ebfc54)[iVar1] = DAT_00ec02c0;
  DAT_00ec02c0 = DAT_00ec02c0 + 1;
  return iVar1;
}

