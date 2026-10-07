/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b50c0 */

void __fastcall FUN_005b50c0(undefined4 *param_1)

{
  int iVar1;
  
  *param_1 = 0;
  param_1[1] = 0;
  param_1 = (undefined4 *)((int)param_1 + 0x27);
  iVar1 = 0x400;
  do {
    *param_1 = 0x80000000;
    param_1 = (undefined4 *)((int)param_1 + 0x23);
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}


