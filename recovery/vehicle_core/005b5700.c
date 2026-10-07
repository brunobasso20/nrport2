/* Ghidra pseudo-C; NR2003.exe @ 005b5700 */

void FUN_005b5700(int param_1)

{
  int iVar1;
  uint uVar2;
  
  uVar2 = (uint)*(byte *)(param_1 + 0x38);
  *(undefined4 *)(param_1 + 0x3c) = 0;
  iVar1 = uVar2 * 0x14;
  if (*(int *)(&DAT_00ea9dc4 + uVar2 * 0x14) != 0) {
    *(int *)(*(int *)(&DAT_00ea9dc8 + iVar1) + 0x3c) = param_1;
    *(int *)(&DAT_00ea9dc8 + iVar1) = param_1;
    return;
  }
  *(int *)(&DAT_00ea9dc4 + iVar1) = param_1;
  *(int *)(&DAT_00ea9dc8 + iVar1) = param_1;
  if (DAT_00eab1c0 != (undefined4 *)0x0) {
    *(undefined4 **)((int)DAT_00eab1c0 + 8) = &DAT_00ea9db8 + uVar2 * 5;
  }
  *(undefined4 **)(&DAT_00ea9dbc + iVar1) = DAT_00eab1c0;
  *(undefined4 *)(&DAT_00ea9dc0 + iVar1) = 0;
  DAT_00eab1c0 = &DAT_00ea9db8 + uVar2 * 5;
  return;
}

