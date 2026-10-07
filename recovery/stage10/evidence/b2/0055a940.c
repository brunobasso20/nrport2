/* NR2003.exe @ 0055a940 FUN_0055a940 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055a940(undefined4 param_1)

{
  char cVar1;
  int iVar2;
  int iVar3;
  int *piVar4;
  undefined4 uVar5;
  int local_8;
  int local_4;
  
  iVar2 = FUN_0055a5c0();
  if (iVar2 != 0) {
    FUN_0055a5b0(param_1);
    return;
  }
  iVar2 = 0;
  local_8 = 0;
  cVar1 = FUN_00566a20(&local_8);
  while (cVar1 != '\0') {
    if (*(int *)(local_8 + 4) != 0) {
      FUN_00563730(local_8);
    }
    cVar1 = FUN_00566a20(&local_8);
  }
  local_4 = taskGetRate();
  piVar4 = &DAT_00c08a18;
  DAT_00c087a4 = (float)local_4;
  iVar3 = 0x30;
  DAT_00c087a0 = _DAT_006e97d8 / DAT_00c087a4;
  do {
    FUN_0059fa90();
    *piVar4 = iVar2;
    piVar4[0x2e] = 5000;
    iVar2 = iVar2 + 1;
    piVar4 = piVar4 + 0xcb;
    iVar3 = iVar3 + -1;
  } while (iVar3 != 0);
  FUN_0055a5b0(param_1);
  cVar1 = FUN_00502460();
  if (cVar1 != '\0') {
    FUN_00502b50(1);
  }
  cVar1 = FUN_00501480();
  if (cVar1 != '\0') {
    FUN_00501b30();
  }
  uVar5 = 0;
  FUN_0055a610(0);
  FUN_00569270(uVar5);
  return;
}

