/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00568c60 */

void FUN_00568c60(undefined4 *param_1)

{
  undefined4 *puVar1;
  int iVar2;
  int *piVar3;
  
  if (param_1[1] != 0) {
    piVar3 = (int *)FUN_006c4980();
    puVar1 = (undefined4 *)param_1[1];
    if (puVar1 != (undefined4 *)*piVar3) {
      if ((puVar1 != (undefined4 *)0x0) &&
         (iVar2 = puVar1[1], puVar1[1] = iVar2 + -1, iVar2 + -1 == 0)) {
        (**(code **)*puVar1)(1);
      }
      iVar2 = *piVar3;
      param_1[1] = iVar2;
      if (iVar2 != 0) {
        *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
      }
    }
    FUN_006c4a00();
  }
  *param_1 = 0;
  param_1[2] = 0;
  *(undefined1 *)((int)param_1 + 0x15e) = 0;
  piVar3 = (int *)FUN_004ed0c0();
  puVar1 = *(undefined4 **)((int)param_1 + 0x18e);
  if (puVar1 != (undefined4 *)*piVar3) {
    if ((puVar1 != (undefined4 *)0x0) &&
       (iVar2 = puVar1[1], puVar1[1] = iVar2 + -1, iVar2 + -1 == 0)) {
      (**(code **)*puVar1)(1);
    }
    iVar2 = *piVar3;
    *(int *)((int)param_1 + 0x18e) = iVar2;
    if (iVar2 != 0) {
      *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
    }
  }
  FUN_004ed160();
  *(undefined4 *)((int)param_1 + 0x186) = 0;
  *(undefined4 *)((int)param_1 + 0x18a) = 0;
  return;
}


