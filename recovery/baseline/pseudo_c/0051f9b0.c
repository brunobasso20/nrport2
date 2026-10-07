/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051f9b0 */

void FUN_0051f9b0(void)

{
  int iVar1;
  int iVar2;
  
  iVar1 = FUN_005099b0();
  if (iVar1 == 5) {
    return;
  }
  iVar1 = 0;
  do {
    iVar2 = DAT_00acca24;
    if (iVar1 != 0) {
      if (*(int *)(iVar1 + 4) == 0) {
        iVar2 = 0;
      }
      else {
        iVar2 = *(int *)(iVar1 + 4) + -4;
      }
      if (iVar2 == DAT_00acca24) {
        return;
      }
    }
    if (iVar2 == 0) {
      return;
    }
    FUN_005afd80(iVar2);
    iVar1 = iVar2;
  } while( true );
}


