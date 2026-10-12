/* NR2003.exe @ 0042b0c0 FUN_0042b0c0 */

void FUN_0042b0c0(int param_1,int param_2)

{
  int *piVar1;
  int iVar2;
  int iVar3;
  int **ppiVar4;
  
  param_2 = param_2 + param_1 * 4;
  iVar3 = param_2 * 0x380;
  if ((*(int *)(&DAT_0087275c + iVar3) != 0) && (DAT_00c72160 != (int *)0x0)) {
    (**(code **)(*DAT_00c72160 + 0x24))(0);
  }
  ppiVar4 = (int **)(&DAT_008729a0 + iVar3);
  iVar2 = 4;
  do {
    if (ppiVar4[8] != (int *)0x0) {
      (**(code **)(*ppiVar4[8] + 4))();
    }
    if (*ppiVar4 != (int *)0x0) {
      (**(code **)(**ppiVar4 + 4))();
    }
    ppiVar4 = ppiVar4 + 1;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  if (*(int **)(&DAT_00872760 + iVar3) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00872760 + iVar3) + 4))();
  }
  *(undefined4 *)(&DAT_00872760 + iVar3) = 0;
  if (*(int **)(&DAT_00872708 + iVar3) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00872708 + iVar3) + 4))();
  }
  *(undefined4 *)(&DAT_00872708 + iVar3) = 0;
  if (*(int **)(&DAT_0087270c + iVar3) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_0087270c + iVar3) + 4))();
  }
  piVar1 = (int *)(&DAT_008726fc)[param_2 * 0xe0];
  *(undefined4 *)(&DAT_0087270c + iVar3) = 0;
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 4))();
  }
  if (*(int **)(&DAT_00872700 + iVar3) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00872700 + iVar3) + 4))();
  }
  if (*(int **)(&DAT_00872710 + iVar3) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00872710 + iVar3) + 4))();
  }
  *(undefined4 *)(&DAT_00872710 + iVar3) = 0;
  (&DAT_008726fc)[param_2 * 0xe0] = 0;
  return;
}

