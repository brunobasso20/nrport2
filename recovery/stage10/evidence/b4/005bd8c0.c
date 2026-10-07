/* NR2003.exe @ 005bd8c0 FUN_005bd8c0 */

int FUN_005bd8c0(int param_1)

{
  int iVar1;
  undefined8 uVar2;
  
  iVar1 = (&DAT_00edb538)[param_1];
  while( true ) {
    if (iVar1 == 0) {
      return 0;
    }
    uVar2 = FUN_005bd0c0(iVar1);
    iVar1 = (int)((ulonglong)uVar2 >> 0x20);
    if ((int)uVar2 != 0) break;
    iVar1 = (&DAT_00edb538)[iVar1];
  }
  return iVar1;
}

