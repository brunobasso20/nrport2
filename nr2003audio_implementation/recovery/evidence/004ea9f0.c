/* NR2003.exe @ 004ea9f0 FUN_004ea9f0 */

void FUN_004ea9f0(int param_1,int param_2,int param_3,int param_4)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int *piVar4;
  int iVar5;

  iVar2 = 0;
  if ((param_1 != 0) && (iVar5 = *(int *)(param_1 + 0x1820), 0 < iVar5)) {
    piVar4 = (int *)(param_1 + 0x17a0);
    do {
      iVar1 = *piVar4;
      if (*(int *)(iVar1 + 0xa8) == param_2) {
        iVar3 = 0;
        if (0 < iVar2) {
          do {
            if (*(int *)(param_3 + iVar3 * 4) == *(int *)(iVar1 + 0xb0)) break;
            iVar3 = iVar3 + 1;
          } while (iVar3 < iVar2);
        }
        if ((iVar3 == iVar2) && (iVar2 < param_4)) {
          *(undefined4 *)(param_3 + iVar2 * 4) = *(undefined4 *)(iVar1 + 0xb0);
          iVar2 = iVar2 + 1;
        }
      }
      piVar4 = piVar4 + 1;
      iVar5 = iVar5 + -1;
    } while (iVar5 != 0);
  }
  return;
}
