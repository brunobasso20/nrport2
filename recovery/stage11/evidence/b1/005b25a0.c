/* NR2003.exe @ 005b25a0 FUN_005b25a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005b25a0(int param_1)

{
  bool bVar1;
  int iVar2;
  undefined4 uVar3;
  
  if (*(int *)(param_1 + 0x1a4) < 0) {
    return;
  }
  if (*(int *)(param_1 + 0x19c) != 0) {
    bVar1 = inBackground();
    if (bVar1) {
      iVar2 = getBGCount();
      FUN_005a0b10(iVar2);
      *(undefined4 *)(param_1 + 0x19c) = 1;
      return;
    }
    if ((*(int *)(param_1 + 0x1a4) < 0) ||
       (iVar2 = FUN_004f5970(*(int *)(param_1 + 0x1a4)), *(char *)(iVar2 + 0x59b) == '\0')) {
      uVar3 = FUN_00546840();
      FUN_005a0b10(uVar3);
    }
    else {
      iVar2 = FUN_004f5970(*(undefined4 *)(param_1 + 0x1a4));
      if ((_DAT_006f73c0 < *(float *)(iVar2 + 0x1946)) && (iVar2 != DAT_00760b38)) {
        if ((float)*(int *)(iVar2 + 0x1b1a) < _DAT_006ea620 !=
            (NAN((float)*(int *)(iVar2 + 0x1b1a)) || NAN(_DAT_006ea620))) {
          *(undefined4 *)(iVar2 + 0x1b1a) = 9;
        }
        FUN_0052a1b0(&DAT_00bcf80c);
        *(undefined4 *)(param_1 + 0x19c) = 1;
        return;
      }
    }
  }
  *(undefined4 *)(param_1 + 0x19c) = 1;
  return;
}

