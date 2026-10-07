/* NR2003.exe @ 0055a700 FUN_0055a700 */

undefined * FUN_0055a700(void)

{
  int iVar1;
  
  iVar1 = FUN_0055a6a0();
  if (iVar1 != -1) {
    iVar1 = FUN_0055a6a0();
    return &DAT_00c06995 + iVar1 * 8;
  }
  return (undefined *)0x0;
}

