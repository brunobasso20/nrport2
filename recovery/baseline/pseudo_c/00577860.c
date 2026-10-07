/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577860 */

void __fastcall FUN_00577860(int param_1)

{
  int iVar1;
  int iVar2;
  
  iVar2 = *(int *)(param_1 + 8);
  while (iVar2 != 0) {
    iVar1 = *(int *)(iVar2 + 0xc);
    FUN_00577860();
    FUN_00577ad0(iVar2);
    iVar2 = iVar1;
  }
  *(undefined4 *)(param_1 + 8) = 0;
  *(undefined4 *)(param_1 + 0xc) = 0;
  return;
}


