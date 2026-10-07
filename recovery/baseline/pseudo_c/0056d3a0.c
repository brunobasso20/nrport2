/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056d3a0 */

void __thiscall FUN_0056d3a0(int param_1_00,int *param_1)

{
  int iVar1;
  int iVar2;
  
  iVar2 = *(int *)(param_1_00 + 0xc);
  if (iVar2 == 0) {
    iVar2 = param_1_00 + 4;
  }
  else {
    iVar1 = *(int *)(iVar2 + 8);
    if (*(int *)(iVar2 + 8) != 0) {
      do {
        iVar2 = iVar1;
        iVar1 = *(int *)(iVar2 + 8);
      } while (iVar1 != 0);
      *param_1 = iVar2;
      return;
    }
  }
  *param_1 = iVar2;
  return;
}


