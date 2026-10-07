/* Ghidra pseudo-C; NR2003.exe @ 005b39e0 */

void FUN_005b39e0(int param_1,undefined4 param_2,undefined4 param_3)

{
  int iVar1;
  
  iVar1 = FUN_005b3a90(param_1);
  if (iVar1 == 0) {
    FUN_005b7df0(&DAT_00e84644,param_3,param_2);
    FUN_005b7d70(param_1 + 0x2cd,param_1 + 0x1e5,&DAT_00e84644);
  }
  FUN_005b8180(param_1 + 0x309,param_1 + 0x1c1);
  FUN_005b7d10(param_1 + 0x2fd,param_1 + 0x1b5);
  FUN_005b8370(&DAT_00e84644,param_1 + 0x309,param_1 + 0x2cd);
  FUN_005b7d70(param_1 + 0x32d,&DAT_00e84644,param_1 + 0x2fd);
  FUN_005b3ae0(param_1,param_2,param_3);
  return;
}

