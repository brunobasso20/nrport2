/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573480 */

undefined4 FUN_00573480(void)

{
  int *piVar1;
  int iVar2;
  int *piVar3;
  
  piVar1 = DAT_00c72138 + DAT_00c7212c;
  piVar3 = DAT_00c72138;
  while (piVar3 != piVar1) {
    iVar2 = *piVar3;
    if (*(int **)(iVar2 + 0x10) != (int *)0x0) {
      (**(code **)(**(int **)(iVar2 + 0x10) + 4))();
    }
    if (*(int **)(iVar2 + 0x14) != (int *)0x0) {
      (**(code **)(**(int **)(iVar2 + 0x14) + 4))();
    }
    FUN_005cfccc(iVar2);
    piVar3 = piVar3 + 1;
  }
  if (DAT_00c72138 != (int *)0x0) {
    FUN_005cfccc(DAT_00c72138);
    DAT_00c72138 = (int *)0x0;
    DAT_00c7212c = 0;
    DAT_00c72130 = 0;
  }
  return 1;
}


