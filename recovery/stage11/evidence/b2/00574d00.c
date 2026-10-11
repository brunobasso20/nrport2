/* NR2003.exe @ 00574d00 FUN_00574d00 */

void FUN_00574d00(void)

{
  int iVar1;
  
  iVar1 = FUN_0055ab00();
  if ((&DAT_00c72733)[iVar1 * 0xce] != '\0') {
    iVar1 = FUN_0055ab00();
    if ((&DAT_00c72730)[iVar1 * 0xce] != '\0') {
      FUN_0055aa60();
      FUN_00559870();
    }
  }
  bgRequestFGAction(FUN_00574c60,(void *)0x0,(void *)0x0);
  return;
}

