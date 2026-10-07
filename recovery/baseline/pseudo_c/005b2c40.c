/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b2c40 */

int FUN_005b2c40(int param_1)

{
  uint uVar1;
  int iVar2;
  int iVar3;
  
  uVar1 = *(uint *)(param_1 + 0x40);
  iVar3 = (((int)uVar1 >> 2 & 1U) + ((int)uVar1 >> 1 & 1U) + (uVar1 & 1)) * 2;
  if ((uVar1 & 0x380) == 0) {
    if ((uVar1 & 0x18) == 0) {
      if ((uVar1 & 0x20) != 0) {
        iVar3 = iVar3 + 7;
      }
    }
    else {
      iVar3 = iVar3 + 2;
    }
  }
  else {
    iVar3 = iVar3 + 2;
  }
  if (*(int *)(param_1 + 0x75) != 0) {
    iVar2 = FUN_005b2c40(*(int *)(param_1 + 0x75));
    iVar3 = iVar3 + iVar2;
  }
  if (*(int *)(param_1 + 0x71) != 0) {
    iVar2 = FUN_005b2c40(*(int *)(param_1 + 0x71));
    iVar3 = iVar3 + iVar2;
  }
  return iVar3;
}


