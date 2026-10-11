/* NR2003.exe @ 00503a80 FUN_00503a80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00503a80(void)

{
  char cVar1;
  int iVar2;
  float fVar3;
  int local_4;
  
  if (DAT_00b8f15c == '\0') {
    return;
  }
  FUN_00503c00();
  if (DAT_00b8e59a != 1) goto LAB_00503be5;
  if ((int)DAT_00b8e5aa < 0) {
    DAT_00b8e921 = '\0';
    fVar3 = -DAT_00b715c0;
LAB_00503b05:
    FUN_00507c90(fVar3,0);
  }
  else {
    if (0 < (int)DAT_00b8e5aa) {
      DAT_00b8e921 = '\0';
      fVar3 = DAT_00b715c0;
      goto LAB_00503b05;
    }
    local_4 = 0;
    cVar1 = FUN_00507b90(&local_4,0x19);
    if (((cVar1 != '\0') && ((*(byte *)(*(int *)(local_4 + 4) + 8) & 0xfe) == 0)) &&
       (fVar3 = DAT_00b715c0, DAT_00b8e921 == '\0')) goto LAB_00503b05;
  }
  DAT_00b8e5a6 = DAT_00b8e5a6 + -1;
  if (DAT_00b8e5ae == '\0') {
    iVar2 = (DAT_00b8e5aa ^ (int)DAT_00b8e5aa >> 0x1f) - ((int)DAT_00b8e5aa >> 0x1f);
    while ((iVar2 != 0 && (DAT_00b8e59e != 0))) {
      cVar1 = FUN_00503480(DAT_00b8e5aa);
      if (cVar1 == '\0') {
        DAT_00b8e5aa = 0;
        goto LAB_00503bc0;
      }
      iVar2 = iVar2 + -1;
    }
  }
  else {
    DAT_00b8e5af = DAT_00b8e5af + -1;
    if (DAT_00b8e5af < 0) {
      cVar1 = FUN_00503480(DAT_00b8e5aa);
      if (cVar1 == '\0') {
        DAT_00b8e5aa = 0;
        DAT_00b8e5ae = '\0';
      }
      DAT_00b8e5af = (DAT_00b8e5aa ^ (int)DAT_00b8e5aa >> 0x1f) - ((int)DAT_00b8e5aa >> 0x1f);
    }
  }
  if ((DAT_00b8e5aa == 1) && (DAT_00b8e5ae == '\0')) {
    FUN_00503470();
    fVar3 = _DAT_00b8e926 * _DAT_00b8e926 * _DAT_00b8e926;
  }
  else {
LAB_00503bc0:
    FUN_00503470();
    fVar3 = 0.0;
  }
  FUN_00569270(fVar3);
  FUN_005697e0();
  if (DAT_00b8e5aa == 0) {
    FUN_005036a0();
  }
LAB_00503be5:
  if (DAT_00b8e91d != 0) {
    FUN_00504ef0();
  }
  return;
}

