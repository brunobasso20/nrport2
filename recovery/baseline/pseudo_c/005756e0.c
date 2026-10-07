/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005756e0 */

void __thiscall FUN_005756e0(int param_1_00,undefined4 param_1)

{
  int iVar1;
  int *piVar2;
  
  for (iVar1 = *(int *)(param_1_00 + 0x10); iVar1 != 0; iVar1 = *(int *)(iVar1 + 0x18)) {
    *(undefined4 *)(iVar1 + 0x1c) = param_1;
  }
  for (piVar2 = *(int **)(param_1_00 + 0xc); piVar2 != (int *)0x0; piVar2 = (int *)piVar2[2]) {
    (**(code **)(*piVar2 + 0x10))(param_1);
  }
  return;
}


