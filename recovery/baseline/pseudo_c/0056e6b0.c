/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e6b0 */

void FUN_0056e6b0(undefined4 *param_1,undefined4 *param_2)

{
  int iVar1;
  
  for (iVar1 = 0x2b; iVar1 != 0; iVar1 = iVar1 + -1) {
    *param_1 = *param_2;
    param_2 = param_2 + 1;
    param_1 = param_1 + 1;
  }
  *(undefined1 *)param_1 = *(undefined1 *)param_2;
  return;
}


