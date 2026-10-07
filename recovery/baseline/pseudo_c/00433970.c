/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00433970 */

void FUN_00433970(int param_1,int param_2)

{
  int *piVar1;
  int iVar2;
  
  iVar2 = 0;
  if (0 < param_2) {
    do {
      piVar1 = *(int **)(param_1 + iVar2 * 4);
      if (piVar1 != (int *)0x0) {
        if (*piVar1 != 0) {
          FUN_004347e0(1);
        }
        if (piVar1[1] != 0) {
          FUN_004347e0(1);
        }
        FUN_00547e80(piVar1,0x18);
      }
      iVar2 = iVar2 + 1;
    } while (iVar2 < param_2);
  }
  return;
}


