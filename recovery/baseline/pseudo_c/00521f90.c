/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00521f90 */

void __fastcall FUN_00521f90(int param_1)

{
  int iVar1;
  int iVar2;
  
  iVar2 = 0;
  iVar1 = FUN_0040ece0();
  if (0 < iVar1) {
    do {
      *(undefined1 *)(param_1 + 0xb3b + iVar2) = 0;
      iVar2 = iVar2 + 1;
      iVar1 = FUN_0040ece0();
    } while (iVar2 < iVar1);
  }
  FUN_0040eed0();
  *(undefined4 *)(param_1 + 0x8f) = 1;
  *(undefined4 *)(param_1 + 0x93) = 0;
  return;
}


