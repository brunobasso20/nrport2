/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00401bc0 */

undefined4 FUN_00401bc0(int param_1)

{
  int iVar1;
  
  iVar1 = FUN_00509b60(0xffffffff);
  if (1 < iVar1) {
    iVar1 = FUN_00509b60(0xffffffff);
    if ((iVar1 != 2) || (*(int *)(param_1 + 0x1b0a) < 1)) {
      return 0;
    }
  }
  *(undefined4 *)(param_1 + 0x18fe) = 0;
  *(undefined4 *)(param_1 + 0x1906) = 0;
  *(undefined4 *)(param_1 + 0x1902) = 0;
  return 1;
}


