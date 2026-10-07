/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00579900 */

void __fastcall FUN_00579900(int *param_1)

{
  int iVar1;
  
  iVar1 = param_1[7];
  if (iVar1 != 0) {
    if (-1 < param_1[0xb]) {
      (**(code **)(*param_1 + 4))(iVar1,param_1 + 8,param_1[0xb]);
      param_1[0xb] = -1;
      param_1[7] = 0;
      return;
    }
    (**(code **)(*param_1 + 8))(iVar1);
    param_1[7] = 0;
  }
  return;
}


