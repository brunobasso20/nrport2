/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00564a80 */

void FUN_00564a80(int param_1)

{
  undefined4 *puVar1;
  int iVar2;
  int *piVar3;
  
  if (param_1 != 0) {
    piVar3 = (int *)FUN_004ed0c0();
    puVar1 = *(undefined4 **)(param_1 + 0x13af);
    if (puVar1 != (undefined4 *)*piVar3) {
      if ((puVar1 != (undefined4 *)0x0) &&
         (iVar2 = puVar1[1], puVar1[1] = iVar2 + -1, iVar2 + -1 == 0)) {
        (**(code **)*puVar1)(1);
      }
      iVar2 = *piVar3;
      *(int *)(param_1 + 0x13af) = iVar2;
      if (iVar2 != 0) {
        *(int *)(iVar2 + 4) = *(int *)(iVar2 + 4) + 1;
      }
    }
    FUN_004ed160();
    return;
  }
  return;
}


