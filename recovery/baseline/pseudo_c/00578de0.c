/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578de0 */

void __fastcall FUN_00578de0(int param_1)

{
  int iVar1;
  int iVar2;
  
  iVar1 = *(int *)(param_1 + 0x6c18);
  for (iVar2 = param_1 + 0x6c1c; iVar2 != param_1 + 0x6c1c + iVar1 * 4; iVar2 = iVar2 + 4) {
    FUN_00577fa0();
    FUN_00578110();
  }
  return;
}


