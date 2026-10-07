/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005d2370 */

undefined4 __thiscall FUN_005d2370(int param_1_00,int *param_1,int *param_2,int param_3)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int *piVar4;
  
  iVar2 = 0;
  if (0 < *(int *)(param_1_00 + 0x1314)) {
    piVar4 = (int *)(param_1_00 + 0xb2);
    iVar3 = 0;
    do {
      iVar1 = *piVar4;
      if (param_3 < iVar1 + iVar3) {
        *param_1 = param_1_00 + 4 + iVar2 * 0x262;
        *param_2 = param_3 - iVar3;
        return 1;
      }
      iVar2 = iVar2 + 1;
      piVar4 = (int *)((int)piVar4 + 0x262);
      iVar3 = iVar1 + iVar3;
    } while (iVar2 < *(int *)(param_1_00 + 0x1314));
  }
  *param_2 = 0;
  *param_1 = 0;
  return 0;
}


