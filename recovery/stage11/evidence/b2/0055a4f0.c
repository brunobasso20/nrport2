/* NR2003.exe @ 0055a4f0 FUN_0055a4f0 */

void FUN_0055a4f0(int param_1)

{
  char cVar1;
  int iVar2;
  
  cVar1 = FUN_0061f420();
  if (cVar1 != '\0') {
    if ((((1 < param_1) && (DAT_00c067d0 < 2)) &&
        (cVar1 = FUN_005c2cf0(DAT_00c08194), cVar1 != '\0')) &&
       (iVar2 = FUN_005c2d20(DAT_00c08194), iVar2 != 1)) {
      FUN_00624730();
      DAT_00c067d0 = param_1;
      DAT_00c067d4 = 0;
      return;
    }
    if ((param_1 < 1) && (0 < DAT_00c067d0)) {
      cVar1 = FUN_005c2cf0(DAT_00c08194);
      if ((cVar1 != '\0') && (iVar2 = FUN_005c2d20(DAT_00c08194), iVar2 == 1)) {
        DAT_00c067d0 = param_1;
        DAT_00c067d4 = 0;
        return;
      }
      FUN_00624750();
    }
  }
  DAT_00c067d0 = param_1;
  DAT_00c067d4 = 0;
  return;
}

