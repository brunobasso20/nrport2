/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00572a80 */

undefined4 FUN_00572a80(char param_1)

{
  int *piVar1;
  int iVar2;
  int *piVar3;
  undefined4 uVar4;
  int *piVar5;
  
  piVar1 = DAT_00c72138 + DAT_00c7212c;
  piVar3 = DAT_00c72138;
  while (piVar3 != piVar1) {
    piVar5 = piVar3 + 1;
    iVar2 = *piVar3;
    piVar3 = piVar5;
    if ((iVar2 != 0) && (*(int **)(iVar2 + 0x18) != (int *)0x0)) {
      if (param_1 == '\0') {
        uVar4 = *(undefined4 *)(iVar2 + 0x10);
      }
      else {
        uVar4 = *(undefined4 *)(iVar2 + 0x14);
      }
      (**(code **)(**(int **)(iVar2 + 0x18) + 0x10))(uVar4);
    }
  }
  return 1;
}


