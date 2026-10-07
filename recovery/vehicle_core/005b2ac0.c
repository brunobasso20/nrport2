/* Ghidra pseudo-C; NR2003.exe @ 005b2ac0 */

void FUN_005b2ac0(undefined4 param_1,int param_2)

{
  int iVar1;
  int iVar2;
  
  iVar1 = *(int *)(param_2 + 0x71);
  if (*(int *)(param_2 + 0x71) != 0) {
    do {
      iVar2 = iVar1;
      iVar1 = *(int *)(iVar2 + 0x71);
    } while (iVar1 != 0);
    *(undefined4 *)(iVar2 + 0x71) = param_1;
    return;
  }
  *(undefined4 *)(param_2 + 0x71) = param_1;
  return;
}

