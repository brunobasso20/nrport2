/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00579a90 */

int * __thiscall FUN_00579a90(int *param_1_00,int *param_1)

{
  int iVar1;
  
  param_1_00[*param_1_00 + 1] = *param_1;
  iVar1 = *param_1_00;
  *param_1_00 = iVar1 + 1;
  return param_1_00 + iVar1 + 1;
}


