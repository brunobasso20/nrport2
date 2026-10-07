/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004eaea0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004eaea0(int param_1_00,int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  int *piVar3;
  int *piVar4;
  float10 fVar5;
  
  if (param_2 == 0) {
    param_2 = *(int *)(param_1_00 + 0x7a4);
    if (param_2 != 0) {
      if (param_1 == 1) {
        if (*(int *)(param_1_00 + 0x7b4) != 0) {
          iVar2 = *(int *)(**(int **)(param_1_00 + 0x7b0) + 0xb9);
          if (0 < param_2) {
            piVar4 = *(int **)(param_1_00 + 0x610 + iVar2 * 4);
            piVar3 = *(int **)(param_1_00 + 0x7a0);
            do {
              iVar1 = **(int **)(param_1_00 + 0x610 + *(int *)(*piVar3 + 0xb9) * 4);
              fVar5 = (float10)(**(code **)(*piVar4 + 0x1c))();
              (**(code **)(iVar1 + 0x18))((float)((float10)_DAT_006e97d8 - fVar5));
              piVar3 = piVar3 + 1;
              param_2 = param_2 + -1;
            } while (param_2 != 0);
          }
          param_2 = *(int *)(param_1_00 + 0x7ac);
          if (0 < param_2) {
            piVar4 = *(int **)(param_1_00 + 0x610 + iVar2 * 4);
            piVar3 = *(int **)(param_1_00 + 0x7a8);
            do {
              iVar2 = **(int **)(param_1_00 + 0x610 + *(int *)(*piVar3 + 0xb9) * 4);
              fVar5 = (float10)(**(code **)(*piVar4 + 0x1c))();
              (**(code **)(iVar2 + 0x18))((float)((float10)_DAT_006e97d8 - fVar5));
              piVar3 = piVar3 + 1;
              param_2 = param_2 + -1;
            } while (param_2 != 0);
            return;
          }
        }
      }
      else {
        if (0 < param_2) {
          piVar4 = *(int **)(param_1_00 + 0x7a0);
          do {
            (**(code **)(**(int **)(param_1_00 + 0x610 + *(int *)(*piVar4 + 0xb9) * 4) + 0x14))();
            piVar4 = piVar4 + 1;
            param_2 = param_2 + -1;
          } while (param_2 != 0);
        }
        iVar2 = *(int *)(param_1_00 + 0x7ac);
        if (0 < iVar2) {
          piVar4 = *(int **)(param_1_00 + 0x7a8);
          do {
            (**(code **)(**(int **)(param_1_00 + 0x610 + *(int *)(*piVar4 + 0xb9) * 4) + 0x14))();
            piVar4 = piVar4 + 1;
            iVar2 = iVar2 + -1;
          } while (iVar2 != 0);
          return;
        }
      }
    }
  }
  else if ((param_2 == 1) && (param_2 = *(int *)(param_1_00 + 0x7b4), param_2 != 0)) {
    if (param_1 == 0) {
      if (*(int *)(param_1_00 + 0x7a4) != 0) {
        iVar2 = *(int *)(**(int **)(param_1_00 + 0x7a0) + 0xb9);
        if (0 < param_2) {
          piVar4 = *(int **)(param_1_00 + 0x610 + iVar2 * 4);
          piVar3 = *(int **)(param_1_00 + 0x7b0);
          do {
            iVar1 = **(int **)(param_1_00 + 0x610 + *(int *)(*piVar3 + 0xb9) * 4);
            fVar5 = (float10)(**(code **)(*piVar4 + 0x1c))();
            (**(code **)(iVar1 + 0x18))((float)((float10)_DAT_006e97d8 - fVar5));
            piVar3 = piVar3 + 1;
            param_2 = param_2 + -1;
          } while (param_2 != 0);
        }
        param_2 = *(int *)(param_1_00 + 0x7bc);
        if (0 < param_2) {
          piVar4 = *(int **)(param_1_00 + 0x610 + iVar2 * 4);
          piVar3 = *(int **)(param_1_00 + 0x7b8);
          do {
            iVar2 = **(int **)(param_1_00 + 0x610 + *(int *)(*piVar3 + 0xb9) * 4);
            fVar5 = (float10)(**(code **)(*piVar4 + 0x1c))();
            (**(code **)(iVar2 + 0x18))((float)((float10)_DAT_006e97d8 - fVar5));
            piVar3 = piVar3 + 1;
            param_2 = param_2 + -1;
          } while (param_2 != 0);
          return;
        }
      }
    }
    else {
      if (0 < param_2) {
        piVar4 = *(int **)(param_1_00 + 0x7b0);
        do {
          (**(code **)(**(int **)(param_1_00 + 0x610 + *(int *)(*piVar4 + 0xb9) * 4) + 0x14))();
          piVar4 = piVar4 + 1;
          param_2 = param_2 + -1;
        } while (param_2 != 0);
      }
      iVar2 = *(int *)(param_1_00 + 0x7bc);
      if (0 < iVar2) {
        piVar4 = *(int **)(param_1_00 + 0x7b8);
        do {
          (**(code **)(**(int **)(param_1_00 + 0x610 + *(int *)(*piVar4 + 0xb9) * 4) + 0x14))();
          piVar4 = piVar4 + 1;
          iVar2 = iVar2 + -1;
        } while (iVar2 != 0);
      }
    }
  }
  return;
}


