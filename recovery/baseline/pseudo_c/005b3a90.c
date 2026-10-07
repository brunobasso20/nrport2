/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b3a90 */

undefined4 FUN_005b3a90(int param_1)

{
  int iVar1;
  int iVar2;
  
  iVar1 = DAT_00e84664;
  iVar2 = (*(int *)(param_1 + 0x40) >> 7 & 7U) - 1;
  if ((-1 < iVar2) && (iVar2 < 3)) {
    DAT_00e84664 = DAT_00e84664 + 4;
    (**(code **)PTR_PTR_0074fe4c)(param_1 + 0x2cd + iVar2 * 4,iVar1);
    return 1;
  }
  return 0;
}


