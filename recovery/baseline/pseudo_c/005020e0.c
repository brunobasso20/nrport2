/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005020e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005020e0(int param_1)

{
  char cVar1;
  int iVar2;
  int *piVar3;
  int iVar4;
  int local_8;
  int local_4;
  
  local_4 = taskGetRate();
  iVar4 = 0;
  DAT_00e4d4c4 = (float)local_4;
  piVar3 = &DAT_00e4d738;
  iVar2 = 0x30;
  DAT_00e4d4c0 = _DAT_006e97d8 / DAT_00e4d4c4;
  do {
    FUN_0059fa90();
    *piVar3 = iVar4;
    piVar3[0x2e] = 5000;
    iVar4 = iVar4 + 1;
    piVar3 = piVar3 + 0xcb;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  local_8 = 0;
  cVar1 = FUN_005aa650(&local_8);
  while (cVar1 != '\0') {
    if (*(int *)(local_8 + 4) != 0) {
      FUN_005aa570(local_8);
    }
    cVar1 = FUN_005aa650(&local_8);
  }
  FUN_005aa6b0();
  if ((param_1 == 2) || (param_1 == 1)) {
    FUN_005ab4b0();
  }
  if ((param_1 == 0) || (param_1 == 1)) {
    FUN_005ab420();
  }
  if ((param_1 == 0) || (param_1 == 2)) {
    DAT_00b8e921 = 0;
    _DAT_00b8e922 = 0x3f800000;
    _DAT_00b8e926 = 0x3f800000;
    _DAT_00b8e92a = 0x13;
    _DAT_00b8e92e = FUN_0055ab00();
    DAT_00b8e932 = 1;
    DAT_00b8e936 = 0;
    DAT_00b8e939 = 0;
    _DAT_00b8e937 = 0x100;
  }
  return;
}


