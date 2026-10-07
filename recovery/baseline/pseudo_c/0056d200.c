/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056d200 */

undefined4 FUN_0056d200(int param_1)

{
  int iVar1;
  int iVar2;
  undefined4 *puVar3;
  int iVar4;
  
  iVar4 = DAT_00c5c2e8;
  if ((-1 < param_1) && (param_1 < *DAT_00c5ca24)) {
    iVar2 = param_1 * 5;
    iVar1 = *(int *)(*(int *)(iVar2 + 1 + DAT_00c5c2e8) + 0x24);
    *(int *)(&DAT_00c5ca28 + iVar1 * 4) = *(int *)(&DAT_00c5ca28 + iVar1 * 4) + -1;
    iVar1 = *(int *)(*(int *)(iVar2 + 1 + iVar4) + 0xd5);
    (&DAT_00c5ca38)[iVar1] = (&DAT_00c5ca38)[iVar1] + -1;
    iVar1 = *(int *)(iVar2 + 1 + iVar4);
    if (iVar1 != 0) {
      FUN_004fe420(0x3f);
      FUN_005cfccc(iVar1);
      iVar4 = DAT_00c5c2e8;
    }
    *(undefined4 *)(iVar2 + 1 + iVar4) = 0;
    param_1 = param_1 + 1;
    if (param_1 < *DAT_00c5ca24) {
      iVar4 = param_1 * 5;
      do {
        puVar3 = (undefined4 *)(DAT_00c5c2e8 + iVar4);
        param_1 = param_1 + 1;
        iVar4 = iVar4 + 5;
        *(undefined4 *)((int)puVar3 + -5) = *puVar3;
        *(undefined1 *)((int)puVar3 + -1) = *(undefined1 *)(puVar3 + 1);
      } while (param_1 < *DAT_00c5ca24);
    }
    *(undefined4 *)(*DAT_00c5ca24 * 5 + -4 + DAT_00c5c2e8) = 0;
    *(undefined1 *)(*DAT_00c5ca24 * 5 + -5 + DAT_00c5c2e8) = 0;
    *DAT_00c5ca24 = *DAT_00c5ca24 + -1;
    return 1;
  }
  return 0;
}


