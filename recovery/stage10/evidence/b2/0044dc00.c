/* NR2003.exe @ 0044dc00 FUN_0044dc00 */

int FUN_0044dc00(void)

{
  int iVar1;
  
  FUN_00557d60(0x6e);
  FUN_00557d60(0x69);
  iVar1 = FUN_006c5018();
  if (iVar1 < 0) {
    return 0x16f;
  }
  if (0xc < iVar1) {
    iVar1 = 0xc;
  }
  return iVar1 + 0x16f;
}

