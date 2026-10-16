/* NR2003.exe @ 004ebe10 recovered_004ebe10 */

int __thiscall recovered_004ebe10(int param_1,int param_2)

{
  int *piVar1;
  bool bVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  int **ppiVar6;
  int *piVar7;
  float10 fVar8;
  undefined4 uVar9;

  if (*(int *)(param_1 + 0x14) == 0) {
    return 0;
  }
  iVar5 = *(int *)(*(int *)(param_1 + 0x14) + 0x1c);
  if (iVar5 == 0) {
    iVar5 = *(int *)(param_1 + 0x7a4);
    if (iVar5 == 0) {
      return param_2;
    }
    iVar3 = *(int *)(param_1 + 0x7ac);
    bVar2 = false;
    if (0 < iVar3) {
      piVar7 = *(int **)(param_1 + 0x7a8);
      do {
        piVar1 = *(int **)(param_1 + 0x610 + *(int *)(*piVar7 + 0xb9) * 4);
        if ((piVar1 != (int *)0x0) && (iVar4 = (**(code **)(*piVar1 + 0x10))(), iVar4 == param_2)) {
          bVar2 = true;
        }
        piVar7 = piVar7 + 1;
        iVar3 = iVar3 + -1;
      } while (iVar3 != 0);
    }
    if (0 < iVar5) {
      piVar7 = *(int **)(param_1 + 0x7a0);
      do {
        piVar1 = *(int **)(param_1 + 0x610 + *(int *)(*piVar7 + 0xb9) * 4);
        if ((piVar1 != (int *)0x0) && (iVar3 = (**(code **)(*piVar1 + 0x10))(), iVar3 == param_2)) {
          bVar2 = true;
        }
        piVar7 = piVar7 + 1;
        iVar5 = iVar5 + -1;
      } while (iVar5 != 0);
    }
    if (bVar2) {
      return param_2;
    }
    if (*(char *)(param_1 + 0x7c0) == '\0') {
      return param_2;
    }
    *(undefined *)(param_1 + 0x7c3) = 0;
    fVar8 = (float10)FUN_004eebf0();
    uVar9 = 2;
  }
  else {
    if (iVar5 != 1) {
      if (iVar5 != 2) {
        return param_2;
      }
      iVar5 = *(int *)(*(int *)(param_1 + 0x28) + 0x1820);
      if (iVar5 < 1) {
        return param_2;
      }
      ppiVar6 = (int **)(param_1 + 0x610);
      piVar7 = (int *)(*(int *)(param_1 + 0x28) + 0x17a0);
      do {
        if ((*ppiVar6 != (int *)0x0) && (*(int *)(*piVar7 + 0xa4) == 0)) {
          (**(code **)(**ppiVar6 + 0x10))();
        }
        piVar7 = piVar7 + 1;
        ppiVar6 = ppiVar6 + 1;
        iVar5 = iVar5 + -1;
      } while (iVar5 != 0);
      return param_2;
    }
    if (*(int *)(param_1 + 0x7b4) == 0) {
      return param_2;
    }
    iVar5 = *(int *)(param_1 + 0x7bc);
    bVar2 = false;
    if (0 < iVar5) {
      piVar7 = *(int **)(param_1 + 0x7b8);
      do {
        piVar1 = *(int **)(param_1 + 0x610 + *(int *)(*piVar7 + 0xb9) * 4);
        if ((piVar1 != (int *)0x0) && (iVar3 = (**(code **)(*piVar1 + 0x10))(), iVar3 == param_2)) {
          bVar2 = true;
        }
        piVar7 = piVar7 + 1;
        iVar5 = iVar5 + -1;
      } while (iVar5 != 0);
    }
    iVar5 = *(int *)(param_1 + 0x7b4);
    if (0 < iVar5) {
      piVar7 = *(int **)(param_1 + 0x7b0);
      do {
        piVar1 = *(int **)(param_1 + 0x610 + *(int *)(*piVar7 + 0xb9) * 4);
        if ((piVar1 != (int *)0x0) && (iVar3 = (**(code **)(*piVar1 + 0x10))(), iVar3 == param_2)) {
          bVar2 = true;
        }
        piVar7 = piVar7 + 1;
        iVar5 = iVar5 + -1;
      } while (iVar5 != 0);
    }
    if (bVar2) {
      return param_2;
    }
    if (*(char *)(param_1 + 0x7c0) == '\0') {
      return param_2;
    }
    fVar8 = (float10)FUN_004eebf0();
    uVar9 = 3;
  }
  FUN_004f02d0(uVar9,(double)fVar8);
  return param_2;
}
