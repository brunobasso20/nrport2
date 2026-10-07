/* NR2003.exe @ 00558830 FUN_00558830 */

int __thiscall FUN_00558830(int param_1_00,int param_1,int param_2,int param_3)

{
  int iVar1;
  int iVar2;
  int *piVar3;
  int iVar4;
  
  iVar4 = *(int *)(&DAT_006ed7f0 + param_2 * 4);
  iVar2 = 0;
  if (param_1 == 0) {
    FUN_00557d20();
  }
  if (0 < iVar4) {
    piVar3 = &DAT_00c05152;
    iVar4 = iVar4 + 1;
    do {
      if ((*piVar3 != 0) && (*(int *)(*piVar3 + 0x12) != 0)) {
        iVar1 = FUN_005587e0(param_1,iVar2 + param_3,param_1_00,4);
        iVar2 = iVar2 + iVar1;
      }
      piVar3 = (int *)((int)piVar3 + 6);
      param_1_00 = param_1_00 + 4;
      iVar4 = iVar4 + -1;
    } while (iVar4 != 0);
    if (param_1 == 0) {
      FUN_00559820();
    }
    return iVar2;
  }
  return 0;
}

