/* NR2003.exe @ 005bcff0 FUN_005bcff0 */

void FUN_005bcff0(void)

{
  int iVar1;
  undefined4 *puVar2;
  
  iVar1 = 0;
  do {
    if ((&DAT_00edf228)[iVar1] != iVar1) {
      (&DAT_00edf228)[iVar1] = 0;
    }
    iVar1 = iVar1 + 1;
  } while (iVar1 < 0x5dc);
  puVar2 = &DAT_00edb538;
  for (iVar1 = 0xf3c; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  puVar2 = &DAT_00ec02c8;
  for (iVar1 = 0xf3c; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  puVar2 = &DAT_00ed7840;
  for (iVar1 = 0xf3c; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  DAT_00ebfc50 = &DAT_00ec3fc0;
  DAT_00ee0fd8 = &DAT_00ec3fc0;
  return;
}

