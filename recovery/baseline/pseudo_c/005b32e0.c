/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b32e0 */

void FUN_005b32e0(int param_1)

{
  int iVar1;
  
  iVar1 = param_1 + 0x1c1;
  FUN_005b8370(&DAT_00e847ec,iVar1,param_1 + 0x2cd);
  FUN_005b7d70(&DAT_00e847ec,&DAT_00e847ec,param_1 + 0x1b5);
  FUN_005b8880(&DAT_00e84618,&DAT_00e847ec);
  FUN_005b8260(&DAT_00e84618,&DAT_00e84618,iVar1);
  FUN_005b8260(&DAT_00e8444c,*(int *)(param_1 + 0x6d) + 0x2d9,iVar1);
  FUN_005b8260(&DAT_00e84420,iVar1,param_1 + 0x2d9);
  FUN_005b94e0(param_1 + 0x3e5,&DAT_00e8444c,&PTR_DAT_006f7484,&DAT_00e84618,&DAT_00e84420);
  return;
}


