/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005631c0 */

void FUN_005631c0(int param_1)

{
  int iVar1;
  undefined4 *puVar2;
  
  iVar1 = FUN_00562f70(param_1);
  if (*(int *)(iVar1 + 4) != 0) {
    FUN_00563730(iVar1);
  }
  iVar1 = param_1 * 0x15b8;
  (&DAT_00c125ca)[iVar1] = 1;
  FUN_00563080(&DAT_00c12030 + param_1 * 0x56e,1);
  *(undefined4 *)(&DAT_00c1323b + iVar1) = 0;
  *(undefined4 *)(&DAT_00c1323f + iVar1) = 0;
  *(undefined4 *)(&DAT_00c13243 + iVar1) = 0;
  *(undefined4 *)(&DAT_00c13247 + iVar1) = 0;
  *(undefined4 *)(&DAT_00c1322b + iVar1) = 0;
  *(undefined4 *)(&DAT_00c1322f + iVar1) = 0;
  *(undefined4 *)(&DAT_00c13233 + iVar1) = 0;
  *(undefined4 *)(&DAT_00c13237 + iVar1) = 0;
  puVar2 = (undefined4 *)(&DAT_00c1325b + iVar1);
  iVar1 = 4;
  do {
    puVar2[-4] = 0x3f800000;
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  FUN_005392c0(param_1);
  FUN_005632f0(&DAT_00c12030 + param_1 * 0x56e);
  return;
}


