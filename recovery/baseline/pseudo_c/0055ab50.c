/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055ab50 */

void FUN_0055ab50(void)

{
  char cVar1;
  int iVar2;
  
  cVar1 = FUN_005c2cf0(DAT_00c08194);
  if (cVar1 != '\0') {
    iVar2 = FUN_0055a5a0();
    if (iVar2 == 2) {
      iVar2 = FUN_0055a5c0();
      if (iVar2 == 1) {
        cVar1 = FUN_00626280();
        if (cVar1 != '\0') {
          FUN_006262f0();
          return;
        }
      }
    }
  }
  return;
}


