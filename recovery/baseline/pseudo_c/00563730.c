/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00563730 */

void FUN_00563730(int param_1)

{
  int iVar1;
  int iVar2;
  
  iVar2 = *(int *)(param_1 + 4);
  if (iVar2 == 0) {
    iVar1 = 0;
  }
  else {
    iVar1 = iVar2 + -4;
  }
  if (iVar1 == param_1) {
    DAT_00c08768 = 0;
  }
  else {
    if (param_1 == DAT_00c08768) {
      if (iVar2 == 0) {
        DAT_00c08768 = 0;
      }
      else {
        DAT_00c08768 = iVar2 + -4;
      }
    }
    iVar2 = *(int *)(param_1 + 8);
    if ((iVar2 == 0) || (iVar2 == 4)) {
      iVar2 = 0;
    }
    if (*(int *)(param_1 + 4) == 0) {
      iVar1 = 0;
    }
    else {
      iVar1 = *(int *)(param_1 + 4) + -4;
    }
    *(int *)(iVar1 + 8) = iVar2;
    iVar2 = *(int *)(param_1 + 4);
    if ((iVar2 == 0) || (iVar2 == 4)) {
      iVar2 = 0;
    }
    if (*(int *)(param_1 + 8) == 0) {
      iVar1 = 0;
    }
    else {
      iVar1 = *(int *)(param_1 + 8) + -4;
    }
    *(int *)(iVar1 + 4) = iVar2;
  }
  DAT_00c0876c = DAT_00c0876c + -1;
  *(undefined4 *)(param_1 + 4) = 0;
  FUN_005632f0();
  return;
}


