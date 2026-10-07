/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00582e80 */

void FUN_00582e80(int *param_1)

{
  int iVar1;
  
  iVar1 = *(int *)(&DAT_00d6a1c8 + DAT_00d77358 * 4);
  DAT_00d77358 = DAT_00d77358 + 1;
  *(int *)(iVar1 + 0x24) = *param_1;
  *param_1 = iVar1;
  return;
}


