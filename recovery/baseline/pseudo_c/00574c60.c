/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00574c60 */

void FUN_00574c60(void)

{
  int *piVar1;
  int iVar2;
  
  iVar2 = 0;
  piVar1 = &DAT_00c727e6;
  do {
    if ((*(char *)((int)piVar1 + -0xb3) != '\0') && (*(char *)((int)piVar1 + -0xb6) != '\0')) {
      if (*piVar1 != 0) {
        FUN_00574960(iVar2);
      }
      FUN_005748f0(iVar2);
      *(undefined1 *)(piVar1 + -0x2d) = 0;
      *(undefined1 *)((int)piVar1 + -0xb3) = 0;
      *(undefined1 *)((int)piVar1 + -0xb2) = 0;
      *(undefined1 *)((int)piVar1 + -0xb1) = 0;
    }
    piVar1 = (int *)((int)piVar1 + 0xce);
    iVar2 = iVar2 + 1;
  } while ((int)piVar1 < 0xc74e86);
  return;
}


