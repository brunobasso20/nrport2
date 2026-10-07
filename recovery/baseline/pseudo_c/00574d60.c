/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00574d60 */

uint FUN_00574d60(void)

{
  char *pcVar1;
  
  pcVar1 = &DAT_00c72730;
  while ((pcVar1[3] == '\0' || (*pcVar1 == '\0'))) {
    pcVar1 = pcVar1 + 0xce;
    if (0xc74dcf < (int)pcVar1) {
      return (uint)pcVar1 & 0xffffff00;
    }
  }
  return CONCAT31((int3)((uint)pcVar1 >> 8),1);
}


