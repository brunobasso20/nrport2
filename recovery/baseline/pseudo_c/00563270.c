/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00563270 */

void FUN_00563270(int param_1)

{
  int iVar1;
  
  iVar1 = FUN_00562f70(param_1);
  if (*(int *)(iVar1 + 4) != 0) {
    FUN_00563730(iVar1);
  }
  FUN_00539380(param_1);
  (&DAT_00c125ca)[param_1 * 0x15b8] = 0;
  return;
}


