/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f69a0 */

void __thiscall FUN_004f69a0(int param_1_00,undefined4 *param_1)

{
  int *piVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  
  iVar5 = 0;
  iVar2 = 0;
  iVar3 = 0x600;
  if (0 < *(int *)(param_1_00 + 4)) {
    iVar4 = 0;
    do {
      piVar1 = (int *)(*(int *)(param_1_00 + 8) + iVar4);
      LOCK();
      *piVar1 = *piVar1 + 1;
      UNLOCK();
      if ((*piVar1 == 0) && (*(int *)(*(int *)(param_1_00 + 8) + 4 + iVar4) < iVar3)) {
        iVar3 = *(int *)(*(int *)(param_1_00 + 8) + 4 + iVar4);
        iVar2 = iVar5;
      }
      piVar1 = (int *)(*(int *)(param_1_00 + 8) + iVar4);
      LOCK();
      *piVar1 = *piVar1 + -1;
      UNLOCK();
      iVar5 = iVar5 + 1;
      iVar4 = iVar4 + 0xc;
    } while (iVar5 < *(int *)(param_1_00 + 4));
  }
  while( true ) {
    piVar1 = (int *)(*(int *)(param_1_00 + 8) + iVar2 * 0xc);
    LOCK();
    *piVar1 = *piVar1 + 1;
    UNLOCK();
    if (*piVar1 == 0) break;
    piVar1 = (int *)(*(int *)(param_1_00 + 8) + iVar2 * 0xc);
    LOCK();
    *piVar1 = *piVar1 + -1;
    UNLOCK();
    iVar2 = (iVar2 + 1) % *(int *)(param_1_00 + 4);
  }
  iVar2 = iVar2 * 0xc;
  *param_1 = *(undefined4 *)(*(int *)(param_1_00 + 8) + 8 + iVar2);
  *(undefined4 **)(*(int *)(param_1_00 + 8) + 8 + iVar2) = param_1;
  *(int *)(*(int *)(param_1_00 + 8) + 4 + iVar2) =
       *(int *)(*(int *)(param_1_00 + 8) + 4 + iVar2) + 1;
  piVar1 = (int *)(*(int *)(param_1_00 + 8) + iVar2);
  LOCK();
  *piVar1 = *piVar1 + -1;
  UNLOCK();
  return;
}


