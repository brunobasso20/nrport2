/* Ghidra pseudo-C; NR2003.exe @ 005b3c60 */

undefined4 FUN_005b3c60(int param_1)

{
  int iVar1;
  int iVar2;
  
  iVar1 = DAT_00e84664;
  iVar2 = (*(int *)(param_1 + 0x40) >> 7 & 7U) - 1;
  if ((2 < iVar2) && (iVar2 < 6)) {
    DAT_00e84664 = DAT_00e84664 + 4;
    (**(code **)PTR_PTR_0074fe4c)(param_1 + 0x35d,iVar1);
    return 1;
  }
  return 0;
}

