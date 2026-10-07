/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005632f0 */

void FUN_005632f0(int param_1)

{
  int iVar1;
  undefined4 *puVar2;
  int *piVar3;
  int *piVar4;
  int iVar5;
  
  iVar5 = 4;
  piVar4 = (int *)(param_1 + 0x1186);
  do {
    if (*piVar4 != 0) {
      piVar3 = (int *)FUN_004ed0c0();
      if (*piVar4 != *piVar3) {
        if (*piVar4 != 0) {
          FUN_004c0e30();
        }
        iVar1 = *piVar3;
        *piVar4 = iVar1;
        if (iVar1 != 0) {
          *(int *)(iVar1 + 4) = *(int *)(iVar1 + 4) + 1;
        }
      }
      FUN_004ed160();
    }
    piVar4 = piVar4 + 1;
    iVar5 = iVar5 + -1;
  } while (iVar5 != 0);
  piVar4 = (int *)(param_1 + 0x11a6);
  iVar5 = 4;
  do {
    if (*piVar4 != 0) {
      piVar3 = (int *)FUN_004ed0c0();
      puVar2 = (undefined4 *)*piVar4;
      if (puVar2 != (undefined4 *)*piVar3) {
        if ((puVar2 != (undefined4 *)0x0) &&
           (iVar1 = puVar2[1], puVar2[1] = iVar1 + -1, iVar1 + -1 == 0)) {
          (**(code **)*puVar2)(1);
        }
        *piVar4 = *piVar3;
        FUN_00483be0();
      }
      FUN_004ed160();
    }
    piVar4 = piVar4 + 1;
    iVar5 = iVar5 + -1;
  } while (iVar5 != 0);
  piVar4 = (int *)(param_1 + 0x11bb);
  iVar5 = 4;
  do {
    if (*piVar4 != 0) {
      piVar3 = (int *)FUN_004ed0c0();
      puVar2 = (undefined4 *)*piVar4;
      if (puVar2 != (undefined4 *)*piVar3) {
        if ((puVar2 != (undefined4 *)0x0) &&
           (iVar1 = puVar2[1], puVar2[1] = iVar1 + -1, iVar1 + -1 == 0)) {
          (**(code **)*puVar2)(1);
        }
        iVar1 = *piVar3;
        *piVar4 = iVar1;
        if (iVar1 != 0) {
          *(int *)(iVar1 + 4) = *(int *)(iVar1 + 4) + 1;
        }
      }
      FUN_004ed160();
    }
    piVar4 = piVar4 + 1;
    iVar5 = iVar5 + -1;
  } while (iVar5 != 0);
  if (*(int *)(param_1 + 0x13af) != 0) {
    piVar4 = (int *)FUN_004ed0c0();
    puVar2 = *(undefined4 **)(param_1 + 0x13af);
    if (puVar2 != (undefined4 *)*piVar4) {
      if ((puVar2 != (undefined4 *)0x0) &&
         (iVar5 = puVar2[1], puVar2[1] = iVar5 + -1, iVar5 + -1 == 0)) {
        (**(code **)*puVar2)(1);
      }
      iVar5 = *piVar4;
      *(int *)(param_1 + 0x13af) = iVar5;
      if (iVar5 != 0) {
        *(int *)(iVar5 + 4) = *(int *)(iVar5 + 4) + 1;
      }
    }
    FUN_004ed160();
    return;
  }
  return;
}


