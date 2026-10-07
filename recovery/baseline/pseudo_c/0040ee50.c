/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040ee50 */

undefined4 __thiscall FUN_0040ee50(int param_1_00,int param_1)

{
  int iVar1;
  
  if (param_1 == 9) {
    if (*(char *)(param_1_00 + 0x8d) == '\0') {
      iVar1 = FUN_005099b0();
    }
    else {
      iVar1 = FUN_00567280();
    }
    if (iVar1 != 7) {
      return 0;
    }
  }
  return 1;
}


