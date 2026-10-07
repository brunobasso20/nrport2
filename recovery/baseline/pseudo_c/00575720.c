/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00575720 */

void __thiscall
FUN_00575720(int param_1_00,undefined4 param_1,undefined4 *param_2,undefined4 param_3)

{
  int iVar1;
  int *piVar2;
  
  for (iVar1 = *(int *)(param_1_00 + 0x10); iVar1 != 0; iVar1 = *(int *)(iVar1 + 0x18)) {
    *(undefined4 *)(iVar1 + 0x1c) = param_1;
    *(undefined4 *)(iVar1 + 0x20) = *param_2;
    *(undefined4 *)(iVar1 + 0x24) = param_2[1];
    *(undefined4 *)(iVar1 + 0x28) = param_2[2];
    *(undefined4 *)(iVar1 + 0x2c) = param_3;
  }
  for (piVar2 = *(int **)(param_1_00 + 0xc); piVar2 != (int *)0x0; piVar2 = (int *)piVar2[2]) {
    (**(code **)(*piVar2 + 0xc))(param_1,param_2,param_3);
  }
  return;
}


