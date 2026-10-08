/* NR2003.exe @ 00563620 FUN_00563620 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00563620(int param_1)

{
  int *piVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  
  FUN_005632e0(param_1,1);
  FUN_005635c0(param_1);
  iVar3 = DAT_00c08768;
  if (DAT_00c08768 != 0) {
    while( true ) {
      iVar4 = *(int *)(iVar3 + 4);
      if (iVar4 == 0) {
        iVar2 = 0;
      }
      else {
        iVar2 = iVar4 + -4;
      }
      if ((iVar2 == DAT_00c08768) ||
         (*(float *)(*(int *)(param_1 + 0x5ae) + 0x3c) <= *(float *)(*(int *)(iVar3 + 0x5ae) + 0x3c)
         )) break;
      if (iVar4 == 0) {
        iVar3 = 0;
      }
      else {
        iVar3 = iVar4 + -4;
      }
    }
    iVar4 = *(int *)(iVar3 + 8);
    if ((iVar4 == 0) || (iVar4 == 4)) {
      iVar4 = 0;
    }
    *(int *)(param_1 + 8) = iVar4;
    piVar1 = (int *)(param_1 + 4);
    if (*(int *)(iVar3 + 8) == 0) {
      iVar4 = 0;
    }
    else {
      iVar4 = *(int *)(iVar3 + 8) + -4;
    }
    *(int **)(iVar4 + 4) = piVar1;
    *piVar1 = iVar3 + 4;
    *(int **)(iVar3 + 8) = piVar1;
    if ((iVar3 == DAT_00c08768) &&
       (*(float *)(*(int *)(param_1 + 0x5ae) + 0x3c) <= *(float *)(*(int *)(iVar3 + 0x5ae) + 0x3c)))
    {
      DAT_00c08768 = param_1;
    }
    DAT_00c0876c = DAT_00c0876c + 1;
    return;
  }
  if (param_1 == 0) {
    _DAT_00000008 = 4;
    uRam00000004 = 0;
    DAT_00c08768 = param_1;
    DAT_00c0876c = DAT_00c0876c + 1;
    return;
  }
  *(int **)(param_1 + 8) = (int *)(param_1 + 4);
  *(int *)(param_1 + 4) = param_1 + 4;
  DAT_00c08768 = param_1;
  DAT_00c0876c = DAT_00c0876c + 1;
  return;
}

