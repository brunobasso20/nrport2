/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577ee0 */

void __fastcall FUN_00577ee0(int *param_1)

{
  int iVar1;
  int *piVar2;
  undefined4 *puVar3;
  
  iVar1 = *(int *)((int)param_1 + 0x3a);
  if (iVar1 != 0) {
    FUN_00577860();
    FUN_00577ad0(iVar1);
  }
  *(undefined4 *)((int)param_1 + 0x3a) = 0;
  **(undefined4 **)((int)param_1 + 0x46) = *(undefined4 *)((int)param_1 + 0x42);
  piVar2 = *(int **)((int)param_1 + 0x42);
  if (piVar2 != (int *)0x0) {
    if (*param_1 == *piVar2) {
      *(undefined4 *)((int)piVar2 + 0x46) = *(undefined4 *)((int)param_1 + 0x46);
    }
    else if (*param_1 == piVar2[1]) {
      *(undefined4 *)((int)piVar2 + 0x4e) = *(undefined4 *)((int)param_1 + 0x46);
    }
  }
  *(undefined4 *)((int)param_1 + 0x46) = 0;
  **(undefined4 **)((int)param_1 + 0x4e) = *(undefined4 *)((int)param_1 + 0x4a);
  piVar2 = *(int **)((int)param_1 + 0x4a);
  if (piVar2 != (int *)0x0) {
    if (param_1[1] == piVar2[1]) {
      *(undefined4 *)((int)piVar2 + 0x4e) = *(undefined4 *)((int)param_1 + 0x4e);
    }
    else if (param_1[1] == *piVar2) {
      *(undefined4 *)((int)piVar2 + 0x46) = *(undefined4 *)((int)param_1 + 0x4e);
    }
  }
  puVar3 = (undefined4 *)*param_1;
  *(undefined4 *)((int)param_1 + 0x4e) = 0;
  if (puVar3 != (undefined4 *)0x0) {
    iVar1 = puVar3[0xf];
    puVar3[0xf] = iVar1 + -1;
    if (iVar1 + -1 < 1) {
      (**(code **)*puVar3)(1);
    }
    *param_1 = 0;
  }
  puVar3 = (undefined4 *)param_1[1];
  if (puVar3 != (undefined4 *)0x0) {
    iVar1 = puVar3[0xf];
    puVar3[0xf] = iVar1 + -1;
    if (iVar1 + -1 < 1) {
      (**(code **)*puVar3)(1);
    }
    param_1[1] = 0;
  }
  return;
}


