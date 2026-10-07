/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f6900 */

undefined4 __fastcall FUN_004f6900(int param_1)

{
  undefined4 uVar1;
  int *piVar2;
  int iVar3;
  int iVar4;
  
  iVar4 = 0;
  if (0 < *(int *)(param_1 + 4)) {
    iVar3 = 0;
    do {
      piVar2 = (int *)(*(int *)(param_1 + 8) + iVar3);
      LOCK();
      *piVar2 = *piVar2 + 1;
      UNLOCK();
      if ((*piVar2 == 0) && (*(int *)(*(int *)(param_1 + 8) + 8 + iVar3) != 0)) {
        iVar3 = *(int *)(param_1 + 8);
        iVar4 = iVar4 * 0xc;
        uVar1 = *(undefined4 *)(iVar3 + 8 + iVar4);
        *(undefined4 *)(iVar3 + 8 + iVar4) = **(undefined4 **)(iVar3 + 8 + iVar4);
        *(int *)(*(int *)(param_1 + 8) + 4 + iVar4) =
             *(int *)(*(int *)(param_1 + 8) + 4 + iVar4) + -1;
        piVar2 = (int *)(*(int *)(param_1 + 8) + iVar4);
        LOCK();
        *piVar2 = *piVar2 + -1;
        UNLOCK();
        return uVar1;
      }
      piVar2 = (int *)(*(int *)(param_1 + 8) + iVar3);
      LOCK();
      *piVar2 = *piVar2 + -1;
      UNLOCK();
      iVar4 = iVar4 + 1;
      iVar3 = iVar3 + 0xc;
    } while (iVar4 < *(int *)(param_1 + 4));
  }
  return 0;
}


