/* Ghidra pseudo-C; NR2003.exe @ 0055f880 */

void FUN_0055f880(void)

{
  int iVar1;
  undefined **ppuVar2;
  undefined **ppuVar3;
  
  iVar1 = FUN_0051c2d0();
  *(undefined4 *)(iVar1 + 8) = 0xbf800000;
  iVar1 = FUN_0051c2d0();
  *(undefined4 *)(iVar1 + 0xc) = 1;
  ppuVar2 = &PTR_DAT_0074e7b8;
  do {
    iVar1 = 0;
    ppuVar3 = ppuVar2;
    do {
      if (((int)ppuVar2 < 0x74e830) && (iVar1 < 5)) {
        FUN_0057c990(ppuVar3,0);
      }
      else {
        FUN_0057ca60(ppuVar3,0);
      }
      iVar1 = iVar1 + 1;
      ppuVar3 = ppuVar3 + 1;
    } while (iVar1 < 6);
    ppuVar2 = ppuVar2 + 6;
  } while ((int)ppuVar2 < 0x74e848);
  return;
}

