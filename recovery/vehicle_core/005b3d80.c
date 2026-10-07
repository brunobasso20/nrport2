/* Ghidra pseudo-C; NR2003.exe @ 005b3d80 */

void FUN_005b3d80(int param_1,undefined4 param_2,undefined4 param_3)

{
  int iVar1;
  
  iVar1 = FUN_005b3a90(param_1);
  if (iVar1 == 0) {
    FUN_005b7df0(&DAT_00e84658,param_3,param_2);
    FUN_005b7d70(param_1 + 0x2cd,param_1 + 0x1e5,&DAT_00e84658);
  }
  FUN_005b8260(param_1 + 0x309,*(int *)(param_1 + 0x6d) + 0x339,param_1 + 0x1c1);
  FUN_005b8370(&DAT_00e84658,*(int *)(param_1 + 0x6d) + 0x339,param_1 + 0x1b5);
  FUN_005b7d70(param_1 + 0x2fd,&DAT_00e84658,*(int *)(param_1 + 0x6d) + 0x32d);
  FUN_005b8370(&DAT_00e84658,param_1 + 0x309,param_1 + 0x2cd);
  FUN_005b7d70(param_1 + 0x32d,&DAT_00e84658,param_1 + 0x2fd);
  FUN_005b3ae0(param_1,param_2,param_3);
  return;
}

